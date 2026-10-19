#!/usr/bin/env python3
# Year-calendar popup for the waybar clock module.
#
# Bound to right-click on the clock (see waybar Modules -> "clock").
# Right-click toggles it: first call opens it, a second call (or a second
# right-click on the clock) closes it again. It also closes itself when it
# loses keyboard focus (i.e. you click anywhere else) or on Escape.
#
# Scroll anywhere over the popup to page through years.

import atexit
import json
import os
import signal
import subprocess
import sys

RUNTIME_DIR = os.environ.get("XDG_RUNTIME_DIR", "/tmp")
PIDFILE = os.path.join(RUNTIME_DIR, "waybar-year-calendar.pid")


def running_pid():
    try:
        with open(PIDFILE) as f:
            pid = int(f.read().strip())
        os.kill(pid, 0)  # raises if not alive / not ours to signal
        return pid
    except (FileNotFoundError, ValueError, ProcessLookupError, PermissionError):
        return None


# Toggle behavior: if an instance is already running, close it and exit.
existing = running_pid()
if existing:
    os.kill(existing, signal.SIGTERM)
    sys.exit(0)

with open(PIDFILE, "w") as f:
    f.write(str(os.getpid()))


def cleanup():
    if running_pid() == os.getpid():
        try:
            os.remove(PIDFILE)
        except OSError:
            pass


atexit.register(cleanup)

import calendar
import datetime

import gi

# GtkLayerShell must be resolved (and imported) before any bare Gtk/Gdk
# import, otherwise gi auto-picks Gtk4/Gdk4 (this system has both GTK3 and
# GTK4 installed) and GtkLayerShell -- which wraps GTK3 -- fails to load.
gi.require_version("GtkLayerShell", "0.1")
gi.require_version("GLibUnix", "2.0")
from gi.repository import GtkLayerShell, Gtk, Gdk, GLib, GLibUnix  # noqa: E402

TODAY = datetime.date.today()
CURRENT_YEAR = TODAY.year

# Monday-first, matching ISO week numbers -- puts Saturday/Sunday together
# at the end (right side) of each row instead of splitting them across the
# two ends of a Sunday-first week.
CAL = calendar.Calendar(firstweekday=0)
WEEKDAY_HEADERS = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
MONTH_NAMES = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December",
]
WEEK_ROWS = 6  # fixed slot count per month so all 12 grids line up


def top_margin(gap=10, fallback=44):
    """How far below the top edge to anchor the popup: waybar's own bar
    height (queried live, so this keeps working across machines/configs with
    a different bar height or margins) plus a small gap. Falls back to a
    fixed value if Hyprland/waybar aren't reachable for some reason."""
    try:
        layers = json.loads(subprocess.check_output(["hyprctl", "-j", "layers"], timeout=1))
        heights = [
            layer["h"]
            for output in layers.values()
            for level in output["levels"].values()
            for layer in level
            if layer.get("namespace") == "waybar"
        ]
        if heights:
            return max(heights) + gap
    except (subprocess.SubprocessError, OSError, json.JSONDecodeError, KeyError):
        pass
    return fallback

CSS = b"""
#year-calendar-root {
    background-color: rgba(30, 30, 46, 0.92);
    border: 1px solid rgba(137, 180, 250, 0.55);
    border-radius: 14px;
    padding: 14px;
}
#year-calendar-title {
    color: #f5c2e7;
    font-weight: bold;
    font-size: 20px;
}
#year-calendar-hint {
    color: #9399b2;
    font-size: 11px;
}
.month-title {
    color: #89b4fa;
    font-weight: bold;
    font-size: 11px;
}
.weekday-header {
    color: #7f849c;
    font-size: 9px;
    font-weight: bold;
}
.week-header {
    color: rgba(127, 132, 156, 0.5);
    font-size: 9px;
    font-weight: bold;
}
.day-cell {
    color: #cdd6f4;
    font-size: 10px;
    padding: 1px 3px;
    border: 1px solid transparent;
    border-radius: 4px;
}
.day-cell.other-month {
    color: rgba(205, 214, 244, 0.25);
}
.day-cell.today {
    color: #1e1e2e;
    background-color: #f38ba8;
    font-weight: bold;
}
.day-cell.selected {
    border-color: #89b4fa;
}
.week-num {
    color: rgba(147, 153, 178, 0.45);
    font-size: 9px;
}
"""


