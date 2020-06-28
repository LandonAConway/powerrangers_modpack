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
    rangers = { "mighty_morphin:black", "mighty_morphin:black_shield" },
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
        if ranger.name == "mighty_morphin:green" or ranger.name == "mighty_morphin:green_shield" or
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