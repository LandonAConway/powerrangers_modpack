morphinggrid.register_firearm("turbo:turbo_auto_blaster", {
  description = "Auto Blaster",
  inventory_image = "turbo_auto_blaster.png",
  distance = 55,
  particle_texture = "turbo_auto_blaster_particle.png",
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
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=140},
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