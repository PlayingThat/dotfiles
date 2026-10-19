-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- Your own default apps, default search engine etc.

-- Set your default editor here. NOTE: this will be automatically uncommented
-- if you select neovim or vim as your default editor.
hl.env("EDITOR", "nvim")

-- These are for UserKeybinds.lua & Waybar modules
-- Returned as a table so other .lua files can: local defaults = require("UserConfigs/01-UserDefaults")
return {
    term = "kitty", -- Terminal
    files = "nemo", -- File Manager
    search_engine = "https://www.google.com/search?q={}", -- Default Search Engine for ROFI Search (SUPER S)
    edit = os.getenv("EDITOR") or "nvim", -- Editor used by the KooL Quick Settings menu (SUPER SHIFT E)
}
