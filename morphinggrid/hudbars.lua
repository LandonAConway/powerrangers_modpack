if minetest.get_modpath("hudbars") then
    hb.register_hudbar("morphinggrid_power_usage", 0xFFFFFF, "Ranger",
        { icon = "morphinggrid_power_usage_icon.png", bgicon = "hudbars_bar_background.png", bar = "morphinggrid_power_usage_bar.png" }, 0, 100,
        true, nil, nil )

    minetest.register_on_joinplayer(function(player)
        hb.init_hudbar(player, "morphinggrid_power_usage", 0, 100, true)
    end)
end