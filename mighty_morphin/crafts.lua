function mod_loaded(str)
	if minetest.get_modpath(str) ~= nil then
		return true
	end
	return false
end

if mod_loaded("electronic_materials") then
	
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
	type = "shaped",
	output = "mighty_morphin:powercoin_detector_off",
	recipe = {
		{"default:steel_ingot", "default:mese", "default:steel_ingot"}, 
		{"morphinggrid:energy", "morphinggrid:energy", "mighty_morphin:empty_morpher"},
		{"default:steel_ingot", "default:mese", "default:steel_ingot"}
	}
})
	
end

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:empty_morpher",
	recipe = {"default:steel_ingot", "default:steel_ingot", "default:copper_ingot", "dye:red", "dye:white",
			  "dye:black", "morphinggrid:standard_morpher_motherboard", "morphinggrid:micro_energy_release_unit",
				"morphinggrid:micro_energy_reader_unit"}
})

--power coins
local powercoins = {
	dragonzord = { "green" },
	tigerzord = { "white" },
	mastodon = { "black" },
	pterodactyl = { "pink" },
	triceratops = { "blue" },
	saber_toothed_tiger = { "yellow" },
	tyrannosaurus = { "red" }
}

for k, r in pairs(powercoins) do
	minetest.register_craft({
		type = "shapeless",
		output = "mighty_morphin:"..k.."_powercoin",
		recipe = {"default:gold_ingot", "default:gold_ingot", "default:copper_ingot",
				  "morphinggrid:energy", "mighty_morphin:"..r[1].."_rangerdata" }
	})
end