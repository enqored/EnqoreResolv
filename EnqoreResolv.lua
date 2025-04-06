local function vec3(x, y, z)
	return { x = x or 0, y = y or 0, z = z or 0 }
end
vector = vec3

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function rgba_to_hex(r, g, b, a)
	return string.format("%02x%02x%02x%02x", r, g, b, a)
end

local function ticks_to_time()
	return globals.tickinterval() * 16
end

local uiComponents = {}
local menu_color = ui.reference("MISC", "Settings", "Menu color")
uiComponents.rage = {
	trashtalk           = ui.new_checkbox("rage", "other", "Trashtalk"),
	clantag_enable      = ui.new_checkbox("rage", "other", "Enable ClanTag"),
	clantag_mode        = ui.new_combobox("rage", "other", "ClanTag Mode", {"enqore.lua", "Custom", "Neverlose"}),
	clantag_custom      = ui.new_textbox("rage", "other", "Custom ClanTag", 16),
	clantag_speed       = ui.new_slider("rage", "other", "ClanTag Speed", 1, 10, 5, true, "", 1),
	clantag_anim        = ui.new_combobox("rage", "other", "ClanTag Animation", {"Scroll", "Blink", "Static"}),
	clantag_fine_speed  = ui.new_slider("rage", "other", "Custom Tag Fine Tune Speed", 1, 10, 5, true, "", 1),
	clantag_fine_offset = ui.new_slider("rage", "other", "Custom Tag Fine Tune Offset", 0, 10, 0, true, "", 1),
	space1              = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF────────────", ui.get(menu_color))),
	space2              = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Predict Enemies •", ui.get(menu_color))),
	predict             = ui.new_checkbox("rage", "other", string.format("\v\rPredict Features by \a%02X%02X%02XFFenqore\v\r", ui.get(menu_color))),
	pingpos             = ui.new_combobox("rage", "other", string.format("Latency \a%02X%02X%02XFFDepending", ui.get(menu_color)), {"High Ping > 60", "Low Ping < 45"}),
	hitboxes            = ui.new_multiselect("rage", "other", "Inverse Hitboxes at time-line", "Head", "Chest", "Stomach"),
	pingpos1            = ui.new_slider("rage", "other", "Attach BackTrack At", 1, 3, 1, true, "", 1, {"Head", "Chest", "Stomach"}),
	space3              = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF────────────", ui.get(menu_color))),
	space4              = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Resolver enchantments by enqore •", ui.get(menu_color))),
	jitterResolver      = ui.new_checkbox("rage", "other", "Jitter " .. string.format("\a%02X%02X%02XFFCorrection", ui.get(menu_color))),
	correctionMode      = ui.new_slider("rage", "other", "Correction " .. string.format("\a%02X%02X%02XFFMode", ui.get(menu_color)), 1, 3, 1, true, "", 1, {"Jitter", "Combined", "Desync"}),
	space5              = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF────────────", ui.get(menu_color))),
	space6              = ui.new_label("rage", "other", string.format("\a%02X%02X%02XFF• Resolver helper •", ui.get(menu_color))),
	accuracyBoost       = ui.new_checkbox("rage", "other", string.format("\v\rJitter accuracy \a%02X%02X%02XFFboost\v\r", ui.get(menu_color))),
	boostLevel          = ui.new_slider("rage", "other", "Intensive boost", 1, 3, 2, true, "", 2, {"High", "Medium", "Low"}),
	interlude           = ui.new_checkbox("rage", "other", string.format("\v\rInterlude \a%02X%02X%02XFFAI\v\r", ui.get(menu_color)))
}
local dtPeekFix = ui.new_checkbox("RAGE", "other", "Fix defensive in peek")

local function updateVisibility(element, state)
	ui.set_visible(element, state)
end

local function updateClantagVisibility()
	local enabled = ui.get(uiComponents.rage.clantag_enable)
	local mode = ui.get(uiComponents.rage.clantag_mode)
	updateVisibility(uiComponents.rage.clantag_mode, enabled)
	updateVisibility(uiComponents.rage.clantag_custom, enabled and mode == "Custom")
	updateVisibility(uiComponents.rage.clantag_speed, enabled and mode == "Custom")
	updateVisibility(uiComponents.rage.clantag_anim, enabled and mode == "Custom")
	updateVisibility(uiComponents.rage.clantag_fine_speed, enabled and mode == "Custom")
	updateVisibility(uiComponents.rage.clantag_fine_offset, enabled and mode == "Custom")
	if not enabled then
		client.set_clan_tag("")
	end
