pr_villians.register_henchman("turbo:piranhatron", {
  description = "Piranhatron",
  texture = "turbo_piranhatron.png",
  hp_max = 200,
  hp = 200,
  damage = 2,
  damageinterval = 2.5,
  can_swim = true,
  benefits_on_attack = true,
  movingspeed = 3,
  lifetime = 900,
  
  spawner = {
    name = "turbo:piranhatron_egg",
    description = "Piranhatron Egg",
    inventory_image = "turbo_piranhatron_egg.png"
  },
})

pr_villians.register_spawner("turbo:fifteen_piranhatron_egg", {
  description = "Mass Piranhatron Egg",
  inventory_image = "turbo_piranhatron_egg.png",
  henchman = "turbo:piranhatron",
  spawn_amount = 15
})