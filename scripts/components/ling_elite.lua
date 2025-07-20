local LingElite = Class(function(self, inst)
    self.inst = inst
    self.elite_level = 0

    -- 只保存那些没有自己保存机制的组件属性
    self.speed_multiplier = 1
    self.damage_multiplier = 1
    self.sleep_resistance = 0
end)

-- 设置精英等级（仅用于升级时调用，不用于加载）
function LingElite:SetElite(level)
    self.elite_level = level
    self:ApplyEliteEffects(level)
end

-- 应用精英等级效果（统一的效果应用逻辑）
function LingElite:ApplyEliteEffects(level)
    local data = TUNING.LING.ELITE[level]
    if not data then
        return
    end

    -- 更新基础属性（这些组件有自己的保存机制，只需要设置最大值）
    self.inst.components.health:SetMaxHealth(data.MAX_HEALTH)
    self.inst.components.hunger:SetMax(data.MAX_HUNGER)
    self.inst.components.sanity:SetMax(data.MAX_SANITY)

    -- 应用诗意组件配置（ling_poetry 组件自己保存所有相关属性）
    if self.inst.components.ling_poetry then
        self.inst.components.ling_poetry:SetElite(level)
    end

    -- 保存并应用移动速度
    self.speed_multiplier = data.SPEED_MULTIPLIER
    self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "ling_elite_speed", data.SPEED_MULTIPLIER)

    -- 保存并应用伤害倍数
    self.damage_multiplier = data.DAMAGE_MULTIPLIER
    self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, data.DAMAGE_MULTIPLIER, "ling_elite_damage")

    -- 保存并应用睡眠抗性
    self.sleep_resistance = data.SLEEP_RESISTANCE
    if self.inst.components.sleeper then
        self.inst.components.sleeper:SetResistance(data.SLEEP_RESISTANCE)
    end

    -- 应用召唤管理器槽位（ling_summon_manager 组件自己保存 max_slots）
    if self.inst.components.ling_summon_manager then
        self.inst.components.ling_summon_manager:SetMaxSlots(data.MAX_GUARDS)
    end

    -- 更新标签
    self:UpdateEliteTags(level)

    -- 更新技能解锁状态
    self:UpdateSkillUnlocks(level)
end

-- 更新精英标签
function LingElite:UpdateEliteTags(level)
    for i = 1, 3 do
        local tag = "ling_elite_" .. i
        self.inst:RemoveTag(tag)
    end
    if level > 0 then
        local tag = "ling_elite_" .. level
        self.inst:AddTag(tag)
    end
end

function LingElite:UpdateSkillUnlocks(level)
    local skill_component = self.inst.components.ark_skill_ling
    if not skill_component then
        return
    end

    -- ark_skill_ling 组件有自己的保存机制，这里只需要设置状态
    if level == 1 then
        skill_component:UnLock(1)
        skill_component:SetSkillLevel(1, 1)
        skill_component:Lock(2)
        skill_component:Lock(3)
    elseif level == 2 then
        skill_component:UnLock(1)
        skill_component:SetSkillLevel(1, 2)
        skill_component:UnLock(2)
        skill_component:SetSkillLevel(2, 1)
        skill_component:Lock(3)
    elseif level == 3 then
        skill_component:UnLock(1)
        skill_component:SetSkillLevel(1, 3)
        skill_component:UnLock(2)
        skill_component:SetSkillLevel(2, 2)
        skill_component:UnLock(3)
        skill_component:SetSkillLevel(3, 1)
    end
end

function LingElite:GetEliteLevel()
    return self.elite_level
end

-- 恢复没有自己保存机制的组件属性
function LingElite:RestoreComponentStates()
    -- 恢复移动速度倍数
    if self.speed_multiplier then
        self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "ling_elite_speed", self.speed_multiplier)
    end

    -- 恢复伤害倍数
    if self.damage_multiplier then
        self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, self.damage_multiplier, "ling_elite_damage")
    end

    -- 恢复睡眠抗性
    if self.sleep_resistance and self.inst.components.sleeper then
        self.inst.components.sleeper:SetResistance(self.sleep_resistance)
    end

    -- 恢复标签
    self:UpdateEliteTags(self.elite_level)
end

function LingElite:OnSave()
    return {
        elite_level = self.elite_level,
        speed_multiplier = self.speed_multiplier,
        damage_multiplier = self.damage_multiplier,
        sleep_resistance = self.sleep_resistance
    }
end

function LingElite:OnLoad(data)
    if data then
        self.elite_level = data.elite_level or 0
        self.speed_multiplier = data.speed_multiplier or 1
        self.damage_multiplier = data.damage_multiplier or 1
        self.sleep_resistance = data.sleep_resistance or 0

        -- 延迟恢复组件状态，确保所有组件都已加载完成
        self.inst:DoTaskInTime(0, function()
            self:RestoreComponentStates()
        end)
    end
end

return LingElite
