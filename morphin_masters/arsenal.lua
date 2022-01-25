morphinggrid.register_firearm("morphin_masters:blaster", {
	description = "Blaster",
	inventory_image = "morphin_masters_blaster.png",
	distance = 5000,
	tool_capabilities = {
		damage_groups = { fleshy = 500 }
	},
	ranger_weapon = {
		weapon_key = "blaster",
		rangers = {
			"morphin_masters:green",
			"morphin_masters:white",
			"morphin_masters:black",
			"morphin_masters:pink",
			"morphin_masters:blue",
			"morphin_masters:yellow",
			"morphin_masters:red",
			"morphin_masters:silver",
			"morphin_masters:gold"
		}
	}
})