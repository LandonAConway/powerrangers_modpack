morphinggrid.register_rangertype("turbo", {
  description = "Turbo"
})

turbo.rangers = {
  {name = "blue", desc = "Blue", ranger_groups = {}},
  {name = "green", desc = "Green", ranger_groups = {}},
  {name = "yellow", desc = "Yellow", ranger_groups = {}},
  {name = "pink", desc = "Pink", ranger_groups = {}},
  {name = "red", desc = "Red", ranger_groups = { leader = 1 }}
}

for _, v in ipairs(turbo.rangers) do
  morphinggrid.register_ranger("turbo:"..v.name, {
      description = v.desc.." Turbo Ranger",
      heal = 100,
      use = 14,
      weapons = {"turbo:turbo_blade", "turbo:turbo_auto_blaster"},
      ranger_groups = v.ranger_groups,
      armor_textures = {
        boots = { armor="turbo_boots.png", preview="turbo_boots_preview.png", inventory="turbo_boots_inv.png" }
      }
  })
  
  morphinggrid.register_griditem("turbo:"..v.name.."_morpher_key", {
		inventory_image = "turbo_morpher_key.png",
		description = v.desc.." Turbo Key"
  })
  
  morphinggrid.register_morpher("turbo:"..v.name.."_morpher", {
		inventory_image = "turbo_morpher_activated.png",
		description = v.desc.." Turbo Morpher",
		ranger = "turbo:"..v.name,
		
		morpher_slots = {
			amount = 1,
			load_input = function(morpher)
				return true, {ItemStack("turbo:"..v.name.."_morpher_key")}
			end,
			output = function(morpher, slots)
				if slots[1]:get_name() == "" then
					return true, ItemStack("turbo:morpher")
				end
				return false, morpher
			end,
			allow_put = function(morpher, stack)
				return 0
			end
		}
  })
end

morphinggrid.register_morpher("turbo:morpher", {
	inventory_image = "turbo_morpher.png",
	description = "Turbo Morpher",
	is_connected = false,
	
	morpher_slots = {
		amount = 1,
		load_input = function(morpher)
			return true, {}
		end,
		output = function(morpher, slots)
			local name = slots[1]:get_name()
			if name == "turbo:blue_morpher_key" then
				return true, ItemStack("turbo:blue_morpher")
			elseif name == "turbo:green_morpher_key" then
				return true, ItemStack("turbo:green_morpher")
			elseif name == "turbo:yellow_morpher_key" then
				return true, ItemStack("turbo:yellow_morpher")
			elseif name == "turbo:pink_morpher_key" then
				return true, ItemStack("turbo:pink_morpher")
			elseif name == "turbo:red_morpher_key" then
				return true, ItemStack("turbo:red_morpher")
			end
			return false, morpher
		end,
		allow_put = function(morpher, stack)
			local name = stack:get_name()
			if name == "turbo:blue_morpher_key" or
			name == "turbo:green_morpher_key" or
			name == "turbo:yellow_morpher_key" or
			name == "turbo:pink_morpher_key" or
			name == "turbo:red_morpher_key" then
				return 1
			end
			return 0
		end
	}
})