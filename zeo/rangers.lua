dofile(minetest.get_modpath("morphinggrid") .. "/functions.lua")

morphinggrid.register_rangertype("zeo", {
  description = "Zeo",
  weapons = {"zeo:zeo_power_pod_sword",
              "zeo:zeo_laser_pistol",
              "zeo:zeo_i_power_disk",
              "zeo:zeo_ii_power_clubs",
              "zeo:zeo_iii_power_tonfas",
              "zeo:zeo_iv_power_hatchets",
              "zeo:zeo_v_power_sword",
              "zeo:advanced_zeo_laser_pistol"}
})

zeo.rangers = {
  {"pink", "Pink", 100, 5, {}, {"zeo:zeo_i_power_disk", "zeo:zeo_power_pod_sword", "zeo:zeo_laser_pistol", "zeo:advanced_zeo_laser_pistol"}},
  {"yellow", "Yellow", 100, 5, {}, {"zeo:zeo_ii_power_clubs", "zeo:zeo_power_pod_sword", "zeo:zeo_laser_pistol", "zeo:advanced_zeo_laser_pistol"}},
  {"blue", "Blue", 100, 5, {}, {"zeo:zeo_iii_power_tonfas", "zeo:zeo_power_pod_sword", "zeo:zeo_laser_pistol", "zeo:advanced_zeo_laser_pistol"}},
  {"green", "Green", 100, 5, {}, {"zeo:zeo_iv_power_hatchets", "zeo:zeo_power_pod_sword", "zeo:zeo_laser_pistol", "zeo:advanced_zeo_laser_pistol"}},
  {"red", "Red", 100, 5, { leader = 1 }, {"zeo:zeo_v_power_sword", "zeo:zeo_power_pod_sword", "zeo:zeo_laser_pistol", "zeo:advanced_zeo_laser_pistol"}}
}

for i, v in ipairs(zeo.rangers) do
  morphinggrid.register_ranger("zeo:"..v[1], {
    description = v[2].." Zeo Ranger",
    heal = v[3],
    use = v[4],
    weapons = v[6],
    ranger_groups = v[5],
    abilities = {
      strength = {
        full_punch_interval = 0.1,
        max_drop_level = 0,
        groupcaps = {
          crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
          snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
          cracky={times={[50]=0.10}, uses=1, maxlevel=50},
          oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
        },
        damage_groups = {fleshy=70},
      }
    },
    morpher = {
      name = "zeo:right_zeonizer_"..v[1],
      inventory_image = "zeo_zeonizer_right.png",
      description = "Right Zeonizer (Zeo Ranger "..i..")",
      recipe = {
        type="shapeless",
        recipe = {"default:gold_ingot", "default:steel_ingot", "default:copper_ingot", "zeo:zeo_crystal_"..i}
      },
      morph_func_override = function(user)
        local ranger = morphinggrid.get_ranger("zeo:"..v[1])
        zeo.morph(user, ranger)
      end
    }
  })
end

morphinggrid.register_ranger("zeo:gold", {
    description = "Gold Zeo Ranger",
    heal = 100,
    use = 4,
    weapons = {},
    ranger_groups = {},
    abilities = {
      strength = {
        full_punch_interval = 0.1,
        max_drop_level = 0,
        groupcaps = {
          crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
          snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
          cracky={times={[50]=0.10}, uses=1, maxlevel=50},
          oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
        },
        damage_groups = {fleshy=70},
      }
    },
})