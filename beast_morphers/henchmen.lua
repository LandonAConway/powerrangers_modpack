pr_villians.register_henchman("beast_morphers:tronic", {
  description = "Tronic",
  texture = "beast_morphers_tronic.png",
  hp_max = 400,
  hp = 400,
  damage = 3,
  damageinterval = 1,
  can_swim = false,
  benefits_on_attack = true,
  movingspeed = 3,
  lifetime = 900,
  
  spawner = {
    name = "beast_morphers:tronic_egg",
    description = "Tronic",
    inventory_image = "beast_morphers_tronic_egg.png"
  },
})

pr_villians.register_spawner("beast_morphers:fifteen_tronic_egg", {
  description = "Mass Tronic Egg",
  inventory_image = "beast_morphers_tronic_egg.png",
  henchman = "beast_morphers:tronic",
  spawn_amount = 15
})