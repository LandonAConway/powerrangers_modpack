dofile(minetest.get_modpath("3d_armor") .. "/api.lua")

function morphinggrid.morph(player, modname, ranger)
	local player_name = player:get_player_name()
	local can_use = minetest.check_player_privs(player_name, { power_rangers=true })
	
	local result = false
	
	if can_use == true
	then
		local inv = minetest.get_inventory({
			type="detached", name=player_name.."_armor"})
		
		morphinggrid.demorph(player, true)
		
		inv:add_item("armor", { name=modname..":helmet_"..ranger })
		inv:add_item("armor", { name=modname..":chestplate_"..ranger })
		inv:add_item("armor", { name=modname..":leggings_"..ranger })
		inv:add_item("armor", { name=modname..":boots_"..ranger })
	
		armor:save_armor_inventory(player)
		armor:set_player_armor(player)
		
		player:set_nametag_attributes({text = " "})
		
		result = true
	else
		minetest.chat_send_player(player_name, "You do not have permisson to morph (Missing Privileges: power_rangers)")
	end
	
	return result
end

function morphinggrid.demorph(player, is_morphing)
	local player_name = player:get_player_name()
	local can_use = minetest.check_player_privs(player_name, { power_rangers=true })
	
	local result = false
	
	if can_use == true then
		local meta = player:get_meta()
		local modname = meta:get_string('power_rangers_mod_name')
		local ranger = meta:get_string(modname.."_morph_status")
		
		if is_morphing == true then
			local inv = minetest.get_inventory({
			type="detached", name=player_name.."_armor"})
		
			for i = 0,5 do
				local stack = inv:get_stack("armor", i)
				inv:remove_item("armor", stack)
			end
			
			armor:save_armor_inventory(player)
			armor:set_player_armor(player)
			
			player:set_nametag_attributes({text = ""})
			
			if ranger ~= "none" then
				local weapons_list = meta:get_string(modname.."_"..ranger.."_weapons")
				local weapons = morphinggrid.split_string(weapons_list, "|")
				morphinggrid.remove_weapons(player, weapons)
			end
		else
			if ranger == "none" then
				minetest.chat_send_player(player_name, "You are not morphed")
			else
				local inv = minetest.get_inventory({
					type="detached", name=player_name.."_armor"})
			
				for i = 0,5 do
					local stack = inv:get_stack("armor", i)
					inv:remove_item("armor", stack)
				end
			
				armor:save_armor_inventory(player)
				armor:set_player_armor(player)
				
				player:set_nametag_attributes({text = ""})
		
				local weapons_list = meta:get_string(modname.."_"..ranger.."_weapons")
				local weapons = morphinggrid.split_string(weapons_list, "|")
				morphinggrid.remove_weapons(player, weapons)
			
				meta:set_string(modname.."_morph_status", "none")
			end
		end
		
		result = true
	else
		minetest.chat_send_player(player_name, "You do not have permisson to demorph (Missing Privileges: power_rangers)")
	end
	
	return result
end

function morphinggrid.remove_weapons(player, weapons)
	local inv = player:get_inventory()
	for _, weapon in pairs(weapons) do
		local inv_list = inv:get_list("main")
		for _, stack in pairs(inv_list) do
			if stack:get_name() == weapon then
				inv:remove_item("main", stack)
			end
		end
	end
end