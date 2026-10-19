#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# searchable enabled keybinds using rofi

# kill yad to not interfere with this binds
pkill yad || true

# check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# define the config files
laptop_lua="$HOME/.config/hypr/UserConfigs/Laptops.lua"
rofi_theme="$HOME/.config/rofi/config-keybinds.rasi"
msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

# modules to load, always with configs/Keybinds + UserKeybinds; Laptops only
# if present (matches the old laptop_conf existence check)
modules="configs/Keybinds UserConfigs/UserKeybinds"
[[ -f "$laptop_lua" ]] && modules="$modules UserConfigs/Laptops"

# These files call hl.bind(key, hl.dsp.xxx(...), opts) rather than hyprlang
# `bind = ...` lines, and the key string is often built at runtime (e.g.
# mainMod .. " + Q"), so grep/sed on the source can't resolve it. Load the
# real .lua files with a stub `hl` API instead and record what they register
# -- this also naturally handles the workspace-binds for-loop and
# require("UserConfigs/01-UserDefaults") for term/files.
display_keybinds=$(cd "$HOME/.config/hypr" && lua - $modules <<'LUA'
package.path = "./?.lua;" .. package.path

local line_cache = {}
local function get_line(source, lineno)
    local path = source:gsub("^@", "")
    local lines = line_cache[path]
    if not lines then
        lines = {}
        local f = io.open(path, "r")
        if f then
            for l in f:lines() do lines[#lines + 1] = l end
            f:close()
        end
        line_cache[path] = lines
    end
    return lines[lineno]
end

-- Trailing comments here always follow the closing paren of the full
-- hl.bind(...) statement, so anchoring on ")<ws>--" avoids false positives
-- from "--" inside exec_cmd string literals (e.g. "Volume.sh --inc").
local function trailing_comment(source, lineno)
    local line = get_line(source, lineno)
    return line and line:match("%)%s*%-%-%s*(.-)%s*$")
end

local function describe(v)
    if type(v) == "table" then
        local parts = {}
        for k, vv in pairs(v) do parts[#parts + 1] = tostring(k) .. "=" .. tostring(vv) end
        table.sort(parts)
        return "{ " .. table.concat(parts, ", ") .. " }"
    elseif type(v) == "function" then
        return "<function>"
    else
        return tostring(v)
    end
end

-- hl.dsp.window.close() etc: build a dotted path through __index and render
-- "path(args)" when called, so dispatcher calls print the same as they read
-- in the source instead of needing one stub per dispatcher.
local function make_dsp(path)
    return setmetatable({}, {
        __index = function(_, k) return make_dsp(path == "" and k or (path .. "." .. k)) end,
        __call = function(_, ...)
            local args, n = {}, select("#", ...)
            for i = 1, n do args[i] = describe((select(i, ...))) end
            return path .. "(" .. table.concat(args, ", ") .. ")"
        end,
    })
end

local binds = {}
hl = setmetatable({
    dsp = make_dsp(""),
    bind = function(key, action, opts)
        local info = debug.getinfo(2, "Sl")
        binds[#binds + 1] = {
            key = key,
            action = describe(action),
            flags = opts and describe(opts) or nil,
            comment = trailing_comment(info.source, info.currentline),
        }
    end,
}, {
    -- Catch-all for hl.* calls these files use that we don't care about here
    -- (hl.env, hl.on, hl.device, ...) so an API we haven't stubbed doesn't
    -- abort the rest of that file's binds.
    __index = function() return function(...) return ... end end,
})

for _, modname in ipairs(arg) do
    local ok, err = pcall(require, modname)
    if not ok then
        io.stderr:write("KeyBinds.sh: failed to load " .. modname .. ": " .. tostring(err) .. "\n")
    end
end

for _, b in ipairs(binds) do
    local out = b.key .. "  ->  " .. b.action
    if b.flags then out = out .. " " .. b.flags end
    if b.comment and b.comment ~= "" then out = out .. "   # " .. b.comment end
    print(out)
end
LUA
)

# check for any keybinds to display
if [[ -z "$display_keybinds" ]]; then
    echo "no keybinds found."
    exit 1
fi

# use rofi to display the keybinds
echo "$display_keybinds" | rofi -dmenu -i -config "$rofi_theme" -mesg "$msg"