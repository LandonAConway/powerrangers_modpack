morphinggrid.morphing_log = {}

morphinggrid.registered_after_morphs = {}
morphinggrid.registered_after_demorphs = {}

morphinggrid.register_after_morph = function(fn)
    table.insert(morphinggrid.registered_after_morphs, fn)
end

morphinggrid.register_after_demorph = function(fn)
    table.insert(morphinggrid.registered_after_demorphs, fn)
end

-- morph functions
dofile(minetest.get_modpath("morphinggrid") .. "/grid_functions.lua")

local check_privs = function(player, ranger)
    if type(ranger) == "string" then
        ranger = morphinggrid.registered_rangers[ranger]
    end

    local privs_to_check = {
        power_rangers = true
    }
    for _, p in pairs(ranger.privs or {}) do
        privs_to_check[p] = true
    end

    local missing_privs = {}
    for p, v in pairs(privs_to_check) do
        if not minetest.check_player_privs(player:get_player_name(), {
            p = v
        }) then
            table.insert(missing_privs, p)
        end
    end

    return minetest.check_player_privs(player:get_player_name(), privs_to_check), missing_privs
end

function morphinggrid.morph(player, ranger, morph_settings)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end

    if type(ranger) == "string" then
        local ranger_name = ranger
        ranger = morphinggrid.registered_rangers[ranger_name]
        if ranger == nil then
            error("'" .. ranger_name .. "' is not a registered ranger.")
        end
    end

    morph_settings = morphinggrid.configure_morph_settings(morph_settings)
    local morph_info = {}

    local player_name = player:get_player_name()
    local can_use, _ = check_privs(player, ranger)

    local rangername_split = morphinggrid.split_string(ranger.name, ":")
    local rangertype = morphinggrid.get_rangertype(rangername_split[1])

    -- morph info
    morph_info.type = "morph"
    morph_info.itemstack = morph_settings.itemstack
    morph_info.player = player
    morph_info.ranger = ranger
    morph_info.pos = player:get_pos()
    morph_info.reason = "unknown"
    morph_info.timestamp = os.date('%Y-%m-%d %H:%M:%S')

    local result = false

    if morph_settings.priv_bypass then
        can_use = true
    end

    -- do morph functions first.
    local morph_params = {
        player = morph_info.player,
        ranger = morph_info.ranger.name,
        morph_settings = morph_settings,
        pos = morph_info.pos,
        timestamp = morph_info.timestamp,
        itemstack = morph_info.itemstack
    }

    local mfunc_args = morphinggrid.call_grid_functions("before_morph", morph_params)

    -- create rangerdata (get_rangerdata is used to do this)
    -- rangerdata is used to store important data about the ranger and is
    -- not associated with the craftitems that are referred to as rangerdata
    morphinggrid.get_rangerdata(player, ranger.name)

    -- check for privs again if mfunc_args.recheck_privs is true. This doesn't override can_use if morph_settings.priv_bypass is true.
    -- if mfunc_args.force_recheck_privs is true, then override can_use regardless.
    if mfunc_args.recheck_privs == true then
        if not morph_settings.priv_bypass then
            can_use, _ = check_privs(player, ranger)
        end
    elseif mfunc_args.force_recheck_privs == true then
        can_use, _ = check_privs(player, ranger)
    end

    -- override morph_settings if it is not nil
    if type(mfunc_args.morph_settings) == "table" then
        morph_settings = morphinggrid.configure_morph_settings(mfunc_args.morph_settings)
    end

    -- continue to morph player if the player has the correct privs, or the need for privs has been overrided
    if can_use == true then
        --only morph if it was not canceled by the grid functions
        if not mfunc_args.cancel then
            local rangerdata = morphinggrid.get_rangerdata(player, ranger.name)
            if not rangerdata:has_energy() then
                morph_info.reason = "not_stable"
                if morph_settings.chat_messages then
                    minetest.chat_send_player(player_name,
                        "You cannot morph because these ranger powers are not currently stable." ..
                            " Please wait some time while the Morphing Grid re-stabelizes these ranger powers.")
                end
                minetest.log("action", "Player (" .. player:get_player_name() .. ") Morphed: " .. ranger.name .. ", " ..
                    (morph_info.reason or ""))
                return false, morph_info
            end

            morphinggrid.demorph(player, {}, true)

            morphinggrid.set_ranger_meta(player, ranger)
            morphinggrid.set_ranger_abilities(player, ranger.name)
            morphinggrid.update_player_visuals(player)

            -- overriding hide_identity
            local hide_identity = ranger.hide_identity
            if type(morph_settings.hide_identity) == "boolean" then
                hide_identity = morph_settings.hide_identity
            end

            if hide_identity then
                player:set_nametag_attributes({
                    text = ranger.description
                })
            end

            if morph_settings.show_hud then
                morphinggrid.show_hud(player, ranger)
            end

            if morph_settings.chat_messages then
                minetest.chat_send_player(player_name, "Morph successful (Ranger: " .. ranger.description .. ")")
            end
            morph_info.reason = "successful"
            result = true
        else
            morph_params.canceled = true
            if morph_settings.chat_messages then
                minetest.chat_send_player(player_name,
                    mfunc_args.description or "Morph unsuccessful." .. " (Ranger: " .. ranger.description .. ")")
            end
            morph_info.reason = mfunc_args.reason or "canceled"
            result = true
        end
    else
        local _, missing_privs = check_privs(player, ranger)
        morph_info.reason = mfunc_args.reason or "no_permission"
        morph_settings.log_this = false
        if morph_settings.chat_messages then
            minetest.chat_send_player(player_name,
                mfunc_args.description or "You don't have permisson to morph (Missing Privileges: " ..
                    table.concat(missing_privs, ", ") .. " )")
        end
    end

    -- call after-morph functions
    morph_params.reason = morph_info.reason
    morph_params.canceled = mfunc_args.canceled
    morphinggrid.call_grid_functions("after_morph", morph_params)

    for k, v in pairs(morphinggrid.registered_after_morphs) do
        morphinggrid.registered_after_morphs[v](player, ranger.name, morph_info)
    end

    for i, v in ipairs(morphinggrid.registered_ranger_after_morphs) do
        if v == ranger.name then
            local rd = morphinggrid.get_ranger(v)
            rd.after_morph(player, morph_info)
        end
    end

    -- Log into morphing log
    if morph_settings.log_this then
        table.insert(morphinggrid.morphing_log, morph_info)
    end

    -- get morpher name
    local morpher_name = "unknown"
    if morph_info.itemstack ~= nil then
        morpher_name = morph_info.itemstack:get_name()
    end

    minetest.log("action",
        "Player (" .. player:get_player_name() .. ") Morphed; Ranger: " .. ranger.name .. ", " .. "Morpher: " .. morpher_name ..
            ", " .. (morph_info.reason or ""))

    return result, morph_info
