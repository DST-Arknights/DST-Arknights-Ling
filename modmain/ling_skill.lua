local ARK_CONSTANTS = require("ark_constants")

RegisterControlDefinition("ling_skill2_shackle", {
  duration = 1.5,
  fx = "ling_aoe_attack_fx",
})

local function CommonActivateTest(skill)
  local inst = skill.inst
  if not inst.components.ling_poetry then
    return true
  end
  local poetry = inst.components.ling_poetry:GetCurrent()
  local cost = skill:GetLevelParams().poetryCost or 0
  if poetry < cost then
    return false, "LING_SKILL_NOT_ENOUGH_POETRY"
  end
  return true
end

local function CommonTryCostPoetry(skill)
  local inst = skill.inst
  local cost = skill:GetLevelParams().poetryCost or 0
  if cost > 0 and inst.components.ling_poetry then
    inst.components.ling_poetry:Dirty(-cost)
  end
end

local function OnSkill1Activate(skill)
  local inst = skill.inst
  SayAndVoice(inst, "LING_SKILL1")
  -- 扣除诗意
  CommonTryCostPoetry(skill)
end

local SKILL1_DAMAGE_MULTIPLIER_SOURCE = "ling_skill1"
local function OnSkill1ActivateEffect(skill)
  local inst = skill.inst
  -- 伤害增加
  inst.components.combat.externaldamagemultipliers:SetModifier(inst, skill:GetLevelParams().damageMultiplier,
    SKILL1_DAMAGE_MULTIPLIER_SOURCE)
  -- 攻速增加
  inst.components.combat.attackspeedmodifiers:SetModifier(inst, skill:GetLevelParams().attackSpeed,
    SKILL1_DAMAGE_MULTIPLIER_SOURCE)
  if inst.components.ling_summon_manager then
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:ActivateSkill1(skill:GetLevel())
      end
    end)
  end
end

local function OnSkill1Deactivate(skill)
  local inst = skill.inst
  -- 伤害恢复
  inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL1_DAMAGE_MULTIPLIER_SOURCE)
  inst.components.combat.attackspeedmodifiers:RemoveModifier(inst, SKILL1_DAMAGE_MULTIPLIER_SOURCE)
  if inst.components.ling_summon_manager then
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:DeactivateSkill1()
      end
    end)
  end
end

local AREAATTACK_EXCLUDETAGS = { "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost",
  "ling_summon" }
local function OnSkill2Install(skill)
  if skill.inst.components.combat then
    skill:HookFunction(skill.inst.components.combat, "DoAttack", function (next, self, target, weapon, ...)
      local weapon = weapon or self.inst.components.combat:GetWeapon()
      local activated = false
      if weapon and weapon.prefab == "ling_lantern" then
        activated = skill:TryActivate()
      end
      next(self, target, weapon, ...)
      if activated then
        local x, y, z = target.Transform:GetWorldPosition()
        local params = skill:GetLevelParams()
        local AOEarc = params.AOEarc
        local shackleTime = params.shackleTime
        local targets = TheSim:FindEntities(x, y, z, AOEarc, { "_combat" }, AREAATTACK_EXCLUDETAGS)
        for _, target in ipairs(targets) do
          ApplyControl(target, "ling_skill2_shackle", shackleTime)
        end
        self.inst.components.combat:DoAreaAttack(target, AOEarc, weapon, nil, nil, AREAATTACK_EXCLUDETAGS)
      end
    end)
  end
end

local SKILL2_DAMAGE_MULTIPLIER_SOURCE = "ling_skill2"
local function OnSkill2Activate(skill)
  local inst = skill.inst
  SayAndVoice(inst, "LING_SKILL2")
  -- 伤害增加
  local damageMultiplier = skill:GetLevelParams().damageMultiplier
  inst.components.combat.externaldamagemultipliers:SetModifier(inst, damageMultiplier, SKILL2_DAMAGE_MULTIPLIER_SOURCE)
  -- 设置为真实伤害
  inst.components.combat.truedamagemultipliers:SetModifier(inst, 1, SKILL2_DAMAGE_MULTIPLIER_SOURCE)
end

