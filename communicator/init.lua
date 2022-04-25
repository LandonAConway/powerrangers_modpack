communicator = {}
communicator.cmd_presets = {}
communicator.registered_channels = {}
communicator.registered_communicators = {}
communicator.mod_storage = {}

local storage = minetest.get_mod_storage()

function communicator.mod_storage.get_string(key)
  return storage:get_string(key)
end

function communicator.mod_storage.set_string(key, value)
  storage:set_string(key, value)
end

dofile(minetest.get_modpath("communicator") .. "/privs.lua")
dofile(minetest.get_modpath("communicator") .. "/commands.lua")
dofile(minetest.get_modpath("communicator") .. "/cmd_presets/presets.lua")
dofile(minetest.get_modpath("communicator") .. "/channels.lua")
dofile(minetest.get_modpath("communicator") .. "/communicators.lua")