end

function morphinggrid.demorph(player, demorph_settings, is_morphing)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end

    demorph_settings = morphinggrid.configure_demorph_settings(demorph_settings)
    local demorph_info = {}

    local player_name = player:get_player_name()
    local can_use = minetest.check_player_privs(player_name, {
        power_rangers = true
    })

    local result = false

    if is_morphing == nil then
        is_morphing = false
    end

    local meta = player:get_meta()
    local ranger = morphinggrid.get_ranger(meta:get_string("player_morph_status"))

    -- demorph info
    demorph_info.type = "demorph"
    demorph_info.player = player
    demorph_info.ranger = ranger
    demorph_info.pos = player:get_pos()
    demorph_info.reason = "unknown"
    demorph_info.timestamp = os.date('%Y-%m-%d %H:%M:%S')

    if demorph_settings.priv_bypass then
        can_use = true
    end

    -- do demorph functions first.
    local getranger = ranger or {}
    local demorph_params = {
        player = demorph_info.player,
        ranger = getranger.name,
        demorph_settings = demorph_settings,
        pos = demorph_info.pos,
        timestamp = demorph_info.timestamp
    }

    if ranger == nil then
        demorph_params.morphed = false
    else
        demorph_params.morphed = true
    end

    local dmfunc_args = {}
    if is_morphing == false then
        dmfunc_args = morphinggrid.call_grid_functions("before_demorph", demorph_params)
    end

    -- check for privs again if dmfunc_args.recheck_privs is true. This doesn't override can_use if demorph_settings.priv_bypass is true.
    -- if dmfunc_args.force_recheck_privs is true, then override can_use regardless.
    if dmfunc_args.recheck_privs == true then
        if not demorph_settings.priv_bypass then
            can_use = minetest.check_player_privs(player_name, {
                power_rangers = true
            })
        end
    elseif dmfunc_args.force_recheck_privs == true then
        can_use = minetest.check_player_privs(player_name, {
            power_rangers = true
        })
    end

    -- override demorph_settings if it is not nil
    if type(dmfunc_args.demorph_settings) == "table" then
        demorph_settings = morphinggrid.configure_demorph_settings(dmfunc_args.demorph_settings)
    end

    if can_use == true then
        if is_morphing == true then --if this function was called from `morphinggrid.morph`
            morphinggrid.powerdown(player, {chat_messages=false})
            -- only remove the hud if the player is already morphed
            if demorph_settings.hide_hud and morphinggrid.get_morph_status(player) ~= nil then
                morphinggrid.hide_hud(player)
            end

            morphinggrid.update_player_visuals(player)

            player:set_nametag_attributes({
                text = ""
            })

            if ranger ~= nil then
                local rangertypedef = morphinggrid.get_rangertype(string.split(ranger.name, ":")[1])
                morphinggrid.remove_ranger_abilities(player)
                morphinggrid.remove_weapons(player, rangertypedef.weapons)
            end

            demorph_info.reason = "successful_durring_morph"
            demorph_settings.log_this = false
            result = true
        else -- not morphing
            if not dmfunc_args.cancel then
                morphinggrid.powerdown(player, {chat_messages=false})
                if ranger == nil then
                    demorph_info.reason = "not_morphed"
                    demorph_settings.log_this = false
                    morphinggrid.call_grid_functions("on_demorph_attempt", demorph_params)
                    if demorph_settings.chat_messages then
                        minetest.chat_send_player(player_name, "You are not morphed.")
                    end
                else
                    local rangername_split = morphinggrid.split_string(ranger.name, ":")
                    local rangertype = morphinggrid.get_rangertype(rangername_split[1])

                    morphinggrid.remove_ranger_abilities(player)
                    morphinggrid.remove_weapons(player, rangertype.weapons)

                    if demorph_settings.hide_hud then
                        morphinggrid.hide_hud(player)
                    end

                    player:set_nametag_attributes({
                        text = ""
                    })

                    meta:set_string("player_morph_status", "none")

                    morphinggrid.update_player_visuals(player)

                    if demorph_settings.chat_messages then
                        minetest.chat_send_player(player_name,
                            "Demorph successful. (Ranger: " .. ranger.description .. ")")
                    end

                    demorph_info.reason = "successful"
                    result = true
                end
            else
                demorph_params.canceled = true
                demorph_info.reason = dmfunc_args.reason or "canceled"
                demorph_settings.log_this = false
                if demorph_settings.chat_messages then
                    minetest.chat_send_player(player_name, dmfunc_args.description or "Demorph unsuccessful." ..
                        " (Ranger: " .. ranger.description .. ")")
                end
            end
        end
    else
        local _, missing_privs = check_privs(player, ranger)
        demorph_info.reason = mfunc_args.reason or "no_permission"
        demorph_settings.log_this = false
        if demorph_settings.chat_messages then
            minetest.chat_send_player(player_name,
                dmfunc_args.description or "You don't have permisson to demorph (Missing Privileges: " ..
                    table.concat(missing_privs, ", ") .. " )")
        end
    end

    local rangername = ""
    if ranger == nil then
        rangername = "none"
    else
        rangername = ranger.name
    end

    if not demorph_settings.voluntary then
        demorph_info.reason = "not_stable"
    end

    -- call after-demorph functions
    if not is_morphing then
        demorph_params.reason = demorph_info.reason
        demorph_params.canceled = dmfunc_args.canceled
        morphinggrid.call_grid_functions("after_demorph", demorph_params)
    end

    for i, v in ipairs(morphinggrid.registered_after_demorphs) do
        morphinggrid.registered_after_demorphs[i](player, rangername, demorph_info)
    end

    for i, v in ipairs(morphinggrid.registered_ranger_after_demorphs) do
        if v == rangername then
            local rd = morphinggrid.get_ranger(v)
            rd.after_demorph(player, demorph_info)
        end
    end

    -- Log
    if demorph_settings.log_this then
        table.insert(morphinggrid.morphing_log, demorph_info)
    end

    if ranger ~= nil then
        minetest.log("action", "Player (" .. player:get_player_name() .. ") Demorphed; Ranger:" .. ranger.name .. ", " ..
            (demorph_info.reason or ""))
    end

    return result, demorph_info
