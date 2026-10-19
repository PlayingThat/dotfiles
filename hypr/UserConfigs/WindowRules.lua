-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- Converted from UserConfigs/WindowRules.disable (the >=0.48 `windowrule` syntax --
-- version-appropriate for your installed Hyprland 0.56.1; the older WindowRules-old.conf
-- used the deprecated windowrulev2 syntax for pre-0.48 installs and wasn't converted).
--
-- NOT required anywhere -- window rules were already disabled in your active config
-- (hyprland.conf never sourced WindowRules.conf). This is a best-effort, NOT activated,
-- reference conversion. Two things are unverified since this file is never loaded:
--   1. Effect field names (float, center, move, opacity, tag, etc.) ARE verified against
--      Hyprland's own WINDOW_RULE_EFFECT_DESCS table in LuaBindingsInternal.hpp.
--   2. The old `title:negative:(...)` "does NOT match" selector has NO confirmed Lua
--      equivalent -- rules using it are marked VERIFY below and left as a best guess
--      (match = { title = "..." } without the negation, which is NOT equivalent).
-- Spot-check this whole file against the current wiki before ever require()-ing it.

-- ===== Tags =====
hl.window_rule({ name = "tag-browser-firefox", match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$" }, tag = "+browser" })
hl.window_rule({ name = "tag-browser-chrome",  match = { class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" }, tag = "+browser" })
hl.window_rule({ name = "tag-browser-chrome-pwa", match = { class = "^(chrome-.+-Default)$" }, tag = "+browser" }) -- Chrome PWAs
hl.window_rule({ name = "tag-browser-chromium", match = { class = "^([Cc]hromium)$" }, tag = "+browser" })
hl.window_rule({ name = "tag-browser-edge", match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$" }, tag = "+browser" })
hl.window_rule({ name = "tag-browser-brave", match = { class = "^(Brave-browser(-beta|-dev|-unstable)?)$" }, tag = "+browser" })
hl.window_rule({ name = "tag-browser-thorium", match = { class = "^([Tt]horium-browser|[Cc]achy-browser)$" }, tag = "+browser" })
hl.window_rule({ name = "tag-browser-zen", match = { class = "^(zen-alpha|zen)$" }, tag = "+browser" })

hl.window_rule({ name = "tag-notif", match = { class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$" }, tag = "+notif" })

hl.window_rule({ name = "tag-koolcheat", match = { title = "^(KooL Quick Cheat Sheet)$" }, tag = "+KooL_Cheat" })
hl.window_rule({ name = "tag-koolsettings", match = { title = "^(KooL Hyprland Settings)$" }, tag = "+KooL_Settings" })
hl.window_rule({ name = "tag-koolsettings2", match = { class = "^(nwg-displays|nwg-look)$" }, tag = "+KooL-Settings" })

hl.window_rule({ name = "tag-terminal", match = { class = "^(Alacritty|kitty|kitty-dropterm)$" }, tag = "+terminal" })

hl.window_rule({ name = "tag-email-thunderbird", match = { class = "^([Tt]hunderbird|org.gnome.Evolution)$" }, tag = "+email" })
hl.window_rule({ name = "tag-email-betterbird", match = { class = "^(eu.betterbird.Betterbird)$" }, tag = "+email" })

hl.window_rule({ name = "tag-projects-codium", match = { class = "^(codium|codium-url-handler|VSCodium)$" }, tag = "+projects" })
hl.window_rule({ name = "tag-projects-vscode", match = { class = "^(VSCode|code-url-handler)$" }, tag = "+projects" })
hl.window_rule({ name = "tag-projects-jetbrains", match = { class = "^(jetbrains-.+)$" }, tag = "+projects" }) -- JetBrains IDEs

hl.window_rule({ name = "tag-screenshare", match = { class = "^(com.obsproject.Studio)$" }, tag = "+screenshare" })

hl.window_rule({ name = "tag-im-discord", match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" }, tag = "+im" })
hl.window_rule({ name = "tag-im-ferdium", match = { class = "^([Ff]erdium)$" }, tag = "+im" })
hl.window_rule({ name = "tag-im-whatsapp", match = { class = "^([Ww]hatsapp-for-linux)$" }, tag = "+im" })
hl.window_rule({ name = "tag-im-zapzap", match = { class = "^(ZapZap|com.rtosta.zapzap)$" }, tag = "+im" })
hl.window_rule({ name = "tag-im-telegram", match = { class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" }, tag = "+im" })
hl.window_rule({ name = "tag-im-teams", match = { class = "^(teams-for-linux)$" }, tag = "+im" })

hl.window_rule({ name = "tag-games-gamescope", match = { class = "^(gamescope)$" }, tag = "+games" })
hl.window_rule({ name = "tag-games-steamapp", match = { class = "^(steam_app_\\d+)$" }, tag = "+games" })

hl.window_rule({ name = "tag-gamestore-steam", match = { class = "^([Ss]team)$" }, tag = "+gamestore" })
hl.window_rule({ name = "tag-gamestore-lutris", match = { title = "^([Ll]utris)$" }, tag = "+gamestore" })
hl.window_rule({ name = "tag-gamestore-heroic", match = { class = "^(com.heroicgameslauncher.hgl)$" }, tag = "+gamestore" })

hl.window_rule({ name = "tag-filemanager-thunar", match = { class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$" }, tag = "+file-manager" })
hl.window_rule({ name = "tag-filemanager-warp", match = { class = "^(app.drey.Warp)$" }, tag = "+file-manager" })

hl.window_rule({ name = "tag-wallpaper", match = { class = "^([Ww]aytrogen)$" }, tag = "+wallpaper" })

hl.window_rule({ name = "tag-multimedia", match = { class = "^([Aa]udacious)$" }, tag = "+multimedia" })
hl.window_rule({ name = "tag-multimedia-video", match = { class = "^([Mm]pv|vlc)$" }, tag = "+multimedia_video" })

hl.window_rule({ name = "tag-settings-rog", match = { title = "^(ROG Control)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-wihotspot", match = { class = "^(wihotspot(-gui)?)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-baobab", match = { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" }, tag = "+settings" }) -- disk usage analyzer
hl.window_rule({ name = "tag-settings-disks", match = { class = "^(gnome-disks|wihotspot(-gui)?)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-kvantum", match = { title = "(Kvantum Manager)" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-filearchiver", match = { class = "^(file-roller|org.gnome.FileRoller)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-nmapplet", match = { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-pavucontrol", match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-qtct", match = { class = "^(qt5ct|qt6ct|[Yy]ad)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-portal", match = { class = "(xdg-desktop-portal-gtk)" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-polkit", match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-rofi", match = { class = "^([Rr]ofi)$" }, tag = "+settings" })

hl.window_rule({ name = "tag-viewer-sysmon", match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" }, tag = "+viewer" })
hl.window_rule({ name = "tag-viewer-evince", match = { class = "^(evince)$" }, tag = "+viewer" }) -- document viewer
hl.window_rule({ name = "tag-viewer-eog", match = { class = "^(eog|org.gnome.Loupe)$" }, tag = "+viewer" }) -- image viewer

-- ===== Special overrides =====
hl.window_rule({ name = "video-noblur", match = { tag = "multimedia_video" }, no_blur = true })
hl.window_rule({ name = "video-opaque", match = { tag = "multimedia_video" }, opacity = "1.0" })

-- ===== Position =====
hl.window_rule({ name = "pos-koolcheat-center", match = { tag = "KooL_Cheat" }, center = true })
hl.window_rule({ name = "pos-thunar-center", match = { class = "([Tt]hunar)", title = "(.*[Tt]hunar.*)" }, center = true }) -- VERIFY: title should be a NEGATIVE match
hl.window_rule({ name = "pos-rog-center", match = { title = "^(ROG Control)$" }, center = true })
hl.window_rule({ name = "pos-koolsettings-center", match = { tag = "KooL-Settings" }, center = true })
hl.window_rule({ name = "pos-keybindings-center", match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({ name = "pos-pavucontrol-center", match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, center = true })
hl.window_rule({ name = "pos-whatsapp-center", match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" }, center = true })
hl.window_rule({ name = "pos-ferdium-center", match = { class = "^([Ff]erdium)$" }, center = true })
hl.window_rule({ name = "pos-pip-move", match = { title = "^(Picture-in-Picture)$" }, move = "72% 7%" })

-- idle inhibit while fullscreen
hl.window_rule({ name = "idleinhibit-fullscreen", match = { fullscreen = true }, idle_inhibit = "fullscreen" })

-- move to workspace
hl.window_rule({ name = "ws-email", match = { tag = "email" }, workspace = "3" })
hl.window_rule({ name = "ws-browser", match = { tag = "browser" }, workspace = "1" })
hl.window_rule({ name = "ws-gamestore", match = { tag = "gamestore" }, workspace = "5" })
hl.window_rule({ name = "ws-im", match = { tag = "im" }, workspace = "7" })
hl.window_rule({ name = "ws-games", match = { tag = "games" }, workspace = "8" })

-- move to workspace (silent)
hl.window_rule({ name = "ws-screenshare-silent", match = { tag = "screenshare" }, workspace = "4 silent" })
hl.window_rule({ name = "ws-virtmanager-silent", match = { class = "^(virt-manager)$" }, workspace = "6 silent" })
hl.window_rule({ name = "ws-virtmanager2-silent", match = { class = "^(.virt-manager-wrapped)$" }, workspace = "6 silent" })
hl.window_rule({ name = "ws-multimedia-silent", match = { tag = "multimedia" }, workspace = "9 silent" })

-- ===== Float =====
hl.window_rule({ name = "float-koolcheat", match = { tag = "KooL_Cheat" }, float = true })
hl.window_rule({ name = "float-wallpaper", match = { tag = "wallpaper" }, float = true })
hl.window_rule({ name = "float-settings", match = { tag = "settings" }, float = true })
hl.window_rule({ name = "float-viewer", match = { tag = "viewer" }, float = true })
hl.window_rule({ name = "float-koolsettings", match = { tag = "KooL-Settings" }, float = true })
hl.window_rule({ name = "float-zoom", match = { class = "([Zz]oom|onedriver|onedriver-launcher)$" }, float = true })
hl.window_rule({ name = "float-calculator", match = { class = "(org.gnome.Calculator)", title = "(Calculator)" }, float = true })
hl.window_rule({ name = "float-mpv", match = { class = "^(mpv|com.github.rafostar.Clapper)$" }, float = true })
hl.window_rule({ name = "float-qalculate", match = { class = "^([Qq]alculate-gtk)$" }, float = true })
hl.window_rule({ name = "float-ferdium", match = { class = "^([Ff]erdium)$" }, float = true })
hl.window_rule({ name = "float-pip", match = { title = "^(Picture-in-Picture)$" }, float = true })

-- float popups and dialogues
hl.window_rule({ name = "float-authrequired", match = { title = "^(Authentication Required)$" }, float = true })
hl.window_rule({ name = "center-authrequired", match = { title = "^(Authentication Required)$" }, center = true })
hl.window_rule({ name = "float-codium-dialog", match = { class = "(codium|codium-url-handler|VSCodium)", title = "(.*codium.*|.*VSCodium.*)" }, float = true }) -- VERIFY: title should be a NEGATIVE match
hl.window_rule({ name = "float-heroic-dialog", match = { class = "^(com.heroicgameslauncher.hgl)$", title = "(Heroic Games Launcher)" }, float = true }) -- VERIFY: title should be a NEGATIVE match
hl.window_rule({ name = "float-steam-dialog", match = { class = "^([Ss]team)$", title = "^([Ss]team)$" }, float = true }) -- VERIFY: title should be a NEGATIVE match
hl.window_rule({ name = "float-thunar-dialog", match = { class = "([Tt]hunar)", title = "(.*[Tt]hunar.*)" }, float = true } ) -- VERIFY: title should be a NEGATIVE match

hl.window_rule({ name = "float-addfolder", match = { title = "^(Add Folder to Workspace)$" }, float = true })
hl.window_rule({ name = "size-addfolder", match = { title = "^(Add Folder to Workspace)$" }, size = "70% 60%" })
hl.window_rule({ name = "center-addfolder", match = { title = "^(Add Folder to Workspace)$" }, center = true })

hl.window_rule({ name = "float-saveas", match = { title = "^(Save As)$" }, float = true })
hl.window_rule({ name = "size-saveas", match = { title = "^(Save As)$" }, size = "70% 60%" })
hl.window_rule({ name = "center-saveas", match = { title = "^(Save As)$" }, center = true })

hl.window_rule({ name = "float-openfiles", match = { initial_title = "(Open Files)" }, float = true })
hl.window_rule({ name = "size-openfiles", match = { initial_title = "(Open Files)" }, size = "70% 60%" })

hl.window_rule({ name = "float-sddmbg", match = { title = "^(SDDM Background)$" }, float = true }) -- KooL's YAD for setting SDDM background
hl.window_rule({ name = "center-sddmbg", match = { title = "^(SDDM Background)$" }, center = true })
hl.window_rule({ name = "size-sddmbg", match = { title = "^(SDDM Background)$" }, size = "16% 12%" })

-- ===== Opacity =====
hl.window_rule({ name = "opacity-browser", match = { tag = "browser" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-projects", match = { tag = "projects" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-im", match = { tag = "im" }, opacity = "0.94 0.86" })
hl.window_rule({ name = "opacity-multimedia", match = { tag = "multimedia" }, opacity = "0.94 0.86" })
hl.window_rule({ name = "opacity-filemanager", match = { tag = "file-manager" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-terminal", match = { tag = "terminal" }, opacity = "0.8 0.7" })
hl.window_rule({ name = "opacity-settings", match = { tag = "settings" }, opacity = "0.8 0.7" })
hl.window_rule({ name = "opacity-viewer", match = { tag = "viewer" }, opacity = "0.82 0.75" })
hl.window_rule({ name = "opacity-wallpaper", match = { tag = "wallpaper" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-texteditor", match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = "0.8 0.7" })
hl.window_rule({ name = "opacity-deluge", match = { class = "^(deluge)$" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-riot", match = { class = "^(im.riot.Riot)$" }, opacity = "0.9 0.8" }) -- Element matrix client
hl.window_rule({ name = "opacity-seahorse", match = { class = "^(seahorse)$" }, opacity = "0.9 0.8" }) -- gnome-keyring gui
hl.window_rule({ name = "opacity-pip", match = { title = "^(Picture-in-Picture)$" }, opacity = "0.95 0.75" })

-- ===== Size =====
hl.window_rule({ name = "size-koolcheat", match = { tag = "KooL_Cheat" }, size = "65% 90%" })
hl.window_rule({ name = "size-wallpaper", match = { tag = "wallpaper" }, size = "70% 70%" })
hl.window_rule({ name = "size-settings", match = { tag = "settings" }, size = "70% 70%" })
hl.window_rule({ name = "size-whatsapp", match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" }, size = "60% 70%" })
hl.window_rule({ name = "size-ferdium", match = { class = "^([Ff]erdium)$" }, size = "60% 70%" })

-- ===== Pinning / extras =====
hl.window_rule({ name = "pin-pip", match = { title = "^(Picture-in-Picture)$" }, pin = true })
hl.window_rule({ name = "aspect-pip", match = { title = "^(Picture-in-Picture)$" }, keep_aspect_ratio = true })

-- ===== Blur & fullscreen =====
hl.window_rule({ name = "games-noblur", match = { tag = "games" }, no_blur = true })
hl.window_rule({ name = "games-fullscreen", match = { tag = "games" }, fullscreen = true })

-- ===== Layer rules =====
hl.layer_rule({ name = "rofi-blur", match = { namespace = "rofi" }, blur = true })
hl.layer_rule({ name = "rofi-ignorealpha", match = { namespace = "rofi" }, ignore_alpha = 0 }) -- old: ignorezero
hl.layer_rule({ name = "notifications-blur", match = { namespace = "notifications" }, blur = true })
hl.layer_rule({ name = "notifications-ignorealpha", match = { namespace = "notifications" }, ignore_alpha = 0 }) -- old: ignorezero
