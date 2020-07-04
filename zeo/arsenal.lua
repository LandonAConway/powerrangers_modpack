zeo.arsenal = {}

minetest.register_tool("zeo:zeo_power_pod_sword", {
  description = "Zeo Power Pod Sword",
  inventory_image = "zeo_power_pod_sword.png",
  ranger_weapon = {
    weapon_key = "zeo_power_pod_sword",
    rangers = {
      "zeo:pink",
      "zeo:yellow",
      "zeo:blue",
      "zeo:green",
      "zeo:red"
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=235},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

morphinggrid.register_firearm("zeo:zeo_laser_pistol", {
  description = "Zeo Laser Pistol",
  inventory_image = "zeo_laser_pistol.png",
  distance = 55,
  particle_texture = "zeo_laser_pistol_particle.png",
  ranger_weapon = {
    weapon_key = "zeo_laser_pistol",
    rangers = {
      "zeo:pink",
      "zeo:yellow",
      "zeo:blue",
      "zeo:green",
      "zeo:red"
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=310},
  },
  sound = {breaks = "default_tool_breaks"},
})

morphinggrid.register_firearm("zeo:advanced_zeo_laser_pistol", {
  description = "Advenced Zeo Laser Pistol",
  inventory_image = "zeo_laser_pistol_advanced.png",
  distance = 75,
  particle_texture = "zeo_laser_pistol_particle.png",
  ranger_weapon = {
    weapon_key = "advanced_zeo_laser_pistol",
    rangers = {
      "zeo:pink",
      "zeo:yellow",
      "zeo:blue",
      "zeo:green",
      "zeo:red"
    },
    required_weapons = {
      "zeo:zeo_power_pod_sword",
      "zeo:zeo_laser_pistol"
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=340},
  },
  sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("zeo:zeo_i_power_disk", {
  description = "Zeo I Power Disk",
  inventory_image = "zeo_i_power_disk.png",
  ranger_weapon = {
    weapon_key = "zeo_i_power_disk",
    rangers = {
      "zeo:pink",
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=145},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("zeo:zeo_ii_power_clubs", {
  description = "Zeo II Power Clubs",
  inventory_image = "zeo_ii_power_clubs.png",
  ranger_weapon = {
    weapon_key = "zeo_ii_power_clubs",
    rangers = {
      "zeo:yellow",
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=145},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("zeo:zeo_iii_power_tonfas", {
  description = "Zeo III Power Tonfas",
  inventory_image = "zeo_iii_power_tonfas.png",
  ranger_weapon = {
    weapon_key = "zeo_iii_power_tonfas",
    rangers = {
      "zeo:blue",
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=145},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("zeo:zeo_iv_power_hatchets", {
  description = "Zeo IV Power Hatchets",
  inventory_image = "zeo_iv_power_hatchets.png",
  ranger_weapon = {
    weapon_key = "zeo_iv_power_hatchets",
    rangers = {
      "zeo:green",
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=145},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("zeo:zeo_v_power_sword", {
  description = "Zeo V Power Sword",
  inventory_image = "zeo_v_power_sword.png",
  ranger_weapon = {
    weapon_key = "zeo_v_power_sword",
    rangers = {
      "zeo:red",
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=145},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

function zeo.arsenal.can_summon(ranger_names, ranger_name)
  for i,v in ipairs(ranger_names) do
    if v == ranger_name then
      return true
    end
  end
  return false
end