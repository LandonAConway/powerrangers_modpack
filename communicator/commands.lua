morphinggrid.register_grid_function_type("before_communicator_command", "before-commuicator-command", {
	params = {
		{"player", "<Player>", "A reference to the player who has executed the command."},
		{"pos", "<table>", "The position of the player who has executed the command."},
		{"command", "<string>", "The command that was typed."},
		{"text", "<string>", "The text followed by the command."},
		{"itemstack", "<ItemStack>", "A reference to the ItemStack of the communicator involved."}
	},
	
	args = {
		{"cancel", "<boolean>", "If true, the command's function will not be executed."},
		{"reason", "<string>", "A reason for cancelation."},
		{"description", "<string>", "A description for cancelation."}
	}
})
morphinggrid.register_grid_function_type("after_communicator_command", "after-communicator-command", {
	params = {
		{"player", "<Player>", "A reference to the player who has executed the command."},
		{"pos", "<table>", "The position of the player who has executed the command."},
		{"command", "<string>", "The command that was typed."},
		{"text", "<string>", "The text followed by the command."},
		{"itemstack", "<ItemStack>", "A reference to the ItemStack of the communicator involved."},
		{"canceled", "<boolean>", "Returns true if the command was canceled."}
	},
	
	args = {
		
	}
})

minetest.register_chatcommand("communicator", {
  params = "<command>",
  description = "Execute a communicator command.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name,text)
    local player = minetest.get_player_by_name(name)
    local inv = communicator.get_inventory(player)
    if not inv:is_empty("single") then
      local stack = inv:get_stack("single", 1)
      local stackname = stack:get_name()
      if communicator.registered_communicators[stackname] ~= nil then
        if text ~= nil and text ~= "" then
          local result,message,itemstack = communicator.execute_communicator_cmd(name,text,stack)
          inv:set_stack("single", 1, itemstack)
          communicator.save_inventory(minetest.get_player_by_name(name))
          return result,message
        end
        return false, "Please enter a command."
      end
      return false, "The item placed in the single communicator slot is not a communicator. Use the chat command '/communicators'"
    end
    return false, "There is no communicator placed in the single communicator slot. Use the chat command '/communicators'"
  end
})

local function before_cmd_executed(cmc,name,text,itemstack)
  if cmc.before_cmd_executed ~= nil then
    return cmc.before_cmd_executed(name,text,itemstack)
  end
  return true, nil, itemstack
end

local function after_cmd_executed(cmc,name,text,itemstack)
  if cmc.after_cmd_executed ~=nil then
    cmc.after_cmd_executed(name,text,itemstack)
  end
end

function communicator.execute_communicator_cmd(name,text,itemstack)
  local stack_name = itemstack:get_name()
  local params = morphinggrid.split_string(text," ")
  local communicatordef = communicator.registered_communicators[stack_name]
  
  local count = string.len(params[1])+1
  local subtext = string.sub(text,count+1)
  
  --execute before-commuicator-command functions.
  local cc_params = {
	player = minetest.get_player_by_name(name),
	pos = minetest.get_player_by_name(name):get_pos(),
	command = params[1],
	text = subtext,
	itemstack = itemstack
  }
  
  local cc_args = morphinggrid.call_grid_functions("before_communicator_command", cc_params)
  
  if cc_args.cancel then
    cc_params.canceled = true
    return false, cc_args.description or "Communicator failed to execute command.", itemstack
  elseif communicatordef.communicator_commands[params[1]] ~= nil then
    local result,message,newitemstack = before_cmd_executed(communicatordef,name,subtext,itemstack)
    if result then
      result,message,newitemstack = communicatordef.communicator_commands[params[1]].func(name,subtext,itemstack)
    end
  if result == nil then result = true end
    message = message or ""
    itemstack = newitemstack or itemstack
    after_cmd_executed(communicatordef,name,subtext,itemstack)
    return result,message,itemstack
  end
  
  return false, "The command '"..params[1].."' does not exist.", itemstack
end