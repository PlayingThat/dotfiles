-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- Your own keybinds. Be mindful to check configs/Keybinds.lua as well to avoid conflicts.
--
-- Fixed vs. the first draft, per the Lua validation error strings baked into the Hyprland
-- binary (`hl.window.fullscreen: invalid mode "{}" (expected fullscreen/maximized)`):
-- window.fullscreen takes `action` (toggle/set/unset) and `mode` (fullscreen/maximized) --
-- there is no `fake` field, so { fake = true } was silently ignored and CTRL+F just did the
-- same real-fullscreen toggle as SHIFT+F. The old `fullscreen, 1` dispatcher arg meant
-- "maximize", so that's mode = "maximized" here.

local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local userScripts = home .. "/.config/hypr/UserScripts"
local defaults = require("UserConfigs/01-UserDefaults")

local mainMod = "SUPER"
local term = defaults.term
local files = defaults.files

-- common shortcuts
-- tap Super (either side) alone to launch rofi; the mod must be included in the
-- key string (SUPER + SUPER_L) since pressing Super_L/Super_R itself sets the
-- SUPER modifier bit -- a bind with no modifier never matches that event.
hl.bind(mainMod .. " + " .. mainMod .. "_L", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"), { release = true })
hl.bind(mainMod .. " + " .. mainMod .. "_R", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"), { release = true })
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window")) -- Main Menu (App Launcher)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd('xdg-open "https://"')) -- default browser
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || true && ags -t 'overview'")) -- desktop overview (if installed)
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term)) -- terminal
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(files)) -- file manager

-- FEATURES / EXTRAS
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(scriptsDir .. "/KeyHints.sh")) -- help / cheat sheet
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(scriptsDir .. "/Refresh.sh")) -- refresh waybar, swaync, rofi
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(scriptsDir .. "/RofiEmoji.sh")) -- emoji menu
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(scriptsDir .. "/RofiSearch.sh")) -- Google search via rofi
hl.bind(mainMod .. " + ALT + O", hl.dsp.exec_cmd(scriptsDir .. "/ChangeBlur.sh")) -- toggle blur settings
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(scriptsDir .. "/GameMode.sh")) -- toggle animations on/off
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.sh")) -- toggle Master/Dwindle layout
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd(scriptsDir .. "/ClipManager.sh")) -- clipboard manager
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd(scriptsDir .. "/RofiThemeSelector.sh")) -- rofi theme selector
hl.bind(mainMod .. " + CTRL + SHIFT + R", hl.dsp.exec_cmd("pkill rofi || true && " .. scriptsDir .. "/RofiThemeSelector-modified.sh"))

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen()) -- real fullscreen
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized" })) -- old `fullscreen, 1` = maximize
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" })) -- float mode
hl.bind(mainMod .. " + ALT + SPACE", function() -- all-float mode
    local ws = hl.get_active_workspace().id
    local action = #hl.get_windows({ workspace = ws, floating = false }) > 0 and "enable" or "disable"
    for _, w in ipairs(hl.get_windows({ workspace = ws })) do
        hl.dispatch(hl.dsp.window.float({ window = "address:" .. w.address, action = action }))
    end
end)
-- exec_cmd only takes a command string (no window-rules options table), so the
-- [float; move; size] rule prefix has to be embedded in the command itself, same as the
-- original `exec, [float; move 15% 5%; size 70% 60%] $term`.
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd('[float; move 15% 5%; size 70% 60%] ' .. term)) -- dropdown terminal

-- Desktop zooming / magnifier
hl.bind(mainMod .. " + ALT + mouse_down", function()
    hl.config({ cursor = { zoom_factor = math.max(hl.get_config("cursor.zoom_factor"), 1) / 2.0 } })
end)
hl.bind(mainMod .. " + ALT + mouse_up", function()
    hl.config({ cursor = { zoom_factor = math.max(hl.get_config("cursor.zoom_factor"), 1) * 2.0 } })
end)

-- Waybar / bar related
hl.bind(mainMod .. " + CTRL + ALT + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")) -- toggle hide/show waybar
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(scriptsDir .. "/WaybarStyles.sh")) -- waybar styles menu
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(scriptsDir .. "/WaybarLayout.sh")) -- waybar layout menu

-- FEATURES / EXTRAS (UserScripts)
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(userScripts .. "/RofiBeats.sh")) -- online music via rofi
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(userScripts .. "/WallpaperSelect.sh")) -- select wallpaper
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(userScripts .. "/WallpaperEffects.sh")) -- wallpaper effects (imagemagick)
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd(userScripts .. "/WallpaperRandom.sh")) -- random wallpaper
hl.bind(mainMod .. " + CTRL + O", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" })) -- disable opacity on active window
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(scriptsDir .. "/KeyBinds.sh")) -- search keybinds via rofi
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(scriptsDir .. "/Animations.sh")) -- Hyprland animations menu
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(userScripts .. "/ZshChangeTheme.sh")) -- change oh-my-zsh theme
hl.bind("ALT_L + SHIFT_L", hl.dsp.exec_cmd(scriptsDir .. "/SwitchKeyboardLayout.sh"), { locked = true, non_consuming = true }) -- change keyboard layout
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(userScripts .. "/RofiCalc.sh")) -- calculator (qalculate)