end

function morphinggrid.configure_morph_settings(morph_settings)
    morph_settings = morph_settings or {}

    if morph_settings.hide_player == nil then
        morph_settings.hide_player = false
    end
    if morph_settings.priv_bypass == nil then
        morph_settings.priv_bypass = false
    end
    if morph_settings.chat_messages == nil then
        morph_settings.chat_messages = true
    end
    if morph_settings.log_this == nil then
        morph_settings.log_this = true
    end
    if morph_settings.show_hud == nil then
        morph_settings.show_hud = true
    end

    morph_settings.armor_parts = morph_settings.armor_parts or {}

    if morph_settings.armor_parts.helmet == nil then
        morph_settings.armor_parts.helmet = true
    end
    if morph_settings.armor_parts.chestplate == nil then
        morph_settings.armor_parts.chestplate = true
    end
    if morph_settings.armor_parts.leggings == nil then
        morph_settings.armor_parts.leggings = true
    end
    if morph_settings.armor_parts.boots == nil then
        morph_settings.armor_parts.boots = true
    end

    return morph_settings
end

function morphinggrid.configure_demorph_settings(demorph_settings)
    demorph_settings = demorph_settings or {}
    if demorph_settings.priv_bypass == nil then
        demorph_settings.priv_bypass = false
    end
    if demorph_settings.chat_messages == nil then
        demorph_settings.chat_messages = true
    end
    if demorph_settings.log_this == nil then
        demorph_settings.log_this = true
    end
    if demorph_settings.voluntary == nil then
        demorph_settings.voluntary = true
    end
    if demorph_settings.hide_hud == nil then
        demorph_settings.hide_hud = true
    end
    return demorph_settings
