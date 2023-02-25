-- local S = armor_i18n.gettext
function morphinggrid.get_ranger_hand_itemstring(ranger)
    local modname = string.split(ranger, ":")[1]
    local rangersubname = string.split(ranger, ":")[2]
    return modname..":ranger_hand_"..rangersubname
end

local register_ranger_hand = function(ranger, def)
    local builtin_hand = minetest.registered_items[""]
    def = def or {}
    def.wield_image = def.wield_image or "wieldhand.png"
    def.range = def.range or builtin_hand.range
    def.wield_scale = def.wield_scale or builtin_hand.wield_scale
    def.tool_capabilities = def.tool_capabilities or builtin_hand.tool_capabilities
    minetest.register_tool(morphinggrid.get_ranger_hand_itemstring(ranger), def)
end

local correct_rtextures = function(rdef)
    local name_ = morphinggrid.split_string(rdef.name, ":")

    -- rtextures and it's 'named' contents cannot be nil otherwise and exception will be thrown.
    rdef.rtextures = rdef.rtextures or {}
    rdef.rtextures.helmet = rdef.rtextures.helmet or {}
    rdef.rtextures.chestplate = rdef.rtextures.chestplate or {}
    rdef.rtextures.leggings = rdef.rtextures.leggings or {}
    rdef.rtextures.boots = rdef.rtextures.boots or {}

    -- auto-generate file names if not specified.
    rdef.rtextures = {
        helmet = {
            armor = rdef.rtextures.helmet.armor or name_[1] .. "_helmet_" .. name_[2] .. ".png",
            armor_visor_mask = rdef.rtextures.helmet.armor_visor_mask,
            preview = rdef.rtextures.helmet.preview or name_[1] .. "_helmet_" .. name_[2] .. "_preview.png",
            inventory = rdef.rtextures.helmet.inventory or name_[1] .. "_inv_helmet_" .. name_[2] .. ".png"
        },

        chestplate = {
            armor = rdef.rtextures.chestplate.armor or name_[1] .. "_chestplate_" .. name_[2] .. ".png",
            preview = rdef.rtextures.chestplate.preview or name_[1] .. "_chestplate_" .. name_[2] ..
                "_preview.png",
            inventory = rdef.rtextures.chestplate.inventory or name_[1] .. "_inv_chestplate_" .. name_[2] ..
                ".png"
        },

        leggings = {
            armor = rdef.rtextures.leggings.armor or name_[1] .. "_leggings_" .. name_[2] .. ".png",
            preview = rdef.rtextures.leggings.preview or name_[1] .. "_leggings_" .. name_[2] ..
                "_preview.png",
            inventory = rdef.rtextures.leggings.inventory or name_[1] .. "_inv_leggings_" .. name_[2] ..
                ".png"
        },

        boots = {
            armor = rdef.rtextures.boots.armor or name_[1] .. "_boots_" .. name_[2] .. ".png",
            preview = rdef.rtextures.boots.preview or name_[1] .. "_boots_" .. name_[2] .. "_preview.png",
            inventory = rdef.rtextures.boots.inventory or name_[1] .. "_inv_boots_" .. name_[2] .. ".png"
        }
    }

    return rdef.rtextures
end

morphinggrid.registered_rangertypes = {}
rangertype = {}

function morphinggrid.register_rangertype(name, rangertypedef)
    rangertypedef.name = name
    rangertypedef.weapons = rangertypedef.weapons or {}
    morphinggrid.registered_rangertypes[name] = rangertypedef
    -- table.insert(morphinggrid.registered_rangertypes, rangertypedef)
end

function morphinggrid.get_rangertype(name)
    for i, v in pairs(morphinggrid.registered_rangertypes) do
        if v.name == name then
            return v
        end
    end
    return nil
end

function morphinggrid.get_registered_rangertypes()
    return morphinggrid.registered_rangertypes
end

morphinggrid.registered_rangers = {}
morphinggrid.registered_morphers = {}
ranger = {}

morphinggrid.registered_ranger_after_morphs = {}
morphinggrid.registered_ranger_after_demorphs = {}

local function register_shortcommands(map)
    for name, def in pairs(map) do
        if type(def.short) == "string" then
            map["."..def.short] = def
        end
    end
