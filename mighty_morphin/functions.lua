--Dragon Shield
function mighty_morphin.give_dragon_shield(from_player, to_player)
	if (morphinggrid.player_check_powerups(from_player, {["mighty_morphin:dragon_shield"] = true})) then
		morphinggrid.powerdown(from_player, "mighty_morphin:dragon_shield")
		morphinggrid.powerup(to_player, "mighty_morphin:dragon_shield")
	end
end

function mighty_morphin.summon_dragon_shield(player)
	if (morphinggrid.player_check_powerups(player, {["mighty_morphin:dragon_shield"] = true})) then
		morphinggrid.powerdown(player, "mighty_morphin:dragon_shield")
	else
		if mighty_morphin.player_has_item(player, "mighty_morphin:dragonzord_powercoin") or 
		mighty_morphin.player_has_item(player, "mighty_morphin:dragonzord_morpher") then
			morphinggrid.powerup(player, "mighty_morphin:dragon_shield")
		end
	end
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
	 local items = { "mighty_morphin:mastodon_powercoin", "mighty_morphin:mastodon_morpher",
	                 "mighty_morphin:pterodactyl_powercoin", "mighty_morphin:pterodactyl_morpher",
	                 "mighty_morphin:triceratops_powercoin", "mighty_morphin:triceratops_morpher",
	                 "mighty_morphin:saber_toothed_tiger_powercoin", "mighty_morphin:saber_toothed_tiger_morpher",
	                 "mighty_morphin:tyrannosaurus_powercoin", "mighty_morphin:tyrannosaurus_morpher",
	                 "mighty_morphin:dragonzord_powercoin", "mighty_morphin:dragonzord_morpher",
	                 "mighty_morphin:tigerzord_powercoin", "mighty_morphin:tigerzord_morpher" }
	
	 for _, item in ipairs(items) do
	   if mighty_morphin.player_has_item(player, item) then
	     return true
	   end
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
	if inv:contains_item("main", stack) == true or
	inv:contains_item("morphers", stack) == true or
	inv:contains_item("morphers_main", stack) == true then
		return true
	end
	return false
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

function mighty_morphin.upper_first_char(text, each)
	if each then
	  local _text = text:gsub("_", " ")
	  local _list = mighty_morphin.split_string(_text, " ")
	  local _newlist = {}
	  for i, v in ipairs(_list) do
		local firstletter = string.sub(v, 1,1):upper()
		local therest = string.sub(v, 2)
		table.insert(_newlist, firstletter..therest)
	  end
	  return table.concat(_newlist, " ")
	else
	  local firstletter = string.sub(text, 1,1)
	  local therest = string.sub(text, 2)
	  return (firstletter:upper()..therest):gsub("_", " ")
	end
end