end

morphinggrid.huds = {}

-- {
--        hud_elem_type = "image",  -- See HUD element types
--        -- Type of element, can be "image", "text", "statbar", or "inventory"
--
--        position = {x=0.5, y=0.5},
--        -- Left corner position of element
--
--        name = "<name>",
--
--        scale = {x = 2, y = 2},
--
--        text = "<text>",
--
--        number = 2,
--
--        item = 3,
--        -- Selected item in inventory. 0 for no item selected.
--
--        direction = 0,
--        -- Direction: 0: left-right, 1: right-left, 2: top-bottom, 3: bottom-top
--
--        alignment = {x=0, y=0},
--
--        offset = {x=0, y=0},
--
--        size = { x=100, y=100 },
--        -- Size of element in pixels
--
--        z_index = 0,
--        -- Z index : lower z-index HUDs are displayed behind higher z-index HUDs
--    }

local hudbars_loaded = function()
    if minetest.get_modpath("hudbars") then
        return true
    end
    return false
end

minetest.register_on_joinplayer(function(player)
    local ranger = morphinggrid.get_morph_status(player)
    if ranger then
        morphinggrid.show_hud(player, ranger)
    end
end)

minetest.register_on_leaveplayer(function(player)
    local ranger = morphinggrid.get_morph_status(player)
    if ranger then
        morphinggrid.hide_hud(player)
    end
end)

