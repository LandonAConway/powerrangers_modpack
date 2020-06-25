pr_henchmen.registered_henchmen = {}

pr_henchmen.registered_callbacks = {
  on_activate = {},
  on_spawn = {},
  on_attack = {},
  on_punch = {}
}

function pr_henchmen.register_henchman(name, def)
  local modname = pr_henchmen.split_string(name, ":")[1]
  local itemname = pr_henchmen.split_string(name, ":")[2]
  
  def.description_is_plural = def.description_is_plural or false
  def.hp_max = def.hp_max or 100
  def.hp = def.hp or 100
  def.damage = def.damage or 1
  def.lifetime = def.lifetime or 120
  def.damageinterval = def.damageinterval or 0
  def.movingspeed = def.movingspeed or 2
  def.can_swim = def.can_swim or true
  def.max_free_fall = def.max_free_fall or 4
  def.benefits_on_attack = def.benefits_on_attack or false
  def.benefit = def.benefit or 1
  
  def.name = name
  pr_henchmen.registered_henchmen[name] = def
  
  if def.on_activate ~= nil then
    table.insert(pr_henchmen.registered_callbacks.on_activate, def.on_activate)
  end
  
  if def.on_spawn ~= nil then
    table.insert(pr_henchmen.registered_callbacks.on_spawn, def.on_spawn)
  end
  
  if def.on_attack ~= nil then
    table.insert(pr_henchmen.registered_callbacks.on_attack, def.on_attack)
  end
  
  if def.on_punch ~= nil then
    table.insert(pr_henchmen.registered_callbacks.on_punch, def.on_punch)
  end
  
  minetest.register_entity(name ,{
  -- entity properties
  
    hp_max = def.hp_max,
    collisionbox = {-0.35,-0.01,-0.35,0.35,1.8,0.35},
    physical = true,
    visual = "mesh",
    mesh = "character.b3d", -- the model & texture is used from the player_ap mod
    textures = {def.texture},-- so you can borrow resurses from other mods by adding them in the mod.conf --> depends (before it was called depends.txt, now it is outdated) 
  
  -- you can declare variables here too, will be able in "self"
  
    animation = {
      stand={x=0,y=79,speed=30,loop=false},
      walk={x=168,y=187,speed=30},
      run={x=168,y=187,speed=40},
      attack={x=200,y=219,speed=30},
    },
    type = "npc",
    team = "default",
    time = 0,
    hp = def.hp,
    damage = def.damage,
    id = 0,
    movingspeed = def.movingspeed,
    swimmingspeed = def.swimmingspeed,
    damageinterval = def.damageinterval,
    damageinterval_time = 0,
    lifetime = def.lifetime,
    can_swim = def.can_swim,
    is_swimming = false,
    benefits_on_attack = def.benefits_on_attack,
    benefit = def.benefit,
    
    -- called while the entity is activate and deactivated, the string will be saved in the entity
    -- i like to do a "storage" variable so everyting in it will be automacly saved, simple
  
    get_staticdata = function(self)
      self.storage.hp = self.hp
      return minetest.serialize(self.storage)
    end,
  
  
    on_activate=function(self, staticdata)
      self.storage = minetest.deserialize(staticdata) or {} --load storage or a new
      self.hp = self.storage.hp
      self.object:set_velocity({x=0,y=-1,z=0})
      self.object:set_acceleration({x=0,y=-10,z =0})    -- set the entity gravity.
      self.id = math.random(1,9999)     --so the mob can determine difference from other mobs
      self.falling_to_punch = false
      anim(self,"stand")
      
      for k, v in pairs(pr_henchmen.registered_callbacks.on_activate) do
        v(self, staticdata)
      end
    end,
    
    on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
      local en = puncher:get_luaentity()
      local dmg = 0
      self.last_punched_by = puncher or self.last_punched_by
      dmg = tool_capabilities.damage_groups.fleshy or 1
  
      if puncher:is_player() then -- adds wear to the tool, advanced stuff
        self.target = puncher
        local look_dir = puncher:get_look_dir()
        self.object:add_velocity({x=look_dir.x*15,y=look_dir.y*4,z=look_dir.z*15})
        local item = minetest.registered_tools[puncher:get_wielded_item():get_name()]
        if item and item.tool_capabilities and item.tool_capabilities.damage_groups then
          local d = tool_capabilities.damage_groups.fleshy
          if d and d > 0 then
            local tool = puncher:get_wielded_item()
            tool:add_wear(math.ceil(self.hp_max/(dmg*dmg)))
            puncher:set_wielded_item(tool)
          end
        end
        for k, v in pairs(pr_henchmen.registered_callbacks.on_punch) do
        v(self, puncher, time_from_last_punch, tool_capabilities, dir, "player")
        end
        
      end
      self.hp = self.hp - dmg
      self.object:set_properties({nametag=self.hp.." / "..self.hp_max ,nametag_color="#00ff00"})
      if self.hp <= 0 then
        self.object:remove()
      end
      
      return self
    end,
    
    on_step = function(self, dtime)
      -- updating the mob each 0.5s is enough and makes it not lag
      self.time = self.time + dtime
      self.lifetime = self.lifetime -dtime
      self.damageinterval_time = self.damageinterval_time + dtime
      if self.lifetime <= 0 then -- removing the mob after a time, or there will be too many
        self.object:remove()
        return
      elseif self.target and self.time < 0.1 or not self.target and self.time < 0.5 then
        return self
      end
      self.time = 0
      
  
      local pos = self.object:get_pos()
      
      --kill the mob if it is in water and cannot swim
      if not self.can_swim then
        if pr_henchmen.check_if_any_group(self.object:get_pos(), { "water" }) then
          self.object:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=1}})
          for k, v in pairs(pr_henchmen.registered_on_punch) do
             v(self, puncher, 1, {full_punch_interval=1,damage_groups={fleshy=self.damage}}, nil, "drowning")
          end
        end
      end
      
      --swimming in water
      local swim_pos = self.object:get_pos()
      local swim_pos_above = {x=swim_pos.x,y=swim_pos.y+1,z=swim_pos.z}
      if pr_henchmen.check_if_any_group(self.object:get_pos(), { "water" }) then
        self.is_swimming = true
        if self.can_swim then
          local vel = self.object:get_velocity()
          if not pr_henchmen.check_if_any_group(swim_pos_above, { "water" }) then
            self.object:set_acceleration({x=0,y=0,z =0})
            self.object:add_velocity({x=0,y=0-vel.y,z=0})
          else
            self.object:set_acceleration({x=0,y=4,z =0})
            self.object:add_velocity({x=0,y=0-vel.y,z=0})
          end
        else
          self.object:set_acceleration({x=0,y=-2,z =0})
        end
      else
        self.is_swimming = false
        self.object:set_acceleration({x=0,y=-10,z =0}) --set back to normal gravity.
      end
  
      --rnd walking
      if self.target == nil then
        local r = math.random(1,4)
        local v = self.object:get_velocity()
        if r == 1 then-- walk randomly
          self.object:set_yaw(math.random(0,6.28))
          walk(self)
        elseif r == 2 then
          stand(self)
        else
          walk(self)
        end
      end
      
      --punch after free fall
      self.max_free_fall = self.max_free_fall or 4
      local line_of_sight = minetest.line_of_sight(self.object:get_pos(), {x=self.object:get_pos().x,y=self.object:get_pos().y-self.max_free_fall,z=self.object:get_pos().z})
      if line_of_sight == true then
        self.falling_to_punch = true
      end
      
      if self.falling_to_punch then
        local node_under = {x=self.object:get_pos().x,y=self.object:get_pos().y-1,z=self.object:get_pos().z}
        if not pr_henchmen.check_if_any_group(node_under, {"water"}) then
          local velocity = self.object:get_velocity()
          if velocity.y > -0.2 and velocity.y < 0.2  then
            self.object:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=20}})
            self.falling_to_punch = false
          end
        end
      end
  
      --look for targets
      if self.target == nil then
        local rnd_target
        for _, ob in pairs(minetest.get_objects_inside_radius(pos, 10)) do
          local en = ob:get_luaentity() -- players do not have this property
          local obp = ob:get_pos()
    
          if ob:is_player() then
            if (en == nil or en and en.id ~= self.id) and visiable(self,obp) and viewfield(self,obp) then
              rnd_target = ob
              if math.random(1,3) == 1 then --choosing random targets
                break
              end
            end
          end
        end
        self.target = rnd_target
      end
      
      -- attack target
      if self.target then
        local tarp = self.target:get_pos()
        if tarp == nil or visiable(self,tarp) == false or viewfield(self,tarp) == false and self.target ~= self.last_punched_by then -- sometimes the object is gone but not the object
          self.target = nil
          return
        end
        lookat(self,tarp)
        walk(self,2)
        self.lifetime = 120 -- resets lifetime
  
        if vector.distance(pos,tarp) <= 3 then
          anim(self,"attack")
          if self.damageinterval_time >= self.damageinterval then
            if core.setting_getbool("enable_damage") then
              self.target:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=self.damage}})
              if self.target:is_player() then
                --morphinggrid.punch_ranger_armor(self.target, self.object, self.damage)
              end
              if self.benefits_on_attack then
                self.hp = self.hp + def.benefit
                if self.hp > self.hp_max then
                  self.hp = self.hp_max
                end
                self.object:set_properties({nametag=self.hp.." / "..self.hp_max ,nametag_color="#00ff00"})
              end
              for k, v in pairs(pr_henchmen.registered_callbacks.on_attack) do
                v(self, 1, {full_punch_interval=1,damage_groups={fleshy=self.damage}})
              end
            end
          end
          if self.target:get_hp() <= 0 then
            self.target = nil
          end
        end
      end
      
      --reset damage interval time
      if self.damageinterval_time >= self.damageinterval then
        self.damageinterval_time = 0
      end
      
      if not self.can_swim then
        if pr_henchmen.check_if_any_group({x=pos.x,y=pos.y-1,z=pos.z}, { "cracky", "soil", "stone", "crumbly", "wood" }) and
        not pr_henchmen.check_if_any_group(posinfront(self, 1), { "water" }) and
        not pr_henchmen.check_if_any_group(posinfront(self, 2), { "water" }) then
          jump(self)
        end
      else
        if pr_henchmen.check_if_any_group({x=pos.x,y=pos.y-1,z=pos.z}, { "cracky", "soil", "stone", "crumbly", "wood" }) then
          jump(self)
        end
      end
    end
  })
  
  local spawner = def.spawner
  spawner.henchman = name
  spawner.spawn_amount = def.spawn_amount or 1
  
  pr_henchmen.register_spawner(spawner.name, spawner)
