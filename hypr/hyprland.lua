-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- Lua entrypoint (Hyprland >= 0.55).
--
-- NOT wired up here: UserConfigs/WindowRules.lua (converted for reference but not require()'d)

local home = os.getenv("HOME")

-- Initial boot script: applies first-run wallpaper/theming. Guarded by .initial_startup_done,
-- same as before -- safe to run every startup.
hl.on("hyprland.start", function()
    hl.exec_cmd(home .. "/.config/hypr/initial-boot.sh")
end)

-- Pre-configured keybinds
require("configs/Keybinds")

-- ## This is where you'd want to start tinkering ##
require("UserConfigs/Startup_Apps")       -- startup packages
require("UserConfigs/ENVariables")        -- environment variables
require("UserConfigs/Laptops")            -- laptop-related binds/devices
require("UserConfigs/LaptopDisplay")      -- laptop display (no-op by default)
require("UserConfigs/UserDecorations")    -- decorations (wallust colors)
require("UserConfigs/UserAnimations")     -- animations
require("UserConfigs/UserKeybinds")       -- your own keybinds
require("UserConfigs/UserSettings")       -- main Hyprland settings
require("UserConfigs/01-UserDefaults")    -- default apps (EDITOR env; also required by UserKeybinds)

-- nwg-displays
require("monitors")
require("workspaces")
