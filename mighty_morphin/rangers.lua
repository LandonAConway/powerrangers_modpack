dofile(minetest.get_modpath("morphinggrid") .. "/functions.lua")

morphinggrid.register_rangertype("mighty_morphin", {
  description = "Mighty Morphin",
  weapons = {"mighty_morphin:power_axe", "mighty_morphin:power_bow", "mighty_morphin:power_lance", "mighty_morphin:power_daggers",
            "mighty_morphin:power_sword", "mighty_morphin:dragon_dagger", "mighty_morphin:saba", "mighty_morphin:blade_blaster",
            "mighty_morphin:power_blaster"}
})

mmprrangers = {
  {"black", "Black", 100, 12, "mastodon", {"mighty_morphin:power_axe", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, {}},
  {"pink", "Pink", 100, 12, "pterodactyl", {"mighty_morphin:power_bow", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, {}},
  {"blue", "Blue", 100, 12, "triceratops", {"mighty_morphin:power_lance", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, {}},
  {"yellow", "Yellow", 100, 12, "saber_toothed_tiger", {"mighty_morphin:power_daggers", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, {}},
  {"red", "Red", 100, 12, "tyrannosaurus", {"mighty_morphin:power_sword", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, { leader = 1 }},
  {"green", "Green", 100, 10, "dragonzord", {"mighty_morphin:dragon_dagger", "mighty_morphin:blade_blaster"}, {}},
  {"white", "White", 100, 9, "tigerzord", {"mighty_morphin:saba", "mighty_morphin:blade_blaster"}, { leader = 1 }}
}

mmprrangers_shields = {
  {"black_shield", "Black", 100, 10, {"mighty_morphin:power_axe", "mighty_morphin:dragon_dagger", "mighty_morphin:blade_blaster",
  "mighty_morphin:power_blaster"}, { hidden = 1 }},
  {"pink_shield", "Pink", 100, 10, {"mighty_morphin:power_bow", "mighty_morphin:dragon_dagger", "mighty_morphin:blade_blaster",
  "mighty_morphin:power_blaster"}, { hidden = 1 }},
  {"blue_shield", "Blue", 100, 10, {"mighty_morphin:power_lance", "mighty_morphin:dragon_dagger", "mighty_morphin:blade_blaster",
  "mighty_morphin:power_blaster"}, { hidden = 1 }},
  {"yellow_shield", "Yellow", 100, 10, {"mighty_morphin:power_daggers", "mighty_morphin:dragon_dagger", "mighty_morphin:blade_blaster",
  "mighty_morphin:power_blaster"}, { hidden = 1 }},
  {"red_shield", "Red", 100, 10, {"mighty_morphin:power_sword", "mighty_morphin:dragon_dagger", "mighty_morphin:blade_blaster",
  "mighty_morphin:power_blaster"}, { hidden = 1, leader = 1 }},
  {"green_no_shield", "Green", 100, 12, {"mighty_morphin:blade_blaster"}, { hidden = 1 }}
}

for i, v in ipairs(mmprrangers) do
  morphinggrid.register_ranger("mighty_morphin:"..v[1], {
    description = v[2].." Mighty Morphin Ranger",
    heal = v[3],
    use = v[4],
    weapons = v[6],
    ranger_groups = v[7],
    morpher = {
      name = "mighty_morphin:"..v[5].."_morpher",
      inventory_image = v[5].."_morpher.png",
      description = mighty_morphin.upper_first_char(v[5]).." Morpher",
      recipe = {
        type="shapeless",
        recipe = {"mighty_morphin:empty_morpher", "mighty_morphin:"..v[5].."_powercoin"}
      },
      morph_func_override = function(user, itemstack)
        local ranger = morphinggrid.get_ranger("mighty_morphin:"..v[1])
        mighty_morphin.morph(user, ranger, "mighty_morphin:"..v[5].."_morpher", itemstack)
      end,
    },
  })
end

for i, v in ipairs(mmprrangers_shields) do
  morphinggrid.register_ranger("mighty_morphin:"..v[1], {
    description = v[2].." Mighty Morphin Ranger",
    heal = v[3],
    use = v[4],
    weapons = v[5],
    ranger_groups = v[6]
  })
end