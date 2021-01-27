function communicator.register_communicator(name, def)
  if (def.chargable == nil) then
    def.chargable = false
  end
  
  if (def.teleportation == nil) then
    def.teleportation = false
  end
  
  def.name = name
  def.groups = def.groups or {}
  def.groups.communicator = def.groups.communicator or 1
  
  minetest.register_tool(name, def)
  communicator.registered_communicators[name] = def
end

minetest.register_on_joinplayer(function(player)
  local inv = player:get_inventory()
  inv:set_size("communicators", 4*14)
  inv:set_size("communicators_main", 1*1)
end)

function communicators.ui()
  local formspec = "size[14,12]"..
    "label[4,0;Place a communicator in the single communicator slot and use it with the communicator chat commands.]"..
    "list[current_player;communicators_main;6.25,0.5;1,1;]"..
    "list[current_player;communicators;0,2;14,4;]"..
    "list[current_player;main;3,7.5;8,4;]"
  return formspec
end

minetest.register_chatcommand("communicators", {
  params = "",
  description = "Shows a player's communicator inventory.",
    
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true
  },
  
  func = function(name)
    minetest.show_formspec(name, name.."_communicators", communicators.ui())
  end
})