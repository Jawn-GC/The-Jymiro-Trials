local level_var = {
    identifier = "crush_on_you",
    title = "Crush on You",
    theme = THEME.TEMPLE,
    world = 1,
	level = 9,
	width = 5,
    height = 5,
    file_name = "crush_on_you.lvl",
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
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_TEMPLE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_CRITTERLOCUST)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.x = entity.x - 0.5
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_TELESCOPE)

	define_tile_code("scepter_shot")
	local scepter_shot_xy = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		scepter_shot_xy[#scepter_shot_xy + 1] = {x,y}
		return true
	end, "scepter_shot")

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()	
		if frames % 300 == 0 then
			for i = 1,#scepter_shot_xy do
				local uid = spawn(ENT_TYPE.ITEM_SCEPTER_ANUBISSHOT, scepter_shot_xy[i][1], scepter_shot_xy[i][2], 0, 0, 0)
				get_entity(uid).speed = 0.0
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
