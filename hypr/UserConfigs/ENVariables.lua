-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- Environment variables. See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- NOTE: the full list of disabled/example variables (SDL, aquamarine, hyprland debug, etc.)
-- lives in ENVariables.conf for reference -- only the active ones are reproduced here.

-- Toolkit Backend Variables
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")

-- xdg Specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- QT Variables
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- hyprland-qt-support
hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")

-- xwayland apps scale fix (useful if you use monitor scaling)
hl.env("GDK_SCALE", "1")
hl.env("QT_SCALE_FACTOR", "1")

-- Bibata-Modern-Ice-Cursor (requires the hyprcursor version)
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")

-- firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- electron >28 apps
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- NVIDIA (activated below since an NVIDIA GPU was detected by the original setup)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
