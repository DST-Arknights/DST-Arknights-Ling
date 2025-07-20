local CONSTANTS = require("ark_constants_ling")

-- 更新等级标签的辅助函数
local function UpdateLevelTags(inst, level)
    for i = 1, 4 do
        inst:RemoveTag(inst.prefab .. "_level_" .. i)
    end
    inst:AddTag(inst.prefab .. "_level_" .. level)
end

local LingGuardBehavior = Class(function(self, inst)
    self.inst = inst

    -- 行为模式直接使用 replica 中的数据，不在组件中重复存储

    -- 召唤者和插槽信息（从 prefab 迁移过来）
    self.saved_summoner_userid = nil
    self.saved_slots = nil

    -- 等级系统（从 ling_guard_level 组件迁移过来）
    self.level = 1

    self:SetBehaviorMode(CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS) -- 默认值
end)

-- 设置行为模式
function LingGuardBehavior:SetBehaviorMode(mode)
    -- 验证模式是否有效
    local valid_mode = false
    for _, valid in pairs(CONSTANTS.GUARD_BEHAVIOR_MODE) do
        if mode == valid then
            valid_mode = true
            break
        end
    end

    if not valid_mode then
        mode = CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS -- 默认为慎模式
    end

    -- 直接设置到 replica，不在组件中存储
    if self.inst.replica.ling_guard then
        self.inst.replica.ling_guard:SetBehaviorMode(mode)
    end

    -- 更新标签
    self:UpdateBehaviorTags()

    -- 更新战斗目标函数
    self:UpdateCombatRetargetFunction()
end

-- 获取行为模式（从 replica 中获取）
function LingGuardBehavior:GetBehaviorMode()
    if self.inst.replica.ling_guard then
        return self.inst.replica.ling_guard:GetBehaviorMode()
    end
    return CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS -- 默认值
end

-- 设置召唤者用户ID
function LingGuardBehavior:SetSummonerUserId(userid)
    self.saved_summoner_userid = userid
end

-- 获取召唤者用户ID
function LingGuardBehavior:GetSummonerUserId()
    return self.saved_summoner_userid
end

-- 设置插槽信息
function LingGuardBehavior:SetSlots(slots)
    self.saved_slots = slots
end

-- 获取插槽信息
function LingGuardBehavior:GetSlots()
    return self.saved_slots
end

-- 设置等级（从 ling_guard_level 组件迁移过来）
function LingGuardBehavior:SetLevel(level)
    if not level or level < 1 or level > 4 then
        level = 1
    end
    local config = TUNING.LING_GUARDS[self.inst.guard_type].LEVELS[level]
    if not config then
        print("Warning: No config found for guard type", self.inst.prefab, "level", level)
        return
    end
    if self.level == level then
        return
    end
    self.level = level
    if self.inst.components.health then
        self.inst.components.health:SetMaxHealth(config.HEALTH)
    end
    if self.inst.components.combat then
        self.inst.components.combat:SetDefaultDamage(config.DAMAGE)
        self.inst.components.combat:SetRange(config.ATTACK_RANGE)
        self.inst.components.combat:SetAttackPeriod(config.ATTACK_PERIOD)
        self.inst.components.combat.externaldamagetakenmultipliers:SetModifier(self.inst, config.DAMAGE_REDUCTION, "level_damage_reduction")
    end
    if self.inst.components.locomotor then
        self.inst.components.locomotor.walkspeed = config.WALK_SPEED
        self.inst.components.locomotor.runspeed = config.RUN_SPEED
    end
    UpdateLevelTags(self.inst, level)
end

-- 获取等级
function LingGuardBehavior:GetLevel()
    return self.level
end

-- 更新行为标签
function LingGuardBehavior:UpdateBehaviorTags()
    -- 移除所有行为标签
    for _, mode in pairs(CONSTANTS.GUARD_BEHAVIOR_MODE) do
        self.inst:RemoveTag("behavior_mode_" .. mode)
    end

    -- 添加当前行为标签（从 replica 中获取）
    local current_mode = self:GetBehaviorMode()
    self.inst:AddTag("behavior_mode_" .. current_mode)
end

-- 更新战斗目标函数
function LingGuardBehavior:UpdateCombatRetargetFunction()
    if not self.inst.components.combat then
        return
    end
    
    -- 设置重新寻找目标的函数
    self.inst.components.combat:SetRetargetFunction(3, function(inst)
        -- 融合过程中不寻找目标
        if inst.is_fusing then
            return nil
        end
        return self:GetRetargetFunction()
    end)
end

-- 获取战斗目标的函数（根据行为模式）
function LingGuardBehavior:GetRetargetFunction()
    local mode = self:GetBehaviorMode()
    
    -- 检查是否为有效的战斗目标
    local function IsValidTarget(target)
        return target and target:IsValid()
               and self.inst.components.combat:CanTarget(target)
               and target:HasTag("monster")
               and not target:HasTag("ling_summon")
               and not target:HasTag("player")
               and not target:HasTag("companion")
    end
    
    if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        -- 守模式：只攻击进入攻击范围的敌人，不主动追击
        local range = self.inst.components.combat.attackrange or 4
        return FindEntity(self.inst, range, IsValidTarget, {"_combat"}, {"player", "companion", "wall", "INLIMBO"})
        
    elseif mode == CONSTANTS.GUARD_BEHAVIOR_MODE.ATTACK then
        -- 攻模式：主动寻找并攻击敌人
        return FindEntity(self.inst, 15, IsValidTarget, {"_combat"}, {"player", "companion", "wall", "INLIMBO"})
        
    else -- CAUTIOUS 慎模式
        -- 慎模式：优先攻击主人的目标，然后攻击攻击主人的敌人，最后主动攻击附近敌人
        local leader = self.inst.components.follower and self.inst.components.follower.leader
        
        -- 1. 优先攻击主人的目标
        if leader and leader.components.combat then
            local leader_target = leader.components.combat.target
            if IsValidTarget(leader_target) then
                return leader_target
            end
        end
        
        -- 2. 攻击正在攻击主人的敌人
        if leader then
            local leader_x, leader_y, leader_z = leader.Transform:GetWorldPosition()
            local monsters = TheSim:FindEntities(leader_x, leader_y, leader_z, 10, {"monster", "_combat"}, {"player", "companion", "wall", "INLIMBO", "ling_summon"})
            for _, monster in ipairs(monsters) do
                if monster.components.combat and monster.components.combat.target == leader
                   and IsValidTarget(monster) then
                    return monster
                end
            end
        end
        
        -- 3. 主动攻击附近的敌人（较小范围，保持慎重）
        return FindEntity(self.inst, 8, IsValidTarget, {"_combat"}, {"player", "companion", "wall", "INLIMBO"})
    end
end

-- 保存数据
function LingGuardBehavior:OnSave()
    return {
        behavior_mode = self:GetBehaviorMode(),
        saved_summoner_userid = self.saved_summoner_userid,
        saved_slots = self.saved_slots,
        level = self.level
    }
end

-- 加载数据
function LingGuardBehavior:OnLoad(data)
    if data then
        -- 加载召唤者和插槽信息
        self.saved_summoner_userid = data.saved_summoner_userid
        self.saved_slots = data.saved_slots

        -- 加载等级信息
        if data.level then
            self.level = data.level
            self:SetLevel(self.level)
        end

        -- 加载行为模式
        if data.behavior_mode then
            self:SetBehaviorMode(data.behavior_mode)
        end
    end
end

return LingGuardBehavior
