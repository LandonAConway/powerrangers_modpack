function communicator.register_communicator(name, def)
  if (def.chargable == nil) then
    def.chargable = false
  end
  
  def.name = name
  def.groups = def.groups or {}
  def.groups.communicator = def.groups.communicator or 1
  def.channel = def.channel or "unknown"
  def.communicator_commands = def.communicator_commands or {}
  def.communicator_command_presets = def.communicator_command_presets or {}
  
  --Register craft
  if def.craft ~= nil then
    minetest.register_craft(def.craft)
  end
  
  --Add command presets
  def = communicator.apply_cmd_presets(def)
  
  --Add default commands to the communicator.
  def.communicator_commands.help = {
    description = "Lists all commands for the communicator.",
    func = function(name)
      minetest.chat_send_player(name,"Commands for: "..(def.description or ""))
      for cmd,t in pairs(def.communicator_commands) do
        minetest.chat_send_player(name,cmd.." "..(t.params or "").." | "..(t.description or ""))
      end
    end
  }
  
  --register it as a communicator
  communicator.registered_communicators[name] = def
  
  --register it as a morpher
  if def.register_morpher == true then
	def.register_item = false
	morphinggrid.register_morpher(name, def)
  elseif def.register_griditem == true then
    def.register_item = false
	def.is_griditem = true
	morphinggrid.register_griditem(name, def)
  end
  
  --register item
  minetest.register_tool(name, def)
end

function communicator.apply_cmd_presets(cmc)
  for pname, p in pairs(cmc.communicator_command_presets) do
    if communicator.cmd_presets[pname] ~= nil then
      if p == true then
        for cname, c in pairs(communicator.cmd_presets[pname]) do
          cmc.communicator_commands[cname] = c
        end
      end
    else
      error("'"..pname.."' is not an existing preset.")
    end
  end
  return cmc
end

minetest.register_on_joinplayer(function(player)
  local inv = player:get_inventory()
  inv:set_size("communicators", 4*14)
  inv:set_size("communicators_main", 1*1)
end)

function communicator.ui()
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
    minetest.show_formspec(name, name.."_communicators", communicator.ui())
  end
})

function communicator.contains_itemstack(player, stack)
  local inv = player:get_inventory()
  return inv:contains_itemstack("communicators", stack)
end

function communicator.get_stack(player, index)
  local inv = player:get_inventory()
  return inv:get_stack("communicators", index)
end

function communicator.set_stack(player, index, stack)
  local inv = player:get_inventory()
  return inv:set_stack("communicators", index, stack)
end