morphinggrid.register_rangertype("morphin_masters", {
	description = "Morphin Masters",
	weapons = { "morphin_masters:blaster", "morphin_masters:master_staff" }
})

local rangers = {
	green = { desc = "Green" },
	white = { desc = "White", rgroups = { leader = 1 } },
	black = { desc = "Black" },
	pink = { desc = "Pink" },
	blue = { desc = "Blue" },
	yellow = { desc = "Yellow" },
	red = { desc = "Red" },
	silver = { desc = "Silver" },
	gold = { desc = "Gold" },
}

for k, v in pairs(rangers) do
	morphinggrid.register_ranger("morphin_masters:"..k, {
		description = v.desc.." Morphin Master",
		heal = 100,
		use = 0,
		weapons = { "morphin_masters:blaster", "morphin_masters:master_staff" },
		colors = { k },
		ranger_groups = v.rgroups or {},
		privs = { "morphinggrid" },
		create_rangerdata = false,
		armor_textures = {
			boots = {
				armor = "morphin_masters_boots.png",
				preview = "morphin_masters_boots_preview.png",
				inventory = "morphin_masters_inv_boots.png" 
			},

			leggings = {
				preview = "morphin_masters_leggings_preview.png",
				inventory = "morphin_masters_inv_leggings.png"
			}
		}
	})

	morphinggrid.register_morpher("morphin_masters:staff_"..k, {
		type = "tool",
		description = v.desc.." Morphin Master Staff",
		inventory_image = "morphin_masters_staff_"..k..".png",
		register_griditem = true,
		ranger = "morphin_masters:"..k,
		tool_capabilities = {
			full_punch_interval = 0.1,
			max_drop_level=1,
			groupcaps={
				snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
				cracky={times={[50]=0.10}, uses=1, maxlevel=50},
			},
			damage_groups = {fleshy=250},
		},
		
		morph_func_override = function(player, itemstack)
			if morphinggrid.get_morph_status(player) ~= "morphin_masters:"..k then
				morphinggrid.morph(player, "morphin_masters:"..k, {morpher=itemstack:get_name(), itemstack=itemstack})
			end
		end,
		
		on_use = function(itemstack, player, pointed_thing)
			local ctrl = player:get_player_control()
			if ctrl.RMB then
				for i, v in ipairs(minetest.get_objects_inside_radius(player:get_pos(), 15)) do
					local capabilities = {
						full_punch_interval = 0,
						max_drop_level=1,
						damage_groups = {fleshy=25},
					}
					
					if v ~= player then
						v:punch(player, 0.1, capabilities)
					end
				end
			else
				if pointed_thing.ref ~= nil then
					local tool_capabilities = morphinggrid.registered_morphers[itemstack:get_name()].tool_capabilities
					pointed_thing.ref:punch(player, 0, tool_capabilities, nil)
				end
			end
		end
	})
end