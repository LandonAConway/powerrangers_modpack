--turbo keys
local turbo_keys = {
	{ "pink" },
	{ "yellow" },
	{ "blue" },
	{ "green" },
	{ "red" }
}

for i, r in pairs(turbo_keys) do
	minetest.register_craft({
		type = "shapeless",
		output = "turbo:"..r[1].."_morpher_key"
		recipe = {"morphinggrid:energy", "morphinggrid:energy", "morphinggrid:energy",
				"default:gold_ingot", "turbo:"..r[1].."_rangerdata" }
	})
end