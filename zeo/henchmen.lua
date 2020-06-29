pr_villians.register_henchman("zeo:cog_metalic", {
  description = "Metalic Cog",
  texture = "zeo_cog_metalic.png",
  hp_max = 300,
  hp = 300,
  damage = 2,
  water_damage = 5,
  damageinterval = 2,
  can_swim = false,
  benefits_on_attack = true,
  benifit = 5,
  movingspeed = 2,
  lifetime = 900,
  
  spawner = {
    name = "zeo:cog_metalic_egg",
    description = "Metalic Cog Egg",
    inventory_image = "zeo_cog_metalic_egg.png"
  },
})

pr_villians.register_henchman("zeo:cog_pink", {
  description = "Pink Cog",
  texture = "zeo_cog_pink.png",
  hp_max = 300,
  hp = 300,
  damage = 2,
  water_damage = 5,
  damageinterval = 2,
  can_swim = false,
  benefits_on_attack = true,
  benefit = 5,
  movingspeed = 2,
  lifetime = 900,
  
  spawner = {
    name = "zeo:cog_pink_egg",
    description = "Pink Cog Egg",
    inventory_image = "zeo_cog_pink_egg.png"
  },
})

pr_villians.register_spawner("zeo:fifteen_cog_metalic_egg", {
  description = "Mass Metalic Cog Egg",
  inventory_image = "zeo_cog_metalic_egg.png",
  henchman = "zeo:cog_metalic",
  spawn_amount = 15
})

pr_villians.register_spawner("zeo:fifteen_cog_pink_egg", {
  description = "Mass Pink Cog Egg",
  inventory_image = "zeo_cog_pink_egg.png",
  henchman = "zeo:cog_pink",
  spawn_amount = 15
})