class YearCalendar(Gtk.Window):
    def __init__(self):
        super().__init__(type=Gtk.WindowType.TOPLEVEL)
        self.year = CURRENT_YEAR
        self.selected_label = None
        self.set_name("year-calendar-window")
        self.set_decorated(False)
        self.set_resizable(False)
        # focus-out grace period: the cursor is still over the waybar clock
        # (not this popup) the instant it opens from a right-click. With
        # follow_mouse enabled, that alone can look like an immediate
        # focus-out. Ignore focus-out events for a brief moment after
        # opening so the popup survives long enough for the mouse to reach
        # it; a real "click away" after that still closes it right away.
        self._focus_grace_until = GLib.get_monotonic_time() + 500_000

        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)

        GtkLayerShell.init_for_window(self)
        # Deliberately not calling set_namespace(): on this system, giving the
        # surface an explicit layer-shell namespace makes Hyprland fire an
        # immediate spurious focus-out right after the window appears, which
        # instantly self-closes the popup via on_focus_out below. Leaving the
        # namespace at gtk-layer-shell's default avoids it.
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, top_margin())
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.ON_DEMAND)

        root = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        root.set_name("year-calendar-root")
        self.add(root)

        header = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2, halign=Gtk.Align.CENTER)
        self.title_label = Gtk.Label()
        self.title_label.set_name("year-calendar-title")
        hint = Gtk.Label(label="scroll to change year  ·  click away or Esc to close")
        hint.set_name("year-calendar-hint")
        header.pack_start(self.title_label, False, False, 0)
        header.pack_start(hint, False, False, 0)
        root.pack_start(header, False, False, 0)

        self.grid = Gtk.Grid(row_spacing=14, column_spacing=18)
        root.pack_start(self.grid, False, False, 0)

        self.months = [self._build_month_grid() for _ in range(12)]
        for i, month_widget in enumerate(self.months):
            row, col = divmod(i, 3)
            self.grid.attach(month_widget, col, row, 1, 1)

        self.add_events(Gdk.EventMask.SCROLL_MASK | Gdk.EventMask.KEY_PRESS_MASK)
        self.connect("scroll-event", self.on_scroll)
        self.connect("key-press-event", self.on_key_press)
        self.connect("focus-out-event", self.on_focus_out)
        self.connect("destroy", self.on_destroy)

        self.render_year()

    def _build_month_grid(self):
        """Build one month's widget tree once; render_year() only ever
        updates the labels' text/CSS classes on it afterwards."""
        grid = Gtk.Grid(row_spacing=2, column_spacing=6)

        title = Gtk.Label(xalign=0.5)
        title.get_style_context().add_class("month-title")
        grid.attach(title, 0, 0, 8, 1)
        grid.title_label = title

        for col, text in enumerate(WEEKDAY_HEADERS):
            lbl = Gtk.Label(label=text, xalign=0.5)
            lbl.get_style_context().add_class("weekday-header")
            grid.attach(lbl, col, 1, 1, 1)
        week_hdr = Gtk.Label(label="Wk", xalign=0.5)
        week_hdr.get_style_context().add_class("week-header")
        grid.attach(week_hdr, 7, 1, 1, 1)

        grid.day_labels = []
        grid.week_labels = []
        for r in range(WEEK_ROWS):
            row_labels = []
            for c in range(7):
                lbl = Gtk.Label(xalign=0.5, width_chars=2)
                lbl.get_style_context().add_class("day-cell")
                box = Gtk.EventBox()
                box.set_visible_window(False)  # don't paint over our custom background
                box.add(lbl)
                box.connect("button-press-event", self.on_day_clicked, lbl)
                grid.attach(box, c, 2 + r, 1, 1)
                row_labels.append(lbl)
            grid.day_labels.append(row_labels)

            wk_lbl = Gtk.Label(xalign=0.5)
            wk_lbl.get_style_context().add_class("week-num")
            grid.attach(wk_lbl, 7, 2 + r, 1, 1)
            grid.week_labels.append(wk_lbl)

        return grid

    def on_day_clicked(self, _box, _event, lbl):
        if self.selected_label is lbl:
            lbl.get_style_context().remove_class("selected")
            self.selected_label = None
            return True
        if self.selected_label is not None:
            self.selected_label.get_style_context().remove_class("selected")
        lbl.get_style_context().add_class("selected")
        self.selected_label = lbl
        return True

    def render_year(self):
        # the grid cells are reused across years, so a click-selection tied
        # to a widget would otherwise point at whatever date scrolls into
        # that same slot next -- clear it whenever the displayed dates change.
        self.selected_label = None
        self.title_label.set_text(str(self.year))
        for month_idx, grid in enumerate(self.months, start=1):
            grid.title_label.set_text(MONTH_NAMES[month_idx - 1])

            dates = list(CAL.itermonthdates(self.year, month_idx))
            weeks = [dates[i:i + 7] for i in range(0, len(dates), 7)]

            for r in range(WEEK_ROWS):
                week = weeks[r] if r < len(weeks) else None
                for c in range(7):
                    lbl = grid.day_labels[r][c]
                    ctx = lbl.get_style_context()
                    ctx.remove_class("selected")
                    if week is None:
                        lbl.set_text("")
                        ctx.remove_class("other-month")
                        ctx.remove_class("today")
                        continue
                    d = week[c]
                    lbl.set_text(str(d.day))
                    in_month = d.month == month_idx and d.year == self.year
                    ctx.remove_class("other-month") if in_month else ctx.add_class("other-month")
                    is_today = in_month and d == TODAY
                    ctx.add_class("today") if is_today else ctx.remove_class("today")

                wk_lbl = grid.week_labels[r]
                if week is None:
                    wk_lbl.set_text("")
                    continue
                full_week = all(d.month == month_idx and d.year == self.year for d in week)
                wk_lbl.set_text(str(week[0].isocalendar()[1]) if full_week else "")

    def on_scroll(self, _widget, event):
        if event.direction == Gdk.ScrollDirection.UP:
            self.year -= 1
        elif event.direction == Gdk.ScrollDirection.DOWN:
            self.year += 1
        else:
            return False
        self.render_year()
        return True

    def on_key_press(self, _widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.destroy()
            return True
        return False

    def on_focus_out(self, *_args):
        if GLib.get_monotonic_time() < self._focus_grace_until:
            return False
        self.destroy()
        return False

    def on_destroy(self, *_args):
        cleanup()
        # GTK/GIO spin up background worker threads (font/icon loading, etc.)
        # that can take a while to wind down and leave the process lingering
        # after Gtk.main_quit(). We've already done the cleanup that matters
        # (removing the pidfile), so exit immediately rather than wait on them.
        os._exit(0)


def on_sigterm(win):
    win.destroy()
    return False


style_provider = Gtk.CssProvider()
style_provider.load_from_data(CSS)
Gtk.StyleContext.add_provider_for_screen(
    Gdk.Screen.get_default(), style_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
)

win = YearCalendar()
GLibUnix.signal_add(GLib.PRIORITY_HIGH, signal.SIGTERM, on_sigterm, win)
win.show_all()
Gtk.main()
