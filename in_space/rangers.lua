morphinggrid.register_rangertype("in_space", {
  description = "In Space"
})

in_space.rangers = {
  {name = "red", desc = "Red", ranger_groups = { leader = 1 }},
  {name = "blue", desc = "Blue", ranger_groups = {}},
  {name = "black", desc = "Black", ranger_groups = {}},
  {name = "pink", desc = "Pink", ranger_groups = {}},
  {name = "yellow", desc = "Yellow", ranger_groups = {}}
}

for _, v in ipairs(in_space.rangers) do
  morphinggrid.register_ranger("in_space:"..v.name, {
      description = v.desc.." In Space Ranger",
      max_energy = 9000,
      energy_damage_per_hp = 0.8,
      energy_heal_per_globalstep = 1,
      weapons = {},
      ranger_groups = v.ranger_groups,
      
      morpher = {
            name = "in_space:"..v.name.."_astro_morpher",
            inventory_image = "in_space_astro_morpher.png",
            description = v.desc.." In Space Astro Morpher",
      
          --recipe = {
            --type="shapeless",
            --recipe = {"morphinggrid:energy", "default:steel_ingot"}
          --},
      },
      
      armor_textures = {
        boots = { armor="in_space_boots.png", preview="in_space_boots_preview.png", inventory="in_space_boots_inv.png" }
      }
  })
end

morphinggrid.register_ranger("in_space:silver", {
    description = "Silver In Space Ranger",
    max_energy = 9500,
    energy_damage_per_hp = 0.8,
    energy_heal_per_globalstep = 1,
    weapons = {},
    ranger_groups = {},
    
    morpher = {
          name = "in_space:digimorpher",
          inventory_image = "in_space_digimorpher.png",
          description = "In Space Digiorpher",
      
          --recipe = {
            --type="shapeless",
            --recipe = {"morphinggrid:energy", "default:steel_ingot"}
          --},
    },
      
    armor_textures = {
      boots = { armor="in_space_boots_silver.png", preview="in_space_boots_preview_silver.png", inventory="in_space_boots_inv_silver.png" }
    }
})