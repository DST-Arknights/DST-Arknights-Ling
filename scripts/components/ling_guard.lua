local CONSTANTS = require("ark_constants_ling")

-- 更新等级标签的辅助函数
local function UpdateLevelTags(inst, level)
    for i = 1, 4 do
        inst:RemoveTag("ling_guard_level_" .. i)
    end
    inst:AddTag("ling_guard_level_level_" .. level)
end

-- 行为模式变化监听器
local function onbehaviormode(self, behavior_mode)
    self.inst.replica.ling_guard:SetBehaviorMode(behavior_mode)
end

-- 工作模式变化监听器
local function onworkmode(self, work_mode)
    self.inst.replica.ling_guard:SetWorkMode(work_mode)
end

-- 守卫位置变化监听器
local function onguardpos(self, guard_pos)
    self.inst.replica.ling_guard:SetGuardPosition(guard_pos)
end

-- 等级变化监听器
local function onlevel(self, level)
    -- 仅同步到 replica，具体逻辑在 SetLevel 方法中处理
    -- 这里不需要同步到 replica，因为等级不需要网络同步
end

local LingGuardBehavior = Class(function(self, inst)
    self.inst = inst

    -- 组件内部存储的变量，会自动同步到 replica
    self.behavior_mode = CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS
    self.work_mode = CONSTANTS.GUARD_WORK_MODE.NONE
    self.guard_pos = nil
    self.level = 1

    -- 召唤者和插槽信息（从 prefab 迁移过来）
    self.saved_summoner_userid = nil
    self.saved_slots = nil
end, nil, {
    behavior_mode = onbehaviormode,
    work_mode = onworkmode,
    guard_pos = onguardpos,
    level = onlevel,
})

-- 设置工作模式
function LingGuardBehavior:SetWorkMode(mode)
    -- 验证模式是否有效
    local valid_mode = false
    for _, valid in pairs(CONSTANTS.GUARD_WORK_MODE) do
        if mode == valid then
            valid_mode = true
            break
        end
    end

    if not valid_mode then
        mode = CONSTANTS.GUARD_WORK_MODE.NONE -- 默认值
    end

    local old_mode = self.work_mode
    self.work_mode = mode -- 设置到组件内部，监听器会自动同步到 replica

    -- 处理工作模式变化的逻辑
    self:HandleWorkModeChange(old_mode, mode)
end

-- 处理工作模式变化的逻辑
function LingGuardBehavior:HandleWorkModeChange(old_mode, new_mode)
    if not self.inst.plant_container then
        return
    end

    local leader = self.inst.components.follower.leader
    local openedGuardPanelInst = leader and leader.components.ling_summon_manager and leader.components.ling_summon_manager.openedGuardPanelInst or nil

    -- 只有当面板打开时才处理容器操作
    if openedGuardPanelInst ~= self.inst then
        return
    end

    -- 从种植模式切换到非种植模式
    if old_mode == CONSTANTS.GUARD_WORK_MODE.PLANT and new_mode ~= CONSTANTS.GUARD_WORK_MODE.PLANT then
        self:ExitPlantMode(leader)
    end

    -- 从非种植模式切换到种植模式
    if old_mode ~= CONSTANTS.GUARD_WORK_MODE.PLANT and new_mode == CONSTANTS.GUARD_WORK_MODE.PLANT then
        self:EnterPlantMode(leader)
    end
end

-- 进入种植模式
function LingGuardBehavior:EnterPlantMode(leader)
    if not leader then
        return
    end

    if self.inst.plant_club then
        if not self.inst.components.ling_guard_plant:isPlanting() then
            self.inst.plant_club.components.container:Open(leader)
        end
    end
    if self.inst.plant_container then
        self.inst.plant_container.components.container:Open(leader)
    end
end

-- 退出种植模式
function LingGuardBehavior:ExitPlantMode(leader)
    if not leader then
        return
    end

    -- 停止种植
    if self.inst.components.ling_guard_plant then
        self.inst.components.ling_guard_plant:StopPlanting()
    end

    -- 关闭容器并转移物品
    if self.inst.plant_container then
        self.inst.plant_container.components.container:Close(leader)
        -- 将容器中的物品转移给守卫的主人
        if leader.components.inventory then
            local container = self.inst.plant_container.components.container
            -- 使用源码中的 MoveItemFromAllOfSlot 方法转移所有物品
            for i = 1, container.numslots do
                if container:GetItemInSlot(i) then
                    container:MoveItemFromAllOfSlot(i, leader, leader)
                end
            end
        else
            -- 如果没有主人或主人没有背包，就丢弃物品
            self.inst.plant_container.components.container:DropEverything()
        end
    end

    if self.inst.plant_club then
        self.inst.plant_club.components.container:Close(leader)
    end
end



function LingGuardBehavior:RefreshGuardModeRangeMark()
    if self.behavior_mode ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        self.guard_pos = nil
    else
        local leader = self.inst.components.follower.leader
        if leader then
            self.guard_pos = leader:GetPosition()
        end
    end
end

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

    self.behavior_mode = mode
    local follower = self.inst.components.follower
    if follower then
        if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
            follower:StopLeashing()
        else
            follower:StartLeashing()
        end
    end
    self:RefreshGuardModeRangeMark()
    -- 更新标签
    self:UpdateBehaviorTags()
end

-- 获取行为模式
function LingGuardBehavior:GetBehaviorMode()
    return self.behavior_mode
end

-- 获取工作模式
function LingGuardBehavior:GetWorkMode()
    return self.work_mode
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

-- 设置等级
function LingGuardBehavior:SetLevel(level)
    local config = TUNING.LING_GUARDS[self.inst.guard_type].LEVELS[level]
    if not config then
        return
    end

    self.level = level -- 设置到组件内部

    -- 更新属性
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

    -- 更新种植组件的等级
    if self.inst.components.ling_guard_plant then
        self.inst.components.ling_guard_plant:SetLevel(level)
    end

    -- 更新容器等级
    if self.inst.plant_container and self.inst.plant_container.replica.container then
        self.inst:DoTaskInTime(0, function()
            self.inst:DoTaskInTime(0, function()
                if self.inst.plant_container.replica.container._ling_level then
                    print("[LingGuardBehavior] [plant_container] SetLevel", level)
                    self.inst.plant_container.replica.container._ling_level:set(level)
                end
            end)
        end)
    end

    -- 更新等级标签
    UpdateLevelTags(self.inst, level)
    print("[LingGuardBehavior] SetLevel", level)
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


-- 保存数据
function LingGuardBehavior:OnSave()
    return {
        behavior_mode = self.behavior_mode,
        work_mode = self.work_mode,
        saved_summoner_userid = self.saved_summoner_userid,
        saved_slots = self.saved_slots,
        level = self.level,
        guard_pos = self.guard_pos and {self.guard_pos:Get()} or nil,
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
            self.saved_level = data.level
        end

        -- 加载行为模式和工作模式
        if data.behavior_mode then
            self.behavior_mode = data.behavior_mode
        end
        if data.work_mode then
            self.work_mode = data.work_mode
        end
        if data.guard_pos then
           self.guard_pos = Vector3(data.guard_pos[1], data.guard_pos[2], data.guard_pos[3])
        end
    end
end

function LingGuardBehavior:LoadPostPass()
    if self.saved_level then
        self.level = self.saved_level
        self.saved_level = nil
    end
end

return LingGuardBehavior
