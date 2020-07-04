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

--minetest.register_craft({
--	type = "shapeless",
--	output = "mighty_morphin:mastodon_morpher",
--	recipe = {"mighty_morphin:mastodon_powercoin", "mighty_morphin:empty_morpher"},
--})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:mastodon_powercoin",
	recipe = {"mighty_morphin:mastodon_morpher"},
	replacements = {
		{"mighty_morphin:mastodon_morpher", "mighty_morphin:empty_morpher"}
	}
})

--minetest.register_craft({
--	type = "shapeless",
--	output = "mighty_morphin:pterodactyl_morpher",
--	recipe = {"mighty_morphin:pterodactyl_powercoin", "mighty_morphin:empty_morpher"},
--})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:pterodactyl_powercoin",
	recipe = {"mighty_morphin:pterodactyl_morpher"},
	replacements = {
		{"mighty_morphin:pterodactyl_morpher", "mighty_morphin:empty_morpher"}
	}
})

--minetest.register_craft({
--	type = "shapeless",
--	output = "mighty_morphin:triceratops_morpher",
--	recipe = {"mighty_morphin:triceratops_powercoin", "mighty_morphin:empty_morpher"},
--})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:triceratops_powercoin",
	recipe = {"mighty_morphin:triceratops_morpher"},
	replacements = {
		{"mighty_morphin:triceratops_morpher", "mighty_morphin:empty_morpher"}
	}
})

--minetest.register_craft({
--	type = "shapeless",
--	output = "mighty_morphin:saber_toothed_tiger_morpher",
--	recipe = {"mighty_morphin:saber_toothed_tiger_powercoin", "mighty_morphin:empty_morpher"},
--})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:saber_toothed_tiger_powercoin",
	recipe = {"mighty_morphin:saber_toothed_tiger_morpher"},
	replacements = {
		{"mighty_morphin:saber_toothed_tiger_morpher", "mighty_morphin:empty_morpher"}
	}
})

--minetest.register_craft({
--	type = "shapeless",
--	output = "mighty_morphin:tyrannosaurus_morpher",
--	recipe = {"mighty_morphin:tyrannosaurus_powercoin", "mighty_morphin:empty_morpher"},
--})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:tyrannosaurus_powercoin",
	recipe = {"mighty_morphin:tyrannosaurus_morpher"},
	replacements = {
		{"mighty_morphin:tyrannosaurus_morpher", "mighty_morphin:empty_morpher"}
	}
})

--minetest.register_craft({
--	type = "shapeless",
--	output = "mighty_morphin:dragonzord_morpher",
--	recipe = {"mighty_morphin:dragonzord_powercoin", "mighty_morphin:empty_morpher"},
--})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:dragonzord_powercoin",
	recipe = {"mighty_morphin:dragonzord_morpher"},
	replacements = {
		{"mighty_morphin:dragonzord_morpher", "mighty_morphin:empty_morpher"}
	}
})

--minetest.register_craft({
--	type = "shapeless",
--	output = "mighty_morphin:tigerzord_morpher",
--	recipe = {"mighty_morphin:tigerzord_powercoin", "mighty_morphin:empty_morpher"},
--})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:tigerzord_powercoin",
	recipe = {"mighty_morphin:tigerzord_morpher"},
	replacements = {
		{"mighty_morphin:tigerzord_morpher", "mighty_morphin:empty_morpher"}
	}
})