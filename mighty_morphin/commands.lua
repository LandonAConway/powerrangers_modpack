minetest.register_chatcommand("power_axe", {
	params = "",
	description = "Summons Power Axe",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_name = player:get_player_name()
		
		local meta = player:get_meta()
		local morph_status = meta:get_string('mighty_morphin_morph_status')
		if morph_status == "black" or morph_status == "black_shield" then
			local inv = player:get_inventory()
			local stack = ItemStack("mighty_morphin:power_axe 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.chat_send_player(player_name, "Could not summon Power Axe becuase inventory is full")
			end
			
			minetest.chat_send_player(player_name, "You summoned the Power Axe")
		else
			minetest.chat_send_player(player_name, "You must be morphed into the Mighty Morphin black ranger to summon this weapon.")
		end
	end,
})

minetest.register_chatcommand("power_bow", {
	params = "",
	description = "Summons Power Bow",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_name = player:get_player_name()
		
		local meta = player:get_meta()
		local morph_status = meta:get_string('mighty_morphin_morph_status')
		if morph_status == "pink" or morph_status == "pink_shield" then
			local inv = player:get_inventory()
			local stack = ItemStack("mighty_morphin:power_bow 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.chat_send_player(player_name, "Could not summon Power Bow becuase inventory is full")
			end
			
			minetest.chat_send_player(player_name, "You summoned the Power Bow")
		else
			minetest.chat_send_player(player_name, "You must be morphed into the Mighty Morphin pink ranger to summon this weapon.")
		end
	end,
})

minetest.register_chatcommand("power_lance", {
	params = "",
	description = "Summons Power Lance",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_name = player:get_player_name()
		
		local meta = player:get_meta()
		local morph_status = meta:get_string('mighty_morphin_morph_status')
		if morph_status == "blue" or morph_status == "blue_shield" then
			local inv = player:get_inventory()
			local stack = ItemStack("mighty_morphin:power_lance 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.chat_send_player(player_name, "Could not summon Power Lance becuase inventory is full")
			end
			
			minetest.chat_send_player(player_name, "You summoned the Power Lance")
		else
			minetest.chat_send_player(player_name, "You must be morphed into the Mighty Morphin blue ranger to summon this weapon.")
		end
	end,
})

minetest.register_chatcommand("power_daggers", {
	params = "",
	description = "Summons Power Daggers",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_name = player:get_player_name()
		
		local meta = player:get_meta()
		local morph_status = meta:get_string('mighty_morphin_morph_status')
		if morph_status == "yellow" or morph_status == "yellow_shield" then
			local inv = player:get_inventory()
			local stack = ItemStack("mighty_morphin:power_daggers 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.chat_send_player(player_name, "Could not summon Power Daggers becuase inventory is full")
			end
			
			minetest.chat_send_player(player_name, "You summoned the Power Daggers")
		else
			minetest.chat_send_player(player_name, "You must be morphed into the Mighty Morphin yellow ranger to summon this weapon.")
		end
	end,
})

minetest.register_chatcommand("power_sword", {
	params = "",
	description = "Summons Power Sword",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_name = player:get_player_name()
		
		local meta = player:get_meta()
		local morph_status = meta:get_string('mighty_morphin_morph_status')
		if morph_status == "red" or morph_status or "red_shield" then
			local inv = player:get_inventory()
			local stack = ItemStack("mighty_morphin:power_sword 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.chat_send_player(player_name, "Could not summon Power Sword becuase inventory is full")
			end
			
			minetest.chat_send_player(player_name, "You summoned the Power Sword")
		else
			minetest.chat_send_player(player_name, "You must be morphed into the Mighty Morphin red ranger to summon this weapon.")
		end
	end,
})

minetest.register_chatcommand("dragon_dagger", {
	params = "",
	description = "Summons Dragon Dagger",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_name = player:get_player_name()
		
		local meta = player:get_meta()
		local morph_status = meta:get_string('mighty_morphin_morph_status')
		if morph_status == "green" or mighty_morphin.player_has_item(player, "mighty_morphin:dragonzord_powercoin") == true then
			local inv = player:get_inventory()
			local stack = ItemStack("mighty_morphin:dragon_dagger 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.chat_send_player(player_name, "Could not summon Dragon Dagger becuase inventory is full")
			end
			
			minetest.chat_send_player(player_name, "You summoned the Dragon Dagger")
		elseif morph_status == "green_no_shield" then
			minetest.chat_send_player(player_name, "You need the Dragon Shield.")
		else
			minetest.chat_send_player(player_name, "You must be morphed into the Mighty Morphin green ranger or have the Dragonzord power coin to summon this weapon.")
		end
	end,
})

minetest.register_chatcommand("saba", {
	params = "",
	description = "Summons Saba",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_name = player:get_player_name()
		
		local meta = player:get_meta()
		local morph_status = meta:get_string('mighty_morphin_morph_status')
		if morph_status == "white" then
			local inv = player:get_inventory()
			local stack = ItemStack("mighty_morphin:saba 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.chat_send_player(player_name, "Could not summon Saba becuase inventory is full")
			end
			
			minetest.chat_send_player(player_name, "You summoned the Saba")
		else
			minetest.chat_send_player(player_name, "You must be morphed into the Mighty Morphin white ranger to summon this weapon.")
		end
	end,
})

minetest.register_chatcommand("give_dragon_shield", {
	params = "<player>",
	description = "Transfers the Dragon Shield to another ranger if you currently have it",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, text)
		local from = minetest.get_player_by_name(name)
		local to = minetest.get_player_by_name(text)
		
		if text ~= nil and text ~= "" then
			if minetest.player_exists(text) then
				if to ~= nil then
					mighty_morphin.give_dragon_shield(from, to)
				else
					minetest.chat_send_player(name, text.." is not online")
				end
			else
				minetest.chat_send_player(name, "Player "..text.." does not exist")
			end
		else
			minetest.chat_send_player(name, "Invalid Usage. Enter a player name.")
		end
	end,
})

minetest.register_chatcommand("dragon_shield", {
	params = "",
	description = "Summons the Dragon Shield if you have the Dragonzord power coin. If you are using it, it will go away.",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		mighty_morphin.summon_dragon_shield(player)
	end,
})