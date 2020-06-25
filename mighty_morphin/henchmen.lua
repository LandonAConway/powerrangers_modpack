pr_henchmen.register_henchman("mighty_morphin:putty", {
  description = "Putty",
  texture = "mighty_morphin_putty.png",
  hp_max = 10,
  hp = 10,
  damage = 1,
  damageinterval = 5,
  can_swim = true,
  benefits_on_attack = true,
  movingspeed = 2,
  lifetime = 900,
  
  spawner = {
    name = "mighty_morphin:putty_egg",
    description = "Putty Egg",
    inventory_image = "mighty_morphin_putty_egg.png"
  },
})

pr_henchmen.register_henchman("mighty_morphin:z_putty", {
  description = "Z Putty",
  texture = "mighty_morphin_zputty.png",
  hp_max = 200,
  hp = 200,
  damage = 1,
  damageinterval = 1,
  can_swim = true,
  benefits_on_attack = true,
  benefit = 3,
  movingspeed = 2,
  lifetime = 900,
  
  spawner = {
    name = "mighty_morphin:z_putty_egg",
    description = "Z Putty Egg",
    inventory_image = "mighty_morphin_putty_egg.png"
  },
})

pr_henchmen.register_spawner("mighty_morphin:fifteen_putty_egg", {
  description = "Mass Putty Egg",
  inventory_image = "mighty_morphin_putty_egg.png",
  henchman = "mighty_morphin:putty",
  spawn_amount = 15
})

pr_henchmen.register_spawner("mighty_morphin:fifteen_z_putty_egg", {
  description = "Mass Z Putty Egg",
  inventory_image = "mighty_morphin_putty_egg.png",
  henchman = "mighty_morphin:z_putty",
  spawn_amount = 15
})