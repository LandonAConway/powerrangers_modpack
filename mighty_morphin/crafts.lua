function mod_loaded(str)
	if minetest.get_modpath(str) ~= nil then
		return true
	end
	return false
end

if mod_loaded("electronic_materials") then

	minetest.register_craft({
		type = "shapeless",
		output = "mighty_morphin:empty_morpher",
		recipe = {"default:steel_ingot", "default:steel_ingot", "default:copper_ingot",
				  "morphinggrid:standard_morpher_motherboard" }
	})
	
	minetest.register_craft({
	type = "shaped",
	output = "mighty_morphin:powercoin_detector_off",
	recipe = {
		{"default:steel_ingot", "default:mese", "default:steel_ingot"}, 
		{"morphinggrid:energy", "electronic_materials:small_motherboard", "mighty_morphin:empty_morpher"},
		{"default:steel_ingot", "default:mese", "default:steel_ingot"}
	}
})
	
else

	minetest.register_craft({
		type = "shapeless",
		output = "mighty_morphin:empty_morpher",
		recipe = {"morphinggrid:energy", "default:steel_ingot", "default:copper_ingot"}
	})
	
	minetest.register_craft({
	type = "shaped",
	output = "mighty_morphin:powercoin_detector_off",
	recipe = {
		{"default:steel_ingot", "default:mese", "default:steel_ingot"}, 
		{"morphinggrid:energy", "morphinggrid:energy", "mighty_morphin:empty_morpher"},
		{"default:steel_ingot", "default:mese", "default:steel_ingot"}
	}
})
	
end