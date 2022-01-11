morphinggrid.register_rangertype("beast_morphers", {
  description = "Beast Morphers",
  weapons = {}
})

local blue_strength = {
    full_punch_interval = 0.1,
    max_drop_level = 0,
    groupcaps = {
      crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
      oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
    },
    damage_groups = {fleshy=50},
}

function beast_morphers.get_strength(name) if name=="blue" then return blue_strength end return nil end

beast_morphers.rangers = {
  {"red", "Red", 100, 10, { leader = 1 }},
  {"yellow", "Yellow", 100, 10, {}},
  {"blue", "Blue", 100, 10, {}},
  {"silver", "Silver", 100, 10, {}},
  {"gold", "Gold", 100, 10, {}}
}

for i, v in ipairs(beast_morphers.rangers) do
  morphinggrid.register_ranger("beast_morphers:"..v[1], {
    description = v[2].." Beast Morphers Ranger",
    heal = v[3],
    use = v[4],
    weapons = {},
    abilities = { strength=beast_morphers.get_strength(v[1]) },
    ranger_groups = v[5]
  })
end