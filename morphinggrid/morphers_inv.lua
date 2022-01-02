morphinggrid.morphers = {}

function morphinggrid.morphers.ui(player_name)
  local formspec = "size[14,12]"..
    "label[4,0;Place a morpher in the single morpher slot and use the chat command '/morph']"..
    "list[detached:morphers_"..player_name..";single;6.25,0.5;1,1;]"..
    "list[detached:morphers_"..player_name..";main;0,2;14,4;]"..
    "list[current_player;main;3,7.5;8,4;]"
  return formspec
end

--create morphers inventory
minetest.register_on_joinplayer(function(player)
  local inv = player:get_inventory()
  inv:set_size("morphers", 4*14)
  inv:set_size("morphers_main", 1*1)
  
  local player_name = player:get_player_name()
  minetest.create_detached_inventory("morphers_"..player_name, {
	on_move = function(_, _, _, _, _, _, player)
		morphinggrid.morphers.save_inventory(player)
	end,
	
	on_put = function(_, _, _, _, player)
		morphinggrid.morphers.save_inventory(player)
	end,
	
	on_take = function(_, _, _, _, player)
		morphinggrid.morphers.save_inventory(player)
	end,
	
	allow_put = function(_, _, _, stack, _)
		local itemstring = stack:get_name()
		if morphinggrid.registered_griditems[itemstring] or
		   morphinggrid.registered_morphers[itemstring] then
			return stack:get_count()
		end
		return 0
	end
  })
  
  local _inv = morphinggrid.morphers.get_inventory(player)
  _inv:set_size("main", 4*14)
  _inv:set_size("single", 1*1)
  
  morphinggrid.morphers.restore_inventory(player)
end)

minetest.register_chatcommand("morphers", {
  params = "",
  description = "Shows a player's morpher inventory.",
    
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name)
    minetest.show_formspec(name, name.."_morphers", morphinggrid.morphers.ui(name))
  end
})

function morphinggrid.morphers.get_inventory(player)
	return minetest.get_inventory({ type="detached", name="morphers_"..player:get_player_name() })
end

function morphinggrid.morphers.save_inventory(player)
	local inv = player:get_inventory()
	local _inv = morphinggrid.morphers.get_inventory(player)
	
	for i, v in ipairs(_inv:get_list("main")) do
		inv:set_stack("morphers", i, v)
	end
	
	local stack = _inv:get_stack("single", 1)
	inv:set_stack("morphers_main", 1, stack)
end

function morphinggrid.morphers.restore_inventory(player)
	local inv = player:get_inventory()
	local _inv = morphinggrid.morphers.get_inventory(player)
	
	for i, v in ipairs(inv:get_list("morphers")) do
		_inv:set_stack("main", i, v)
	end
	
	local stack = inv:get_stack("morphers_main", 1)
	_inv:set_stack("single", 1, stack)
end

--minetest.create_detatched_inventory("name")
	--allow_move //inv, from_list, from_index, to_list, to_index, count, player
	--allow_put //inv, listname, index, stack, player
	--allow_take //inv, listname, index, stack, player
	--on_put //inv, listname, index, stack, player
--end