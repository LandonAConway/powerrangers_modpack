dofile(minetest.get_modpath("3d_armor") .. "/api.lua")

local S = armor_i18n.gettext

function register_ranger_as_armor(modname, ranger, rangerdesc, power_heal, power_use)
	armor:register_armor(modname..":helmet_"..ranger, {
		description = S(rangerdesc.." Helmet"),
		inventory_image = modname.."_inv_helmet_"..ranger..".png",
		armor_groups = {fleshy=100},
		groups = {armor_head=1, armor_heal=power_heal, armor_use=power_use, armor_water=1,
			not_in_creative_inventory=1},
		on_drop = function(itemstack, dropper, pos)
			return
		end,
	})

	armor:register_armor(modname..":chestplate_"..ranger, {
		description = S(rangerdesc.." Chestplate"),
		inventory_image = modname.."_inv_chestplate_"..ranger..".png",
		armor_groups = {fleshy=100},
		groups = {armor_torso=1, armor_heal=power_heal, armor_use=power_use,
			not_in_creative_inventory=1},
		on_drop = function(itemstack, dropper, pos)
			return
		end,
	})

	armor:register_armor(modname..":leggings_"..ranger, {
		description = S(rangerdesc.." Leggings"),
		inventory_image = modname.."_inv_leggings_"..ranger..".png",
		armor_groups = {fleshy=100},
		groups = {armor_legs=1, armor_heal=power_heal, armor_use=power_use,
			not_in_creative_inventory=1},
		on_drop = function(itemstack, dropper, pos)
			return
		end,
	})

	armor:register_armor(modname..":boots_"..ranger, {
		description = S(rangerdesc.." Boots"),
		inventory_image = modname.."_inv_boots_"..ranger..".png",
		armor_groups = {fleshy=100},
		groups = {armor_feet=1, armor_heal=power_heal, armor_use=power_use,
			not_in_creative_inventory=1},
		on_drop = function(itemstack, dropper, pos)
			return
		end,
	})
end

function morphinggrid.split_string (inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	
	local t = {}
	if string.find(inputstr, sep) then
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
		end
	else
		table.insert(t, inputstr)
	end
	
	return t
end