end

ui.set_callback(uiComponents.rage.clantag_enable, updateClantagVisibility)
ui.set_callback(uiComponents.rage.clantag_mode, updateClantagVisibility)
updateClantagVisibility()

local function updatePredictVisibility()
	local predictOn = ui.get(uiComponents.rage.predict)
	updateVisibility(uiComponents.rage.pingpos, predictOn)
	updateVisibility(uiComponents.rage.pingpos1, predictOn)
	updateVisibility(uiComponents.rage.hitboxes, predictOn)
end

updatePredictVisibility()
ui.set_callback(uiComponents.rage.predict, updatePredictVisibility)

local function updateCorrectionVisibility()
	updateVisibility(uiComponents.rage.correctionMode, ui.get(uiComponents.rage.jitterResolver))
end

updateCorrectionVisibility()
ui.set_callback(uiComponents.rage.jitterResolver, updateCorrectionVisibility)

local function updateBoostVisibility()
	updateVisibility(uiComponents.rage.boostLevel, ui.get(uiComponents.rage.accuracyBoost))
end

updateBoostVisibility()
ui.set_callback(uiComponents.rage.accuracyBoost, updateBoostVisibility)

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

local function player_will_peek()
	local enemies = entity.get_players(true)
	if not enemies then
		return false
	end
	local localPlayer = entity.get_local_player()
	if not localPlayer then
		return false
	end
	local eyePos = vec3(client.eye_position())
	local localVelocity = vec3(entity.get_prop(localPlayer, "m_vecVelocity"))
	local tickTime = ticks_to_time()
	local predictedEye = vec3(eyePos.x + localVelocity.x * tickTime, eyePos.y + localVelocity.y * tickTime, eyePos.z + localVelocity.z * tickTime)
	for i = 1, #enemies do
		local enemy = enemies[i]
		local enemyVelocity = vec3(entity.get_prop(enemy, "m_vecVelocity"))
		local enemyOrigin = vec3(entity.get_prop(enemy, "m_vecOrigin"))
		local predictedOrigin = vec3(enemyOrigin.x + enemyVelocity.x * tickTime, enemyOrigin.y + enemyVelocity.y * tickTime, enemyOrigin.z + enemyVelocity.z * tickTime)
		entity.get_prop(enemy, "m_vecOrigin", predictedOrigin)
		local headPos = vec3(entity.hitbox_position(enemy, 0))
		local predictedHead = vec3(headPos.x + enemyVelocity.x * tickTime, headPos.y + enemyVelocity.y * tickTime, headPos.z + enemyVelocity.z * tickTime)
		local trace_entity, damage = client.trace_bullet(localPlayer, predictedEye.x, predictedEye.y, predictedEye.z, predictedHead.x, predictedHead.y, predictedHead.z)
		entity.get_prop(enemy, "m_vecOrigin", enemyOrigin)
		if damage > 0 then
			return true
		end
	end
	return false
end

