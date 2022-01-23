minetest.register_tool("beast_morphers:cheetah_claws", {
  description = "Cheetah Claws",
  inventory_image = "beast_morphers_cheetah_claws.png",
  ranger_weapon = {
    weapon_key = "cheetah_claws",
    rangers = { "beast_morphers:red" }
  },
  tool_capabilities = {
    full_punch_interval = 0.4,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=110, cracky=50},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1}
})

morphinggrid.register_firearm("beast_morphers:cheetah_beast_blaster", {
	description = "Cheetah Beast Blaster",
	inventory_image = "beast_morphers_cheetah_beast_blaster.png",
	distance = 85,
	ranger_weapon = {
		weapon_key = "cheetah_beast_blaster",
		rangers = { "beast_morphers:red" }
	},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 1,
		damage_groups = { fleshy = 150 }
	},
	particle_override = function(player, ranger)
		beast_morphers.fire_weapon(player, 85)
	end
})

morphinggrid.register_firearm("beast_morphers:beast_x_ultra_blaster", {
	description = "Beast-X Ultra Blaster",
	inventory_image = "beast_morphers_beast_x_ultra_blaster.png",
	distance = 75,
	ranger_weapon = {
		weapon_key = "beast_x_ultra_blaster",
		rangers = { 
			"beast_morphers:red",
			"beast_morphers:yellow",
			"beast_morphers:blue",
			"beast_morphers:silver",
			"beast_morphers:gold"  },
		required_weapons = {
			"beast_morphers:beast_x_blaster",
		}
	},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 1,
		damage_groups = { fleshy = 300 }
	},
	particle_override = function(player, ranger)
		beast_morphers.fire_weapon(player, 75)
	end
})

morphinggrid.register_firearm("beast_morphers:beast_x_ultra_bow", {
	description = "Beast-X Ultra Bow",
	inventory_image = "beast_morphers_beast_x_ultra_bow.png",
	distance = 75,
	ranger_weapon = {
		weapon_key = "beast_x_ultra_bow",
		rangers = { 
			"beast_morphers:red",
			"beast_morphers:yellow",
			"beast_morphers:blue",
			"beast_morphers:silver",
			"beast_morphers:gold"  }
	},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 1,
		damage_groups = { fleshy = 280 }
	},
	particle_override = function(player, ranger)
		beast_morphers.fire_weapon(player, 75)
	end
})

minetest.register_tool("beast_morphers:beast_x_spin_saber", {
	description = "Beast-X Spin Saber",
	inventory_image = "beast_morphers_beast_x_spin_saber.png",
	ranger_weapon = {
		weapon_key = "beast_x_spin_saber",
		rangers = { 
			"beast_morphers:red",
			"beast_morphers:yellow",
			"beast_morphers:blue",
			"beast_morphers:silver",
			"beast_morphers:gold"  }
	},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 1,
		damage_groups = { fleshy = 95 }
	},
	groups = {sword = 1}
})

morphinggrid.register_firearm("beast_morphers:beast_x_cannon", {
	description = "Beast-X Cannon",
	inventory_image = "beast_morphers_beast_x_cannon.png",
	distance = 55,
	ranger_weapon = {
		weapon_key = "beast_x_cannon",
		rangers = { 
			"beast_morphers:red",
			"beast_morphers:yellow",
			"beast_morphers:blue",
			"beast_morphers:silver",
			"beast_morphers:gold"  },
		required_weapons = {
			"beast_morphers:beast_x_blaster",
			"beast_morphers:beast_x_saber"
		}
	},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 1,
		damage_groups = { fleshy = 80 }
	},
	particle_override = function(player, ranger)
		beast_morphers.fire_weapon(player, 55)
	end
})

morphinggrid.register_firearm("beast_morphers:beast_x_blaster", {
	description = "Beast-X Blaster",
	inventory_image = "beast_morphers_beast_x_blaster.png",
	distance = 40,
	ranger_weapon = {
		weapon_key = "beast_x_blaster",
		rangers = { 
			"beast_morphers:red",
			"beast_morphers:yellow",
			"beast_morphers:blue",
			"beast_morphers:silver",
			"beast_morphers:gold"  }
	},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 1,
		damage_groups = { fleshy = 80 }
	},
	particle_override = function(player, ranger)
		beast_morphers.fire_weapon(player, 55)
	end
})

minetest.register_tool("beast_morphers:beast_x_saber", {
	description = "Beast-X Saber",
	inventory_image = "beast_morphers_beast_x_saber.png",
	ranger_weapon = {
		weapon_key = "beast_x_saber",
		rangers = { 
			"beast_morphers:red",
			"beast_morphers:yellow",
			"beast_morphers:blue",
			"beast_morphers:silver",
			"beast_morphers:gold"  }
	},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 1,
		damage_groups = { fleshy = 80 }
	},
	groups = {sword = 1}
})

minetest.register_tool("beast_morphers:striker_saber", {
	description = "Striker Saber",
	inventory_image = "beast_morphers_striker_saber.png",
	ranger_weapon = {
		weapon_key = "striker_saber",
		rangers = {
			"beast_morphers:silver",
			"beast_morphers:gold"  }
	},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 1,
		damage_groups = { fleshy = 140 }
	},
	groups = {sword = 1}
})

function beast_morphers.fire_weapon(player, distance)
	local _pos = player:get_pos()
	local pos = {x=_pos.x,y=_pos.y+1.45,z=_pos.z}
	local look_dir = player:get_look_dir()
	local speed = 8
	minetest.add_particlespawner({
		amount = 400,
		time = 0.7,
		minpos = pos,
		maxpos = pos,
		minvel = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
		maxvel = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
		-- minacc = {x=look_dir.x*(speed/2),y=look_dir.y*(speed/2),z=look_dir.z*(speed/2)},
		-- maxacc = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
		minacc = {x=0,y=0,z=0},
		maxaxx = {x=0,y=0,z=0},
		minxptime = speed*distance,
		maxxptime = speed*distance,
		minsize = 1,
		maxsize = 1,
		collisiondetection = true,
		verticle = false,
		texture = "beast_morphers_particle.png"
	})
end