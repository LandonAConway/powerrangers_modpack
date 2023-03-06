function morphinggrid.energy_port(pos)
	local list_name = "nodemeta:"..pos.x..','..pos.y..','..pos.z
	local formspec = "size[8,6]"..
		"list["..list_name..";energy;3.5,0;1,1;]"..
		"list[current_player;main;0,2;8,4;]"
	return formspec
end

minetest.register_node("morphinggrid:energy_port", {
	description = "Morphing Grid Energy Port",
	tiles = {
		"morphinhgrid_energy_port.png",
		"morphinhgrid_energy_port.png",
		"morphinhgrid_energy_port.png",
		"morphinhgrid_energy_port.png",
		"morphinhgrid_energy_port.png",
		"morphinhgrid_energy_port.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, metal = 1},
	sounds = default.node_sound_metal_defaults(),
	
	after_place_node = function(pos, placer, itemstack)
		local can_place = minetest.check_player_privs(placer:get_player_name(), {power_rangers = true})
		if can_place == true then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_size("energy", 1*1)
			local energy_stack = ItemStack('morphinggrid:energy '..math.round(math.random(1, 5)))
			inv:set_stack("energy", 1, energy_stack)
		else
			minetest.remove_node(pos)
			minetest.chat_send_player(placer:get_player_name(), "You do not have the power_rangers priv.")
		end
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack)
		local can_use = minetest.check_player_privs(clicker:get_player_name(), {power_rangers = true})
		if can_use == true then
			minetest.show_formspec(clicker:get_player_name(), "morphinggrid:energy_port_formspec", morphinggrid.energy_port(pos))
		else
			minetest.chat_send_player(clicker:get_player_name(), "You do not have the power_rangers priv.")
		end
	end,
	
	can_dig = function(pos, player)
		local can_dig = minetest.check_player_privs(player:get_player_name(), {power_rangers = true})
		if can_dig == true then
			return true
		else
			minetest.chat_send_player(player:get_player_name(), "You do not have the power_rangers priv.")
			return false
		end
	end,
	
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return 0
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	on_metadata_inventory_take = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("energy", 1*1)
		local energy_stack = ItemStack('morphinggrid:energy '..math.round(math.random(1, 5)))
		inv:set_stack("energy", 1, energy_stack)
	end,
	
	grid_doc = {
		other_item = true,
		description = "Allows players to get access to Morphing Grid Energy directly."
	}
})

function mod_loaded(str)
	if minetest.get_modpath(str) ~= nil then
		return true
	end
	return false
end

if mod_loaded("electronic_materials") then

	minetest.register_craft({
		type = "shaped",
		output = "morphinggrid:energy_port",
		recipe = {
			{"default:steelblock", "default:mese", "default:steelblock"}, 
			{"default:steelblock", "electronic_materials:medium_motherboard", "default:steelblock"},
			{"default:steelblock", "default:mese", "default:steelblock"}
		}
	})
	
else
	minetest.register_craft({
		type = "shaped",
		output = "morphinggrid:energy_port",
		recipe = {
			{"default:steelblock", "default:mese", "default:steelblock"}, 
			{"default:steelblock", "default:diamondblock", "default:steelblock"},
			{"default:steelblock", "default:mese", "default:steelblock"}
		}
	})
end