client.set_event_callback("player_death", function(event)
	local localPlayer = entity.get_local_player()
	if not localPlayer then
		return
	end
	local killer = client.userid_to_entindex(event.attacker)
	if killer == localPlayer then
		local victim = client.userid_to_entindex(event.userid)
		if not victim then
			return
		end
		local localTeam = entity.get_prop(localPlayer, "m_iTeamNum")
		local victimTeam = entity.get_prop(victim, "m_iTeamNum")
		if victimTeam and localTeam and victimTeam ~= localTeam and ui.get(uiComponents.rage.trashtalk) then
			local victimName = entity.get_player_name(victim) or "unknown"
			local idx = math.random(1, #killMessages)
			local msg = killMessages[idx](victimName)
			client.exec("say " .. msg)
		end
	end
end)

client.exec("Clear")
client.exec("con_filter_enable 0")

local animationText = "enqore Ragebot enchantments"
local alpha = 150
local y = 0
client.set_event_callback("paint_ui", function()
	local screenW, screenH = client.screen_size()
	local sizing = lerp(0.1, 0.9, math.sin(globals.realtime() * 0.9) * 0.5 + 0.5)
	local rotation = lerp(0, 360, globals.realtime() % 1)
	alpha = lerp(alpha, 0, globals.frametime() * 0.5)
	y = lerp(y, 20, globals.frametime() * 2)
	renderer.rectangle(0, 0, screenW, screenH, 13, 13, 13, alpha)
	renderer.circle_outline(screenW / 2, screenH / 2, 149, 149, 201, alpha, 20, rotation, sizing, 3)
	renderer.text(screenW / 2, screenH / 2 + 40, 149, 149, 201, alpha, "c", 0, "Loaded !")
	renderer.text(screenW / 2, screenH / 2 + 60, 149, 149, 201, alpha, "c", 0, "Welcome - " .. animationText .. " [DEBUG]")
end)

local tracers = {}
client.set_event_callback("bullet_impact", function(event)
	local shooter = client.userid_to_entindex(event.userid)
	local impact_pos = vec3(event.x, event.y, event.z)
	local shooter_pos = nil
	if shooter == entity.get_local_player() then
		shooter_pos = vec3(client.eye_position())
	else
		shooter_pos = vec3(entity.get_prop(shooter, "m_vecOrigin"))
	end
	table.insert(tracers, {start = shooter_pos, ["end"] = impact_pos, time = globals.realtime()})
end)

client.set_event_callback("paint", function()
	for i = #tracers, 1, -1 do
		local tracer = tracers[i]
		if globals.realtime() - tracer.time > 1 then
			table.remove(tracers, i)
		else
			local s = renderer.world_to_screen(tracer.start)
			local e = renderer.world_to_screen(tracer["end"])
			if s and e then
				renderer.line(s.x, s.y, e.x, e.y, 255, 0, 0, 255)
			end
		end
	end
	if ui.get(uiComponents.rage.jitterResolver) then
		local enemies = entity.get_players(true)
		for i = 1, #enemies do
			local enemy = enemies[i]
			local enemy_origin = vec3(entity.get_prop(enemy, "m_vecOrigin"))
			local pos = renderer.world_to_screen(enemy_origin)
			if pos then
				renderer.text(pos.x, pos.y, 255, 255, 0, 255, "c", 0, "Resolver fixed")
			end
		end
	end
end)

local refs = { dt = { ui.reference("RAGE", "Aimbot", "Double tap") } }
client.set_event_callback("setup_command", function(cmd)
	local localPlayer = entity.get_local_player()
	if localPlayer then
		if ui.get(uiComponents.rage.predict) then
			if ui.get(uiComponents.rage.pingpos) == "Low" then
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
		local dtEnabled = ui.get(refs.dt[1])
		if dtEnabled and player_will_peek() then
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
	}
}

