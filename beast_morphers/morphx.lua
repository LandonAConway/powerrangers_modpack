morphinggrid.register_griditem("beast_morphers:morphx_source", {
  type = "node",
  description = "Morph X Source",
  drawtype = "liquid",
  waving = 3,
  tiles = {
    {
      name = "beast_morphers_morphx_1.png",
      backface_culling = false,
      animation = {
        type = "vertical_frames",
        aspect_w = 16,
        aspect_h = 16,
        length = 2.0,
      },
    },
    {
      name = "beast_morphers_morphx_2.png",
      backface_culling = true,
      animation = {
        type = "vertical_frames",
        aspect_w = 16,
        aspect_h = 16,
        length = 2.0,
      },
    },
  },
  paramtype = "light",
  walkable = false,
  pointable = true,
  diggable = false,
  buildable_to = true,
  is_ground_content = false,
  light_source = 7,
  sunlight_propagates = true,
  use_texture_alpha = true,
  drop = "",
  drowning = 1,
  liquidtype = "source",
  liquid_alternative_flowing = "beast_morphers:morphx_flowing",
  liquid_alternative_source = "beast_morphers:morphx_source",
  liquid_viscosity = 1,
  post_effect_color = {a = 103, r = 0, g = 255, b = 0},
  groups = {liquid = 3},
  sounds = default.node_sound_water_defaults(),
  grid_doc = {
	description = "Morph-X is Morphing Grid Energy that is converted into liguid."
  },
  
  on_punch = function(pos, node, player, pointed_thing)
    local wielded_item = player:get_wielded_item()
    if wielded_item:get_name() == "beast_morphers:morphx_drum" then
      local amount = tonumber(wielded_item:get_meta():get_string("morphx_amount")) or 0
      
      wielded_item:get_meta():set_string("description", "Morph-X Drum. Contains 200 litres of Morph-X.")
      wielded_item:get_meta():set_string("morphx_amount", "200")
      player:get_inventory():set_stack(player:get_wield_list(), player:get_wield_index(), wielded_item)
      
      if wielded_item:get_meta():get_string("morphx_amount") == "" then
        minetest.remove_node(pos)
      else 
        if amount < 100 then
          minetest.remove_node(pos)
        end
      end
    end
  end,
  
  mesecons = {receptor = {
          state = mesecon.state.on,
          rules = mesecon.rules.default
  }}
})

morphinggrid.register_griditem("beast_morphers:morphx_flowing", {
  type = "node",
  description = "Flowing Morph-X",
  drawtype = "flowingliquid",
  waving = 3,
  tiles = {"beast_morphers_morphx_1.png"},
  special_tiles = {
    {
      name = "beast_morphers_morphx_2.png",
      backface_culling = false,
      animation = {
        type = "vertical_frames",
        aspect_w = 16,
        aspect_h = 16,
        length = 0.8,
      },
    },
    {
      name = "beast_morphers_morphx_2.png",
      backface_culling = true,
      animation = {
        type = "vertical_frames",
        aspect_w = 16,
        aspect_h = 16,
        length = 0.8,
      },
    },
  },
  paramtype = "light",
  paramtype2 = "flowingliquid",
  walkable = false,
  pointable = true,
  diggable = false,
  buildable_to = true,
  is_ground_content = false,
  light_source = 7,
  sunlight_propagates = true,
  use_texture_alpha = true,
  drop = "",
  drowning = 1,
  liquidtype = "flowing",
  liquid_alternative_flowing = "beast_morphers:morphx_flowing",
  liquid_alternative_source = "beast_morphers:morphx_source",
  liquid_viscosity = 1,
  post_effect_color = {a = 103, r = 0, g = 255, b = 0},
  groups = {liquid = 3, not_in_creative_inventory = 1},
  sounds = default.node_sound_water_defaults(),
  grid_doc = {
	hidden = true
  },
  
  on_punch = function(pos, node, player, pointed_thing)
    local wielded_item = player:get_wielded_item()
    if wielded_item:get_name() == "beast_morphers:morphx_drum" then
      local amount = tonumber(wielded_item:get_meta():get_string("morphx_amount")) or 0
      
      wielded_item:get_meta():set_string("description", "Morph-X Drum. Contains 200 litres of Morph-X.")
      wielded_item:get_meta():set_string("morphx_amount", "200")
      player:get_inventory():set_stack(player:get_wield_list(), player:get_wield_index(), wielded_item)
      
      if wielded_item:get_meta():get_string("morphx_amount") == "" then
        minetest.remove_node(pos)
      else 
        if amount < 100 then
          minetest.remove_node(pos)
        end
      end
    end
  end,
  
  mesecons = {receptor = {
          state = mesecon.state.on,
          rules = mesecon.rules.default
  }}
})

