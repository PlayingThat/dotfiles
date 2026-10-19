-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ --
-- User Settings -- your own settings, kept separate so they survive dotfiles updates.
-- Field names verified against /usr/share/hypr/stubs/hl.meta.lua (HL.ConfigOpt.*)

hl.config({
    dwindle = {
        preserve_split = true,
        special_scale_factor = 0.8,
    },

    master = {
        new_status = "master",
        new_on_top = true,
        mfact = 0.5,
    },

    general = {
        resize_on_border = true,
        layout = "dwindle",
    },

    input = {
        kb_layout = "de",
        kb_variant = "",
        kb_model = "",
        kb_options = "ctrl:nocaps",
        kb_rules = "",
        repeat_rate = 50,
        repeat_delay = 300,

        sensitivity = 0.2, -- mouse sensitivity
        accel_profile = "adaptive", -- flat or adaptive or "" (libinput default)
        numlock_by_default = true,
        left_handed = false,
        follow_mouse = true,
        float_switch_override_focus = false,

        touchpad = {
            disable_while_typing = true,
            natural_scroll = true,
            clickfinger_behavior = false,
            middle_button_emulation = true,
            tap_to_click = true, -- was "tap-to-click" in hyprlang; the Lua schema uses tap_to_click
            drag_lock = false,
        },

        -- below for devices with a touchscreen
        touchdevice = {
            enabled = true,
        },

        -- below is for tablets
        tablet = {
            transform = 0,
            left_handed = false,
        },
    },

    gestures = {
        workspace_swipe_distance = 500,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_forever = true,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 2,
        mouse_move_enables_dpms = true,
        enable_swallow = false,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
    },

    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },

    -- could help when scaling and not pixelating
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },

    render = {
        direct_scanout = 0,
    },

    cursor = {
        sync_gsettings_theme = true,
        no_hardware_cursors = 1, -- set to 1 to disable hardware cursors
        enable_hyprcursor = true,
        warp_on_change_workspace = 2,
        no_warps = true,
    },
})

-- ignore maximize requests from apps (e.g. kitty), so new windows tile normally
hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })

-- slurp: no fade-out, otherwise grim captures its selection border
hl.layer_rule({ name = "slurp-noanim", match = { namespace = "selection" }, no_anim = true })
