GLOBAL.setmetatable(env, {
  __index = function(t, k)
    return GLOBAL.rawget(GLOBAL, k)
  end
})
local common = require("ark_ling_common")

-- 加载语言文件
common.LoadPOFile("scripts/languages/ling_chinese_s.po", "zh")

PrefabFiles = {'ling', 'ling_lantern', 'ling_lantern_smoke' }
Assets = {
  Asset('ATLAS', 'images/saveslot_portraits/ling.xml'),
  Asset('ATLAS', 'images/selectscreen_portraits/ling.xml'),
  Asset('ATLAS', 'images/map_icons/ling.xml'),
  Asset('ATLAS', 'images/avatars/avatar_ling.xml'),
  Asset('ATLAS', 'images/avatars/avatar_ghost_ling.xml'),
  Asset('ATLAS', 'images/avatars/self_inspect_ling.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_lantern.xml'),
  Asset('ATLAS', 'bigportraits/ling.xml'),
  Asset('ATLAS', 'images/names_ling.xml'),
  Asset('ANIM', 'anim/ling.zip'),
  Asset('ANIM', 'anim/ling_poetry.zip'),
  Asset('ANIM', 'anim/ling_lantern.zip'),
  Asset('ANIM', 'anim/swap_ling_lantern_stick.zip'),
}

AddMinimapAtlas('images/map_icons/ling.xml')
AddModCharacter("ling", "FEMALE")
AddReplicableComponent("ling_poetry")

-- 常量配置
TUNING.LING = {
  ELITE = {{
    MAX_HEALTH = 50,
    MAX_HUNGER = 150,
    MAX_SANITY = 250,
    MAX_POETRY = 30,
    POETRY_RECOVERY_WHILE_IDLE_PER_SECOND = 5 / 60,
    POETRY_RECOVERY_IN_DREAM_PER_SECOND = 1,
  }, {
    MAX_HEALTH = 80,
    MAX_HUNGER = 50,
    MAX_SANITY = 250,
    MAX_POETRY = 60,
    POETRY_RECOVERY_WHILE_IDLE_PER_SECOND = 5 / 60,
    POETRY_RECOVERY_IN_DREAM_PER_SECOND = 3,
  }, {
    MAX_HEALTH = 120,
    MAX_HUNGER = 150,
    MAX_SANITY = 300,
    MAX_POETRY = 100,
    POETRY_RECOVERY_WHILE_IDLE_PER_SECOND = 5 / 60,
    POETRY_RECOVERY_IN_DREAM_PER_SECOND = 5,
  }}
}

-- 诗意值ui
AddClassPostConstruct("widgets/statusdisplays", function(self)
  if not self.owner or self.owner.prefab ~= "ling" then
    return
  end
  local LingPoetryBadge = require "widgets/ling_poetry"
  self.ling_poetry = self:AddChild(LingPoetryBadge(self.owner))
  self.owner:DoTaskInTime(.5, function(owner)
    local heartX, heartY = self.heart:GetPosition():Get()
    local brainX, brainY = self.brain:GetPosition():Get()
    local stomachX, stomachY = self.stomach:GetPosition():Get()
    local offsetX = stomachX - heartX
    if brainY == heartY or brainY == stomachY then
      if self.heart:GetScale().x / self.ling_poetry:GetScale().x ~= 1 then
        self.ling_poetry:SetScale(self.heart:GetScale())
      end
      offsetX = stomachX - brainX
    end
    self.ling_poetry:SetPosition(stomachX + offsetX, stomachY, 0)
  end)
  local _SetGhostMode = self.SetGhostMode
  function self:SetGhostMode(ghost_mode, ...)
    _SetGhostMode(self, ghost_mode, ...)
    if ghost_mode then
      self.ling_poetry:Hide()
    else
      self.ling_poetry:Show()
    end
  end
end)

-- 精英化配方
AddCharacterRecipe("ling_elite_2", {
  Ingredient("goldnugget", 30),
  Ingredient("papyrus", 5),
  Ingredient("tentaclespots", 10),
  Ingredient("honey", 3),
}, TECH.MAGIC_TWO, {
  nounlock = true,
  -- TODO: 修正图像
  atlas = "images/map_icons/ling.xml",
  image = "ling.tex",
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
  -- TODO: 修正图像
  atlas = "images/map_icons/ling.xml",
  image = "ling.tex",
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