local function OnSkill2Deactivate(skill)
  local inst = skill.inst
  -- 伤害恢复
  inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL2_DAMAGE_MULTIPLIER_SOURCE)
  -- 取消真实伤害
  inst.components.combat.truedamagemultipliers:RemoveModifier(inst, SKILL2_DAMAGE_MULTIPLIER_SOURCE)
end

local function OnSkill3Activate(skill)
  local inst = skill.inst
  local voice = { "LING_SKILL3_1", "LING_SKILL3_2" }
  local voiceIndex = math.random(1, #voice)
  SayAndVoice(inst, voice[voiceIndex])
  -- 扣除诗意
  CommonTryCostPoetry(skill)
end

local SKILL3_DAMAGE_MULTIPLIER_SOURCE = "ling_skill3"
local function OnSkill3ActivateEffect(skill)
  local inst = skill.inst
  local level = skill:GetLevel()
  -- 伤害增加
  local damageMultiplier = skill:GetLevelParams().damageMultiplier
  inst.components.combat.externaldamagemultipliers:SetModifier(inst, damageMultiplier, SKILL3_DAMAGE_MULTIPLIER_SOURCE)
  -- 护甲增加
  local damageTakenMultiplier = skill:GetLevelParams().damageTakenMultiplier
  inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, damageTakenMultiplier,
    SKILL3_DAMAGE_MULTIPLIER_SOURCE)
  if inst.components.ling_summon_manager then
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:ActivateSkill3(level)
      end
    end)
  end
end

local function OnSkill3Deactivate(skill)
  local inst = skill.inst
  -- 伤害恢复
  inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL3_DAMAGE_MULTIPLIER_SOURCE)
  -- 护甲恢复
  inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, SKILL3_DAMAGE_MULTIPLIER_SOURCE)
  -- 通知所有守卫取消技能3
  if inst.components.ling_summon_manager then
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:DeactivateSkill3()
      end
    end)
  end
end

local skillConfig = { {
  id = 'ling_skill1',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING[1],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING[1],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_1.tex",
  hotkey = KEY_Z,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.MANUAL,
  ActivateTest = CommonActivateTest,
  OnActivateEffect = OnSkill1ActivateEffect,
  OnActivate = OnSkill1Activate,
  OnDeactivate = OnSkill1Deactivate,
  levels = { {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[1][1],
    activationEnergy = 60,
    buffDuration = 25,
    params = {
      attackSpeed = 1.2,
      damageMultiplier = 1.2,
      poetryCost = 15 -- 消耗诗意值
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[1][2],
    activationEnergy = 50,
    buffDuration = 25,
    params = {
      attackSpeed = 1.38,
      damageMultiplier = 1.38,
      poetryCost = 13 -- 消耗诗意值
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[1][3],
    activationEnergy = 40,
    buffDuration = 25,
    params = {
      attackSpeed = 1.5,
      damageMultiplier = 1.5,
      poetryCost = 10 -- 消耗诗意值
    }
  } }
}, {
  id = 'ling_skill2',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING[2],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING[2],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_2.tex",
  hotkey = KEY_X,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.AUTO,
  OnInstall = OnSkill2Install,
  OnActivate = OnSkill2Activate,
  OnDeactivate = OnSkill2Deactivate,
  levels = { {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[2][1],
    activationEnergy = 15,
    maxActivationStacks = 1,
    params = {
      damageMultiplier = 2.5,
      AOEarc = 3,
      shackleTime = 1.5,
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[2][2],
    activationEnergy = 10,
    maxActivationStacks = 2,
    params = {
      damageMultiplier = 3.7,
      AOEarc = 3,
      shackleTime = 2.5,
    }
  } }
}, {
  id = 'ling_skill3',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING[3],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING[3],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_3.tex",
  hotkey = KEY_C,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.MANUAL,
  ActivateTest = CommonActivateTest,
  OnActivateEffect = OnSkill3ActivateEffect,
  OnActivate = OnSkill3Activate,
  OnDeactivate = OnSkill3Deactivate,
  levels = { {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[3][1],
    activationEnergy = 30,
    buffDuration = 20,
    params = {
      damageMultiplier = 1.4,
      damageAbsorption = 0.6,
      poetryCost = 18 -- 消耗诗意值
    }
  } }
} }

for _, skill in ipairs(skillConfig) do
  RegisterArkSkill(skill)
end
