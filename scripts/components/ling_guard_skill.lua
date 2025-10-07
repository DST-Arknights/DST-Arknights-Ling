-- 召唤兽技能组件
-- 用于管理召唤兽受到令的技能影响
-- 组件自行管理技能配置，不依赖令的技能配置

local ling_targeting = require("ling_targeting")

local SKILL1_DAMAGE_SOURCE = "ling_skill_1"
local SKILL3_DAMAGE_SOURCE = "ling_skill_3"

-- 召唤兽技能配置（独立于令的技能配置）
local GUARD_SKILL_CONFIG = {
    [1] = {
        -- 技能1：攻击速度和伤害提升
        enabled = true,  -- 是否启用此技能
        damageMultiplier = 1.5,  -- 伤害倍率
        attackSpeed = 1.5,  -- 攻击速度
        trueDamage = true,  -- 真伤
    },
    [2] = {
        -- 技能2：不影响召唤兽
        enabled = false,
    },
    [3] = {
        -- 技能3：伤害和防御提升 + 伤害光环
        enabled = true,  -- 是否启用此技能
        damageMultiplier = 1.4,  -- 伤害倍率
        damageAbsorption = 0.6,  -- 伤害吸收
        auraRange = 2,  -- 光环范围
        auraDamagePercent = 0.2,  -- 光环伤害百分比（令攻击力的20%）
        auraInterval = 0.5,  -- 光环伤害间隔
    },
}

local LingGuardSkill = Class(function(self, inst)
    self.inst = inst

    -- 当前激活的技能状态
    self.active_skills = {
        [1] = false,
        [2] = false,
        [3] = false,
    }

    -- 技能特效引用
    self.skill_fx = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
    }

    -- 技能3光环相关
    self.skill3_aura_task = nil  -- 光环伤害任务
end)

-- 检查是否有主人
function LingGuardSkill:HasOwner()
    return self.inst.components.follower
        and self.inst.components.follower.leader
        and self.inst.components.follower.leader:IsValid()
end

-- 获取主人
function LingGuardSkill:GetOwner()
    if not self:HasOwner() then
        return nil
    end
    return self.inst.components.follower.leader
end

-- 获取技能配置
function LingGuardSkill:GetSkillConfig(skill_index)
    return GUARD_SKILL_CONFIG[skill_index]
end

-- 激活技能（统一接口）
function LingGuardSkill:ActivateSkill(skill_index)
    -- 检查技能是否启用
    local config = self:GetSkillConfig(skill_index)
    if not config or not config.enabled then
        return false
    end

    -- 检查是否已经激活
    if self.active_skills[skill_index] then
        return false
    end

    -- 根据技能索引调用对应的内部方法
    if skill_index == 1 then
        return self:ActivateSkill1()
    elseif skill_index == 3 then
        return self:ActivateSkill3()
    end

    return false
end

-- 取消技能（统一接口）
function LingGuardSkill:DeactivateSkill(skill_index)
    lprint("DeactivateSkill", skill_index)
    -- 检查是否已经激活
    if not self.active_skills[skill_index] then
        return false
    end

    -- 根据技能索引调用对应的内部方法
    if skill_index == 1 then
        return self:DeactivateSkill1()
    elseif skill_index == 3 then
        return self:DeactivateSkill3()
    end

    return false
end

-- 内部方法：激活技能1
function LingGuardSkill:ActivateSkill1()
    if not self.inst.components.combat then
        return false
    end

    local config = self:GetSkillConfig(1)
    if not config then
        return false
    end

    self.active_skills[1] = true

    -- 应用技能1效果
    local owner = self:GetOwner()
    if owner then
        self.inst.components.combat.externaldamagemultipliers:SetModifier(
            owner,
            config.damageMultiplier,
            SKILL1_DAMAGE_SOURCE
        )
        self.inst.components.combat:SetAttackSpeed(config.attackSpeed)

        -- 应用真伤
        if config.trueDamage then
            self.inst.components.combat:EnableTrueDamage()
        end
    end

    return true
end

-- 内部方法：取消技能1
function LingGuardSkill:DeactivateSkill1()
    lprint("DeactivateSkill1")
    if not self.inst.components.combat then
        return false
    end

    local config = self:GetSkillConfig(1)
    if not config then
        return false
    end

    lprint("DeactivateSkill1", "before remove")
    self.active_skills[1] = false

    -- 移除技能1效果
    local owner = self:GetOwner()
    if owner then
        self.inst.components.combat.externaldamagemultipliers:RemoveModifier(
            owner,
            SKILL1_DAMAGE_SOURCE
        )
        self.inst.components.combat:SetAttackSpeed(1)

        -- 移除真伤（如果没有其他技能提供真伤）
        if config.trueDamage and not self.active_skills[3] then
            self.inst.components.combat:DisableTrueDamage()
        end
    end
    lprint("DeactivateSkill1", "after remove")

    return true
end

-- 内部方法：激活技能3
function LingGuardSkill:ActivateSkill3()
    if not self.inst.components.combat then
        return false
    end

    local config = self:GetSkillConfig(3)
    if not config then
        return false
    end

    self.active_skills[3] = true

    -- 应用技能3效果
    local owner = self:GetOwner()
    if owner then
        self.inst.components.combat.externaldamagemultipliers:SetModifier(
            owner,
            config.damageMultiplier,
            SKILL3_DAMAGE_SOURCE
        )
        self.inst.components.combat.externaldamagetakenmultipliers:SetModifier(
            owner,
            config.damageAbsorption,
            SKILL3_DAMAGE_SOURCE
        )
    end

    -- 播放技能特效
    self:SpawnSkillEffect(3)

    -- 启动光环伤害
    self:StartAuraDamage()

    return true