client.set_event_callback("net_update_end", function()
	local mode = ui.get(uiComponents.rage.clantag_mode)
	if mode == "enqore.lua" then
		local tagList = misc.clantag.list
		local count = #tagList
		local tick = math.floor(globals.realtime() * 5) % count + 1
		client.set_clan_tag(tagList[tick])
	elseif mode == "Neverlose" then
		local t = math.floor(globals.realtime()) % 53
		if t == 1 then client.set_clan_tag("  ")
		elseif t == 2 then client.set_clan_tag(" | ")
		elseif t == 3 then client.set_clan_tag(" |\\ ")
		elseif t == 4 then client.set_clan_tag(" |\\| ")
		elseif t == 5 then client.set_clan_tag(" N ")
		elseif t == 6 then client.set_clan_tag(" N3 ")
		elseif t == 7 then client.set_clan_tag(" Ne ")
		elseif t == 8 then client.set_clan_tag(" Ne\\ ")
		elseif t == 9 then client.set_clan_tag(" Ne\\/ ")
		elseif t == 10 then client.set_clan_tag(" Nev ")
		elseif t == 11 then client.set_clan_tag(" Nev3 ")
		elseif t == 12 then client.set_clan_tag(" Neve ")
		elseif t == 13 then client.set_clan_tag(" Neve| ")
		elseif t == 14 then client.set_clan_tag(" Neve|2 ")
		elseif t == 15 then client.set_clan_tag(" Never|_ ")
		elseif t == 16 then client.set_clan_tag(" Neverl ")
		elseif t == 17 then client.set_clan_tag(" Neverl0 ")
		elseif t == 18 then client.set_clan_tag(" Neverlo ")
		elseif t == 19 then client.set_clan_tag(" Neverlo5 ")
		elseif t == 20 then client.set_clan_tag(" Neverlos ")
		elseif t == 21 then client.set_clan_tag(" Neverlos3 ")
		elseif t == 22 then client.set_clan_tag(" Neverlose ")
		elseif t == 23 then client.set_clan_tag(" Neverlose. ")
		elseif t == 24 then client.set_clan_tag(" Neverlose.< ")
		elseif t == 25 then client.set_clan_tag(" Neverlose.c< ")
		elseif t == 26 then client.set_clan_tag(" Neverlose.cc ")
		elseif t == 27 then client.set_clan_tag(" Neverlose.cc ")
		elseif t == 28 then client.set_clan_tag(" Neverlose.c< ")
		elseif t == 29 then client.set_clan_tag(" Neverlose.< ")
		elseif t == 30 then client.set_clan_tag(" Neverlose. ")
		elseif t == 31 then client.set_clan_tag(" Neverlose ")
		elseif t == 32 then client.set_clan_tag(" Neverlos3 ")
		elseif t == 33 then client.set_clan_tag(" Neverlos ")
		elseif t == 34 then client.set_clan_tag(" Neverlo5 ")
		elseif t == 35 then client.set_clan_tag(" Neverlo ")
		elseif t == 36 then client.set_clan_tag(" Neverl0 ")
		elseif t == 37 then client.set_clan_tag(" Neverl ")
		elseif t == 38 then client.set_clan_tag(" Never|_ ")
		elseif t == 39 then client.set_clan_tag(" Never|2 ")
		elseif t == 40 then client.set_clan_tag(" Neve|2 ")
		elseif t == 41 then client.set_clan_tag(" Neve| ")
		elseif t == 42 then client.set_clan_tag(" Neve ")
		elseif t == 43 then client.set_clan_tag(" Nev3 ")
		elseif t == 44 then client.set_clan_tag(" Nev ")
		elseif t == 45 then client.set_clan_tag(" Ne\\/ ")
		elseif t == 46 then client.set_clan_tag(" Ne\\ ")
		elseif t == 47 then client.set_clan_tag(" Ne ")
		elseif t == 48 then client.set_clan_tag(" N3 ")
		elseif t == 49 then client.set_clan_tag(" N ")
		elseif t == 50 then client.set_clan_tag(" |\\| ")
		elseif t == 51 then client.set_clan_tag(" |\\ ")
		elseif t == 52 then client.set_clan_tag(" | ")
		else client.set_clan_tag("  ") end
	elseif mode == "Custom" then
		local customTag = ui.get(uiComponents.rage.clantag_custom)
		local speed = ui.get(uiComponents.rage.clantag_speed)
		local fineSpeed = ui.get(uiComponents.rage.clantag_fine_speed)
		local fineOffset = ui.get(uiComponents.rage.clantag_fine_offset)
		local animType = ui.get(uiComponents.rage.clantag_anim)
		if customTag and customTag ~= "" then
			local len = #customTag
			local offset = (math.floor(globals.realtime() * speed) + fineOffset) % len
			local animated = customTag:sub(offset + 1) .. customTag:sub(1, offset)
			if animType == "Blink" then
				if math.floor(globals.realtime() * fineSpeed) % 2 == 0 then
					client.set_clan_tag(animated)
				else
					client.set_clan_tag("")
				end
			elseif animType == "Static" then
				client.set_clan_tag(customTag)
			else
				client.set_clan_tag(animated)
			end
		else
			client.set_clan_tag("")
		end
	else
		client.set_clan_tag("")
	end
end)

client.color_log(149, 149, 201, "enqore Prediction ~ Welcome back")
client.delay_call(2, function() end)
