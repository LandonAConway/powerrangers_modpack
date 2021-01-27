function communicator.register_channel(name, def)
  if name == nil or name == "" then
    error("'name' cannot be nil or empty.")
  end
  
  def.name = name
  def.description = def.description or ""
  def.private_call_sign = def.private_call_sign or ""
  def.public_call_sign = def.public_call_sign or ""
  
  communicator.registered_channels[name] = def
end