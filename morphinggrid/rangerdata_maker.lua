local get_rangers = function()
	local t = {}
	for k, v in pairs(morphinggrid.registered_rangers) do
		if v.create_rangerdata then
			table.insert(t, k)
		end
	end
	
	table.sort(t)
	return t
end

rangerdata_maker_formspec = {}
function morphinggrid.rangerdata_maker(pos, player)
	local rdmf = rangerdata_maker_formspec
	rdmf[player:get_player_name()] = {
		pos = pos
	}
	
	local list_name = "nodemeta:"..pos.x..','..pos.y..','..pos.z
	local formspec = "formspec_version[4]size[10.5,11]"..
		"dropdown[0.4,0.7;9.7,0.8;rangers;"..table.concat(get_rangers(),",")..";1;false]"..
		"button[0.4,3.8;9.7,0.8;create;Create]"..
		"button_exit[8.2,10;2,0.8;exit;Exit]"..
		"list[current_player;main;0.4,5;8,4;0]"..
		"list["..list_name..";output;5.4,2.4;1,1;0]"..
		"list["..list_name..";energy;0.4,2.4;1,1;0]"..
		"label[0.4,2.1;Morphing Grid Energy:]"..
		"label[0.4,0.4;Ranger:]"..
		"label[5.4,2.1;Output:]"
	return formspec
end

-- formspec_version[4]
-- size[10.5,11]
-- dropdown[0.4,0.7;9.7,0.8;;;1]
-- button_exit[8.2,10;2,0.8;exit;Exit]
-- list[current_player;main;0.4,5;8,4;0]
-- list[current_player;main;5.4,2.4;1,1;0]
-- list[current_player;main;0.4,2.4;1,1;0]
-- label[0.4,2.1;Morphing Grid Energy:]
-- label[0.4,0.4;Ranger:]
-- label[5.4,2.1;Output:]
-- button[0.4,3.8;9.7,0.8;create;Create]

minetest.register_node("morphinggrid:rangerdata_maker", {
	description = "Ranger Data Maker",
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
			inv:set_size("output", 1*1)
		else
			minetest.remove_node(pos)
			minetest.chat_send_player(placer:get_player_name(), "You do not have the power_rangers priv.")
		end
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack)
		local can_use = minetest.check_player_privs(clicker:get_player_name(), {power_rangers = true})
		if can_use == true then
			minetest.show_formspec(clicker:get_player_name(), "morphinggrid:rangerdata_maker_formspec",
				morphinggrid.rangerdata_maker(pos, clicker))
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
	
	-- allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		-- return 0
	-- end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "energy" then
			if stack:get_name() == "morphinggrid:energy" then
				return stack:get_count()
			end
		elseif listname == "output" then
			return 0
		end
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	
	grid_doc = {
		other_item = true,
		description = "Allows players to create ranger data. Ranger data is a type of energy that is tethered"..
			" to a specific ranger which allows it to be used to create other items that have a connection to"..
			" the Morphing Grid like grid items. Using this node is very dangerous and the likelyhood of being"..
			" successful in creating ranger data is usually very low."
	}
})

local function get_max_random(item_count)
	local maximum = 95
	if item_count < maximum then
		return maximum - item_count, item_count
	else
		return 1, maximum
	end
end

local function round(number)
	local floored = math.floor(number)
	local remainder = number - floored
	if remainder < 0.5 then
		return floored
	else
		return floored + 1
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "morphinggrid:rangerdata_maker_formspec" then
		local rdmf = rangerdata_maker_formspec[player:get_player_name()]
		local pos = rdmf.pos
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		
		if fields.create then
			local stack = inv:get_stack("energy", 1)
			if stack:get_name() == "morphinggrid:energy" then
				local max_random, take = get_max_random(stack:get_count())
				local r = round(math.random(1, max_random))
				
				stack:take_item(take)
				inv:set_stack("energy", 1, stack)
				if r == 1 then
					inv:set_stack("output", 1, ItemStack(fields.rangers.."_rangerdata"))
				else
					minetest.close_formspec(player:get_player_name(), "morphinggrid:rangerdata_maker_formspec")
					rangerdata_maker_effect(player)
				end
			end
		end
	end
end)

function rangerdata_maker_effect(player)
	local look_dir = player:get_look_dir()
	local v = 150
	player:punch(player, 0.1, {damage_groups={fleshy=2}})
	player:add_velocity({x=(0-look_dir.x)*v ,y=(0-look_dir.y)*v ,z=(0-look_dir.z)*v})
	
	minetest.chat_send_player(player:get_player_name(), "Creation failed, please carefully try again.")
	minetest.chat_send_player(player:get_player_name(), "Adding more Morphing Grid Energy will increase your chances "..
	"of a successful ranger data creation.")
end

function mod_loaded(str)
	if minetest.get_modpath(str) ~= nil then
		return true
	end
	return false
end

if mod_loaded("electronic_materials") then

	minetest.register_craft({
		type = "shaped",
		output = "morphinggrid:rangerdata_maker",
		recipe = {
			{"default:steelblock", "default:diamondblock", "default:steelblock"}, 
			{"default:steelblock", "electronic_materials:medium_motherboard", "default:steelblock"},
			{"default:steelblock", "default:diamondblock", "default:steelblock"}
		}
	})
	
else
	minetest.register_craft({
		type = "shaped",
		output = "morphinggrid:rangerdata_maker",
		recipe = {
			{"default:steelblock", "default:diamondblock", "default:steelblock"}, 
			{"default:steelblock", "default:diamondblock", "default:steelblock"},
			{"default:steelblock", "default:diamondblock", "default:steelblock"}
		}
	})
end