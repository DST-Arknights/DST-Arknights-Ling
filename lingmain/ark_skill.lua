
local common = require("ark_common_ling")
local CONSTANTS = require("ark_constants_ling")

-- 安装技能
AddModRPCHandler("arkSkill_ling", "RequestSyncSkillStatus", function(player, idx)
  if player and player.components.ark_skill_ling then
    player.components.ark_skill_ling:RequestSyncSkillStatus(idx)
  end
end)

AddClientModRPCHandler("arkSkill_ling", "SyncSkillStatus", function (skillIndex, ...)
  if not ThePlayer then
    return
  end
  local arkSkillUi = ThePlayer.HUD.controls.arkSkillUi_ling
  if not arkSkillUi then
    return
  end
  local skillUi = arkSkillUi:GetSkill(skillIndex)
  print('SyncSkillStatus', skillIndex, ...)
  -- local oldLevel = skillUi.level
  skillUi:SyncSkillStatus(...)
  -- ThePlayer:PushEvent("refreshcrafting")
end)


AddModRPCHandler("arkSkill_ling", "ManualActivateSkill", function(player, skillIndex)
  if player and player.components.ark_skill_ling then
    player.components.ark_skill_ling:ManualActivateSkill(skillIndex)
  end
end)



AddModRPCHandler("arkSkill_ling", "ManualCancelSkill", function(player, skillIndex)
  if player and player.components.ark_skill_ling then
    player.components.ark_skill_ling:ManualCancelSkill(skillIndex)
  end
end)


local function getStorageKey(player)
  return "ark_skill_local_hot_key_ling" .. player.userid .. player.prefab
end

local function SetupArkSkillHotKey(config)
  local hotKeyManager = {
    default = {},  -- 默认热键配置
    custom = nil,   -- 自定义热键配置
  }

  -- 保存默认热键配置
  for i, skillConfig in pairs(config.skills) do
    hotKeyManager.default[i] = skillConfig.hotKey
  end

  -- 保存自定义热键
  function ThePlayer:SaveArkSkillLocalHotKey(idx, hotKey)
    hotKeyManager.custom = hotKeyManager.custom or {}

    if hotKey == nil then
      table.remove(hotKeyManager.custom, idx)
    else
      hotKeyManager.custom[idx] = hotKey
    end

    TheSim:SetPersistentString(getStorageKey(ThePlayer),
      json.encode(hotKeyManager.custom), false)
  end

  -- 获取热键配置
  function ThePlayer:GetArkSkillLocalHotKey(idx)
    return config.skills[idx].hotKey
  end

  -- 加载自定义热键配置
  function ThePlayer:LoadArkSkillLocalHotKey()
    TheSim:GetPersistentString(getStorageKey(ThePlayer),
      function(load_success, str)
        if not load_success then
          hotKeyManager.custom = {}
          return
        end

        local ok, data = pcall(json.decode, str)
        if not ok then
          hotKeyManager.custom = {}
          return
        end

        hotKeyManager.custom = data
      end)
  end

  -- 刷新热键配置
  function ThePlayer:RefreshArkSkillLocalHotKey()
    -- 恢复默认热键
    for i, hotKey in pairs(hotKeyManager.default) do
      config.skills[i].hotKey = hotKey
    end

    -- 应用自定义热键
    if not hotKeyManager.custom then return end

    for i, hotKey in pairs(hotKeyManager.custom) do
      if config.skills[i] then
        config.skills[i].hotKey = hotKey
      end
    end
  end
end

local arkSkillLevelUpImages = {}

AddClientModRPCHandler("arkSkill_ling", "SetupArkSkillUi", function(config)
  if not config or not ThePlayer or not ThePlayer.HUD or ThePlayer.HUD.controls.arkSkillUi_ling then
    return
  end
  local config = json.decode(config)
  local controls = ThePlayer.HUD.controls
  local ArkSkillUi = require "widgets/ark_skill_ui_ling"
  local arkSkillUi = controls.inv.hand_inv:AddChild(ArkSkillUi(ThePlayer, config))
  controls.arkSkillUi_ling = arkSkillUi
  arkSkillUi:SetPosition(config.position or Vector3(-840, 80, 0))
  arkSkillUi:SetScale(.5, .5, .5)
  arkSkillUi:MoveToBack()
  -- 安装本地热键方法
  SetupArkSkillHotKey(config)
  ThePlayer:LoadArkSkillLocalHotKey()
  ThePlayer:RefreshArkSkillLocalHotKey()

  local function findSkillHotKeyIndex(hotKey, skillConfigs)
    for i, config in pairs(skillConfigs) do
      if config.hotKey == hotKey then
        return i
      end
    end
  end
  -- 替换高清资源
  for _, skill in pairs(config.skills) do
    local resolveAtlas = resolvefilepath(skill.atlas)
    if not arkSkillLevelUpImages[resolveAtlas] then
      arkSkillLevelUpImages[resolveAtlas] = {}
    end
    arkSkillLevelUpImages[resolveAtlas][skill.image] = true
  end

  -- 安装热键
  local _OnRawKey = ThePlayer.HUD.OnRawKey
  function ThePlayer.HUD:OnRawKey(key, down)
    if not down then
      return _OnRawKey(self, key, down)
    end
    if ThePlayer.HUD._settingSkillHotKeyCallback then
      -- 检查是否有冲突
      local conflictIndex = findSkillHotKeyIndex(key, config.skills)
      ThePlayer.HUD._settingSkillHotKeyCallback(key, conflictIndex)
      return true
    end
    local skillIndex = findSkillHotKeyIndex(key, config.skills)
    if not skillIndex then
      return _OnRawKey(self, key, down)
    end
    local skill = arkSkillUi:GetSkill(skillIndex)
    skill:TryActivateSkill()
    return true
  end
end)