end

function pr_henchmen.register_spawner(name, def)
  local on_place = def.on_place
  minetest.register_craftitem(name, {
    description = def.description,
    inventory_image = def.inventory_image,
    on_place = function(itemstack, user, pointed_thing)
      if pointed_thing.type=="node" then
        local p = pointed_thing.above
        pr_henchmen.spawn(def.henchman, {x=p.x,y=p.y+1,z=p.z}, def.spawn_amount)
        if not core.setting_getbool("creative_mode") then
          itemstack:take_item()
        end
      end
      if on_place ~= nil then
        on_place(itemstack, user, pointed_thing)
      end
      return itemstack
    end
  })
end

function pr_henchmen.spawn(name, pos, amount)
  for i=1,amount do
    minetest.add_entity(pos, name):set_yaw(math.random(0,6.28))
  end
  
  for i, v in ipairs(pr_henchmen.registered_callbacks.on_spawn) do
    v(name, pos, amount)
  end
end

function walk(self)
  if math.random(1,3) > 1 then-- stands at 1
    local v = self.object:get_velocity()
    self.object:set_velocity({
      x=math.random(-1,1), 
      y=v.y,
      z=math.random(-1,1)
    })
  end
end

-- check if the anim exists, use it if it's not same as the last
function anim(self,type)
  if self.visual ~= "mesh" or type == self.anim or not self.animation then return end
  local a=self.animation[type]
  if not a then return end
  self.object:set_animation({x=a.x, y=a.y,},a.speed,false,a.loop)
  self.anim=type
