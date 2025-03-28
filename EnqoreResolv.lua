local b_2 = {}

local killMessages = {
    function(victim) return victim .. " - nothing can save you from enqore.lua" end,
    function(victim) return "enqore and アンコール are the same person, " .. victim .. ", did you know?" end,
    function(victim) return "Cry baby " .. victim .. "?" end,
    function(victim) return "Even defensive won't save you from enqore.lua prediction" end,
    function(victim) return "Who needs trash talk when there's enqore.lua?" end,
    function(victim) return victim .. " is having a rough time" end,
    function(victim) return "You can't hit thanks to enqore.lua" end,
    function(victim) return victim .. ", I remember your mom, a horrible woman" end,
    function(victim) return "fuck your face off enqore.lua" end,
    function(victim) return "I'm boosted by アンコール with his enqore.lua" end,
    function(victim) return "I never thought losers like " .. victim .. " would play HVH" end,
    function(victim) return victim .. ", you'll remember me your whole miserable life. enqore.lua" end
}

local first = {
    " enqore resolver for アンコール",
    " アンコール custom resolver from enqore",
    " from enqore for the best",
    " アンコール custom resolver from enqore"
}
local second = {
    " ",
    " ",
    " ",
    " "
}

local menu_color = ui.reference("MISC", "Settings", "Menu color")
b_2.rage = {
    trashtalk      = ui.new_checkbox("rage", "other", "Trashtalk"),
    clantag_enable = ui.new_checkbox("rage", "other", "Enable Clantag"),
    clantag_mode   = ui.new_combobox("rage", "other", "Clantag Mode", {"enqore.lua", "Custom"}),
    clantag_custom = ui.new_textbox("rage", "other", "Custom Clantag", 16),
    space1         = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF────────────", ui.get(menu_color))),
    space2         = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Predict Enemies •", ui.get(menu_color))),
    predict        = ui.new_checkbox("rage", "other", string.format("\v\rPredict Features by \a%02X%02X%02XFFenqore\v\r", ui.get(menu_color))),
    pingpos        = ui.new_combobox("rage", "other", string.format("Latency \a%02X%02X%02XFFDepending", ui.get(menu_color)), {"High Ping > 60", "Low Ping < 45"}),
    hitboxes       = ui.new_multiselect("rage", "other", "Inverse Hitboxes at time-line", "Head", "Chest", "Stomach"),
    pingpos1       = ui.new_slider("rage", "other", "Attach BackTrack At", 1, 3, 1, true, "", 1, {"Head", "Chest", "Stomach"}),
    space3         = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF────────────", ui.get(menu_color))),
    space4         = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Resolver enchantments by enqore •", ui.get(menu_color))),
    jittercorrectionresolvercorsas = ui.new_checkbox("rage", "other", "Jitter " .. string.format("\a%02X%02X%02XFFCorrection", ui.get(menu_color))),
    pingpofass     = ui.new_slider("rage", "other", "Correction " .. string.format("\a%02X%02X%02XFFMode", ui.get(menu_color)), 1, 3, 1, true, "", 1, {"Jitter", "Combined", "Desync"}),
    space5         = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF────────────", ui.get(menu_color))),
    space6         = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Resolver helper •", ui.get(menu_color))),
    interesting    = ui.new_checkbox("rage", "other", string.format("\v\rJitter accuracy \a%02X%02X%02XFFboost\v\r", ui.get(menu_color))),
    boost          = ui.new_slider("rage", "other", "Intensive boost", 1, 3, 2, true, "", 2, {"High", "Medium", "Low"}),
    interlude      = ui.new_checkbox("rage", "other", string.format("\v\rInterlude \a%02X%02X%02XFFAI\v\r", ui.get(menu_color)))
}

local dtPeekFix = ui.new_checkbox("RAGE", "other", "Fix defensive in peek")

ui.set_callback(b_2.rage.clantag_enable, function()
    local enabled = ui.get(b_2.rage.clantag_enable)
    ui.set_visible(b_2.rage.clantag_mode, enabled)
    ui.set_visible(b_2.rage.clantag_custom, enabled and ui.get(b_2.rage.clantag_mode) == "Custom")
    if not enabled then
        client.set_clan_tag("")
    end
end)

ui.set_callback(b_2.rage.clantag_mode, function()
    local mode = ui.get(b_2.rage.clantag_mode)
    local enabled = ui.get(b_2.rage.clantag_enable)
    ui.set_visible(b_2.rage.clantag_custom, enabled and mode == "Custom")
end)
ui.set_visible(b_2.rage.clantag_mode, ui.get(b_2.rage.clantag_enable))
ui.set_visible(b_2.rage.clantag_custom, ui.get(b_2.rage.clantag_enable) and ui.get(b_2.rage.clantag_mode) == "Custom")



