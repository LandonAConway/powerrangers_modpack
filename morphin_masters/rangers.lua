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
	purple = { desc = "Purple" },
	orange = { desc = "Orange" }
}

for k, v in pairs(rangers) do
	morphinggrid.register_ranger("morphin_masters:"..k, {
		description = v.desc.." Morphin Master",
		max_energy = 10000,
		energy_damage_per_hp = 0,
		energy_damage_per_glabalstep = 0,
		energy_heal_per_globalstep = 100,
		weapons = { "morphin_masters:blaster", "morphin_masters:fury_blaster", "morphin_masters:laser_digger", "morphin_masters:master_staff" },
		color = k,
		ranger_groups = v.rgroups or {},
		privs = { "morphinggrid" },
		create_rangerdata = false,
		ranger_command_presets = { default = true, visor = true },
		ranger_commands = {
			set_enerform_intensity = {
				short = "seni",
				description = "Sets the visual intensity of Enerform.",
				func = function(name, text)
					local player = minetest.get_player_by_name(name)
					local rangerdata = morphinggrid.get_current_rangerdata(player)
					local n = tonumber(text)
					if n and n > 0 then
						local max_particles = n*5
						rangerdata:set_setting_value("enerform_max_particles", max_particles)
						return true, "Enerform intensity set to '"..text.."'."
					end
					return false, "Enter a valid number that is greater than zero."
				end
			},
			toggle_enerform = {
				short = "tgen",
				description = "Toggles Enerform.",
				func = function(name)
					local player = minetest.get_player_by_name(name)
					morphin_masters.enerform_set_color(player, k)
					morphin_masters.enerform_toggle(player)
				end
			},
			toggle_master_mode = {
				short = "tgmm",
				description = "Toggles Master Mode.",
				func = function(name)
					morphin_masters.toggle_master_mode(name)
				end
			},
			generate_master_mode_key = {
				short = "gmmk",
				description = "Generates a Master Mode Key.",
				func = function(name)
					local player = minetest.get_player_by_name(name)
					local inv = player:get_inventory()
					inv:add_item("main", ItemStack("morphin_masters:master_mode_key"))
				end
			}
		},
		hand = {
			range = 175,
			tool_capabilities = {
				full_punch_interval = 0.1,
				max_drop_level = 0,
				groupcaps = {
					cracky = {times={[1]=1.0, [2]=0.75, [3]=0.50}, uses=0, maxlevel=3},
					crumbly = {times={[1]=0.80, [2]=0.50, [3]=0.30}, uses=0, maxlevel=3},
					choppy={times={[1]=1.10, [2]=0.90, [3]=0.50}, uses=0, maxlevel=3},
					snappy = {times={[1]=0.35,[2]=0.25,[3]=0.20}, uses=0, maxlevel=1},
					oddly_breakable_by_hand = {times={[1]=1.10,[2]=0.70,[3]=0.30}, uses=0}
				},
				damage_groups = {fleshy=35},
			}
		},
		rtextures = {
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