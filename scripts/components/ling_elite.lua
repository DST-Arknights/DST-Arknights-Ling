local LingElite = Class(function(self, inst)
    self.inst = inst
    self.elite_level = 0
end)

function LingElite:SetElite(level)
    self.elite_level = level
    local data = TUNING.LING.ELITE[level]
    
    -- 更新基础属性
    self.inst.components.health:SetMaxHealth(data.MAX_HEALTH)
    self.inst.components.hunger:SetMax(data.MAX_HUNGER)
    self.inst.components.sanity:SetMax(data.MAX_SANITY)
    
    -- 更新诗意组件
    if self.inst.components.ling_poetry then
        self.inst.components.ling_poetry:SetElite(level)
    end
    
    -- 更新移动速度
    self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "ling_elite_speed", data.SPEED_MULTIPLIER)
    
    -- 更新伤害倍数
    self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, data.DAMAGE_MULTIPLIER, "ling_elite_damage")
    
    -- 更新睡眠抗性
    if self.inst.components.sleeper then
        self.inst.components.sleeper:SetResistance(data.SLEEP_RESISTANCE)
    end
    
    -- 更新召唤管理器
    if self.inst.components.ling_summon_manager then
        self.inst.components.ling_summon_manager:SetMaxSlots(data.MAX_GUARDS)
    end
    
    -- 更新标签
    for i = 1, 3 do
        local tag = "ling_elite_" .. i
        self.inst:RemoveTag(tag)
    end
    local tag = "ling_elite_" .. level
    self.inst:AddTag(tag)
    
    -- 更新技能解锁状态
    self:UpdateSkillUnlocks(level)
end

function LingElite:UpdateSkillUnlocks(level)
    local skill_component = self.inst.components.ark_skill_ling
    if not skill_component then
        return
    end
    
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

function LingElite:OnSave()
    return {
        elite_level = self.elite_level
    }
end

function LingElite:OnLoad(data)
    if data and data.elite_level then
        self:SetElite(data.elite_level)
    end
end

return LingElite