end

function jump(self)
  local v = self.object:get_velocity()
  if v.y == 0 then-- dont jump in air
    self.object:set_velocity({x=v.x, y=5.5, z=v.z})
  end
end

function stand(self)
  local v = self.object:get_velocity()
  self.object:set_velocity({
    x = 0,
    y = v.y,  --keep falling
    z = 0
  })
  anim(self,"stand")
end

function walk(self,speed)
  speed = speed and (self.movingspeed*speed) or self.movingspeed -- choosing movingspeed as default if speed is nil

  local yaw = self.object:get_yaw()
  local v = self.object:get_velocity()
  local x = (math.sin(yaw) * -1) * speed
  local z = (math.cos(yaw) * 1) * speed
  
  if self.is_swimming then
    if self.swimmingspeed == nil then
      x = (x/5)*3
      z = (z/5)*3
    else
      x = (math.sin(yaw) * -1) * self.swimmingspeed
      z = (math.cos(yaw) * 1) * self.swimmingspeed
    end
  end
  
  if not self.can_swim then
    if not pr_henchmen.check_if_any_group(posinfront(self,1),{"water"}) then
      self.object:set_velocity({
        x = x,
        y = v.y,
        z = z
      })
    else
      stand(self)
    end
  else
    self.object:set_velocity({
        x = x,
        y = v.y,
        z = z
    })
  end

  if speed > self.movingspeed then
    anim(self,"run")
  else
    anim(self,"walk")
  end
