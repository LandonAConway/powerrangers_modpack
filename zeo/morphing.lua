function zeo.morph(player, ranger, itemstack)
  local weapons = zeo.get_weapons()
  if zeo.player_has_item(player, "zeo:left_zeonizer") == true then
    if morphinggrid.morph(player, ranger, { morpher = "zeo:right_zeonizer_"..morphinggrid.split_string(ranger.name, ":")[2],
		itemstack = itemstack}) == true
    then
      local ranger_ = morphinggrid.split_string(ranger.name, ":")[2]
      local meta = player:get_meta()
      local rangercolor = zeo.getrangercolor(ranger_)
      meta:set_string("mmpr_last_morphed_color", rangercolor.."_Ranger")
    end
  else
    if ranger.name == "zeo:gold" then
      if morphinggrid.morph(player, ranger, {itemstack = itemstack}) then
        local ranger_ = morphinggrid.split_string(ranger.name, ":")[2]
        local meta = player:get_meta()
        local rangercolor = zeo.getrangercolor(ranger_)
        meta:set_string("mmpr_last_morphed_color", rangercolor.."_Ranger")
      end
    end
  end
end

function zeo.getrangercolor(text)
  local firstletter = string.sub(text, 1,1)
  local therest = string.sub(text, 2)
  return firstletter:upper()..therest
end

function zeo.is_morphed(player)
  local meta = player:get_meta()
  if zeo.get_morph_status(player) ~= "none" then
    return true
  end
  return false
end

function zeo.get_morph_status(player)
  local meta = player:get_meta()
  local morphstatus = meta:get_string('zeo_morph_status')
  if morphstatus ~= nil and morphstatus ~= "" then
    return morphstatus
  end
  return "none"
end

function zeo.get_weapons()
  return ''
end