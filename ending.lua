local sound = require('play_sound')

local level_var = {
    identifier = "Ending",
    title = "Ending",
    theme = THEME.CITY_OF_GOLD,
	world = 1,
	level = 15,
    width = 3,
    height = 3,
    file_name = "cog.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level_var.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		generate_world_particles(PARTICLEEMITTER.AU_GOLD_SPARKLES, entity.uid)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.CHAR_HIREDHAND)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity.station = 3
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.TV)

	local frames = 0
	local start_x, start_y, start_l
	local pilots_dead = 0
	local buff_pilot_spawned = false
	local pilots = {}
	local buff_pilot
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()	
		if frames == 0 then
			start_x, start_y, start_l = get_position(players[1].uid)
			pilots = get_entities_by(ENT_TYPE.CHAR_HIREDHAND, MASK.ANY, LAYER.BOTH)
		end
		for i = 1, #pilots do
			if get_entity(pilots[i]) == nil or get_entity(pilots[i]).health == 0 then
				pilots_dead = pilots_dead + 1
			end
		end
		if pilots_dead == #pilots and buff_pilot_spawned == false then
			buff_pilot = spawn_companion(ENT_TYPE.CHAR_HIREDHAND, start_x, start_y, start_l, 0, 0)
			get_entity(buff_pilot).health = 99
			get_entity(buff_pilot).more_flags = set_flag(get_entity(buff_pilot).more_flags, 2)
			pick_up(buff_pilot, spawn(ENT_TYPE.ITEM_PLASMACANNON, 0, 0, 0, 0, 0))
			generate_world_particles(PARTICLEEMITTER.ALTAR_SKULL, buff_pilot)
			sound.play_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)
			buff_pilot_spawned = true
		end
		pilots_dead = 0
		frames = frames + 1
    end, ON.FRAME)

	toast("Congratulations!")
end

level_var.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level_var