end

function morphinggrid.register_ranger(name, rangerdef)
    local name_ = morphinggrid.split_string(name, ":")
    rangerdef.name = name

    -- make sure fields are not nil
    rangerdef.ranger_groups = rangerdef.ranger_groups or {}
    rangerdef.abilities = rangerdef.abilities or {}
    rangerdef.max_energy = rangerdef.max_energy or 2500
    rangerdef.energy_damage_per_hp = rangerdef.energy_damage_per_hp or 1
    rangerdef.energy_heal_per_globalstep = rangerdef.energy_heal_per_globalstep or 1
    rangerdef.energy_damage_per_globalstep = rangerdef.energy_damage_per_globalstep or 0

    if rangerdef.hide_identity == nil then
        rangerdef.hide_identity = true
    end
    if rangerdef.hide_player == nil then
        rangerdef.hide_player = false
    end
    if rangerdef.create_rangerdata == nil then
        rangerdef.create_rangerdata = true
    end

    -- textures
    rangerdef.rtextures = rangerdef.rtextures or rangerdef.armor_textures
    rangerdef.rtextures = correct_rtextures(rangerdef)

    --ranger hand
    register_ranger_hand(name, rangerdef.hand)

    -- Register Armor
    -- register_ranger_armor(rangerdef)

    -- ranger commands
    rangerdef.ranger_commands = rangerdef.ranger_commands or {}

    -- Add command presets
    rangerdef.ranger_command_presets = rangerdef.ranger_command_presets or {}
    for preset_name, add in pairs(rangerdef.ranger_command_presets) do
        if add then
            if not morphinggrid.ranger_cmd_presets[preset_name] then
                error("'" .. preset_name .. "' is not an existing preset.")
            end
            for command_name, def in pairs(morphinggrid.ranger_cmd_presets[preset_name]) do
                rangerdef.ranger_commands[command_name] = def
            end
        end
    end

    -- add help command
    rangerdef.ranger_commands.help = {
        short = "h",
        description = "Lists all commands for the ranger.",
        func = function(name)
            minetest.chat_send_player(name, "Commands for: " .. (rangerdef.description or name))
            for cmd, t in pairs(rangerdef.ranger_commands) do
                minetest.chat_send_player(name, cmd .. " " .. (t.params or "") .. " | " .. (t.description or name))
            end
        end
    }

    register_shortcommands(rangerdef.ranger_commands)

    if rangerdef.morpher ~= nil then
        local morpherdef = rangerdef.morpher

        -- Morpher
        morpherdef.ranger = rangerdef.name
        morpherdef.type = morpherdef.type or "craftitem"
        morphinggrid.register_morpher(morpherdef.name, morpherdef)

        -- Register morpher craft
        if morpherdef.recipe ~= nil then
            local recipe = morpherdef.recipe
            recipe.output = morpherdef.name
            minetest.register_craft(morpherdef.recipe)
        end
    end

    -- register after morph callback
    if rangerdef.after_morph ~= nil then
        table.insert(morphinggrid.registered_ranger_after_morphs, name)
    end

    if rangerdef.after_demorph ~= nil then
        table.insert(morphinggrid.registered_ranger_after_demorphs, name)
    end

    -- Add to table
    morphinggrid.registered_rangers[rangerdef.name] = rangerdef
    -- table.insert(morphinggrid.registered_rangers, rangerdef)

    -- register rangerdata
    morphinggrid.register_griditem(name .. "_rangerdata", {
        inventory_image = "rangerdata.png",
        description = (rangerdef.description or name) .. " Ranger Data",
        groups = {
            not_in_creative_inventory = 1
        },
        grid_doc = {
            hidden = true
        }
    })
end

function morphinggrid.get_ranger(name)
    return morphinggrid.registered_rangers[name or ""]
end

function morphinggrid.get_registered_rangers()
    return morphinggrid.registered_rangers
end

function morphinggrid.get_ranger_group(ranger, group)
    if type(ranger) == "string" then
        ranger = morphinggrid.get_ranger(ranger)
    end
    if ranger ~= nil then
        local v = ranger.ranger_groups[group]
        if v ~= nil then
            return v
        end
    end
    return 0
