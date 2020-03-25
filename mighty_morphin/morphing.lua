dofile(minetest.get_modpath("morphinggrid") .. "/morphing.lua")

function mighty_morphin.morph(player, ranger)
	mighty_morphin.set_ranger_meta(player, ranger)
	if morphinggrid.morph(player, "mighty_morphin", ranger) == true
	then
		minetest.chat_send_player(player:get_player_name(), "You have sucessfully morphed into the "..ranger.." ranger")
	end
end