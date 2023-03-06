morphin_masters = {}

morphin_masters.rangers = {
    ["morphin_masters:green"] = true,
    ["morphin_masters:white"] = true,
    ["morphin_masters:black"] = true,
    ["morphin_masters:pink"] = true,
    ["morphin_masters:blue"] = true,
    ["morphin_masters:yellow"] = true,
    ["morphin_masters:red"] = true,
    ["morphin_masters:silver"] = true,
    ["morphin_masters:gold"] = true,
    ["morphin_masters:purple"] = true,
    ["morphin_masters:orange"] = true
}

dofile(minetest.get_modpath("morphin_masters") .. "/arsenal.lua")
dofile(minetest.get_modpath("morphin_masters") .. "/master_staff.lua")
dofile(minetest.get_modpath("morphin_masters") .. "/rangers.lua")
dofile(minetest.get_modpath("morphin_masters") .. "/powerups.lua")
dofile(minetest.get_modpath("morphin_masters") .. "/staff.lua")
dofile(minetest.get_modpath("morphin_masters") .. "/enerform.lua")
dofile(minetest.get_modpath("morphin_masters") .. "/abilities.lua")