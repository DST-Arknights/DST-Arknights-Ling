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

-- 精英化配方
AddCharacterRecipe("ling_elite_2", {
  Ingredient("goldnugget", 30),
  Ingredient("papyrus", 5),
  Ingredient("tentaclespots", 10),
  Ingredient("honey", 3),
}, TECH.MAGIC_TWO, {
  nounlock = true,
  atlas = "images/inventoryimages/ling_elite.xml",
  image = "elite1.tex",
  actionstr = "LING_ELITE_2",
  builder_tag = "ling_elite_1",
  manufactured = true,
})

-- 精英化配方
AddCharacterRecipe("ling_elite_3", {
  Ingredient("goldnugget", 180),
  Ingredient("papyrus", 8),
  Ingredient("purebrilliance", 5),
  Ingredient("wagpunk_bits", 4),
}, TECH.MAGIC_THREE, {
  nounlock = true,
  atlas = "images/inventoryimages/ling_elite.xml",
  image = "elite2.tex",
  actionstr = "LING_ELITE_3",
  builder_tag = "ling_elite_2",
  manufactured = true,
})

AddPrefabPostInit("researchlab4", function(self)
  if not TheWorld.ismastersim then
      return
  end
  local _onactivate = self.components.prototyper.onactivate
  self.components.prototyper.onactivate = function(inst, doer, recipe)
    if recipe.name == "ling_elite_2" then
      if doer.SetElite then
        doer:SetElite(2)
      else
        if doer.components.talker then
          doer.components.talker:Say(GetActionFailString(doer, 'BUILD', nil))
        end
      end
    end
    return _onactivate(inst, doer, recipe)
  end
end)

AddPrefabPostInit("researchlab3", function(self)
  if not TheWorld.ismastersim then
      return
  end
  local _onactivate = self.components.prototyper.onactivate
  self.components.prototyper.onactivate = function(inst, doer, recipe)
    if recipe.name == "ling_elite_3" or recipe.name == "ling_elite_2" then
      if doer.SetElite then
        if recipe.name == "ling_elite_2" then
          doer:SetElite(2)
        else
          doer:SetElite(3)
        end
      else
        if doer.components.talker then
          doer.components.talker:Say(GetActionFailString(doer, 'BUILD', nil))
        end
      end
    end
    return _onactivate(inst, doer, recipe)
  end
end)