local level_var = {
    identifier = "ascension",
    title = "Ascension",
    theme = THEME.TIDE_POOL,
    world = 1,
	level = 8,
	width = 3,
    height = 8,
    file_name = "ascension.lvl",
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
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_PAGODA)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)

	define_tile_code("bubble_shot")
	local bubble_shot = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		bubble_shot[#bubble_shot + 1] = spawn(ENT_TYPE.ITEM_AXOLOTL_BUBBLESHOT, x, y, 0, 0, 0)
		get_entity(bubble_shot[#bubble_shot]).swing = 0.0
		return true
	end, "bubble_shot")

	define_tile_code("scepter_shot")
	local scepter_shot_xy = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		scepter_shot_xy[#scepter_shot_xy + 1] = {x,y}
		return true
	end, "scepter_shot")

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()	
		for i = 1,#bubble_shot do
			if players[1] ~= nil and get_entity(bubble_shot[i]) ~= nil then
				if get_entity(bubble_shot[i]).trapped_uid == players[1].uid then
					local input = read_input(players[1].uid)
					if test_flag(input, INPUT_FLAG.LEFT) == true then
						get_entity(bubble_shot[i]).velocityx = get_entity(bubble_shot[i]).velocityx - 0.003
					elseif test_flag(input, INPUT_FLAG.RIGHT) == true then
						get_entity(bubble_shot[i]).velocityx = get_entity(bubble_shot[i]).velocityx + 0.003
					end
					get_entity(bubble_shot[i]).velocityy = 0.03
				end
			end
		end
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
