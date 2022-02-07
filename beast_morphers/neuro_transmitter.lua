beast_morphers.neuro_transmitter = {}

function beast_morphers.neuro_transmitter.nt_interface(pos)
  local list_name = "nodemeta:"..pos.x..','..pos.y..','..pos.z
  local formspec = "size[8,6]"..
    "list["..list_name..";morphx;3.5,0;1,1;]"..
    "list[current_player;main;0,2;8,4;]"
  return formspec
end

minetest.register_node("beast_morphers:neuro_transmitter", {
  description = "Neuro Transmitter",
  tiles = {
    "beast_morphers_neuro_transmitter.png",
    "beast_morphers_neuro_transmitter.png",
    "beast_morphers_neuro_transmitter.png",
    "beast_morphers_neuro_transmitter.png",
    "beast_morphers_neuro_transmitter.png",
    "beast_morphers_neuro_transmitter.png"
  },
  drawtype = "nodebox",
  paramtype = "light",
  node_box = {
    type = "fixed",
    fixed = {
      {-0.5, 0.3125, -0.5, -0.4375, 0.375, 0.5},
      {0.4375, 0.3125, -0.5, 0.5, 0.375, 0.5},
      {-0.5, 0.3125, -0.5, 0.5, 0.375, -0.4375},
      {-0.5, 0.3125, 0.4375, 0.5, 0.375, 0.5},
      {-0.5, 0.3125, 0.1875, 0.5, 0.375, 0.25},
      {-0.5, 0.3125, -0.25, 0.5, 0.375, -0.1875},
      {0.1875, 0.3125, -0.5, 0.25, 0.375, 0.5},
      {-0.25, 0.3125, -0.5, -0.1875, 0.375, 0.5},
      {-0.25, 0.3125, 0.1875, -0.1875, 0.5, 0.25},
      {-0.25, 0.3125, -0.25, -0.1875, 0.5, -0.1875},
      {0.1875, 0.3125, -0.25, 0.25, 0.5, -0.1875},
      {0.1875, 0.3125, 0.1875, 0.25, 0.5, 0.25},
      {-0.25, 0.4375, -0.25, 0.25, 0.5, 0.25},
    }
  },
  groups = { cracky = 2 },
  grid_doc = {
	description = "The Neuro Transmitter is capable of giving players the right DNA to become a ranger. Right click the "..
    "node to place a Morph-X Drum inside, and stand under it when it is on using mesecon. While standing under it "..
    "You wull also need to wield a test tube of DNA."
  },
  
  after_place_node = function(pos, placer, itemstack)
    local can_place = minetest.check_player_privs(placer:get_player_name(), { power_rangers = true })
    if can_place == true then
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      inv:set_size("morphx", 1*1)
    else
      minetest.remove_node(pos)
      minetest.chat_send_player(placer:get_player_name(), "You do not have the power_rangers priv.")
    end
  end,
  
  on_rightclick = function(pos, node, clicker, itemstack)
    local can_use = minetest.check_player_privs(clicker:get_player_name(), { power_rangers = true })
    if can_use == true then
      minetest.show_formspec(clicker:get_player_name(), "beast_morphers:nt_formspec", beast_morphers.neuro_transmitter.nt_interface(pos))
    else
      minetest.chat_send_player(clicker:get_player_name(), "You do not have the power_rangers priv.")
    end
  end,
})