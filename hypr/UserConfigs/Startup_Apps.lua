-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- Commands and apps to be executed at launch.
-- Wrapped in hl.on("hyprland.start", ...) so these fire ONCE at actual startup,
-- matching old exec-once semantics -- top-level hl.exec_cmd() calls would instead
-- re-run on every config reload (e.g. every wallpaper change), duplicating processes.

local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local userScripts = home .. "/.config/hypr/UserScripts"

-- Toggled by UserScripts/WallpaperSelect.sh when you pick a video wallpaper
-- (was $livewallpaper + a commented-out exec-once in the old .conf). Kept as
-- plain locals, not a function call, so the script can sed them in place.
local live_wallpaper_enabled = false
local livewallpaper = ""

hl.on("hyprland.start", function()
    -- wallpaper daemon
    if live_wallpaper_enabled then
        hl.exec_cmd('mpvpaper "*" -o "load-scripts=no no-audio --loop" ' .. livewallpaper)
    else
        hl.exec_cmd("swww-daemon --format xrgb")
    end

    -- session/env activation
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- polkit (polkit-gnome / kde)
    hl.exec_cmd(scriptsDir .. "/Polkit.sh")

    -- startup apps
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("swaync")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("waybar")

    -- clipboard manager
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- rainbow borders
    hl.exec_cmd(userScripts .. "/RainbowBorders.sh")

    -- hypridle (needed to trigger hyprlock)
    hl.exec_cmd("hypridle")
end)
