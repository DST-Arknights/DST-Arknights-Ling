local ling_targeting = require("ling_targeting")

local skillConfig = {{
  id = 'skill1',
  levels = {{
    damageMultiplier = 1.2,
    attackSpeed = 1.2
  }, {
    damageMultiplier = 1.38,
    attackSpeed = 1.38
  }, {
    damageMultiplier = 1.5,
    attackSpeed = 1.5
  }}
}, {
  id = 'skill3',
  levels = {{
    damageMultiplier = 1.4,
    damageAbsorption = 0.6,
    auraRange = 2,
    auraDamageOwnerPercent = 0.2,
    auraInterval = 0.5
  }}
}}

local function GetSkillConfig(id)
  for _, skill in ipairs(skillConfig) do
    if skill.id == id then
      return skill
    end
  end
  return nil
end

local SKILL1_DAMAGE_SOURCE = "ling_skill_1"
local SKILL3_DAMAGE_SOURCE = "ling_skill_3"
local LingGuardSkill = Class(function(self, inst)
  self.inst = inst
  self.active_skills = {}
  for _, skill in ipairs(skillConfig) do
    self.active_skills[skill.id] = false
  end
end)

function LingGuardSkill:ActivateSkill1(level)
  local id = 'skill1'
  local config = GetSkillConfig(id).levels[level]
  if not config then
    return false
  end
  self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, config.damageMultiplier,
    SKILL1_DAMAGE_SOURCE)
  self.inst.components.combat.attackspeedmodifiers:SetModifier(self.inst, config.attackSpeed, SKILL1_DAMAGE_SOURCE)
  self.active_skills[id] = true
  return true
end

function LingGuardSkill:DeactivateSkill1()
  local id = 'skill1'
  self.inst.components.combat.externaldamagemultipliers:RemoveModifier(self.inst, SKILL1_DAMAGE_SOURCE)
  self.inst.components.combat.attackspeedmodifiers:RemoveModifier(self.inst, SKILL1_DAMAGE_SOURCE)
  self.active_skills[id] = false
end

function LingGuardSkill:ActivateSkill3(level)
  ArkLogger:Debug("LingGuardSkill:ActivateSkill3", self.inst, level)
  local id = 'skill3'
  local config = GetSkillConfig(id).levels[level]
  if not config then
    return false
  end
  self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, config.damageMultiplier,
    SKILL3_DAMAGE_SOURCE)
  self.inst.components.combat.externaldamagetakenmultipliers:SetModifier(self.inst, config.damageAbsorption,
    SKILL3_DAMAGE_SOURCE)
  self:StartAuraDamage(function()
    return config.auraDamageOwnerPercent * self:GetOwnerAttackDamage()
  end, config.auraInterval, config.auraRange)
  self.active_skills[id] = true
end

function LingGuardSkill:DeactivateSkill3()
  local id = 'skill3'
  self.inst.components.combat.externaldamagemultipliers:RemoveModifier(self.inst, SKILL3_DAMAGE_SOURCE)
  self.inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(self.inst, SKILL3_DAMAGE_SOURCE)
  self:StopAuraDamage()
  self.active_skills[id] = false
end

function LingGuardSkill:DoAuraDamage(damage, range)
  damage = FunctionOrValue(damage, self.inst)
  if damage <= 0 then
    return
  end
  local x, y, z = self.inst.Transform:GetWorldPosition()
  local ents = TheSim:FindEntities(x, y, z, range or 2, {"_combat"},
    {"playerghost", "INLIMBO", "player", "companion", "wall", "ling_summon"})
  for _, target in ipairs(ents) do
    -- if ling_targeting.IsThreatToGuard(self.inst, target) then
      ArkLogger:Debug("LingGuardSkill:DoAuraDamage attacking", target, damage)
    target.components.combat:GetAttacked(self.inst, damage, nil, "ling_skill_3_aura")
    -- end
  end
end

function LingGuardSkill:StartAuraDamage(damage, interval, range)
  self:StopAuraDamage()
  local fx = SpawnPrefab("ling_guard_skill_halo_fx")
  fx.entity:SetParent(self.inst.entity)
  self._auraFx = fx
  self._auraTask = self.inst:DoPeriodicTask(interval, function()
    self:DoAuraDamage(damage, range)
  end)
end

function LingGuardSkill:StopAuraDamage()
  if self._auraFx then
    self._auraFx:Remove()
    self._auraFx = nil
  end
  if self._auraTask then
    self._auraTask:Cancel()
    self._auraTask = nil
  end
end

-- 获取令的攻击力
function LingGuardSkill:GetOwnerAttackDamage()
  local owner = self.inst.components.follower.leader
  if not owner or not owner.components.combat then
    return 0
  end

  -- 获取武器
  local weapon = owner.components.combat:GetWeapon()

  -- 计算基础伤害（模拟CalcDamage的逻辑，但不需要目标）
  local basedamage = 0
  local basemultiplier = owner.components.combat.damagemultiplier or 1
  local externaldamagemultipliers = owner.components.combat.externaldamagemultipliers
  local bonus = owner.components.combat.damagebonus or 0

  if weapon and weapon.components.weapon then
    -- 使用武器伤害
    basedamage = FunctionOrValue(weapon.components.weapon.damage, weapon, owner, nil)
  else
    -- 使用默认伤害
    basedamage = owner.components.combat.defaultdamage or 0
  end

  -- 计算最终伤害
  local damage = basedamage * basemultiplier * (externaldamagemultipliers and externaldamagemultipliers:Get() or 1)
                   + bonus

  return math.max(0, damage)
end

function LingGuardSkill:DeactivateAllSkills()
  self:DeactivateSkill1()
  self:DeactivateSkill3()
end

function LingGuardSkill:SyncWithOwner()
  local leader = self.inst.components.follower.leader
  if not leader or not leader:IsValid() then
    return
  end
  if not leader.components.ark_skill then
    return
  end
  local leaderSkill1 = leader.components.ark_skill:GetSkill("skill1")
  if leaderSkill1:IsActivating() then
    local level = leaderSkill1:GetLevel()
    self:ActivateSkill1(level)
  else
    self:DeactivateSkill1()
  end
  local leaderSkill3 = leader.components.ark_skill:GetSkill("skill3")
  if leaderSkill3:IsActivating() then
    local level = leaderSkill3:GetLevel()
    self:ActivateSkill3(level)
  else
    self:DeactivateSkill3()
  end
end

-- 组件移除时清理
function LingGuardSkill:OnRemoveFromEntity()
  self:DeactivateAllSkills()
  self:StopAuraDamage()
end

return LingGuardSkill
