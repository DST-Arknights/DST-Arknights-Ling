-- 召唤兽技能组件
-- 用于管理召唤兽受到令的技能影响
-- 组件自行管理技能配置，不依赖令的技能配置

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
        fxColor = {1, 0.5, 0.5, 1},  -- 红色光环
    },
    [2] = {
        -- 技能2：不影响召唤兽
        enabled = false,
    },
    [3] = {
        -- 技能3：伤害和防御提升
        enabled = true,  -- 是否启用此技能
        damageMultiplier = 1.4,  -- 伤害倍率
        damageAbsorption = 0.6,  -- 伤害吸收
        fxColor = {0.5, 0.5, 1, 1},  -- 蓝色光环
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

    -- 播放技能特效
    self:SpawnSkillEffect(1)

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
    -- 移除技能特效
    self:RemoveSkillEffect(1)

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

    -- 移除技能特效
    self:RemoveSkillEffect(3)

    return true
end

-- 播放技能特效
function LingGuardSkill:SpawnSkillEffect(skill_index)
    -- 移除旧特效
    self:RemoveSkillEffect(skill_index)

    local config = self:GetSkillConfig(skill_index)
    if not config or not config.fxColor then
        return
    end

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

-- 组件移除时清理
function LingGuardSkill:OnRemoveFromEntity()
    self:DeactivateAllSkills()
end

return LingGuardSkill