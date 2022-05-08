morphinggrid.register_rangertype("beast_morphers", {
  description = "Beast Morphers",
  weapons = { "beast_morphers:cheetah_claws", "beast_morphers:cheetah_beast_blaster",
				"beast_morphers:beast_x_ultra_blaster", "beast_morphers:beast_x_ultra_bow", "beast_morphers:beast_x_spin_saber",
				"beast_morphers:beast_x_cannon", "beast_morphers:beast_x_blaster", "beast_morphers:beast_x_saber",
				"beast_morphers:striker_saber" },
  grid_doc = {
	  description = "Beast Morphers is a team of rangers that use a combination of dna and morph-x (morphing grid energy "..
	    "refined into a liquid) to get their powers. To use a morpher, a players needs to have the dna of a specific animal. "..
	    "More information about how to do this is found in the documentation of the the Neuro Transmitter in 'Other Items'. "
  }
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

local w_red = { 
				"beast_morphers:beast_x_ultra_blaster",
				"beast_morphers:beast_x_ultra_bow",
				"beast_morphers:beast_x_spin_saber",
				"beast_morphers:beast_x_cannon",
				"beast_morphers:beast_x_blaster",
				"beast_morphers:beast_x_saber",
				"beast_morphers:cheetah_claws",
				"beast_morphers:cheetah_beast_blaster"
}

local w_yellow = { 
				"beast_morphers:beast_x_ultra_blaster",
				"beast_morphers:beast_x_ultra_bow",
				"beast_morphers:beast_x_spin_saber",
				"beast_morphers:beast_x_cannon",
				"beast_morphers:beast_x_blaster",
				"beast_morphers:beast_x_saber"
}

local w_blue = { 
				"beast_morphers:beast_x_ultra_blaster",
				"beast_morphers:beast_x_ultra_bow",
				"beast_morphers:beast_x_spin_saber",
				"beast_morphers:beast_x_cannon",
				"beast_morphers:beast_x_blaster",
				"beast_morphers:beast_x_saber"
}

local w_silver = { 
				"beast_morphers:beast_x_ultra_blaster",
				"beast_morphers:beast_x_ultra_bow",
				"beast_morphers:beast_x_spin_saber",
				"beast_morphers:beast_x_cannon",
				"beast_morphers:beast_x_blaster",
				"beast_morphers:beast_x_saber",
				"beast_morphers:striker_saber"
}

local w_gold = { 
				"beast_morphers:beast_x_ultra_blaster",
				"beast_morphers:beast_x_ultra_bow",
				"beast_morphers:beast_x_spin_saber",
				"beast_morphers:beast_x_cannon",
				"beast_morphers:beast_x_blaster",
				"beast_morphers:beast_x_saber",
				"beast_morphers:striker_saber"
}

local special_abilities = {
	red = {
		title = "Special Abilities     ", value = "Running",
		desc = "Press RMB while fast running to run faster."
	},
	yellow = {
		title = "Special Abilities     ", value = "Jumping",
		desc = "Press RMB while jumping to jump higher."
	},
	blue = {
		title = "Special Abilities     ", value = "Strength",
		desc = "Press LMB and RMB at the same time to hit multiple objects at once."
	},
	silver = {
		title = "Special Abilities     ", value = "None",
		desc = ""
	},
	gold = {
		title = "Special Abilities     ", value = "None",
		desc = ""
	}
}

beast_morphers.rangers = {
  {"red", "Red", 0, 0, { leader = 1 }, weapons = w_red },
  {"yellow", "Yellow", 0, 0, weapons = w_yellow },
  {"blue", "Blue", 0, 0, weapons = w_blue },
  {"silver", "Silver", 0, 0, weapons = w_silver },
  {"gold", "Gold", 0, 0, weapons = w_gold }
}

for i, v in ipairs(beast_morphers.rangers) do
  morphinggrid.register_ranger("beast_morphers:"..v[1], {
    description = v[2].." Beast Morphers Ranger",
	max_energy = 14000,
	energy_damage_per_hp = 1,
	energy_heal_per_globalstep = 1.2,
	color = v[1],
    weapons = v.weapons,
    abilities = { strength=beast_morphers.get_strength(v[1]) },
    ranger_groups = v[5],
	
	grid_doc = {
		custom_details = {
			special_abilities[v[1]]
		}
	}
  })
end