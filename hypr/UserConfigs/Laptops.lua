-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- Laptop-specific keybinds and touchpad device config. Addendum to configs/Keybinds.lua.

local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local mainMod = "SUPER"

-- for disabling touchpad. `hyprctl devices` to get device name.
local touchpadDevice = "syna801a:00-06cb:cec6-touchpad"

hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --dec"), { repeating = true })
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --inc"), { repeating = true })
hl.bind("XF86Launch1", hl.dsp.exec_cmd("rog-control-center"))       -- ASUS Armory Crate button
hl.bind("XF86Launch3", hl.dsp.exec_cmd("asusctl led-mode -n"))      -- FN+F4 switch keyboard RGB profile
hl.bind("XF86Launch4", hl.dsp.exec_cmd("asusctl profile -n"))       -- FN+F5 change fan profile
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --dec"), { repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --inc"), { repeating = true })
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd(scriptsDir .. "/TouchPad.sh"))

-- Screenshot keybindings using F6 (no PrintScreen button)
hl.bind(mainMod .. " + F6",         hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --area"))
hl.bind(mainMod .. " + CTRL + F6",  hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in5"))
hl.bind(mainMod .. " + ALT + F6",   hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in10"))
hl.bind("ALT + F6",                 hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --active"))

hl.device({ name = touchpadDevice, enabled = true })

-- Below are useful when connecting your laptop to an external display.
-- See original Laptops.conf comments -- the lid-switch-writes-LaptopDisplay.conf trick is
-- disabled by default there and stays disabled here too (LaptopDisplay.lua is a no-op).