end

-- 内部方法：取消技能3
function LingGuardSkill:DeactivateSkill3()
    if not self.inst.components.combat then
        return false
    end

    self.active_skills[3] = false

    -- 移除技能3效果
    local owner = self:GetOwner()
    if owner then
        self.inst.components.combat.externaldamagemultipliers:RemoveModifier(
            owner,
            SKILL3_DAMAGE_SOURCE
        )
        self.inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(
            owner,
            SKILL3_DAMAGE_SOURCE
        )
    end

    -- 停止光环伤害
    self:StopAuraDamage()
    lprint("DeactivateSkill3", "after stop aura damage")
    -- 移除技能特效
    self:RemoveSkillEffect(3)

    return true
end

-- 播放技能特效
function LingGuardSkill:SpawnSkillEffect(skill_index)
    -- 只有技能3才有特效
    if skill_index ~= 3 then
        return
    end

    -- 移除旧特效
    self:RemoveSkillEffect(skill_index)
    -- 创建新特效
    local fx = SpawnPrefab("ling_guard_skill_halo_fx")
    if fx then
        fx.entity:SetParent(self.inst.entity)        -- 保存特效引用
        self.skill_fx[skill_index] = fx
    end
end

-- 移除技能特效
function LingGuardSkill:RemoveSkillEffect(skill_index)
    local fx = self.skill_fx[skill_index]
    if fx and fx:IsValid() then
        lprint("RemoveSkillEffect", skill_index)
        fx:Remove()
    end
    lprint("RemoveSkillEffect", skill_index, "after remove")
    self.skill_fx[skill_index] = nil
end

-- 关闭所有技能（失去主人时调用）
function LingGuardSkill:DeactivateAllSkills()
    for i = 1, 3 do
        self:DeactivateSkill(i)
    end
end

-- 检查主人的技能状态并同步（关联时调用）
function LingGuardSkill:SyncWithOwner()
    local owner = self:GetOwner()
    if not owner or not owner.components.ark_skill_ling then
        return
    end

    local skill_component = owner.components.ark_skill_ling

    -- 遍历所有技能，检查主人的技能状态
    for skill_index = 1, 3 do
        local config = self:GetSkillConfig(skill_index)
        if config and config.enabled then
            -- 如果主人的技能激活，则激活召唤兽的技能
            if skill_component:IsSkillActive(skill_index) then
                self:ActivateSkill(skill_index)
            end
        end
    end
end

-- 检查技能是否激活
function LingGuardSkill:IsSkillActive(skill_index)
    return self.active_skills[skill_index] or false
end

-- 启动光环伤害
function LingGuardSkill:StartAuraDamage()
    self:StopAuraDamage()  -- 先停止之前的任务

    local config = self:GetSkillConfig(3)
    if not config then
        return
    end

    -- 创建定时任务
    self.skill3_aura_task = self.inst:DoPeriodicTask(config.auraInterval, function()
        self:DoAuraDamage()
    end)
end

-- 停止光环伤害
function LingGuardSkill:StopAuraDamage()
    if self.skill3_aura_task then
        self.skill3_aura_task:Cancel()
        self.skill3_aura_task = nil
    end
end

-- 执行光环伤害
function LingGuardSkill:DoAuraDamage()
    local config = self:GetSkillConfig(3)
    if not config then
        return
    end

    local owner = self:GetOwner()
    if not owner or not owner.components.combat then
        return
    end

    -- 获取令的当前攻击力
    local owner_damage = self:GetOwnerAttackDamage(owner)
    if owner_damage <= 0 then
        return
    end

    -- 计算光环伤害（令攻击力的20%）
    local aura_damage = owner_damage * config.auraDamagePercent

    -- 使用 ling_targeting 的方法获取范围内的敌人
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, config.auraRange, {"_combat"},
        {"playerghost", "INLIMBO", "player", "companion", "wall", "ling_summon"})

    for _, target in ipairs(ents) do
        -- 使用 ling_targeting 的威胁判定方法
        -- if ling_targeting.IsThreatToGuard(self.inst, target) then
            -- 造成真实伤害
            target.components.combat:GetAttacked(self.inst, aura_damage, nil, "ling_skill_3_aura")
        -- end
    end
end

-- 获取令的攻击力
function LingGuardSkill:GetOwnerAttackDamage(owner)
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
        basedamage = weapon.components.weapon.damage or 0
        if type(basedamage) == "function" then
            basedamage = basedamage(weapon, owner, nil)
        end
    else
        -- 使用默认伤害
        basedamage = owner.components.combat.defaultdamage or 0
    end

    -- 计算最终伤害
    local damage = basedamage * basemultiplier * (externaldamagemultipliers and externaldamagemultipliers:Get() or 1) + bonus

    return math.max(0, damage)
end

-- 组件移除时清理
function LingGuardSkill:OnRemoveFromEntity()
    self:DeactivateAllSkills()
    self:StopAuraDamage()
end

return LingGuardSkill