end

function ranger.get_rangertype(rangerdef)
    local rangertype_string = morphinggrid.split_string(rangerdef.name, ":")[1]
    for _, rt in pairs(morphinggrid.rangertypes) do
        if rt.name == rangertype_string then
            return rt
        end
    end
    return nil
end

function ranger.get_ranger(rangerdef)
    return morphinggrid.split_string(rangerdef.name, ":")[2]
end

local function deepCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            v = deepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

-- Morpher
function morphinggrid.register_morpher(name, morpherdef)
    morpherdef.name = name
    morpherdef.type = morpherdef.type or "craftitem"
    morpherdef.morpher_commands = morpherdef.morpher_commands or {}
    morpherdef.groups = morpherdef.groups or {}
    morpherdef.groups.morpher = morpherdef.groups.morpher or 1
    morpherdef.griditems = morpherdef.griditems or {}
    morpherdef.hp_multiplier = morpherdef.hp_multiplier or 1

    morpherdef.allow_prevent_respawn = morpherdef.allow_prevent_respawn or function(player, itemstack)
        return morphinggrid.default_callbacks.morpher.allow_prevent_respawn(player, itemstack)
    end

    -- configure if the morpher is supposed to morph a player. This should be false if a morpher does not have a connection to the morphinggrid.
    -- This is set to 'true' by default. If the morpher has no connection, the 'morphing' functionality will not be registered.
    if type(morpherdef.has_connection) ~= "boolean" then
        morpherdef.has_connection = true
    end

    -- on_use method. This is what allows the player to morph.
    local save_on_use = morpherdef.on_use
    morpherdef.on_use = function(itemstack, user, pointed_thing)
        if morpherdef.has_connection then
            local grid_params = {
                player = user,
                pos = user:get_pos(),
                itemstack = itemstack
            }

            local grid_args = morphinggrid.call_grid_functions("before_morpher_use", grid_params)
            itemstack = grid_params.itemstack
            if not grid_args.cancel then
                if morpherdef.morph_func_override ~= nil then
                    itemstack = morpherdef.morph_func_override(user, itemstack, pointed_thing)
                elseif morpherdef.ranger == nil then
                    -- nothing happens. This must be checked to prevent errors but allow for custom modding.
                else
                    local ranger = morphinggrid.get_ranger(morpherdef.ranger)
                    if ranger == nil then
                        error("'" .. morpherdef.ranger .. "' is not a registred ranger.")
                    end
                    morphinggrid.morph(user, ranger, {
                        morpher = name,
                        itemstack = itemstack
                    })
                end
            else
                grid_params.canceled = true
            end

            morphinggrid.call_grid_functions("after_morpher_use", grid_params)
            itemstack = grid_params.itemstack
        end

        if morpherdef.register_griditem == true then
            local _grid_params = {
                itemstack = itemstack,
                user = user,
                pointed_thing = pointed_thing
            }

            local _grid_args = morphinggrid.call_grid_functions("before_grid_item_on_use", _grid_params)
            if not _grid_args.cancel then
                if type(save_on_use) == "function" then
                    itemstack = save_on_use(itemstack, user, pointed_thing)
                end
            else
                _grid_params.canceled = true
            end

            morphinggrid.call_grid_functions("after_grid_item_on_use", _grid_params)
        else
            if type(save_on_use) == "function" then
                itemstack = save_on_use(itemstack, user, pointed_thing)
            end
        end

        return itemstack
    end

    -- Add command presets
    morpherdef.morpher_command_presets = morpherdef.morpher_command_presets or {}
    for pname, p in pairs(morpherdef.morpher_command_presets) do
        if morphinggrid.morpher_cmd_presets[pname] then
            if p == true then
                for cname, c in pairs(morpherdef.morpher_cmd_presets[pname]) do
                    morpherdef.morpher_commands[cname] = c
                end
            end
        else
            error("'" .. pname .. "' is not an existing preset.")
        end
    end

    -- Add default commands to the morpher.
    morpherdef.morpher_commands.help = {
        short = "h",
        description = "Lists all commands for the morpher.",
        func = function(name)
            minetest.chat_send_player(name, "Commands for: " .. morpherdef.description)
            for cmd, t in pairs(morpherdef.morpher_commands) do
                minetest.chat_send_player(name, cmd .. " " .. (t.params or "") .. " | " .. (t.description or ""))
            end
        end
    }

    if type(morpherdef.morpher_slots) == "table" then
        morpherdef.morpher_commands.slots = {
            short = "s",
            description = "Gives access to the morpher's slots.",
            func = function(pname)
                minetest.show_formspec(pname, "morphinggrid:morpher_slots",
                    morphinggrid.morpher_slots.formspec(pname, name))
            end
        }
    end

    register_shortcommands(morpherdef.morpher_commands)

    -- get register_item
    local register_item
    if type(morpherdef.register_item) == "boolean" then
        register_item = morpherdef.register_item
    else
        register_item = true
    end

    -- register it as a morpher
    morphinggrid.registered_morphers[name] = morpherdef

    -- register it as a griditem
    if morpherdef.register_griditem == true then
        morpherdef.register_item = false
        morpherdef.is_griditem = true
        morpherdef.exclude_callbacks = {
            on_use = false
        }
        morphinggrid.register_griditem(name, morpherdef)
    end

    -- register item
    if register_item == true then
        local allowed_types = {
            tool = true,
            craftitem = true
        }
        if not allowed_types[morpherdef.type] then
            error("item type '" .. morpherdef.type .. "' is invalid.")
        end
    end

    minetest["register_" .. morpherdef.type](name, morpherdef)
