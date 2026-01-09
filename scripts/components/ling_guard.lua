local CONSTANTS = require("ark_constants_ling")
local LING_GUARD_TUNING = require("ling_guard_tuning")
local FORM = CONSTANTS.GUARD_FORM
-- 行为模式变化监听器
local function onbehaviormode(self, value)
    self.inst.replica.ling_guard.state.behavior_mode = value
end

-- 工作模式变化监听器
local function onworkmode(self, value)
    self.inst.replica.ling_guard.state.work_mode = value
end

-- 守卫位置变化监听器
local function onguardpos(self, value)
    if value == nil then
        value = Vector3(0, 0, 0)
    end
    self.inst.replica.ling_guard.state.guard_pos_x = value.x
    self.inst.replica.ling_guard.state.guard_pos_y = value.y
    self.inst.replica.ling_guard.state.guard_pos_z = value.z
end

-- 等级变化监听器
local function onlevel(self, level)
    self.inst.replica.ling_guard.state.level = level
end

-- 形态变化监听器
local function onform(self, value)
    self.inst.replica.ling_guard.state.form = value
end

local function OnRemove(inst)
    local comp = inst.components.ling_guard
    if comp and comp.panel_opener then
        comp:ClosePanel(comp.panel_opener)
    end
    comp:ThrowContainerItems(inst.plant_container)
    comp:ThrowContainerItems(inst.plant_club)
    comp:ThrowContainerItems(inst)
end

local LingGuardBehavior = Class(function(self, inst)
    self.inst = inst

    -- 组件内部存储的变量，会自动同步到 replica
    self.behavior_mode = CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS
    self.work_mode = CONSTANTS.GUARD_WORK_MODE.NONE
    self.guard_pos = nil
    self.level = 1
    self.form = FORM.QINGPING
    self.panel_opener = nil
    -- 插槽信息（从 prefab 迁移过来）
    self.saved_slots = nil
    inst:ListenForEvent("onremove", OnRemove)
end, nil, {
    behavior_mode = onbehaviormode,
    work_mode = onworkmode,
    guard_pos = onguardpos,
    level = onlevel,
    form = onform,
})

function LingGuardBehavior:CheckOpenPlantContainer(doer)
    if self.work_mode == CONSTANTS.GUARD_WORK_MODE.PLANT then
        if self.inst.plant_container then
            self.inst.plant_container.components.container:Open(doer)
        end
        if self.inst.plant_club then
            -- 种植中时关闭容器，否则打开
            if not self.inst.components.ling_guard_plant:isPlanting() then
                self.inst.plant_club.components.container:Open(doer)
            elseif self.inst.plant_club.components.container:IsOpenedBy(doer) then
                self.inst.plant_club.components.container:Close(doer)
            end
        end
    end
end

function LingGuardBehavior:ClosePlantContainer(doer)
    if self.inst.plant_container and self.inst.plant_container.components.container:IsOpenedBy(doer) then
        self.inst.plant_container.components.container:Close(doer)
    end
    if self.inst.plant_club and self.inst.plant_club.components.container:IsOpenedBy(doer) then
        self.inst.plant_club.components.container:Close(doer)
    end
end

function LingGuardBehavior:OpenContainer(doer)
    if not self.inst.components.container then
        return
    end
    self.inst.components.container:SkipAutoClose(doer)
    self.inst.components.container:Open(doer)
end

function LingGuardBehavior:CloseContainer(doer)
    if not self.inst.components.container then
        return
    end
    self.inst.components.container:StopSkipAutoClose(doer)
    self.inst.components.container:Close(doer)
end

function LingGuardBehavior:OpenPanel(doer)
    if self.panel_opener == doer then
        ArkLogger:Warn("LingGuardBehavior:OpenPanel", "already opened by", doer, self.inst)
        return
    end
    ArkLogger:Debug("LingGuardBehavior:OpenPanel", doer, self.inst)
    -- 关闭之前打开的面板
    if doer.components.leader then
        for follower, _ in pairs(doer.components.leader.followers) do
            if follower.components.ling_guard and follower.components.ling_guard:IsPanelOpenedBy(doer) then
                follower.components.ling_guard:ClosePanel(doer)
            end
        end
        -- 关闭其他正在打开的人
        if self.panel_opener then
            self:ClosePanel(self.panel_opener)
        end
    end
    self.panel_opener = doer
    self.inst.replica.ling_guard.state:Attach(doer)
    self.inst:DoTaskInTime(4, function()
        self.inst.replica.ling_guard.state.guard_pos_x = self.inst.replica.ling_guard.state.guard_pos_x + 1
    end)
    if self.inst.components.container then
        self.inst.components.container:SkipAutoClose(doer)
    end
    self:CheckOpenPlantContainer(doer)
end

function LingGuardBehavior:ClosePanel(doer)
    self.inst.replica.ling_guard.state:Attach(self.inst)
    self.panel_opener = nil
    if self.inst.components.container then
        self.inst.components.container:StopSkipAutoClose(doer)
    end
    self:ClosePlantContainer(doer)
end

function LingGuardBehavior:IsPanelOpenedBy(doer)
    return self.panel_opener == doer
end

function LingGuardBehavior:ThrowContainerItems(container)
    if not container or not container.components or not container.components.container then
        return
    end
    local leader = self.inst.components.follower.leader
    if leader and leader.components.inventory then
        local container = container.components.container
        -- 使用源码中的 MoveItemFromAllOfSlot 方法转移所有物品
        for i = 1, container.numslots do
            if container:GetItemInSlot(i) then
                container:MoveItemFromAllOfSlot(i, leader, leader)
            end
        end
    else
        -- 如果没有主人或主人没有背包，就丢弃物品
        container.components.container:DropEverything()
    end
