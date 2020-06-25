--Dragon Shield
function mighty_morphin.give_dragon_shield(from_player, to_player)
	local from_ranger = mighty_morphin.get_current_ranger(from_player)
	local to_ranger = mighty_morphin.get_current_ranger(to_player)
	
	if from_ranger ~= "none" then
		if from_ranger == "black_shield" or
		from_ranger == "pink_shield" or
		from_ranger == "blue_shield" or
		from_ranger == "yellow_shield" or
		from_ranger == "red_shield" or
		from_ranger == "green" then
			if to_ranger ~= "black_shield" and
			to_ranger ~= "pink_shield" and
			to_ranger ~= "blue_shield" and
			to_ranger ~= "yellow_shield" and
			to_ranger ~= "red_shield" and
			to_ranger ~= "green" and
			to_ranger ~= "green_no_shield" and
			to_ranger ~= "white" then
				local take_away = mighty_morphin.get_ranger_without_dragon_shield(from_ranger)
				mighty_morphin.morph(to_player, morphinggrid.get_ranger("mighty_morphin:"..to_ranger.."_shield"))
				mighty_morphin.morph(from_player, morphinggrid.get_ranger("mighty_morphin:"..take_away))
				
				minetest.chat_send_player(from_player:get_player_name(), "You gave the Dragon Shield to "..to_player:get_player_name())
				minetest.chat_send_player(to_player:get_player_name(), from_player:get_player_name().." gave you the Dragon Shield")
			elseif to_ranger == "green_no_shield" then
				local take_away = mighty_morphin.get_ranger_without_dragon_shield(from_ranger)
				mighty_morphin.morph(to_player, morphinggrid.get_ranger("mighty_morphin:green"))
				mighty_morphin.morph(from_player, morphinggrid.get_ranger("mighty_morphin:"..take_away))
				
				minetest.chat_send_player(from_player:get_player_name(), "You gave the Dragon Shield to "..to_player:get_player_name())
				minetest.chat_send_player(to_player:get_player_name(), from_player:get_player_name().." gave you the Dragon Shield")
			else
				minetest.chat_send_player(from_player:get_player_name(), "Other player is not morphed")
			end
		elseif from_ranger == "green_no_shield" then
			minetest.chat_send_player(from_player:get_player_name(), "You need the Dragon Shield to do this.")
			minetest.chat_send_all("from_ranger = "..from_ranger)
		else
			minetest.chat_send_player(from_player:get_player_name(), "You do not have the Dragon Shield.")
			minetest.chat_send_all("from_ranger = "..from_ranger)
		end
	else
		minetest.chat_send_player(from_player:get_player_name(), "You are not morphed.")
	end
end

function mighty_morphin.summon_dragon_shield(player)
	local ranger = mighty_morphin.get_current_ranger(player)
	if mighty_morphin.player_has_item(player, "mighty_morphin:dragonzord_powercoin") == true then
		if ranger == "black" or
		ranger == "pink" or
		ranger == "blue" or
		ranger == "yellow" or
		ranger == "red" then
			local new_ranger = mighty_morphin.get_ranger_with_dragon_shield(ranger)
			mighty_morphin.morph(player, morphinggrid.get_ranger("mighty_morphin:"..new_ranger))
			minetest.chat_send_player(player:get_player_name(), "You are now using the Dragon Shield.")
		elseif ranger == "black_shield" or
		ranger == "pink_shield" or
		ranger == "blue_shield" or
		ranger == "yellow_shield" or
		ranger == "red_shield" then
			local new_ranger = mighty_morphin.get_ranger_without_dragon_shield(ranger)
			mighty_morphin.morph(player, morphinggrid.get_ranger("mighty_morphin:"..new_ranger))
			minetest.chat_send_player(player:get_player_name(), "You are no longer using the Dragon Shield.")
		elseif ranger == "none" then
			minetest.chat_send_player(player:get_player_name(), "You are not morphed.")
		end
	else
		if ranger == "green" then
			local new_ranger = mighty_morphin.get_ranger_without_dragon_shield(ranger)
			mighty_morphin.morph(player, morphinggrid.get_ranger("mighty_morphin:"..new_ranger))
			minetest.chat_send_player(player:get_player_name(), "You are no longer using the Dragon Shield.")
		elseif ranger == "green_no_shield" then
			local new_ranger = mighty_morphin.get_ranger_with_dragon_shield(ranger)
			mighty_morphin.morph(player, morphinggrid.get_ranger("mighty_morphin:"..new_ranger))
			minetest.chat_send_player(player:get_player_name(), "You are now using the Dragon Shield.")
		elseif ranger == "none" then
			minetest.chat_send_player(player:get_player_name(), "You are not morphed.")
		else
			minetest.chat_send_player(player:get_player_name(), "You need the Dragonzord power coin.")
		end
	end
