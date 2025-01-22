local level_var = {
    identifier = "in_a_prickle",
    title = "In a Prickle",
    theme = THEME.JUNGLE,
    world = 1,
	level = 5,
    width = 6,
    height = 5,
    file_name = "in_a_prickle.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level_var.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SKELETON)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_BONES)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_STONE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	local snap
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		snap = entity.uid
		entity.more_flags = set_flag(entity.more_flags, ENT_MORE_FLAG.CURSED_EFFECT)
		generate_world_particles(PARTICLEEMITTER.CURSEDEFFECT_PIECES, entity.uid)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SNAP_TRAP)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity:set_cursed(true)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_PET_DOG)

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
        if get_entity(snap) ~= nil then
			if get_entity(snap).bait_uid == -1 then
				get_entity(snap):destroy()
			end
		end
		frames = frames + 1
    end, ON.FRAME)

	toast(level_var.title)
	
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
