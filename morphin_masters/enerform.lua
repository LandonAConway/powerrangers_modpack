local loaded = false

local colors = {
    red = {r=255,g=0,b=0},
    pink = {r=255,g=0,b=85},
    blue = {r=0,g=0,b=255},
    green = {r=0,g=200,b=38},
    yellow = {r=255,g=255,b=0},
    black = {r=25,g=25,b=25},
    white = {r=245,g=245,b=245},
    gold = {r=201,g=150,b=69},
    silver = {r=185,g=201,b=215}
}

local function cap(n, min, max)
    if type(min) == "number" and n < min then
        return min
    elseif type(max) == "number" and n > max then
        return max
    end
    return n
end

local function get_color(player)
    local color = colors[morphin_masters.enerform_get_color(player)]
    if not color then
        color = {r=255,g=255,b=255}
    end
    return minetest.rgba(color.r,color.g,color.b)
end

local function get_speed(vel)
    local x = vel.x
    local y = vel.y
    local z = vel.z
    if x < 0 then x = x*-1 end
    if y < 0 then y = y*-1 end
    if z < 0 then z = z*-1 end
    return x+y+z
end

local function particles(player, max_particles, texture)
    local lpos = player:get_pos()
    minetest.after(0.1, function()
        local direction = vector.direction(lpos, player:get_pos())
        local pos = vector.new(0,0.8,0)
        local vel = player:get_velocity()
        local speed = get_speed(vel)
        local time = cap(speed/15, 1)
        local amount = max_particles
        local area_size = speed*0.01
        local minpos = vector.offset(pos, area_size, area_size, area_size)
        local maxpos = vector.offset(pos, -area_size, -area_size, -area_size)
        local vel_factor = (speed/35)*0.2
        vel_factor = cap(vel_factor, 0.4)
        local minvel = vector.new(vel_factor,vel_factor,vel_factor)
        local maxvel = vector.new(-vel_factor,-vel_factor,-vel_factor)
        local xptime = cap((speed/15),0.9)
        local colorstring = get_color(player)
        local id = minetest.add_particlespawner({
            attached = player,
            amount = max_particles,
            time = time,
            minpos = minpos,
            maxpos = maxpos,
            minvel = minvel,
            maxvel = maxvel,
            minexptime = xptime,
            maxexptime = xptime,
            minsize = 0.8,
            maxsize = 1.4,
            collisiondetection = true,
            collision_removal = true,
            object_collision = false,
            texture = texture.."^[colorize:"..colorstring..":"..
                math.random(205,255).."^[opacity:"..math.random(98,255),
            glow = 14,
        })
        minetest.after(time+xptime+2.5, function()
            minetest.delete_particlespawner(id)
        end)
    end)
end

-- local function particles(player, max_particles, texture)
--     local lpos = player:get_pos()
--     minetest.after(0.1, function()
--         local direction = vector.direction(lpos, player:get_pos())
--         local pos = vector.offset(player:get_pos(), 0, 0.8, 0)
--         local time = 1
--         local vel = player:get_velocity()
--         local speed = get_speed(vel)
--         local amount = max_particles
--         local area_size = speed*0.01
--         local minpos = vector.offset(pos, area_size, area_size, area_size)
--         local maxpos = vector.offset(pos, -area_size, -area_size, -area_size)
--         local vel_factor = (speed/35)*0.35
--         vel_factor = cap(vel_factor, 0.4)
--         local minvel = vector.new(vel_factor,vel_factor,vel_factor)
--         local maxvel = vector.new(-vel_factor,-vel_factor,-vel_factor)
--         local acc = {
--             x = -(direction.x*(speed/1.5)),
--             y = -(direction.y*(speed/1.5)),
--             z = -(direction.z*(speed/1.5)),
--         }
--         local xptime = cap((speed/15),0.9)
--         local colorstring = get_color(player)
--         local id = minetest.add_particlespawner({
--             amount = max_particles,
--             time = time,
--             minpos = minpos,
--             maxpos = maxpos,
--             minvel = minvel,
--             maxvel = maxvel,
--             minacc = acc,
--             maxacc = acc,
--             minexptime = xptime,
--             maxexptime = xptime,
--             minsize = 0.8,
--             maxsize = 1.4,
--             collisiondetection = true,
--             collision_removal = true,
--             object_collision = false,
--             texture = texture.."^[colorize:"..colorstring..":"..
--                 math.random(205,255).."^[opacity:"..math.random(98,255),
--             glow = 14,
--         })
--         minetest.after(time+xptime+2.5, function()
--             minetest.delete_particlespawner(id)
--         end)
--     end)
-- end

local max_particles = tonumber(minetest.settings:get("morphin_masters.enerform_max_particles")) or 125
local function effect(player)
    local n_particles = max_particles/5
    particles(player, n_particles, "morphin_masters_enerform1.png")
    particles(player, n_particles, "morphin_masters_enerform2.png")
    particles(player, n_particles, "morphin_masters_enerform3.png")
    particles(player, n_particles, "morphin_masters_enerform4.png")
    particles(player, n_particles, "morphin_masters_enerform5.png")
end

local frequency = tonumber(minetest.settings:get("morphin_masters.enerform_frequency")) or 0.1
local _time = 0
minetest.register_globalstep(function(time)
    if _time > frequency then
        for _, player in pairs(minetest.get_connected_players()) do
            if morphin_masters.enerform_get_state(player) == "on" then
                if loaded then
                    effect(player)
                end
            end
        end
        _time = 0
    end
    _time = _time + time
end)

function morphin_masters.enerform_get_color(player)
    local meta = player:get_meta()
    return meta:get_string("morphin_masters:enerform_color")
end

function morphin_masters.enerform_set_color(player, color)
    local meta = player:get_meta()
    if colors[color] then
        meta:set_string("morphin_masters:enerform_color", color)
    end
end

function morphin_masters.enerform_get_state(player)
    local meta = player:get_meta()
    local mode = meta:get_string("morphin_masters:enerform")
    if mode ~= "on" then
        mode = "off"
    end
    return mode
end

local function get_nametag_text(player)
    local ranger = morphinggrid.get_morph_status(player)
    if ranger then
        local rangerdef = morphinggrid.registered_rangers[ranger]
        return rangerdef.description or ranger
    end
end

function morphin_masters.enerform_on(player)
    local meta = player:get_meta()
    local prop = {
        collide_with_object = false,
        pointable = false,
        makes_footstep_sound = false,
        visual_size = {x = 0, y = 0, z = 0},
    }
    player:set_properties(prop)
    player:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}, text=get_nametag_text(player)})
    meta:set_string("morphin_masters:enerform", "on")
end

function morphin_masters.enerform_off(player)
    local meta = player:get_meta()
    local prop = {
        collide_with_object = true,
        pointable = true,
        makes_footstep_sound = true,
        visual_size = {x = 1, y = 1, z = 1},
    }
    player:set_properties(prop)
    player:set_nametag_attributes({color = {a = 255, r = 255, g = 255, b = 255}, text=get_nametag_text(player)})
    meta:set_string("morphin_masters:enerform", "off")
end

function morphin_masters.enerform_toggle(player)
    local mode = morphin_masters.enerform_get_state(player)
    if mode == "on" then
        morphin_masters.enerform_off(player)
    else
        morphin_masters.enerform_on(player)
    end
end

morphinggrid.register_after_morph(function(player, ranger)
    if morphin_masters.enerform_get_state(player) == "on" then
        player:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}})
    end
end)

morphinggrid.register_after_demorph(function(player, ranger)
    if morphin_masters.enerform_get_state(player) == "on" then
        player:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}})
    end
end)

loaded = true