local configure_player_name = function(player)
    local player_name = player
    if type(player) == "userdata" then
        player_name = player:get_player_name()
    end
    return player_name
end

-------------------
--Ranger Settings--
-------------------

ranger_settings = {
    settings = {},
    default = {
        helmet_state = "on",
        visor_state = "closed"
    }
}

function morphinggrid.save_ranger_settings()
    local settings = {}
    for k, v in pairs(ranger_settings.settings) do
        if type(v) ~= "function" and type(v) ~= "userdata" then
            settings[k] = v
        end
    end
    morphinggrid.mod_storage.set_string("ranger_settings", minetest.serialize(settings))
end

function morphinggrid.load_ranger_settings()
    ranger_settings.settings = minetest.deserialize(
        morphinggrid.mod_storage.get_string("ranger_settings")) or {}
end

minetest.register_on_mods_loaded(function()
    morphinggrid.load_ranger_settings()
end)

local ranger_settings_init = function(player, ranger)
    local name = configure_player_name(player)
    local settings = ranger_settings.settings or {}
    settings[name] = settings[name] or {}
    settings[name][ranger] = settings[name][ranger] or {}
    for setting_name, value in pairs(ranger_settings.default) do
        if settings[name][ranger][setting_name] == nil then
            settings[name][ranger][setting_name] = value
        end
    end
end

function ranger_settings.get_value(self, player, ranger, setting)
    ranger_settings_init(player, ranger)
    local name = configure_player_name(player)
    return self.settings[name][ranger][setting]
end

function ranger_settings.set_value(self, player, ranger, setting, value)
    ranger_settings_init(player, ranger)
    local name = configure_player_name(player)
    self.settings[name][ranger][setting] = value
    morphinggrid.save_ranger_settings()
end

function ranger_settings.get_value_of_current(self, player, setting)
    local name = configure_player_name(player)
    local ranger = morphinggrid.get_morph_status(player)
    ranger_settings_init(player, ranger)
    if ranger then
        return self:get_value(player, ranger, setting)
    end
end

function ranger_settings.set_value_of_current(self, player, setting, value)
    local name = configure_player_name(player)
    local ranger = morphinggrid.get_morph_status(player)
    ranger_settings_init(player, ranger)
    if ranger then
        self:set_value(player, ranger, setting, value)
    end
end


---------------
--Ranger Data--
---------------

morphinggrid.rangerdatas = {}

_rangerdata_config = {
    energy_level = 0,
    loaded = false
}

_rangerdata = { }

function morphinggrid.save_rangerdatas()
    local rangerdatas = {}
    for player_name, datas in pairs(morphinggrid.rangerdatas) do
        rangerdatas[player_name] = {}
        for ranger_name, data in pairs(datas) do
            rangerdatas[player_name][ranger_name] = {}
            --clean functions and userdata from ranger datas
            for k, v in pairs(data) do
                if type(v) ~= "function" and type(v) ~= "userdata" then
                    rangerdatas[player_name][ranger_name][k] = v
                end
            end
        end
    end
    morphinggrid.mod_storage.set_string("rangerdatas", minetest.serialize(rangerdatas))
end

function morphinggrid.load_rangerdatas()
    local rangerdatas = minetest.deserialize(
        morphinggrid.mod_storage.get_string("rangerdatas")) or {}
    for player_name, datas in pairs(rangerdatas) do
        for ranger_name, data in pairs(datas) do
            --add field indicating that the ranger data has not been filled with functions yet.
            data.loaded = false
        end
    end
    morphinggrid.rangerdatas = rangerdatas
end

minetest.register_on_mods_loaded(function()
    morphinggrid.load_ranger_settings()
    morphinggrid.load_rangerdatas()
end)

--this function must be called whenever a ranger data is retrieved
local rangerdata_init = function(player, ranger, refresh)
    local player_name = configure_player_name(player)
    if not morphinggrid.registered_rangers[ranger or ""] then
        error("rangerstring expected, got "..type(ranger))
    end
    local rangerdatas = morphinggrid.rangerdatas

    if rangerdatas[player_name] and rangerdatas[player_name][ranger] and not refresh then
        --reload an old ranger data
        if not rangerdatas[player_name][ranger].loaded then
            for k, v in pairs(_rangerdata) do
                rangerdatas[player_name][ranger][k] = v
            end
        end
    else
        --creates a new ranger data
        rangerdatas[player_name] = { [ranger] = _rangerdata_config }
        for k, v in pairs(_rangerdata) do
            rangerdatas[player_name][ranger][k] = v
        end
        local data = rangerdatas[player_name][ranger]
        data.player_name = player_name
        data.ranger = ranger
        data.energy_level = data:get_ranger_definition().energy_default or data:get_max_energy()
    end
    --important information that should never change needs to be reloaded to prevent issues.
    rangerdatas[player_name][ranger].player_name = player_name
    rangerdatas[player_name][ranger].ranger = ranger
    rangerdatas[player_name][ranger].loaded = true
    morphinggrid.save_rangerdatas()
    return rangerdatas[player_name][ranger]
end

function morphinggrid.refresh_rangerdata(player, ranger)
    return rangerdata_init(player, ranger, true)
end

function morphinggrid.get_rangerdata(player, ranger)
    local player_name = configure_player_name(player)
    return rangerdata_init(player, ranger)
end

function morphinggrid.get_current_rangerdata(player)
    local player_name = configure_player_name(player)
    local ranger = morphinggrid.get_morph_status(player)
    if ranger then
        return morphinggrid.get_rangerdata(player, ranger)
    end
