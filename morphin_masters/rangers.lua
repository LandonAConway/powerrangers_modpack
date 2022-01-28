morphinggrid.register_rangertype("morphin_masters", {
	description = "Morphin Masters",
	weapons = { "morphin_masters:blaster", "morphin_masters:laser_digger", "morphin_masters:master_staff" }
})

local rangers = {
	green = { desc = "Green" },
	white = { desc = "White", rgroups = { leader = 1 } },
	black = { desc = "Black" },
	pink = { desc = "Pink" },
	blue = { desc = "Blue" },
	yellow = { desc = "Yellow" },
	red = { desc = "Red" },
	silver = { desc = "Silver" },
	gold = { desc = "Gold" },
}

for k, v in pairs(rangers) do
	morphinggrid.register_ranger("morphin_masters:"..k, {
		description = v.desc.." Morphin Master",
		heal = 100,
		use = 0,
		weapons = { "morphin_masters:blaster", "morphin_masters:laser_digger", "morphin_masters:master_staff" },
		color = k,
		ranger_groups = v.rgroups or {},
		privs = { "morphinggrid" },
		create_rangerdata = false,
		armor_textures = {
			boots = {
				armor = "morphin_masters_boots.png",
				preview = "morphin_masters_boots_preview.png",
				inventory = "morphin_masters_inv_boots.png" 
			},

			leggings = {
				preview = "morphin_masters_leggings_preview.png",
				inventory = "morphin_masters_inv_leggings.png"
			}
		}
	})
end