morphinggrid.register_firearm("mighty_morphin:blade_blaster", {
  description = "Blade Blater",
  inventory_image = "mighty_morphin_blade_blaster.png",
  distance = 45,
  particle_texture = "mighty_morphin_blade_blaster_particle.png",
  ranger_weapon = {
    weapon_key = "blade_blaster",
    rangers = {
      "mighty_morphin:black", "mighty_morphin:black_shield",
      "mighty_morphin:pink", "mighty_morphin:pink_shield",
      "mighty_morphin:blue", "mighty_morphin:blue_shield",
      "mighty_morphin:yellow", "mighty_morphin:yellow_shield",
      "mighty_morphin:red", "mighty_morphin:red_shield",
      "mighty_morphin:green", "mighty_morphin:green_no_shield"
    }
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
})

morphinggrid.register_firearm("mighty_morphin:power_blaster", {
  description = "Power Blaster",
  inventory_image = "mighty_morphin_power_blaster.png",
  distance = 55,
  ranger_weapon = {
    weapon_key = "power_blaster",
    rangers = {
      "mighty_morphin:black", "mighty_morphin:black_shield",
      "mighty_morphin:pink", "mighty_morphin:pink_shield",
      "mighty_morphin:blue", "mighty_morphin:blue_shield",
      "mighty_morphin:yellow", "mighty_morphin:yellow_shield",
      "mighty_morphin:red", "mighty_morphin:red_shield"
    },
    required_weapons = {
      "mighty_morphin:power_axe",
      "mighty_morphin:power_bow",
      "mighty_morphin:power_lance",
      "mighty_morphin:power_daggers",
      "mighty_morphin:power_sword"
    }
  },
  tool_capabilities = {
    full_punch_interval = 0.2,
    max_drop_level = 1,
    damage_groups = {fleshy=350}
  },
  
  particle_override = function(player, ranger)
    mighty_morphin.fire_power_blaster(player, ranger)
  end
})

minetest.register_tool("mighty_morphin:power_axe", {
  description = "Power Axe",
  inventory_image = "mighty_morphin_power_axe.png",
  ranger_weapon = {
    weapon_key = "power_axe",
    rangers = { "mighty_morphin:black", "mighty_morphin:black_shield" },
    can_summon = function(player, ranger)
      if ranger ~= nil then
        if ranger.name == "mighty_morphin:black" or ranger.name == "mighty_morphin:black_shield" or
        mighty_morphin.player_has_item_and_is_morphed(player, "mighty_morphin:mastodon_powercoin") == true then
          return true
        end
      end
      return false
    end
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=100},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("mighty_morphin:power_bow", {
  description = "Power Bow",
  inventory_image = "mighty_morphin_power_bow.png",
  ranger_weapon = {
    weapon_key = "power_bow",
    rangers = { "mighty_morphin:pink", "mighty_morphin:pink_shield" },
    can_summon = function(player, ranger)
      if ranger ~= nil then
        if ranger.name == "mighty_morphin:pink" or ranger.name == "mighty_morphin:pink_shield" or
        mighty_morphin.player_has_item_and_is_morphed(player, "mighty_morphin:pterodactyl_powercoin") == true then
          return true
        end
      end
      return false
    end
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=100},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("mighty_morphin:power_lance", {
  description = "Power Lance",
  inventory_image = "mighty_morphin_power_lance.png",
  ranger_weapon = {
    weapon_key = "power_lance",
    rangers = { "mighty_morphin:blue", "mighty_morphin:blue_shield" },
    can_summon = function(player, ranger)
      if ranger ~= nil then
        if ranger.name == "mighty_morphin:blue" or ranger.name == "mighty_morphin:blue_shield" or
        mighty_morphin.player_has_item_and_is_morphed(player, "mighty_morphin:triceratops_powercoin") == true then
          return true
        end
        return false
      end
    end
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=100},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("mighty_morphin:power_daggers", {
  description = "Power Daggers",
  inventory_image = "mighty_morphin_power_daggers.png",
  ranger_weapon = {
    weapon_key = "power_daggers",
    rangers = { "mighty_morphin:yellow", "mighty_morphin:yellow_shield" },
    can_summon = function(player, ranger)
      if ranger ~= nil then
        if ranger.name == "mighty_morphin:yellow" or ranger.name == "mighty_morphin:yellow_shield" or
        mighty_morphin.player_has_item_and_is_morphed(player, "mighty_morphin:saber_toothed_tiger_powercoin") == true then
          return true
        end
        return false
      end
    end
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=100},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("mighty_morphin:power_sword", {
  description = "Power Sword",
  inventory_image = "mighty_morphin_power_sword.png",
  ranger_weapon = {
    weapon_key = "power_sword",
    rangers = { "mighty_morphin:red", "mighty_morphin:red_shield" },
    can_summon = function(player, ranger)
      if ranger ~= nil then
        if ranger.name == "mighty_morphin:red" or ranger.name == "mighty_morphin:red_shield" or
        mighty_morphin.player_has_item_and_is_morphed(player, "mighty_morphin:tyrannosaurus_powercoin") == true then
          return true
        end
        return false
      end
    end
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=100},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

minetest.register_tool("mighty_morphin:dragon_dagger", {
  description = "Dragon Dagger",
  inventory_image = "mighty_morphin_dragon_dagger.png",
  ranger_weapon = {
    weapon_key = "dragon_dagger",
    rangers = { "mighty_morphin:green", "mighty_morphin:green_no_shield" },
    can_summon = function(player, ranger)
      if ranger ~= nil then
        if ranger.name == "mighty_morphin:green" or ranger.name == "mighty_morphin:green_no_shield" or
        mighty_morphin.player_has_item_and_is_morphed(player, "mighty_morphin:dragonzord_powercoin") == true then
          return true
        end
        return false
      end
    end
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
  groups = {sword = 1}
})

minetest.register_tool("mighty_morphin:saba", {
  description = "Saba",
  inventory_image = "mighty_morphin_saba.png",
  ranger_weapon = {
    weapon_key = "saba",
    rangers = { "mighty_morphin:white" },
    can_summon = function(player, ranger)
      if ranger ~= nil then
        if ranger.name == "mighty_morphin:white" or
        mighty_morphin.player_has_item_and_is_morphed(player, "mighty_morphin:tigerzord_powercoin") == true then
          return true
        end
        return false
      end
    end
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=100},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

function mighty_morphin.fire_power_blaster(player, ranger)
  local look_dir = player:get_look_dir()
  local speed = 7
  
  local black_pos = morphinggrid.get_side_pos(player, 0.9, 1)
  local yellow_pos = morphinggrid.get_side_pos(player, 0.4, 1)
  local red_pos = morphinggrid.get_pos_ahead(player, 1)
  local pink_pos = morphinggrid.get_side_pos(player, -0.4, 1)
  local blue_pos = morphinggrid.get_side_pos(player, -0.9, 1)
  
  mighty_morphin.power_blaster_particle(black_pos,look_dir,speed,"mighty_morphin_black_laser_particle.png")
  mighty_morphin.power_blaster_particle(yellow_pos,look_dir,speed,"mighty_morphin_yellow_laser_particle.png")
  mighty_morphin.power_blaster_particle(red_pos,look_dir,speed,"mighty_morphin_red_laser_particle.png")
  mighty_morphin.power_blaster_particle(pink_pos,look_dir,speed,"mighty_morphin_pink_laser_particle.png")
  mighty_morphin.power_blaster_particle(blue_pos,look_dir,speed,"mighty_morphin_blue_laser_particle.png")
end

function mighty_morphin.power_blaster_particle(pos,look_dir,speed,texture)
  minetest.add_particlespawner({
    amount = 100,
    time = 0.4,
    minpos = pos,
    maxpos = pos,
    minvel = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
    maxvel = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
    minacc = {x=look_dir.x*(speed/2),y=look_dir.y*(speed/2),z=look_dir.z*(speed/2)},
    maxacc = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
    minxptime = 15,
    maxxptime = 19,
    minsize = 1,
    maxsize = 3,
    collisiondetection = true,
    verticle = false,
    texture = texture
  })
end