end

function morphinggrid.morph_from_morpher(player, morpher, itemstack)
    if type(morpher) == "string" then
        if morphinggrid.registered_morphers[morpher] == nil then
            error("'" .. morpher .. "' is not a registered morpher.")
        end
        morpher = morphinggrid.registered_morphers[morpher]
    end

    -- requrment to be a seable morpher
    if morpher.has_connection then
        local grid_params = {
            player = player,
            pos = player:get_pos(),
            itemstack = itemstack
        }

        local grid_args = morphinggrid.call_grid_functions("before_morpher_use", grid_params)
        itemstack = grid_params.itemstack
        if not grid_args.cancel then
            if morpher.morph_func_override ~= nil then
                itemstack = morpher.morph_func_override(player, itemstack) or itemstack
            elseif morpher.ranger == nil then

            else
                local ranger = morphinggrid.registered_rangers[morpher.ranger]
                if ranger == nil then
                    error("'" .. morpher.ranger .. "' is not a registered ranger.")
                end
                morphinggrid.morph(player, ranger, {
                    morpher = morpher.name,
                    itemstack = itemstack
                })
            end
        else
            grid_params.canceled = true
        end

        morphinggrid.call_grid_functions("after_morpher_use", grid_params)
    end

    return itemstack
end

function morphinggrid.get_morpher(name)
    return morphinggrid.registered_morphers[name]
end

function morphinggrid.get_morphers()
    return morphinggrid.registered_morphers
end

-- default morpher functions
morphinggrid.default_callbacks.morpher = {}

function morphinggrid.default_callbacks.morpher.allow_prevent_respawn(player, itemstack)
    local def = morphinggrid.registered_morphers[itemstack:get_name()]

    -- if item is a grid item, use it's default callback
    if def.is_griditem then
        return morphinggrid.default_callbacks.griditem.allow_prevent_respawn(player, itemstack)
    end

    -- if not, continue
    local count = 0
    local rangers = {}
    for i, griditem in ipairs(def.griditems) do
        local griditemdef = morphinggrid.registered_griditems[griditem] or {
            rangers = {}
        }

        -- minetest.chat_send_all("["..def.name.."].griditems["..(griditem or "(nil)").."]")
        for _, ranger in ipairs(griditemdef.rangers) do
            -- minetest.chat_send_all("["..def.name.."].griditems["..(griditem or "(nil)")..
            -- "].rangers["..(ranger or "(nil)").."]")

            count = count + 1
            table.insert(rangers, ranger)
        end
    end

    if count < 1 then
        return true
    end

    for k, ranger in ipairs(rangers) do
        local rangerdata = morphinggrid.get_rangerdata(player, ranger)
        if rangerdata:has_energy() then
            return true
        end
    end
    return false
end
