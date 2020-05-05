dofile(minetest.get_modpath("morphinggrid") .. "/morphing.lua")

function mighty_morphin.morph(player, ranger)
	mighty_morphin.set_ranger_meta(player, ranger)
	if morphinggrid.morph(player, "mighty_morphin", ranger) == true
	then
		minetest.chat_send_player(player:get_player_name(), "You have sucessfully morphed into the "..ranger.." ranger")
		local meta = player:get_meta()
		local rangercolor = mighty_morphin.getrangercolor(ranger)
		meta:set_string("mmpr_last_morphed_color", rangercolor.."_Ranger")
	end
end

function mighty_morphin.getrangercolor(text)
	if text == "green_no_shield" then text = "green"
	elseif text == "black_shield" then text = "black"
	elseif text == "pink_shield" then text = "pink"
	elseif text == "blue_shield" then text = "blue"
	elseif text == "yellow_shield" then text = "yellow"
	elseif text == "red_shield" then text = "red" end
	
	local firstletter = string.sub(text, 1,1)
	local therest = string.sub(text, 2)
	return firstletter:upper()..therest
end