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

minetest.register_chatcommand("make_powercoin", {
	params = "<coin_name> Itemstring of coin without the mods name.",
	description = "Gets the wanted power coin.",
	
	privs = {
		interact = true,
		power_rangers = true,
		powercoin_maker = true,
	},
	
	func = function(name, text)
		if text == "mastodon_powercoin" or
		text == "pterodactyl_powercoin" or
		text == "triceratops_powercoin" or
		text == "saber_toothed_tiger_powercoin" or
		text == "tyrannosaurus_powercoin" or
		text == "dragonzord_powercoin" or
		text == "tigerzord_powercoin" then
			local powercoinname = "mighty_morphin:"..text
			local player = minetest.get_player_by_name(name)
			
			local inv = player:get_inventory()
			local stack = ItemStack(powercoinname.." 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				return false, "Could not make power coin becuase inventory is full"
			else
				return true, "Power coin is in inventory."
			end
		end
		return false, "'"..text.."' is not a power coin."
	end,
})