morphinggrid.morphers = {}

function morphinggrid.morphers.ui()
  local formspec = "size[14,12]"..
    "label[4,0;Place a morpher in the single morpher slot and use the chat command '/morph']"..
    "list[current_player;morphers_main;6.25,0.5;1,1;]"..
    "list[current_player;morphers;0,2;14,4;]"..
    "list[current_player;main;3,7.5;8,4;]"
  return formspec
end

minetest.register_chatcommand("morphers", {
  params = "",
  description = "Shows a player's morpher inventory.",
    
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name)
    minetest.show_formspec(name, name.."_morphers", morphinggrid.morphers.ui())
  end
})

function morphinggrid.morphers.contains_itemstack(player, stack)
  local inv = player:get_inventory()
  return inv:contains_itemstack("morphers", stack)
end

function morphinggrid.morphers.get_stack(player, index)
  local inv = player:get_inventory()
  return inv:get_stack("morphers", index)
end

function morphinggrid.morphers.set_stack(player, index, stack)
  local inv = player:get_inventory()
  return inv:set_stack("morphers", index, stack)
end