end

-- 设置工作模式
function LingGuardBehavior:SetWorkMode(mode)
    local old_mode = self.work_mode
    self.work_mode = mode -- 设置到组件内部，监听器会自动同步到 replica
    -- 进入种植模式要处理种植容器的显示
    if old_mode ~= CONSTANTS.GUARD_WORK_MODE.PLANT and mode == CONSTANTS.GUARD_WORK_MODE.PLANT then
        if self.panel_opener then
            self:CheckOpenPlantContainer(self.panel_opener)
        end
    end
    -- 退出种植模式要处理种植容器的隐藏
    if old_mode == CONSTANTS.GUARD_WORK_MODE.PLANT and mode ~= CONSTANTS.GUARD_WORK_MODE.PLANT then
        -- 停止种植
        self.inst.components.ling_guard_plant:StopPlanting()
        if self.panel_opener then
            self:ClosePlantContainer(self.panel_opener)
        end
        -- 物品抛出
        self:ThrowContainerItems(self.inst.plant_container)
    end
end

-- 设置行为模式
function LingGuardBehavior:SetBehaviorMode(mode)
    self.behavior_mode = mode
    if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        self.inst.components.follower:StopLeashing()
        local leader = self.inst.components.follower.leader
        if leader then
            local pos = leader:GetPosition()
            self.inst.components.knownlocations:RememberLocation("home", pos)
            self.guard_pos = pos
        end
    else
        self.guard_pos = nil
        self.inst.components.follower:StartLeashing()
    end
end

-- 获取行为模式
function LingGuardBehavior:GetBehaviorMode()
    return self.behavior_mode
end

-- 获取工作模式
function LingGuardBehavior:GetWorkMode()
    return self.work_mode
end

-- 设置/获取/切换 形态（门槛：自身等级>=2；弦惊不可切换；初始化时总是应用）
function LingGuardBehavior:SetForm(form)
    if self.level < 2 then
        return false
    end
    self.form = form
    -- 事件通知（prefab 用于挂载武器等）
    self.inst:PushEvent("ling_form_changed", { form = form })
    -- 切换后根据当前等级刷新一次数值
    self:SetLevel(self.level)
    return true
end

function LingGuardBehavior:GetForm()
    return self.form
end

function LingGuardBehavior:Recall()
  local act = BufferedAction(self.inst, self.inst, ACTIONS.LING_GUARD_RECALL)
  self.inst.components.locomotor:PushAction(act, false)
end

-- 设置插槽信息
function LingGuardBehavior:SetSlots(slots)
    self.saved_slots = slots
end

-- 获取插槽信息
function LingGuardBehavior:GetSlots()
    return self.saved_slots
end

function LingGuardBehavior:ApplyLevelEffects()
    local level = self.level
    local cfg = LING_GUARD_TUNING.GetLevelConfig(self.form, level)
    if not cfg then return end
    if self.inst.components.health then
        self.inst.components.health:SetMaxHealth(cfg.HEALTH)
    end
    if self.inst.components.combat then
        self.inst.components.combat:SetDefaultDamage(cfg.DAMAGE)
        self.inst.components.combat:SetAttackPeriod(cfg.ATTACK_PERIOD)
        self.inst.components.combat:SetRange(cfg.ATTACK_RANGE)
        self.inst.components.combat.externaldamagetakenmultipliers:SetModifier(self.inst, cfg.DAMAGE_REDUCTION, "level_damage_reduction")
    end
    if self.inst.components.locomotor then
        self.inst.components.locomotor.walkspeed = cfg.WALK_SPEED
        self.inst.components.locomotor.runspeed = cfg.RUN_SPEED
    end
    if self.inst.components.ling_guard_plant then
        self.inst.components.ling_guard_plant:SetLevel(level)
    end
    -- 同步给manager
    self.inst:PushEvent("ling_guard_level_changed", { level = level })
end

-- 设置等级
function LingGuardBehavior:SetLevel(level)
    self.level = level
    self:ApplyLevelEffects()
end

-- 获取等级
function LingGuardBehavior:GetLevel()
    return self.level
end

-- 融合 TODO:
function LingGuardBehavior:Fusion()
    return nil
end

-- 保存数据
function LingGuardBehavior:OnSave()
    return {
        behavior_mode = self.behavior_mode,
        work_mode = self.work_mode,
        saved_slots = self.saved_slots,
        level = self.level,
        form = self.form,
        guard_pos = self.guard_pos and {self.guard_pos:Get()} or nil,
    }
end

-- 加载数据
function LingGuardBehavior:OnLoad(data)
    if data then
        -- 加载插槽信息
        self.saved_slots = data.saved_slots

        -- 加载等级信息
        if data.level then
            self.level = data.level
        end
        -- 加载形态信息
        if data.form then
            self.form = data.form
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
        self:ApplyLevelEffects()
    end
end

-- 检查守卫是否可以跟随迁移
-- 守模式不允许迁移，其他模式允许
function LingGuardBehavior:CanMigrate()
    return self.behavior_mode ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD
end

function LingGuardBehavior:OnRemoveFromEntity()
    OnRemove(self.inst)
    self.inst:RemoveEventCallback("onremove", OnRemove)
end

function LingGuardBehavior:PrepareForMigration()
    ArkLogger:Debug("LingGuardBehavior:PrepareForMigration", self.inst)
    if self.inst.components.locomotor then
        self.inst.components.locomotor:Stop()
    end
    self.inst.persists = false
    self.inst.ready_for_migration = true
end

return LingGuardBehavior
