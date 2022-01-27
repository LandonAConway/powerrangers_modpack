minetest.register_tool("morphin_masters:laser_digger", {
	description = "Laser Digger",
	inventory_image = "morphin_masters_laser_digger.png",
	tool_capabilities = {
		full_punch_interval = 0.1,
		damage_groups = { fleshy = 5 },
		max_uses = 0,
		groups = { pickaxe=1, shovel=1, axe=1, sword=1, hoe=1 },
		groupcaps = {
			-- cracky = { times = {[1]=2.0,[2]=1.0,[3]=0.50}, uses=30, maxlevel=3},
			-- crumbly = { times = {[1]=1.20,[2]=0.60,[3]=0.30}, uses=20, maxlevel=3},
			-- choppy = { times = {[1]=2.10,[2]=0.90,[3]=0.50}, uses=30, maxlevel=3},
			-- snappy = { times = {[1]=1.90,[2]=0.90,[3]=0.30}, uses=40, maxlevel=3},
			cracky = { times = {[1]=2.0,[2]=1.0,[3]=0.50,[1000]=0.1}, uses=0, maxlevel=1000},
			crumbly = { times = {[1]=1.20,[2]=0.60,[3]=0.30,[1000]=0.1}, uses=0, maxlevel=1000},
			choppy = { times = {[1]=2.10,[2]=0.90,[3]=0.50,[1000]=0.1}, uses=0, maxlevel=1000},
			snappy = { times = {[1]=1.90,[2]=0.90,[3]=0.30,[1000]=0.1}, uses=0, maxlevel=1000},
		}
	},
	ranger_weapon = {
		weapon_key = "laser_digger",
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