-- 修改技能升级图标的尺寸, 维持高清
AddClassPostConstruct("widgets/spinner", function(self)
  local SetSelectedIndex = self.SetSelectedIndex
  function self:SetSelectedIndex(index)
    SetSelectedIndex(self, index)
    local fgimage = self.fgimage
    local atlas = fgimage.atlas
    local texture = fgimage.texture
    if arkSkillLevelUpImages[atlas] and arkSkillLevelUpImages[atlas][texture] then
      fgimage:SetSize(60, 60)
    end
  end
end)

local function SetupArkSkillConfig(prefab, config)
  TUNING.ARK_SKILL[string.upper(prefab)] = config
  local skills = config.skills
  -- for i, skill in ipairs(skills) do
  --   if i > CONSTANTS.MAX_SKILL_LIMIT then
  --     break
  --   end

  --   for j, levelConfig in ipairs(skill.levels) do
  --     if j > CONSTANTS.MAX_SKILL_LEVEL then
  --       break
  --     end
  --     if j ~= 1 then
  --       local prefabName = common.genArkSkillLevelUpPrefabName(i, j)
  --       local ingredients = levelConfig.ingredients or { Ingredient("goldnugget", 1) }
  --       local tag = common.genArkSkillLevelTag(i, j - 1)
  --       AddCharacterRecipe(prefabName, ingredients, TECH.ARK_TRAINING_ONE, {
  --         nounlock = true,
  --         atlas = skill.atlas,
  --         image = skill.image,
  --         actionstr = j <= 7 and "ARK_SKILL_UPDATE" or "ARK_SKILL_SPECIALIZATION",
  --         builder_tag = tag,
  --         manufactured = true,
  --       })
  --       local upperName = string.upper(prefabName)
  --       STRINGS.NAMES[upperName] = STRINGS.UI.ARK_SKILL.SKILL .. " " .. skill.name
  --       local currentLevel = STRINGS.UI.ARK_SKILL.LEVEL[tostring(j-1)] or tostring(j-1)
  --       local nextLevel = STRINGS.UI.ARK_SKILL.LEVEL[tostring(j)] or tostring(j)
  --       local desc = STRINGS.UI.ARK_SKILL.CURRENT_LEVEL .. " " .. " " .. currentLevel .. "\n" .. (STRINGS.UI.ARK_SKILL.NEXT_LEVEL .. " " .. nextLevel)
  --       STRINGS.RECIPE_DESC[upperName] = desc
  --     end
  --   end
  -- end
end

SetupArkSkillConfig("ling", {
  skills = {{
    name = STRINGS.UI.ARK_SKILL.NAMES.LING["1"],
    lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING["1"],
    atlas = "images/ling_skill.xml",
    image = "skill_icon_skchr_ling_1.tex",
    hotKey = KEY_Z,
    energyRecoveryMode = CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
    activationMode = CONSTANTS.ACTIVATION_MODE.MANUAL,
    unlock = true,
    bullet = false,
    levels = {{
      desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["1"]["1"],
      energy = 60,
      buffTime = 25,
      attackSpeed = 1.2,
      damageMultiplier = 1.2,
      trueDamage = true,
      affectGuards = true, -- 技能1影响守卫
    }, {
      desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["1"]["2"],
      energy = 50,
      buffTime = 25,
      attackSpeed = 1.38,
      damageMultiplier = 1.38,
      trueDamage = true,
      affectGuards = true, -- 技能1影响守卫
    }, {
      desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["1"]["3"],
      energy = 40,
      buffTime = 25,
      attackSpeed = 1.5,
      damageMultiplier = 1.5,
      trueDamage = true,
      affectGuards = true, -- 技能1影响守卫
    }},
  }, {
    name = STRINGS.UI.ARK_SKILL.NAMES.LING["2"],
    lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING["2"],
    atlas = "images/ling_skill.xml",
    image = "skill_icon_skchr_ling_2.tex",
    hotKey = KEY_X,
    energyRecoveryMode = CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
    activationMode = CONSTANTS.ACTIVATION_MODE.AUTO,
    levels = {{
      desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["2"]["1"],
      energy = 15,
      maxActivationStacks = 1,
      damageMultiplier = 2.5,
      AOEarc = 3,
      -- 束缚时长
      shackleTime = 1.5,
      trueDamage = true,
      affectGuards = false, -- 技能2不影响守卫
    }, {
      desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["2"]["2"],
      energy = 10,
      maxActivationStacks = 2,
      damageMultiplier = 3.7,
      AOEarc = 3,
      -- 束缚时长
      shackleTime = 2.5,
      trueDamage = true,
      affectGuards = false, -- 技能2不影响守卫
    }},
  }, {
    name = STRINGS.UI.ARK_SKILL.NAMES.LING["3"],
    lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING["3"],
    atlas = "images/ling_skill.xml",
    image = "skill_icon_skchr_ling_3.tex",
    hotKey = KEY_C,
    energyRecoveryMode = CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
    activationMode = CONSTANTS.ACTIVATION_MODE.MANUAL,
    levels = {{
      desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["3"]["1"],
      energy = 30,
      buffTime = 30,
      damageMultiplier = 1.4,
      damageAbsorption = 0.6,
      affectGuards = true, -- 技能3影响守卫
    }},
  }}
})
