morphinggrid.morpher_slots = {}
morphinggrid.morpher_slots.formspecdata = {}

local function get_morpher(player)
	local inv = player:get_inventory()
	local _inv = morphinggrid.morphers.get_inventory(player)
	if player:get_wielded_item():get_name() ~= "" then
		return player:get_wielded_item()
    else
		return _inv:get_stack("single", 1)
	end
end

local function set_morpher(player, itemstack)
	local inv = player:get_inventory()
	local _inv = morphinggrid.morphers.get_inventory(player)
	if morphinggrid.registered_morphers[player:get_wielded_item():get_name()] then
		player:set_wielded_item(itemstack)
    else
		_inv:set_stack("single", 1, itemstack)
	end
end

minetest.register_on_joinplayer(function(player)
	minetest.create_detached_inventory(player:get_player_name().."_morpher_slots", {
		allow_put = function(inv, listname, index, stack, _player)
			local plrfs = morphinggrid.morpher_slots.formspecdata[_player:get_player_name()]
			local slotsdef = morphinggrid.registered_morphers[plrfs.morpher].morpher_slots
			
			local allow_put = slotsdef.allow_put or function() return stack:get_count() end
			return allow_put(get_morpher(_player), stack)
		end, 
		
		on_put = function(inv, listname, index, stack, _player)
			morphinggrid.morpher_slots.do_work(_player)
		end,
		
		on_take = function(inv, listname, index, stack, _player)
			morphinggrid.morpher_slots.do_work(_player)
		end
	})
	
	local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."_morpher_slots"})
	for k, v in pairs(morphinggrid.registered_morphers) do
		local slotsdef = v.morpher_slots
		if type(slotsdef) == "table" then
			inv:set_size(k, slotsdef.amount)
		end
	end
	
	morphinggrid.morpher_slots.formspecdata[player:get_player_name()] = {}
end)

function morphinggrid.morpher_slots.formspec(player, morpher)
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	
	local plrfs = morphinggrid.morpher_slots.formspecdata[player:get_player_name()]
	local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."_morpher_slots"})
	local morpherdef = morphinggrid.registered_morphers[morpher]
	local slotsdef = morpherdef.morpher_slots
	local desc = morpherdef.description or morpherdef.name
	plrfs["morpher"] = morpher
	
	--set morpher inventory before showing it.
	local result, input = slotsdef.load_input(get_morpher(player))
	if result then
		for i, v in ipairs(input) do
			inv:add_item(morpher, v)
		end
	end
	
	local formspec = "formspec_version[4]"..
	"size[10.5,12]"..
	"list[current_player;main;0.4,5.9;8,4;0]"..
	"button_exit[7.3,11;3,0.8;exit;Exit]"..
	"label[0.2,0.4;Slots for "..desc..":]"..
	"list[detached:"..player:get_player_name().."_morpher_slots;"..morpher..";0.4,0.7;"..slotsdef.amount..",1;0]"
	
	return formspec
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "morphinggrid:morpher_slots" then
		local plrfs = morphinggrid.morpher_slots.formspecdata[player:get_player_name()]
		local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."_morpher_slots"})
		local slotsdef = morphinggrid.registered_morphers[plrfs.morpher].morpher_slots
		
		local pinv = player:get_inventory()
		for i, v in ipairs(inv:get_list(plrfs.morpher)) do
			inv:remove_item(plrfs.morpher, v)
		end
	end
end)

function morphinggrid.morpher_slots.do_work(player)
	local plrfs = morphinggrid.morpher_slots.formspecdata[player:get_player_name()]
	local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."_morpher_slots"})
	local slotsdef = morphinggrid.registered_morphers[plrfs.morpher].morpher_slots
		
	local wmorpher = get_morpher(player)
	local result, itemstack = slotsdef.output(wmorpher, inv:get_list(plrfs.morpher))
	if result then
		set_morpher(player, itemstack)
		
		for i, v in ipairs(inv:get_list(plrfs.morpher)) do
			inv:remove_item(plrfs.morpher, v)
		end
		
		minetest.show_formspec(player:get_player_name(), "morphinggrid:morpher_slots",
							morphinggrid.morpher_slots.formspec(player, itemstack:get_name()))
	end
end