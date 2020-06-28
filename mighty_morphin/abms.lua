minetest.register_abm({
	nodenames = {"mighty_morphin:powercoin_detector_off"},
	interval = 1.0,
	chance = 1,
	action = function(pos)
		if mighty_morphin.scan_for_players_with_power_coin(pos) == true then
			minetest.swap_node(pos, {name = "mighty_morphin:powercoin_detector_on"})
		end
	end
})

minetest.register_abm({
	nodenames = {"mighty_morphin:powercoin_detector_on"},
	interval = 1.0,
	chance = 1,
	action = function(pos)
		if mighty_morphin.scan_for_players_with_power_coin(pos) == false then
			minetest.swap_node(pos, {name = "mighty_morphin:powercoin_detector_off"})
		end
	end
})