end

function _rangerdata.refresh(self)
    return morphinggrid.refresh_rangerdata(minetest.get_player_by_name(self.player_name), self.ranger)
end

function _rangerdata.get_ranger_definition(self)
    return morphinggrid.registered_rangers[self.ranger]
end

function _rangerdata.get_setting_value(self, setting, default)
    local value = ranger_settings:get_value(self.player_name, self.ranger, setting)
    if value == nil then value = default end
    return value
end

function _rangerdata.set_setting_value(self, setting, value)
    ranger_settings:set_value(self.player_name, self.ranger, setting, value)
end


-----------------
--Energy System--
-----------------

function _rangerdata.get_max_energy(self)
    local player = minetest.get_player_by_name(self.player_name)
    local rangerdef = morphinggrid.registered_rangers[self.ranger]
    local max_energy = rangerdef.max_energy
    local powerupslist = morphinggrid.player_get_powerups_list(player)
    for _, powerup in pairs(powerupslist) do
        local powerupdef = morphinggrid.registered_powerups[powerup]
        if powerupdef then
            max_energy = powerupdef.max_energy(player, self.ranger, powerup, max_energy, self:get_energy_level())
        end
    end
    return max_energy
end

function _rangerdata.get_energy_damage_per_hp(self)
    local rangerdef = self:get_ranger_definition()
    local value = rangerdef.energy_damage_per_hp
    if type(value) == "function" then value = value(minetest.get_player_by_name(self.player_name), self.ranger) end
    return value
end

function _rangerdata.get_energy_damage_per_globalstep(self)
    local rangerdef = self:get_ranger_definition()
    local value = rangerdef.energy_damage_per_globalstep
    if type(value) == "function" then value = value(minetest.get_player_by_name(self.player_name), self.ranger) end
    return value
end

function _rangerdata.get_energy_heal_per_globalstep(self)
    local rangerdef = self:get_ranger_definition()
    local value = rangerdef.energy_heal_per_globalstep
    if type(value) == "function" then value = value(minetest.get_player_by_name(self.player_name), self.ranger) end
    return value
end

function _rangerdata.get_energy_level(self)
    return self.energy_level
end

function _rangerdata.set_energy_level(self, level)
    if level <= self:get_max_energy() then
        self.energy_level = level
    else
        self.energy_level = self:get_max_energy()
    end
end

function _rangerdata.subtract_energy(self, energy)
    self:set_energy_level(self:get_energy_level()-energy)
    return self:get_energy_level()
end

function _rangerdata.add_energy(self, energy)
    self:set_energy_level(self:get_energy_level()+energy)
    return self:get_energy_level()
end

function _rangerdata.get_energy_level_percentage(self)
    local rangerdef = self:get_ranger_definition()
    return self:get_energy_level()/self:get_max_energy()
end

function _rangerdata.set_energy_level_percentage(self, level)
    local rangerdef = self:get_ranger_definition()
    self:set_energy_level(level*self:get_max_energy())
end

function _rangerdata.damage_energy_hp(self, hp)
    local rangerdef = self:get_ranger_definition()
    return self:subtract_energy(hp*self:get_energy_damage_per_hp())
end

function _rangerdata.damage_energy(self, globalsteps)
    local rangerdef = self:get_ranger_definition()
    return self:subtract_energy(self:get_energy_damage_per_globalstep()*(globalsteps or 1))
end

function _rangerdata.heal_energy(self, globalsteps)
    local rangerdef = self:get_ranger_definition()
    return self:add_energy(self:get_energy_heal_per_globalstep()*(globalsteps or 1))
end

function _rangerdata.has_energy(self)
    return self:get_energy_level() > 0
end


--calculate energy on each global step
--EDIT: energy should not be calculated for every globalstep. This lags the server. Instead, do it at an interval.
local globalstep_update_interval = 10
local globalsteps = 0
local time = 0
local time_since_last_save = 0
minetest.register_globalstep(function(dtime)
    if time >= globalstep_update_interval then
        for _, player in pairs(minetest.get_connected_players()) do
            --make sure morphed players have data
            local current_ranger = morphinggrid.get_morph_status(player)
            if current_ranger then
                rangerdata_init(player, current_ranger)
            end
            morphinggrid.rangerdatas[player:get_player_name()] = morphinggrid.rangerdatas[player:get_player_name()] or {}
            local datas = morphinggrid.rangerdatas[player:get_player_name()]
            for ranger, data in pairs(datas) do
                if data.loaded then
                    --player is not morphed as the 'ranger' so heal the ranger's energy.
                    if ranger ~= current_ranger then
                        data:heal_energy(globalsteps)
                    else -- player is morphed as the 'ranger'
                        data:damage_energy(globalsteps)
                        if not data:has_energy() then
                            --demorph the player because they do not have energy; their powers have been destroyed
                            morphinggrid.demorph(player, { voluntary = false, chat_messages = false })
                            minetest.chat_send_player(player:get_player_name(), "You have demorphed becuase you did not have enough power. (Ranger: "
                                ..(data:get_ranger_definition().description or ranger)..")")
                        end
                        morphinggrid.hud_update_power_usage(player)
                    end
                end
            end
        end
        if time_since_last_save > 30 then
            morphinggrid.save_rangerdatas()
            time_since_last_save = 0
        end
        globalsteps = 0
        time = 0
    end
    globalsteps = globalsteps + 1
    time = time + dtime
    time_since_last_save = time_since_last_save + dtime
end)