function morphinggrid.show_hud(player, ranger)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end

    if type(ranger) == "string" then
        ranger = morphinggrid.registered_rangers[ranger]
    end

    local rangerdata = morphinggrid.get_current_rangerdata(player)
    local energy_level = rangerdata:get_energy_level_percentage()

    -- this will be used if [hudbars] is not installed
    local position = {
        x = 0.5,
        y = 0.7
    }
    local hud_standard = {
        title = {
            hud_elem_type = "text",
            position = position,
            offset = {
                x = 0,
                y = -32
            },
            text = "Morph Status:",
            number = "0xFFFFFF"
        },
        ranger = {
            hud_elem_type = "text",
            position = position,
            offset = {
                x = 0,
                y = 0
            },
            text = "Ranger: " .. ranger.description,
            number = "0xFFFFFF"
        },
        status = {
            hud_elem_type = "statbar",
            position = position,
            offset = {
                x = -160,
                y = 32
            },
            text = "morphinggrid_power_usage_32.png",
            number = energy_level * 20
        }
    }

    -- for [hudbars]
    local hb_position = {
        x = 0.5,
        y = 0.8
    }

    local bg_width = 324
    local helmet_bg_width = 20
    local margin = 8

    local helmet_offset_x = -((bg_width / 2) + (margin / 2))
    local main_offset_x = (margin / 2) + (helmet_bg_width / 2)
    local hud_hb = {
        helmet_bg = {
            hud_elem_type = "image",
            position = hb_position,
            scale = {
                x = 1,
                y = 1
            },
            text = "morphinggrid_ranger_helmet_hud_bar.png",
            alignment = {
                x = 1,
                y = 1
            },
            offset = {
                x = -8 + helmet_offset_x,
                y = -10
            }
        },
        bg = {
            hud_elem_type = "image",
            position = hb_position,
            scale = {
                x = 1,
                y = 1
            },
            text = "morphinggrid_ranger_hud_bar.png",
            alignment = {
                x = 1,
                y = 1
            },
            offset = {
                x = -162 + main_offset_x,
                y = -10
            }
        },
        helmet = {
            hud_elem_type = "image",
            position = hb_position,
            scale = {
                x = 1,
                y = 1
            },
            text = ranger.rtextures.helmet.inventory,
            alignment = {
                x = 1,
                y = 1
            },
            offset = {
                x = -8 + helmet_offset_x + 2,
                y = -8
            }
        },
        ranger = {
            hud_elem_type = "text",
            position = hb_position,
            offset = {
                x = main_offset_x,
                y = 0
            },
            text = "Ranger: " .. ranger.description,
            number = "0xFFFFFF"
        }
    }

    if not morphinggrid.huds[player:get_player_name()] then
        morphinggrid.huds[player:get_player_name()] = {}
        if morphinggrid.optional_dependencies["hudbars"] then
            morphinggrid.huds[player:get_player_name()].helmet_bg = player:hud_add(hud_hb.helmet_bg)
            morphinggrid.huds[player:get_player_name()].bg = player:hud_add(hud_hb.bg)
            morphinggrid.huds[player:get_player_name()].helmet = player:hud_add(hud_hb.helmet)
            morphinggrid.huds[player:get_player_name()].ranger = player:hud_add(hud_hb.ranger)
            hb.unhide_hudbar(player, "morphinggrid_power_usage")
            hb.change_hudbar(player, "morphinggrid_power_usage", energy_level * 100)
        else
            morphinggrid.huds[player:get_player_name()].title = player:hud_add(hud_standard.title)
            morphinggrid.huds[player:get_player_name()].ranger = player:hud_add(hud_standard.ranger)
            morphinggrid.huds[player:get_player_name()].status = player:hud_add(hud_standard.status)
        end
    end
