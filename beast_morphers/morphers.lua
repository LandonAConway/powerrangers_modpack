--65535

keys = {
  { "red", "Red", "red" },
  { "yellow", "Yellow", "yellow" },
  { "blue", "Blue", "blue" },
  { "silver", "Silver", "grey" },
  { "gold", "Gold", "brown" }
}

for i, v in ipairs(keys) do
  morphinggrid.register_griditem("beast_morphers:morpher_key_"..v[1], {
	type = "tool",
    description = v[2].." Ranger Key",
    inventory_image = "beast_morphers_key_"..v[1]..".png",
    groups = {
      bm_key = 1
    },
	grid_doc = {
		description = "This key is what provides the ability to morph into the "..v[2].." if it is placed to the left "..
			"of the Bease Morphers Morpher"
	}
  })
  
  minetest.register_craft({
	  output = "beast_morphers:morpher_key_"..v[1],
	  type = "shapeless",
	  recipe = { "default:steel_ingot", "default:copper_ingot", "dye:"..v[3], 
		"beast_morphers:"..v[1].."_rangerdata"}
	})
end

morphinggrid.register_morpher("beast_morphers:morpher", {
  type = "craftitem",
  description = "Beast Morphers Morpher",
  inventory_image = "beast_morphers_morpher.png",
  grid_doc = {
	description = "When a ranger key is placed to the right of this morpher, it will morph a player into a power ranger."..
		" If the morpher is in the single slot of the morphers inventory, the ranger key should be in the first slot"..
		" of the morphers inventory."
  },
  
  morph_func_override = function(user, itemstack)
    beast_morphers.morph(user, itemstack)
  end
})