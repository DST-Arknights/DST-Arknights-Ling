local skillConfig = require("ling_skill_config")

local ATTACK_RECOVERY_ENERGY = 1

local LingSkill = Class(function(self, inst)
  self.inst = inst
  inst:AddComponent("ark_skill")
  for _, skill in ipairs(skillConfig) do
    inst.components.ark_skill:RegisterSkill(skill)
  end
  self:RegisterSkill()
  -- 解锁第一个技能
  inst.components.ark_skill:GetSkill(skillConfig[1].id):Unlock()
end)

local function RegisterSkill1(self)
  local inst = self.inst
  local damageMultiplierSource = "ling_skill1"
  local skill1 = inst.components.ark_skill:GetSkill("skill1")
  skill1:SetOnActive(function()
    -- 伤害增加
    local damageMultiplier = skill1:GetLevelConfig().damageMultiplier
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, damageMultiplier, damageMultiplierSource)
    inst.components.combat.attackspeedmodifiers:SetModifier(inst, skill1:GetLevelConfig().attackSpeed,
      damageMultiplierSource)
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:ActivateSkill(1)
      end
    end)
  end)
  skill1:SetOnDeactivate(function()
    -- 伤害恢复
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, damageMultiplierSource)
    inst.components.combat.attackspeedmodifiers:RemoveModifier(inst, damageMultiplierSource)
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:DeactivateSkill(1)
      end
    end)
  end)
end

local function UnregisterSkill1(self)
end
-- 束缚目标5秒
local function ShackleTarget(target, duration)
  if target.components.locomotor then
    if not target:IsValid() then
      return
    end
    local effectiveName = "ling_skill2_shackle"
    -- 设置移动速度为0（完全束缚）
    target.components.locomotor:SetExternalSpeedMultiplier(target, effectiveName, 0)

    -- 创建束缚特效
    -- TODO: 替换为真实特效
    local fx = SpawnPrefab("spat_splat_fx")
    fx.entity:SetParent(target.entity)
    fx.Transform:SetPosition(0, 0, 0)

    -- 定时解除束缚
    target:DoTaskInTime(duration, function()
      if target:IsValid() then
        target.components.locomotor:RemoveExternalSpeedMultiplier(target, effectiveName)
        if fx and fx:IsValid() then
          fx:Remove()
        end
      end
    end)
  end
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
    inst.components.combat:EnableTrueDamage()
  end)
  skill2:SetOnDeactivate(function()
    -- 伤害恢复
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, damageMultiplierSource)
    -- 取消真实伤害
    inst.components.combat:DisableTrueDamage()
  end)
  -- hook
  self._combat_StartAttack = self.inst.components.combat.StartAttack
  self.skill2_unregistered = false
  inst.components.combat.StartAttack = function(comp)
    self._combat_StartAttack(comp)
    if self.skill2_unregistered then
      return
    end
    local weapon = inst.components.combat:GetWeapon()
    if weapon and weapon.prefab == "ling_lantern" then
      -- 尝试触发2技能,
      ArkLogger:Debug("ling_skill", "ling_skill2: TryActivate")
      inst.components.ark_skill:GetSkill("skill2"):TryActivate()
    end
  end
  self._combat_DoAttack = self.inst.components.combat.DoAttack
  inst.components.combat.DoAttack = function(comp, targ, weapon, projectile, stimuli, instancemult, instrangeoverride,
    instpos)
    self._combat_DoAttack(comp, targ, weapon, projectile, stimuli, instancemult, instrangeoverride, instpos)
    if self.skill2_unregistered then
      return
    end
    if skill2:IsActivating() then
      local x, y, z = targ.Transform:GetWorldPosition()
      local AOEarc = skill2:GetLevelConfig().AOEarc
      -- 排查所有友好目标
      local fx = SpawnPrefab("ling_guard_skill_halo_fx")
      fx.Transform:SetPosition(x, 1, z)
      local shackleTime = skill2:GetLevelConfig().shackleTime
      local targets = TheSim:FindEntities(x, y, z, AOEarc, {"_combat"}, AREAATTACK_EXCLUDETAGS)
      for _, target in ipairs(targets) do
        -- TODO: 更多的过滤条件
        if target ~= inst then
          ShackleTarget(target, shackleTime)
        end
      end
      ShackleTarget(targ, shackleTime)
      inst.components.combat:DoAreaAttack(targ, AOEarc, weapon, nil, nil, nil)
    end
  end
end

local function UnregisterSkill2(self)
  self.skill2_unregistered = true
  if self._combat_StartAttack == self.inst.components.combat.StartAttack then
    self.inst.components.combat.StartAttack = self._combat_StartAttack
    self._combat_StartAttack = nil
  end
end

local function RegisterSkill3(self)
  local inst = self.inst
  local damageMultiplierSource = "ling_skill3"
  local skill3 = inst.components.ark_skill:GetSkill("skill3")
  skill3:SetOnActive(function()
    -- 伤害增加
    local damageMultiplier = skill3:GetLevelConfig().damageMultiplier
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, damageMultiplier, damageMultiplierSource)
    -- 护甲增加
    local damageTakenMultiplier = skill3:GetLevelConfig().damageTakenMultiplier
    inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, damageTakenMultiplier,
      damageMultiplierSource)
    -- 通知所有守卫激活技能3（守卫组件自行决定是否启用）
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:ActivateSkill(3)
      end
    end)
  end)
  skill3:SetOnDeactivate(function()
    -- 伤害恢复
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, damageMultiplierSource)
    -- 护甲恢复
    inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, damageMultiplierSource)
    -- 通知所有守卫取消技能3
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:DeactivateSkill(3)
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
