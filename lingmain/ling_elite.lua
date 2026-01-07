TUNING.LING.ELITE = {{
  MAX_HEALTH = 50,
  MAX_HUNGER = 150,
  MAX_SANITY = 250,
  MAX_POETRY = 30,
  POETRY_RECOVERY_WHILE_IDLE_PER_SECOND = 5 / 60,
  POETRY_RECOVERY_IN_DREAM_PER_SECOND = 1,
  MAX_GUARDS = 3,
  DAMAGE_MULTIPLIER = 0.8,
  SPEED_MULTIPLIER = 1,
  SLEEP_RESISTANCE = 10,
}, {
  MAX_HEALTH = 80,
  MAX_HUNGER = 50,
  MAX_SANITY = 250,
  MAX_POETRY = 60,
  POETRY_RECOVERY_WHILE_IDLE_PER_SECOND = 5 / 60,
  POETRY_RECOVERY_IN_DREAM_PER_SECOND = 3,
  MAX_GUARDS = 4,
  DAMAGE_MULTIPLIER = 0.9,
  SPEED_MULTIPLIER = 1,
  SLEEP_RESISTANCE = 10,
}, {
  MAX_HEALTH = 120,
  MAX_HUNGER = 150,
  MAX_SANITY = 300,
  MAX_POETRY = 100,
  POETRY_RECOVERY_WHILE_IDLE_PER_SECOND = 5 / 60,
  POETRY_RECOVERY_IN_DREAM_PER_SECOND = 5,
  MAX_GUARDS = 5,
  DAMAGE_MULTIPLIER = 1,
  SPEED_MULTIPLIER = 1,
  SLEEP_RESISTANCE = 10,
}}

TUNING.LING.MAX_GUARDS = 1
for k, v in pairs(TUNING.LING.ELITE) do
  TUNING.LING.MAX_GUARDS = math.max(TUNING.LING.MAX_GUARDS, v.MAX_GUARDS)
end

AddEliteLevelUpRecipes("ling", {{
  ingredients = {
    Ingredient("goldnugget", 30),
    Ingredient("papyrus", 5),
    Ingredient("tentaclespots", 10),
    Ingredient("honey", 3),
  },
  atlas = "images/inventoryimages/ling_elite.xml",
  image = "elite1.tex",
}, {
  ingredients = {
    Ingredient("goldnugget", 180),
    Ingredient("papyrus", 8),
    Ingredient("purebrilliance", 5),
    Ingredient("wagpunk_bits", 4),
  },
  atlas = "images/inventoryimages/ling_elite.xml",
  image = "elite2.tex",
}})
