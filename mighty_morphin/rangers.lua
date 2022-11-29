dofile(minetest.get_modpath("morphinggrid") .. "/functions.lua")

morphinggrid.register_rangertype("mighty_morphin", {
    description = "Mighty Morphin",
    weapons = {"mighty_morphin:power_axe", "mighty_morphin:power_bow", "mighty_morphin:power_lance", "mighty_morphin:power_daggers",
                "mighty_morphin:power_sword", "mighty_morphin:dragon_dagger", "mighty_morphin:saba", "mighty_morphin:blade_blaster",
                "mighty_morphin:power_blaster"
    },
    grid_doc = {
            description = "The Mighty Morphin Power Rangers (MMPR) is a team of rangers that uses Power Coins to obtain their powers."..
            "Power Coins are placed inside of an empty morpher using morpher slots. The green ranger (via Dragonzord Powercoin) "..
            "has a special shield that makes him stronger. The shield can be removed, and given to other rangers of the same team."..
            "When the green ranger was destroyed, the white ranger (via Tigerzord Powercoin) took the green ranger's place."
    }
})

mmprrangers = {
    {"black", "Black", 7700, 0.7, "mastodon", {"mighty_morphin:power_axe", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, {}},
    {"pink", "Pink", 7700, 0.7, "pterodactyl", {"mighty_morphin:power_bow", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, {}},
    {"blue", "Blue", 7700, 0.7, "triceratops", {"mighty_morphin:power_lance", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, {}},
    {"yellow", "Yellow", 7700, 0.7, "saber_toothed_tiger", {"mighty_morphin:power_daggers", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, {}},
    {"red", "Red", 7700, 0.7, "tyrannosaurus", {"mighty_morphin:power_sword", "mighty_morphin:blade_blaster", "mighty_morphin:power_blaster"}, { leader = 1 }},
    {"green", "Green", 7700, 0.7, "dragonzord", {"mighty_morphin:dragon_dagger", "mighty_morphin:blade_blaster"}, {}, {"mighty_morphin:dragon_shield"}},
    {"white", "White", 7700, 0.7, "tigerzord", {"mighty_morphin:saba", "mighty_morphin:blade_blaster"}, { leader = 1 }}
}

for i, v in ipairs(mmprrangers) do
    morphinggrid.register_ranger("mighty_morphin:"..v[1], {
        description = v[2].." Mighty Morphin Ranger",
        max_energy = v[3],
        energy_damage_per_hp = 1,
        energy_heal_per_globalstep = v[4],
        powerups = v[8],
        color = v[1],
        weapons = v[6],
        ranger_groups = v[7],
        ranger_command_presets = { default = true, visor = true },
        rtextures = { helmet = { armor_visor_mask = "mighty_morphin_visor_mask_"..v[1]..".png" } },
        morpher = {
            name = "mighty_morphin:"..v[5].."_morpher",
            inventory_image = v[5].."_morpher.png",
            description = mighty_morphin.upper_first_char(v[5], true).." Morpher",
            griditems = { "mighty_morphin:"..v[5].."_powercoin" },
            prevents_respawn = true,
            hp_multiplier = 0.5,
            grid_doc = {
                description = "Morphs a player into the Mighty Morphin "..v[2].." Ranger."
            },
            ranger_armor = { helmet = { helmet_visor_mask = "mighty_morphin_visor_mask_"..v[1] } },
            morpher_slots = {
                amount = 1,
                load_input = function(itemstack)
                return true, {ItemStack("mighty_morphin:"..v[5].."_powercoin")}
                end,
                output = function(itemstack, slots)
                if slots[1]:get_name() == "" then
                    return true, ItemStack("mighty_morphin:empty_morpher")
                end
                return false, itemstack
                end,
                allow_put = function()
                return 0
                end,
                grid_doc = {
                inputs = {
                    { input = {} }
                }
                }
            },
            morph_func_override = function(user, itemstack)
                local ranger = morphinggrid.get_ranger("mighty_morphin:"..v[1])
                mighty_morphin.morph(user, ranger, "mighty_morphin:"..v[5].."_morpher", itemstack)
            end,
        },
    })
end

morphinggrid.register_powerup("mighty_morphin:dragon_shield", {
    description = "Dragon Shield",
    mult_energy = 0.85,
    rtextures = {
        chestplate = { armor = "mighty_morphin_dragon_shield.png" }
    }
})