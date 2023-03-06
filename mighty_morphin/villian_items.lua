morphinggrid.register_griditem("mighty_morphin:magic_wand", {
    description = "Magic Wand",
    inventory_image = "mighty_morphin_magic_wand.png",
    type = "tool",
    tool_capabilities = {
        damage_groups = { fleshy = 350 }
    },
    griditem_commands = {
        set_henchmen_amount = {
            description = "Sets the amount of henchmen that will be spawned.",
            func = function(name, text)
                local n = tonumber(text)
                if n and n > 0 then
                    local player = minetest.get_player_by_name(name)
                    local stack = player:get_wielded_item()
                    stack:get_meta():set_string("henchmen_amount", tostring(n))
                    return true, "", stack
                end
                return false, "Please enter a valid number greater than zero."
            end
        }
    },
    grid_doc = {
        description = "Rita Repulsa's Magic Wand."
    },

    on_place = function(_, placer, pointed_thing)
        local item = placer:get_wielded_item()
        local n = tonumber(item:get_meta():get_string("mode")) or 0
        n = n + 1
        if n > 1 then n = 0 end
        item:get_meta():set_string("mode", tostring(n))
        placer:set_wielded_item(item)
    end,

    on_use = function(itemstack, user, pointed_thing)
        local mode = tonumber(itemstack:get_meta():get_string("mode")) or 0
        if mode == 0 then
			if pointed_thing.ref then
				pointed_thing.ref:punch(user, 0.1, itemstack:get_definition().tool_capabilities)
			end
        elseif mode == 1 then
            if pointed_thing.type == "node" then
                local pos = pointed_thing.above
                local meta = user:get_wielded_item():get_meta()
                local n = tonumber(meta:get_string("henchmen_amount")) or 1
                for i=1, n do
                    minetest.add_entity(pos, "mighty_morphin:putty")
                end
            end
        end
    end
})

morphinggrid.register_griditem("mighty_morphin:z_staff", {
    description = "Z Staff",
    inventory_image = "mighty_morphin_z_staff.png",
    type = "tool",
    range = 1072,
    tool_capabilities = {
        full_punch_interval = 0.1,
        damage_groups = { fleshy = 550 }
    },
    griditem_commands = {
        set_henchmen_amount = {
            description = "Sets the amount of henchmen that will be spawned.",
            func = function(name, text)
                local n = tonumber(text)
                if n and n > 0 then
                    local player = minetest.get_player_by_name(name)
                    local stack = player:get_wielded_item()
                    stack:get_meta():set_string("henchmen_amount", tostring(n))
                    return true, "", stack
                end
                return false, "Please enter a valid number greater than zero."
            end
        }
    },
    grid_doc = {
        description = "Zedd's Z Staff."
    },

    on_place = function(_, placer, pointed_thing)
        local item = placer:get_wielded_item()
        local n = tonumber(item:get_meta():get_string("mode")) or 0
        n = n + 1
        if n > 1 then n = 0 end
        item:get_meta():set_string("mode", tostring(n))
        placer:set_wielded_item(item)
    end,

    on_use = function(itemstack, user, pointed_thing)
        local mode = tonumber(itemstack:get_meta():get_string("mode")) or 0
        if mode == 0 then
			if pointed_thing.ref then
				pointed_thing.ref:punch(user, 0.1, itemstack:get_definition().tool_capabilities)
			end
        elseif mode == 1 then
            if pointed_thing.type == "node" then
                local pos = pointed_thing.above
                local meta = user:get_wielded_item():get_meta()
                local n = tonumber(meta:get_string("henchmen_amount")) or 1
                for i=1, n do
                    minetest.add_entity(pos, "mighty_morphin:z_putty")
                end
            end
        end
    end
})