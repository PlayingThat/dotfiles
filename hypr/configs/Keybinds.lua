-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- Default Keybinds. See https://wiki.hypr.land/Configuring/Basics/Binds/
--
-- Verified against /usr/share/hypr/stubs/hl.meta.lua and the Lua validation error strings
-- baked into the Hyprland binary itself (ran `strings /usr/bin/Hyprland | grep hl\.window`
-- etc.), since the shipped example config doesn't demonstrate every call shape used here.
-- Confirmed and fixed vs. the first draft:
--   - hl.dsp.window.move/swap direction must be "left"/"right"/"up"/"down", NOT "l"/"r"/"u"/"d"
--     (binary: `hl.window.move: invalid direction "{}" (expected left/right/up/down)`)
--   - hl.dsp.window.resize needs an explicit relative = true field, else it's an absolute
--     size (binary: `hl.window.resize: expected no args, a table { x, y, relative?, window? }`)
-- Still an educated guess, low risk if wrong (matches the maintainers' own tested pattern):
--   - hl.dsp.window.move({ workspace = N, silent = true })  (old: movetoworkspacesilent)
--   - hl.dsp.group.next()                         (old: changegroupactive, no arg = forward)
--
-- Also: the numbered-workspace binds below use plain digit keys (1-9,0), matching Hyprland's
-- own shipped example loop, instead of the old `code:10`..`code:19` physical-key selectors.
-- That's a deliberate, disclosed behavior change (only matters on non-standard keyboard
-- layouts where the digit row differs) -- "code:N" syntax inside a Lua bind string isn't
-- verified to still work, so this follows the maintainers' own tested pattern instead.

local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"

local mainMod = "SUPER"

hl.bind("CTRL + ALT + Delete", hl.dsp.exit()) -- exit Hyprland
hl.bind(mainMod .. " + Q", hl.dsp.window.close()) -- close active (not kill)
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(scriptsDir .. "/KillActiveProcess.sh")) -- kill active process
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/LockScreen.sh")) -- screen lock
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd(scriptsDir .. "/Wlogout.sh")) -- power menu
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t -sw")) -- swayNC notification panel
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(scriptsDir .. "/Kool_Quick_Settings.sh")) -- Settings Menu

-- Master Layout
hl.bind(mainMod .. " + CTRL + D", hl.dsp.layout("removemaster"))
hl.bind(mainMod .. " + I", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + J", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + K", hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))

-- Dwindle Layout
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Works on either layout (Master or Dwindle)
hl.bind(mainMod .. " + M", hl.dsp.layout("splitratio 0.3"))

-- Group
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + CTRL + tab", hl.dsp.group.next()) -- VERIFY, see header note

-- Cycle windows, bringing floating ones to top
hl.bind("ALT + tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Special keys / hot keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --inc"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --dec"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --toggle-mic"), { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --toggle"), { locked = true })
hl.bind("XF86Sleep",            hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind("XF86Rfkill",           hl.dsp.exec_cmd(scriptsDir .. "/AirplaneMode.sh"), { locked = true })

-- Media controls using keyboard
-- Note: "XF86AudioPlayPause" is not a real X11/XF86 keysym; keyboards send
-- XF86AudioPlay and/or XF86AudioPause instead, both bound below.
hl.bind("XF86AudioPause",     hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioPlay",      hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioNext",      hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --nxt"), { locked = true })
hl.bind("XF86AudioPrev",      hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --prv"), { locked = true })
hl.bind("XF86AudioStop",      hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --stop"), { locked = true })

-- Screenshot keybindings. NOTE: you may need to press Fn as well
hl.bind(mainMod .. " + Print",                hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + Print",        hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --area"))
hl.bind(mainMod .. " + CTRL + Print",         hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in5"))
hl.bind(mainMod .. " + CTRL + SHIFT + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in10"))
hl.bind("ALT + Print",                        hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --active"))

-- screenshot with swappy
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('geom=$(slurp) && sleep 0.5 && grim -g "$geom" - | swappy -f -'))

-- Resize windows (relative = true: adjust by this delta, matching old `resizeactive`)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0, y = 50, relative = true }),  { repeating = true })

-- Move windows (reposition within layout)
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down" }))

-- Swap windows
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ direction = "down" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces related
hl.bind(mainMod .. " + tab",         hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

-- Special workspace
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + U",         hl.dsp.workspace.toggle_special())

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- Move active window to a workspace silently with mainMod + CTRL + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key,      hl.dsp.window.move({ workspace = i, silent = true })) -- VERIFY
end
hl.bind(mainMod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + CTRL + bracketleft",   hl.dsp.window.move({ workspace = "-1", silent = true })) -- VERIFY
hl.bind(mainMod .. " + CTRL + bracketright",  hl.dsp.window.move({ workspace = "+1", silent = true })) -- VERIFY

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + period",     hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma",      hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Custom solution for when the lid is closed
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd(home .. "/.config/hypr/handle_lid_switch.sh"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl reload"), { locked = true })
