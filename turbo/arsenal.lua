morphinggrid.register_firearm("turbo:turbo_auto_blaster", {
  description = "Auto Blaster",
  inventory_image = "turbo_auto_blaster.png",
  distance = 55,
  particle_texture = "turbo_laser_particle.png",
  ranger_weapon = {
    weapon_key = "turbo_auto_blaster",
    rangers = {
		"turbo:blue",
		"turbo:green",
		"turbo:yellow",
		"turbo:pink",
		"turbo:red"
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    damage_groups = {fleshy=140},
  },
  sound = {breaks = "default_tool_breaks"},
})

morphinggrid.register_firearm("turbo:turbo_auto_blaster_turbo_mode", {
	description = "Auto Blaster (Turbo Mode)",
	inventory_image = "turbo_auto_blaster_turbo_mode.png",
	distance = 70,
	particle_texture = "turbo_laser_particle.png",
	ranger_weapon = {
		weapon_key = "turbo_auto_blaster_turbo_mode",
		rangers = {
			"turbo:blue",
			"turbo:green",
			"turbo:yellow",
			"turbo:pink",
			"turbo:red"
		},
		required_weapons = {
			"turbo:turbo_auto_blaster"
		}
	},
	tool_capabilities = {
		full_punch_interval = 0.4,
		max_drop_level=1,
		damage_groups = {fleshy=180},
  },
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("turbo:turbo_blade", {
  description = "Turbo Blade",
  inventory_image = "turbo_blade.png",
  ranger_weapon = {
    weapon_key = "turbo_blade",
	rangers = {
		"turbo:blue",
		"turbo:green",
		"turbo:yellow",
		"turbo:pink",
		"turbo:red"
    }
	--can_summon(player,ranger)
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=120},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

morphinggrid.register_firearm("turbo:turbo_turbine_laser", {
	description = "Turbine Laser",
	inventory_image = "turbo_turbine_laser.png",
	distance = 140,
	particle_texture = "turbo_laser_particle.png",
	ranger_weapon = {
		weapon_key = "turbo_turbine_laser",
		rangers = {
			"turbo:blue",
			"turbo:green",
			"turbo:yellow",
			"turbo:pink",
			"turbo:red"
		},
		required_weapons = {
			"turbo:turbo_hand_blaster",
			"turbo:turbo_thunder_cannon",
			"turbo:turbo_laser_star_chargers",
			"turbo:turbo_wind_fire",
			"turbo:turbo_lightning_sword"
		}
	},
	tool_capabilities = {
		full_punch_interval = 0.4,
		max_drop_level=1,
		damage_groups = {fleshy=250},
  },
	sound = {breaks = "default_tool_breaks"},
})

--individual weapons

morphinggrid.register_firearm("turbo:turbo_hand_blaster", {
  description = "Turbo Hand Blaster",
  inventory_image = "turbo_hand_blaster.png",
  distance = 65,
  particle_texture = "turbo_laser_particle_blue.png",
  ranger_weapon = {
    weapon_key = "turbo_hand_blaster",
    rangers = {
		"turbo:blue",
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    damage_groups = {fleshy=110},
  },
  sound = {breaks = "default_tool_breaks"},
})

morphinggrid.register_firearm("turbo:turbo_thunder_cannon", {
  description = "Turbo Thunder Cannon",
  inventory_image = "turbo_thunder_cannon.png",
  distance = 65,
  particle_texture = "turbo_laser_particle_green.png",
  ranger_weapon = {
    weapon_key = "turbo_thunder_cannon",
    rangers = {
		"turbo:green",
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    damage_groups = {fleshy=110},
  },
  sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("turbo:turbo_laser_star_chargers", {
  description = "Turbo Laser Star Chargers",
  inventory_image = "turbo_laser_star_chargers.png",
  ranger_weapon = {
    weapon_key = "turbo_laser_star_chargers",
	rangers = {
		"turbo:yellow"
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=110},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

morphinggrid.register_firearm("turbo:turbo_wind_fire", {
  description = "Turbo Wind Fire",
  inventory_image = "turbo_wind_fire.png",
  distance = 65,
  particle_texture = "turbo_laser_particle_pink.png",
  ranger_weapon = {
    weapon_key = "turbo_wind_fire",
    rangers = {
		"turbo:pink",
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    damage_groups = {fleshy=110},
  },
  sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("turbo:turbo_lightning_sword", {
  description = "Turbo Lightning Sword",
  inventory_image = "turbo_lightning_sword.png",
  ranger_weapon = {
    weapon_key = "turbo_lightning_sword",
	rangers = {
		"turbo:red"
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=110},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})