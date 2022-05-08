morphinggrid.register_rangertype("morphin_masters", {
	description = "Morphin Masters",
	weapons = { "morphin_masters:blaster", "morphin_masters:laser_digger", "morphin_masters:master_staff" },
	grid_doc = {
		description = "The Morphin Masters powers are used by a civilation of beings that have dedicated their entire "..
		"existence to studying the Morphin Grid. The Morphin Masters have many abilities and are invincible. "..
		"Each master represents all rangers of it's color. Using their staffs, each master can morph another player "..
		"into any ranger of their same color. They also have many other abilities like flying, punching masses of mobs or "..
		"players, running fast, and more (try experimenting with using combinations of RMB, LMB, and sneak in certain situations."
	}
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
		max_energy = 10000,
		energy_damage_per_hp = 0,
		energy_heal_per_globalstep = 100,
		weapons = { "morphin_masters:blaster", "morphin_masters:laser_digger", "morphin_masters:master_staff" },
		color = k,
		ranger_groups = v.rgroups or {},
		privs = { "morphinggrid" },
		create_rangerdata = false,
		ranger_command_presets = { default = true, visor = true },
		armor_textures = {
			boots = {
				armor = "morphin_masters_boots.png",
				preview = "morphin_masters_boots_preview.png",
				inventory = "morphin_masters_inv_boots.png" 
			},

			leggings = {
				preview = "morphin_masters_leggings_preview.png",
				inventory = "morphin_masters_inv_leggings.png"
			},

			helmet = {
				armor_visor_mask = "morphin_masters_helmet_visor_mask.png"
			}
		}
	})
end