end

function morphinggrid.hide_hud(player)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end

    local huds = morphinggrid.huds[player:get_player_name()]
    if huds then
        if morphinggrid.optional_dependencies["hudbars"] then
            player:hud_remove(huds.helmet_bg)
            player:hud_remove(huds.bg)
            player:hud_remove(huds.helmet)
            player:hud_remove(huds.ranger)
            hb.hide_hudbar(player, "morphinggrid_power_usage")
        else
            player:hud_remove(huds.title)
            player:hud_remove(huds.ranger)
            player:hud_remove(huds.status)
        end

        morphinggrid.huds[player:get_player_name()] = nil
    end
end

function morphinggrid.hud_update_power_usage(player)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end

    if morphinggrid.hud_is_visible(player) then
        local rangerdata = morphinggrid.get_current_rangerdata(player)
        local energy_level = rangerdata:get_energy_level_percentage()

        if morphinggrid.optional_dependencies["hudbars"] then
            hb.change_hudbar(player, "morphinggrid_power_usage", energy_level * 100)
        else
            player:hud_change(morphinggrid.huds[player:get_player_name()].status, "number",
                math.floor(energy_level * 20))
        end
    end
end

function morphinggrid.hud_is_visible(player)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end

    if morphinggrid.huds[player:get_player_name()] then
        return true
    end
    return false
end

function morphinggrid.set_ranger_meta(player, ranger)
    local meta = player:get_meta()
    local rangername_split = morphinggrid.split_string(ranger.name, ":")
    local rangertype = morphinggrid.get_rangertype(rangername_split[1])

    meta:set_string('player_morph_status', ranger.name)
    meta:set_string('player_last_morph_status', ranger.name)
end

function morphinggrid.set_ranger_abilities(player, ranger)
    -- wieldhand
    local inv = player:get_inventory()
    inv:set_size("hand", 1)
    inv:set_stack("hand", 1, ItemStack(morphinggrid.get_ranger_hand_itemstring(ranger)))
end

function morphinggrid.remove_ranger_abilities(player)
    -- wieldhand
    local inv = player:get_inventory()
    inv:set_stack("hand", 1, ItemStack(""))
    inv:set_size("hand", 0)
end

function morphinggrid.remove_weapons(player, weapons)
    local inv = player:get_inventory()
    for _, weapon in pairs(weapons) do
        local inv_list = inv:get_list("main")
        for _, stack in pairs(inv_list) do
            if stack:get_name() == weapon then
                inv:remove_item("main", stack)
            end
        end
    end
end

function morphinggrid.get_morph_status(player)
    if player == "string" then
        player = minetest.get_player_by_name(player)
    end
    local meta = player:get_meta()
    local status = meta:get_string('player_morph_status')
    if status ~= "none" and status ~= nil and status ~= "" then
        return status
    else
        return nil
    end
end

function morphinggrid.get_last_morph_status(player)
    local meta = player:get_meta()
    local status = meta:get_string('player_last_morph_status')
    if status ~= "none" and status ~= nil and status ~= "" then
        return status
    else
        return nil
    end
end

-- Morphing log
function morphinggrid.get_morphing_log()
    return morphinggrid.morphing_log
end

function morphinggrid.get_player_morphing_log(player)
    local t = {}
    for i, v in ipairs(morphinggrid.morphing_log) do
        if v.player:get_player_name() == player:get_player_name() then
            table.insert(t, v)
        end
    end
    return t
end
