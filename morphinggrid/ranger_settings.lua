ranger_settings = {
    settings = {},
    default = {
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
    local name = player:get_player_name()
    local settings = ranger_settings.settings
    settings[name] = settings[name] or {}
    settings[name][ranger] = settings[name][ranger] or ranger_settings.default
end

function ranger_settings.get_value(self, player, ranger, setting)
    ranger_settings_init(player, ranger)
    local name = player:get_player_name()
    return self.settings[name][ranger][setting]
end

function ranger_settings.set_value(self, player, ranger, setting, value)
    ranger_settings_init(player, ranger)
    local name = player:get_player_name()
    self.settings[name][ranger][setting] = value
    morphinggrid.save_ranger_settings()
end

function ranger_settings.get_value_of_current(self, player, setting)
    ranger_settings_init(player, ranger)
    local name = player:get_player_name()
    local ranger = morphinggrid.get_morph_status(player)
    if ranger then
        return self:get_value(player, ranger, setting)
    end
end

function ranger_settings.set_value_of_current(self, player, setting, value)
    ranger_settings_init(player, ranger)
    local name = player:get_player_name()
    local ranger = morphinggrid.get_morph_status(player)
    if ranger then
        self:set_value(player, ranger, setting, value)
    end
end