morphinggrid.register_griditem("beast_morphers:morphx_drum", {
  type = "node",
  description = "Morph-X Drum",
  tiles = {
    "beast_morphers_morphx_drum_top.png",
    "beast_morphers_morphx_drum_bottom.png",
    "beast_morphers_morphx_drum_side.png",
    "beast_morphers_morphx_drum_side.png",
    "beast_morphers_morphx_drum_side.png",
    "beast_morphers_morphx_drum_side.png"
  },
  drawtype = "nodebox",
  paramtype = "light",
  paramtype2 = "facedir",
  node_box = {
    type = "fixed",
    fixed = {
      {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
      {-0.3125, -0.5, -0.125, 0.3125, 0.5, 0.125},
      {-0.125, -0.5, -0.3125, 0.125, 0.5, 0.3125},
    }
  },
  groups = { cracky = 1 },
  drop = {},
  grid_doc = {
	description = "Contains Morph-X. Can be refilled by wielding and clicking a Morph-X source node."
  },
  
  after_place_node = function(pos, placer, itemstack)
    local meta = minetest.get_meta(pos)
    local amount = itemstack:get_meta():get_string("morphx_amount")
    if amount == nil or amount == "" then amount = "0" end
    meta:set_string("morphx_amount", amount)
    meta:set_string("infotext", "Morph-X Drum. Contains "..amount.." litres of Morph-X.")
  end,
  
  on_punch = function(pos, node, player, pointed_thing)
    local wielded_item = player:get_wielded_item()
    for i, v in ipairs({"red", "yellow", "blue", "silver", "gold"}) do
      if wielded_item:get_name() == "beast_morphers:morpher_key_"..v then
        local meta = minetest.get_meta(pos)
        local amount = tonumber(meta:get_string("morphx_amount"))
        if amount > 0 then
          amount = amount - 0.25
          meta:set_string("morphx_amount", amount)
          meta:set_string("infotext", "Morph-X Drum. Contains "..amount.." litres of Morph-X.")
          wielded_item:set_wear(0)
          player:get_inventory():set_stack(player:get_wield_list(), player:get_wield_index(), wielded_item)
        else
          minetest.chat_send_player(player:get_player_name(), "Drum is empty.")
        end
      end
    end
    
    if wielded_item:get_name() == "beast_morphers:test_tube_empty" then
      local meta = minetest.get_meta(pos)
      local amount = tonumber(meta:get_string("morphx_amount"))
      local wield_count = wielded_item:get_count()
      if amount >= (wield_count * 0.125) then
        amount = amount - (wield_count * 0.125)
        meta:set_string("morphx_amount", amount)
        meta:set_string("infotext", "Morph-X Drum. Contains "..amount.."litres of Morph-X.")
        player:get_inventory():set_stack(player:get_wield_list(), player:get_wield_index(), ItemStack("beast_morphers:test_tube_morphx "..wield_count))
      else
        minetest.chat_send_player(player:get_player_name(), "There is not enough Morph-X to fill that many test tubes.")
      end
    elseif wielded_item:get_name() == "beast_morphers:flask_empty" then
      local meta = minetest.get_meta(pos)
      local amount = tonumber(meta:get_string("morphx_amount"))
      local wield_count = wielded_item:get_count()
      if amount >= (wield_count * 0.25) then
        amount = amount - (wield_count * 0.25)
        meta:set_string("morphx_amount", amount)
        meta:set_string("infotext", "Morph-X Drum. Contains "..amount.."litres of Morph-X.")
        player:get_inventory():set_stack(player:get_wield_list(), player:get_wield_index(), ItemStack("beast_morphers:flask_morphx "..wield_count))
      else
        minetest.chat_send_player(player:get_player_name(), "There is not enough Morph-X to fill that many flasks.")
      end
    end
    
    local meta = minetest.get_meta(pos)
    local amount = tonumber(meta:get_string("morphx_amount"))
    player:get_meta():set_string("last_punched_morphx_drum_amount", amount)
  end,
  
  on_dig = function(pos, node, player)
    local new_itemstack = ItemStack("beast_morphers:morphx_drum")
    local drum_amount = player:get_meta():get_string("last_punched_morphx_drum_amount")
    new_itemstack:get_meta():set_string("description", "Morph-X Drum. Contains "..drum_amount.." litres of Morph-X.")
    new_itemstack:get_meta():set_string("morphx_amount", drum_amount)
    minetest.item_drop(new_itemstack, player, pos)
    minetest.remove_node(pos)
  end
})