morphinggrid.register_morpher("zeo:gold_staff", {
  type = "tool",
  description = "Gold Staff",
  inventory_image = "zeo_gold_staff.png",
  ranger_weapon = {
    weapon_key = "zeo_gold_staff",
    rangers = { "zeo:gold" },
  },
  tool_capabilities = {
    full_punch_interval = 0.1,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=100},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1, morpher=1},
  
  morph_func_override = function(user)
      local morphstate = morphinggrid.get_morph_status(user)
      if morphstate ~= "zeo:gold" then
        local ranger = morphinggrid.get_ranger("zeo:gold")
        zeo.morph(user, ranger)
      end
  end
})

minetest.register_craftitem("zeo:left_zeonizer", {
  description = "Left Zeonizer",
  inventory_image = "zeo_zeonizer_left.png",
  groups = {not_in_creative_inventory=1},
})