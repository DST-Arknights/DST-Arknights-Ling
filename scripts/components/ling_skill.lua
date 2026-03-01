local ARK_CONSTANTS = require("ark_constants")
local skillConfig = {{
  id = 'skill1',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING[1],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING[1],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_1.tex",
  hotkey = KEY_Z,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.MANUAL,
  levels = {{
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[1][1],
    activationEnergy = 10,
    buffDuration = 25,
    config = {
      attackSpeed = 1.2,
      damageMultiplier = 1.2,
      poetryCost = 30 -- 消耗诗意值
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[1][2],
    activationEnergy = 50,
    buffDuration = 25,
    config = {
      attackSpeed = 1.38,
      damageMultiplier = 1.38,
      poetryCost = 25 -- 消耗诗意值
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[1][3],
    activationEnergy = 40,
    buffDuration = 25,
    config = {
      attackSpeed = 1.5,
      damageMultiplier = 1.5,
      poetryCost = 20 -- 消耗诗意值
    }
  }}
}, {
  id = 'skill2',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING[2],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING[2],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_2.tex",
  hotkey = KEY_X,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.AUTO,
  levels = {{
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[2][1],
    activationEnergy = 15,
    maxActivationStacks = 1,
    config = {
      damageMultiplier = 2.5,
      AOEarc = 3,
      shackleTime = 1.5,
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[2][2],
    activationEnergy = 3,
    -- activationEnergy = 10,
    maxActivationStacks = 2,
    config = {
      damageMultiplier = 3.7,
      AOEarc = 3,
      shackleTime = 2.5,
    }
  }}
}, {
  id = 'skill3',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING[3],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING[3],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_3.tex",
  hotkey = KEY_C,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.MANUAL,
  levels = {{
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING[3][1],
    activationEnergy = 30,
    buffDuration = 20,
    config = {
      damageMultiplier = 1.4,
      damageAbsorption = 0.6,
      poetryCost = 50 -- 消耗诗意值
    }
  }}
}}
local SKILL_STATUS = ARK_CONSTANTS.SKILL_STATUS

local LingSkill = Class(function(self, inst)
  self.inst = inst
  inst:AddComponent("ark_skill")
  for _, skill in ipairs(skillConfig) do
    inst.components.ark_skill:RegisterSkill(skill)
  end
  self:RegisterSkill()
end)

local function RegisterSkill1(self)
  local inst = self.inst
  local damageMultiplierSource = "ling_skill1"
  local skill1 = inst.components.ark_skill:GetSkill("skill1")
  skill1:SetActivateTest(function(target, targetPos, force)
    local poetry = inst.components.ling_poetry and inst.components.ling_poetry:GetCurrent()
    local cost = skill1:GetLevelConfig().poetryCost
    local allow = poetry >= cost
    if not allow then
      SayAndVoice(inst, "LING_SKILL_NOT_ENOUGH_POETRY")
    end
    return allow
  end)
  skill1:SetOnEffectsSync(function(inst, payload)
    local to = payload.to
    if to.status == SKILL_STATUS.BUFFING then
      -- 伤害增加
      local damageMultiplier = skill1:GetLevelConfig().damageMultiplier
      inst.components.combat.externaldamagemultipliers:SetModifier(inst, damageMultiplier, damageMultiplierSource)
      -- 攻速增加
      inst.components.combat.attackspeedmodifiers:SetModifier(inst, skill1:GetLevelConfig().attackSpeed,
        damageMultiplierSource)
      inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
        if guard.components.ling_guard_skill then
          guard.components.ling_guard_skill:ActivateSkill1(to.level)
        end
      end)
    end
  end)
  skill1:SetOnActive(function()
    -- 播放点音效什么的
    -- 扣除诗意
    local cost = skill1:GetLevelConfig().poetryCost
    inst.components.ling_poetry:Dirty(-cost)
  end)
  skill1:SetOnDeactivate(function()
    -- 伤害恢复
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, damageMultiplierSource)
    inst.components.combat.attackspeedmodifiers:RemoveModifier(inst, damageMultiplierSource)
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:DeactivateSkill1()
      end
    end)
  end)
end

local function UnregisterSkill1(self)
end
-- 束缚目标5秒
local function ShackleTarget(target, duration)
  if not target.components.immobilizable then
    target:AddComponent("immobilizable")
    target.components.immobilizable:AddImmobilizeFX("ling_aoe_attack_fx")
  end
  target.components.immobilizable:Immobilize(duration)