local function vec_3(_x, _y, _z)
    return { x = _x or 0, y = _y or 0, z = _z or 0 }
end

local function ticks_to_time()
    return globals.tickinterval() * 16
end

local refs = {
    dt = { ui.reference("RAGE", "Aimbot", "Double tap") }
}

local function player_will_peek()
    local enemies = entity.get_players(true)
    if not enemies then
        return false
    end

    local eye_position = vec_3(client.eye_position())
    local velocity_prop_local = vec_3(entity.get_prop(entity.get_local_player(), "m_vecVelocity"))
    local predicted_eye_position = vec_3(
        eye_position.x + velocity_prop_local.x * ticks_to_time(),
        eye_position.y + velocity_prop_local.y * ticks_to_time(),
        eye_position.z + velocity_prop_local.z * ticks_to_time()
    )

    for i = 1, #enemies do
        local player = enemies[i]
        local velocity_prop = vec_3(entity.get_prop(player, "m_vecVelocity"))
        local origin = vec_3(entity.get_prop(player, "m_vecOrigin"))
        local predicted_origin = vec_3(
            origin.x + velocity_prop.x * ticks_to_time(),
            origin.y + velocity_prop.y * ticks_to_time(),
            origin.z + velocity_prop.z * ticks_to_time()
        )

        entity.get_prop(player, "m_vecOrigin", predicted_origin)

        local head_origin = vec_3(entity.hitbox_position(player, 0))
        local predicted_head_origin = vec_3(
            head_origin.x + velocity_prop.x * ticks_to_time(),
            head_origin.y + velocity_prop.y * ticks_to_time(),
            head_origin.z + velocity_prop.z * ticks_to_time()
        )
        local trace_entity, damage = client.trace_bullet(entity.get_local_player(), predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z)

        entity.get_prop(player, "m_vecOrigin", origin)

        if damage > 0 then
            return true
        end
    end

    return false
end