end

function lookat(self,pos2)
  local pos1 = self.object:get_pos()
  local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
  local yaw = math.atan(vec.z/vec.x)-math.pi/2
  if pos1.x >= pos2.x then
    yaw = yaw+math.pi
  end
  self.object:set_yaw(yaw)
end

function visiable(self,pos2) -- checking if someting is blocking the mobs view
  local pos1 = self.object:get_pos()
  local v = {x = pos1.x - pos2.x, y = pos1.y - pos2.y-1, z = pos1.z - pos2.z}
  v.y=v.y-1
  local amount = (v.x ^ 2 + v.y ^ 2 + v.z ^ 2) ^ 0.5
  local d=vector.distance(pos1,pos2)
  v.x = (v.x  / amount)*-1
  v.y = (v.y  / amount)*-1
  v.z = (v.z  / amount)*-1
  for i=1,d,1 do
    local node = minetest.registered_nodes[minetest.get_node({x=pos1.x+(v.x*i),y=pos1.y+(v.y*i),z=pos1.z+(v.z*i)}).name]
    if node and node.walkable then
      return false
    end
  end
  return true
end

function viewfield(self,p2) -- if target is in the view field
  local ob1 = self.object
  local p1 = ob1:get_pos()
  local a = vector.normalize(vector.subtract(p2, p1))
  local yaw = math.floor(ob1:get_yaw()*100)/100
  local b = {x=math.sin(yaw)*-1,y=0,z=math.cos(yaw)*1}
  local deg = math.acos((a.x*b.x)+(a.y*b.y)+(a.z*b.z)) * (180 / math.pi)
  return not (deg < 0 or deg > 50)
end

function posinfront(self, distance)
  local yaw = self.object:get_yaw()
  local p = self.object:get_pos()
  distance = distance or 1
  local x = math.sin(yaw) * -distance
  local z = math.cos(yaw) * distance
  return vector.new(p.x + x, p.y - 1, p.z + z)
end