end

local AREAATTACK_EXCLUDETAGS = {"noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost",
  "ling_summon"}
local function RegisterSkill2(self)
  local inst = self.inst
  local damageMultiplierSource = "ling_skill2"
  local skill2 = inst.components.ark_skill:GetSkill("skill2")
  self.skill2_stack = 0
  skill2:SetOnActive(function()
    -- 伤害增加
    local damageMultiplier = skill2:GetLevelConfig().damageMultiplier
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, damageMultiplier, damageMultiplierSource)
    -- 设置为真实伤害
    inst.components.combat.truedamagemultipliers:SetModifier(inst, 1, damageMultiplierSource)
  end)
  skill2:SetOnDeactivate(function()
    -- 伤害恢复
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, damageMultiplierSource)
    -- 取消真实伤害
    inst.components.combat.truedamagemultipliers:RemoveModifier(inst, damageMultiplierSource)
  end)
  self._combat_DoAttack = self.inst.components.combat.DoAttack
  inst.components.combat.DoAttack = function(comp, targ, weapon, projectile, stimuli, instancemult, instrangeoverride,
    instpos)
    if self.skill2_unregistered then
      return
    end
    local weapon = inst.components.combat:GetWeapon()
    if weapon and weapon.prefab == "ling_lantern" then
      inst.components.ark_skill:GetSkill("skill2"):TryActivate()
    end
    self._combat_DoAttack(comp, targ, weapon, projectile, stimuli, instancemult, instrangeoverride, instpos)
    if skill2:IsActivating() then
      local x, y, z = targ.Transform:GetWorldPosition()
      local AOEarc = skill2:GetLevelConfig().AOEarc
      -- 排查所有友好目标
      local shackleTime = skill2:GetLevelConfig().shackleTime
      local targets = TheSim:FindEntities(x, y, z, AOEarc, {"_combat"}, AREAATTACK_EXCLUDETAGS)
      for _, target in ipairs(targets) do
         ShackleTarget(target, shackleTime)
      end
      inst.components.combat:DoAreaAttack(targ, AOEarc, weapon, nil, nil, AREAATTACK_EXCLUDETAGS)
    end
  end
end

local function UnregisterSkill2(self)
  self.skill2_unregistered = true
end

local function RegisterSkill3(self)
  local inst = self.inst
  local damageMultiplierSource = "ling_skill3"
  local skill3 = inst.components.ark_skill:GetSkill("skill3")
  skill3:SetActivateTest(function(target, targetPos, force)
    local poetry = inst.components.ling_poetry and inst.components.ling_poetry:GetCurrent()
    local cost = skill3:GetLevelConfig().poetryCost
    local allow = poetry >= cost
    if not allow then
      SayAndVoice(inst, "LING_SKILL_NOT_ENOUGH_POETRY")
    end
    return allow
  end)
  skill3:SetOnEffectsSync(function(inst, payload)
    local to = payload.to
    if to.status == SKILL_STATUS.BUFFING then
      -- 伤害增加
      local damageMultiplier = skill3:GetLevelConfig().damageMultiplier
      inst.components.combat.externaldamagemultipliers:SetModifier(inst, damageMultiplier, damageMultiplierSource)
      -- 护甲增加
      local damageTakenMultiplier = skill3:GetLevelConfig().damageTakenMultiplier
      inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, damageTakenMultiplier,
        damageMultiplierSource)
        inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
          if guard.components.ling_guard_skill then
            guard.components.ling_guard_skill:ActivateSkill3(to.level)
          end
        end)
    end
  end)
  skill3:SetOnActive(function()
    -- 播放点音效什么的
    -- 扣除诗意
    local cost = skill3:GetLevelConfig().poetryCost
    inst.components.ling_poetry:Dirty(-cost)
  end)
  skill3:SetOnDeactivate(function()
    -- 伤害恢复
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, damageMultiplierSource)
    -- 护甲恢复
    inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, damageMultiplierSource)
    -- 通知所有守卫取消技能3
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:DeactivateSkill3()
      end
    end)
  end)
end

local function UnregisterSkill3(inst)
end

function LingSkill:RegisterSkill()
  RegisterSkill1(self)
  RegisterSkill2(self)
  RegisterSkill3(self)
end

function LingSkill:OnRemoveFromEntity()
  self.inst:RemoveComponent("ark_skill")
  UnregisterSkill1(self)
  UnregisterSkill2(self)

end

return LingSkill