end

function mighty_morphin.get_ranger_without_dragon_shield(ranger)
	local result = ""
	if ranger == "black_shield" then
		result = "black"
	elseif ranger == "pink_shield" then
		result = "pink"
	elseif ranger == "blue_shield" then
		result = "blue"
	elseif ranger == "yellow_shield" then
		result = "yellow"
	elseif ranger == "red_shield" then
		result = "red"
	elseif ranger == "green" then
		result = "green_no_shield"
	end
	
	return result
end

function mighty_morphin.get_ranger_with_dragon_shield(ranger)
	local result = ""
	if ranger == "black" then
		result = "black_shield"
	elseif ranger == "pink" then
		result = "pink_shield"
	elseif ranger == "blue" then
		result = "blue_shield"
	elseif ranger == "yellow" then
		result = "yellow_shield"
	elseif ranger == "red" then
		result = "red_shield"
	elseif ranger == "green_no_shield" then
		result = "green"
	end
	
	return result
end

function mighty_morphin.set_dg_meta(player, value)
	local meta = player:get_meta()
	meta:set_string('mighty_morphin_dragon_shield_given', value)
end

function mighty_morphin.get_dg_meta(player, value)
	local meta = player:get_meta()
	return meta:get_string('mighty_morphin_dragon_shield_given')
end

--Power Coin Detector
function mighty_morphin.scan_for_players_with_power_coin(pos)
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 7)) do
		local isplayer = obj:get_player_name()
		if isplayer ~= "" then
			if mighty_morphin.search_for_powercoin(obj) == true then
				return true
			end
		end
	end
	return false
end

function mighty_morphin.search_for_powercoin(player)
	if mighty_morphin.player_has_item(player, "mighty_morphin:mastodon_powercoin") or
	mighty_morphin.player_has_item(player, "mighty_morphin:mastodon_morpher") or
	mighty_morphin.player_has_item(player, "mighty_morphin:pterodactyl_powercoin") or
	mighty_morphin.player_has_item(player, "mighty_morphin:pterodactyl_morpher") or
	mighty_morphin.player_has_item(player, "mighty_morphin:triceratops_powercoin") or
	mighty_morphin.player_has_item(player, "mighty_morphin:triceratops_morpher") or
	mighty_morphin.player_has_item(player, "mighty_morphin:saber_toothed_tiger_powercoin") or
	mighty_morphin.player_has_item(player, "mighty_morphin:saber_toothed_tiger_morpher") or
	mighty_morphin.player_has_item(player, "mighty_morphin:tyrannosaurus_powercoin") or
	mighty_morphin.player_has_item(player, "mighty_morphin:tyrannosaurus_morpher") or
	mighty_morphin.player_has_item(player, "mighty_morphin:dragonzord_powercoin") or
	mighty_morphin.player_has_item(player, "mighty_morphin:dragonzord_morpher") or
	mighty_morphin.player_has_item(player, "mighty_morphin:tigerzord_powercoin") or
	mighty_morphin.player_has_item(player, "mighty_morphin:tigerzord_morpher") then
		return true
	end
	return false
end

--Other Useful Functions
function mighty_morphin.get_current_ranger(player)
	local meta = player:get_meta()
	local ranger = mighty_morphin.split_string(meta:get_string('player_morph_status'), ":")
	return ranger[2]
end

function mighty_morphin.player_has_item(player, item)
	local inv = player:get_inventory()
	local stack = ItemStack(item.." 1")
	local result = false
	if inv:contains_item("main", stack) == true then
		result = true
	end
	return result
end

function mighty_morphin.player_has_item_and_is_morphed(player, item)
  local morph_status = morphinggrid.get_morph_status(player)
	if morph_status ~= nil then
		if mighty_morphin.player_has_item(player, item) then
			return true
		end
	end
	return false
end

function mighty_morphin.split_string(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	
	local t = {}
	if string.find(inputstr, sep) then
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
		end
	else
		table.insert(t, inputstr)
	end
	
	return t
end

function mighty_morphin.check_if_string_contains(str, value)
	local result = false
	if string.find(str, value) then
		result = true
	end
	return result
end

function mighty_morphin.upper_first_char(text)
  local firstletter = string.sub(text, 1,1)
  local therest = string.sub(text, 2)
  return firstletter:upper()..therest
end