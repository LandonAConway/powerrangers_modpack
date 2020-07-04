minetest.register_craftitem("morphinggrid:energy", {
	description = "Morphing Grid Energy",
	inventory_image = "morphinggrid_energy.png",
	groups = {not_in_creative_inventory=1},
})

function mod_loaded(str)
  if minetest.get_modpath(str) ~= nil then
    return true
  end
  return false
end

if mod_loaded("electronic_materials") then

  minetest.register_craftitem("morphinggrid:micro_energy_connector_release_unit", {
    description = "Micro Morphing Grid Energy Connector/Release Unit",
    inventory_image = "energy_release_micro_unit.png"
  })
  
  minetest.register_craftitem("morphinggrid:standard_morpher_motherboard", {
    description = "Standard Morpher Motherboard",
    inventory_image = "morpher_mother_board.png"
  })
  
end