client.set_event_callback("player_death", function(event)
    local local_entity = entity.get_local_player()
    if not local_entity then return end

    local killer_entity = client.userid_to_entindex(event.attacker)
    if killer_entity == local_entity then
        local victim_entity = client.userid_to_entindex(event.userid)
        if not victim_entity then return end

        local local_team = entity.get_prop(local_entity, "m_iTeamNum")
        local victim_team = entity.get_prop(victim_entity, "m_iTeamNum")
        if victim_team and local_team and victim_team ~= local_team then
            if ui.get(b_2.rage.trashtalk) then
                local victim_name = entity.get_player_name(victim_entity) or "unknown"
                local idx = math.random(1, #killMessages)
                local msg = killMessages[idx](victim_name)
                client.exec("say " .. msg)
            end
        end
    end
end)

client.exec("Clear")
client.exec("con_filter_enable 0")

local enqore = "enqore Prediction ~ "

client.set_event_callback("paint", function()
    local r, g, b, a = ui.get(menu_color)
end)

client.color_log(149, 149, 201, enqore .. "Welcome back")
client.delay_call(2, function() end)

local function lerp(a, b, t)
    return a + (b - a) * t
end

local vector = require("vector")
local y = 0
local alpha = 150
client.set_event_callback("paint_ui", function()
    local screen = vector(client.screen_size())
    local ladd = "enqore Ragebot enchantments"
    local size = vector(screen.x, screen.y)

    local sizing = lerp(0.1, 0.9, math.sin(globals.realtime() * 0.9) * 0.5 + 0.5)
    local rotation = lerp(0, 360, globals.realtime() % 1)
    alpha = lerp(alpha, 0, globals.frametime() * 0.5)
    y = lerp(y, 20, globals.frametime() * 2)

    renderer.rectangle(0, 0, size.x, size.y, 13, 13, 13, alpha)
    renderer.circle_outline(screen.x / 2, screen.y / 2, 149, 149, 201, alpha, 20, rotation, sizing, 3)
    renderer.text(screen.x / 2, screen.y / 2 + 40, 149, 149, 201, alpha, "c", 0, "Loaded !")
    renderer.text(screen.x / 2, screen.y / 2 + 60, 149, 149, 201, alpha, "c", 0, "Welcome - " .. ladd .. " [DEBUG]")
end)

local options = {"Head", "Chest", "Stomach"}
local levl = {"Jitter", "Combined", "Desync"}
local topchik = {"High", "Medium", "Low"}

local ref = {
    aimbot = ui.reference("RAGE", "Aimbot", "Enabled"),
    doubletap = {
        main = { ui.reference("RAGE", "Aimbot", "Double tap") },
        fakelag_limit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit")
    }
}

client.set_event_callback("paint", function()
    rgba_to_hex = function(c, d, e, f)
        return string.format("%02x%02x%02x%02x", c, d, e, f)
    end
end)

client.set_event_callback("paint", function()
    if ui.get(b_2.rage.predict) then
        local r, g, b = ui.get(menu_color)
        renderer.indicator(r, g, b, 255, "\a" .. rgba_to_hex(r, g, b, 255 * math.abs(math.cos(globals.curtime() * 1))) .. "enqorehvh")
    end
end)

local function checks1()
    if ui.get(b_2.rage.predict) then
        ui.set_visible(b_2.rage.pingpos, true)
        ui.set_visible(b_2.rage.pingpos1, true)
        ui.set_visible(b_2.rage.hitboxes, true)
    else
        ui.set_visible(b_2.rage.pingpos, false)
        ui.set_visible(b_2.rage.pingpos1, false)
        ui.set_visible(b_2.rage.hitboxes, false)
    end
end

checks1()
ui.set_callback(b_2.rage.predict, function()
    checks1()
end)

local function checks2()
    if ui.get(b_2.rage.jittercorrectionresolvercorsas) then
        ui.set_visible(b_2.rage.pingpofass, true)
    else
        ui.set_visible(b_2.rage.pingpofass, false)
    end
end

checks2()
ui.set_callback(b_2.rage.jittercorrectionresolvercorsas, function()
    checks2()
end)

local function checks()
    if ui.get(b_2.rage.interesting) then
        ui.set_visible(b_2.rage.boost, true)
    else
        ui.set_visible(b_2.rage.boost, false)
    end
end

checks()
to_hex = function(r, g, b, a)
    return string.format("%02x%02x%02x%02x", r, g, b, a)
end

ui.set_callback(b_2.rage.interesting, function()
    checks()
end)

client.set_event_callback("setup_command", function(cmd)
    local lp = entity.get_local_player()
    if lp then
        if ui.get(b_2.rage.predict) then
            if ui.get(b_2.rage.pingpos) == "Low" then
                cvar.cl_interpolate:set_int(0)
                cvar.cl_interp_ratio:set_int(1)
                cvar.cl_interp:set_float(0.031000)
            else
                cvar.cl_interp:set_float(0.031000)
                cvar.cl_interp_ratio:set_int(1)
                cvar.cl_interp:set_int(0)
            end
        else
            cvar.cl_interp:set_float(0.016000)
            cvar.cl_interp_ratio:set_int(1)
            cvar.cl_interp:set_int(0)
        end
    end

    if ui.get(dtPeekFix) then
        local dt = ui.get(refs.dt[1])
        if dt and player_will_peek() then
            cmd.force_defensive = true
        else
            cmd.force_defensive = false
        end
    end
end)



misc = misc or {}
vars = vars or {}
vars.misc = vars.misc or {}

misc.clantag = {
    enabled = false,
    last = 0,
    list = {
        "⠀⠀⠀⠀",
        "_⠀⠀⠀",
        "e_⠀⠀⠀",
        "en_⠀⠀",
        "enq_⠀⠀",
        "enqo_",
        "enqor_",
        "enqore_",
        "enqore.l_",
        "enqore.lu_",
        "enqore.lua_",
        "enqore.lua",
        "enqore.lua_",
        "enqore.lua",
        "enqore.lua_",
        "enqore.lua",
        "enqore.lua_",
        "enqore.lu_",
        "enqore.l_",
        "enqore_",
        "enqor_",
        "enqo_",
        "enq_⠀⠀",
        "en_⠀⠀",
        "e_⠀⠀⠀",
        "_⠀⠀⠀",
        "⠀⠀⠀⠀"
    },
    work = function()
        if misc.clantag.enabled and not vars.misc.clantag.value then
            misc.clantag.enabled = false
            callbacks.net_update_end:unset(misc.clantag.work)
            client.set_clan_tag("")
        end
    end
}

client.set_event_callback("net_update_end", function()
    if not ui.get(b_2.rage.clantag_enable) then
        client.set_clan_tag("")
        return
    end

    local mode = ui.get(b_2.rage.clantag_mode)
    if mode == "enqore.lua" then
        misc.clantag.enabled = true
        local tagList = misc.clantag.list
        local count = #tagList
        local t = globals.realtime()
        local speed = 5
        local index = math.floor(t * speed % count) + 1
        client.set_clan_tag(tagList[index])
    elseif mode == "Custom" then
        local customTag = ui.get(b_2.rage.clantag_custom)
        if customTag and customTag ~= "" then
            local len = #customTag
            local speed = 5
            local offset = math.floor(globals.realtime() * speed) % len
            local animated = customTag:sub(offset+1) .. customTag:sub(1, offset)
            client.set_clan_tag(animated)
        else
            client.set_clan_tag("")
        end
    else
        client.set_clan_tag("")
    end
end)