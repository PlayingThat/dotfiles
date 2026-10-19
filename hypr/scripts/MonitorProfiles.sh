#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For applying Pre-configured Monitor Profiles

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# Variables
iDIR="$HOME/.config/swaync/images"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
monitor_dir="$HOME/.config/hypr/Monitor_Profiles"
target="$HOME/.config/hypr/monitors.lua"
rofi_theme="$HOME/.config/rofi/config-Monitors.rasi"
msg='❗NOTE:❗ This will overwrite $HOME/.config/hypr/monitors.lua'

# Define the list of files to ignore
ignore_files=(
  "README"
)

# list of Monitor Profiles, sorted alphabetically with numbers first
mon_profiles_list=$(find -L "$monitor_dir" -maxdepth 1 -type f | sed 's/.*\///' | sed 's/\.conf$//' | sort -V)

# Remove ignored files from the list
for ignored_file in "${ignore_files[@]}"; do
    mon_profiles_list=$(echo "$mon_profiles_list" | grep -v -E "^$ignored_file$")
done

# Rofi Menu
chosen_file=$(echo "$mon_profiles_list" | rofi -i -dmenu -config $rofi_theme -mesg "$msg")

if [[ -n "$chosen_file" ]]; then
    full_path="$monitor_dir/$chosen_file.conf"

    # Profiles in Monitor_Profiles/ stay in plain hyprlang `monitor=` syntax
    # (nwg-displays itself only knows how to write that format -- see
    # monitors.lua's own header comment), so convert to hl.monitor({...})
    # calls here when applying, since monitors.lua -- not monitors.conf -- is
    # what hyprland.lua actually require()s.
    {
        echo "-- Applied from Monitor_Profiles/$chosen_file.conf by MonitorProfiles.sh on $(date)"
        lua - "$full_path" <<'LUA'
local f = assert(io.open(arg[1]))
for line in f:lines() do
    local rest = line:match("^%s*monitor%s*=%s*(.*)$")
    if rest then
        local fields = {}
        for tok in (rest .. ","):gmatch("([^,]*),") do
            fields[#fields + 1] = tok:match("^%s*(.-)%s*$")
        end
        local output, mode, position, scale = fields[1] or "", fields[2], fields[3], fields[4]
        local parts = { string.format("output = %q", output) }
        if mode == "disable" then
            parts[#parts + 1] = "disabled = true"
        else
            if mode and mode ~= "" then parts[#parts + 1] = string.format("mode = %q", mode) end
            if position and position ~= "" then parts[#parts + 1] = string.format("position = %q", position) end
            if scale and scale ~= "" then parts[#parts + 1] = string.format("scale = %q", scale) end
            -- best-effort mapping of trailing keyword,value tokens (mirror, transform, bitdepth, disable)
            local i = 5
            while i <= #fields do
                local key = (fields[i] or ""):lower()
                if key == "mirror" then
                    parts[#parts + 1] = string.format("mirror = %q", fields[i + 1] or "")
                    i = i + 2
                elseif key == "transform" then
                    parts[#parts + 1] = "transform = " .. (fields[i + 1] or "0")
                    i = i + 2
                elseif key == "bitdepth" then
                    parts[#parts + 1] = "bitdepth = " .. (fields[i + 1] or "8")
                    i = i + 2
                elseif key == "disable" then
                    parts[#parts + 1] = "disabled = true"
                    i = i + 1
                else
                    i = i + 1 -- unrecognized token, skip (best effort)
                end
            end
        end
        print("hl.monitor({ " .. table.concat(parts, ", ") .. " })")
    end
end
LUA
    } > "$target"

    notify-send -u low -i "$iDIR/ja.png" "$chosen_file" "Monitor Profile Loaded"
fi

sleep 1
${SCRIPTSDIR}/RefreshNoWaybar.sh &