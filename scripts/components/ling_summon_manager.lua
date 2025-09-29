local CONSTANTS = require "ark_constants_ling"

local LING_TUNING = require("ling_guard_tuning")
local FORM = CONSTANTS.GUARD_FORM

local GUARD_SLOT_STATUS = CONSTANTS.GUARD_SLOT_STATUS
local SLOT_TYPE = CONSTANTS.GUARD_SLOT_TYPE

local function getSlotCount(slot_type)
  return slot_type == SLOT_TYPE.ELITE and 2 or 1
end

local function SlotTypeToPrefab(slot_type)
  if slot_type == SLOT_TYPE.BASIC then
    return "ling_guard_basic"
  elseif slot_type == SLOT_TYPE.ELITE then
    return "ling_guard_elite"
  end
end

local MAX_GUARDS = 0;
-- 遍历 TUNING.LING.ELITE
for k, v in pairs(TUNING.LING.ELITE) do
  MAX_GUARDS = math.max(MAX_GUARDS, v.MAX_GUARDS)
end

local LingSummonManager = Class(function(self, inst)
  self.inst = inst
  self.max_slots = 0
  self.callerOpened = false
  self:SetMaxSlots(3)
end)

-- 设置槽位数据到网络变量（通过 replica）
function LingSummonManager:SetSlotData(slot_index, inst, type, level, status)
  if slot_index <= MAX_GUARDS and self.inst.replica.ling_summon_manager then
    local replica = self.inst.replica.ling_summon_manager
    if replica._slots and replica._slots[slot_index] then
      replica._slots[slot_index].inst:set(inst)
      replica._slots[slot_index].type:set(type or 0)
      replica._slots[slot_index].level:set(level or 0)
      replica._slots[slot_index].status:set(status or GUARD_SLOT_STATUS.EMPTY)
      print("[LingSummonManager] SetSlotData", slot_index, inst, type, level, status)
    end
  end
end

-- 获取槽位数据（从 replica）
function LingSummonManager:GetSlotData(slot_index)
  if slot_index <= MAX_GUARDS and self.inst.replica.ling_summon_manager then
    local replica = self.inst.replica.ling_summon_manager
    return replica:GetSlotData(slot_index)
  end
  return nil
end

function LingSummonManager:SetMaxSlots(max_slots)
  local old_max = self.max_slots
  self.max_slots = max_slots

  -- 同步到 replica
  if self.inst.replica.ling_summon_manager then
    self.inst.replica.ling_summon_manager:SetMaxSlots(max_slots)
  end

  -- 如果减少了槽位数量，将超出的槽位设为禁用状态
  if max_slots < old_max then
    for i = max_slots + 1, old_max do
      if i <= MAX_GUARDS then
        self:SetSlotData(i, nil, 0, 0, GUARD_SLOT_STATUS.DISABLED)
      end
    end
  end

  -- 如果增加了槽位数量，将新增的槽位设为空状态
  if max_slots > old_max then
    for i = old_max + 1, max_slots do
      if i <= MAX_GUARDS then
        self:SetSlotData(i, nil, 0, 0, GUARD_SLOT_STATUS.EMPTY)
      end
    end
  end
end

function LingSummonManager:CanAssignToSlot(slot_index, required_slots)
  required_slots = required_slots or 1

  -- 检查插槽范围
  if slot_index < 1 or slot_index > self.max_slots then
    return nil
  end

  -- 检查指定插槽是否可用
  local slot_data = self:GetSlotData(slot_index)
  if not slot_data or slot_data.status ~= GUARD_SLOT_STATUS.EMPTY then
    return nil
  end

  -- 如果只需要1个插槽，直接返回
  if required_slots == 1 then
    return {slot_index}
  end

  -- 对于需要多个插槽的情况（如弦惊），寻找任意可用插槽
  local slots = {slot_index} -- 第一个插槽已确定
  local found_count = 1

  -- 寻找其他可用插槽
  for i = 1, self.max_slots do
    if i ~= slot_index then
      local other_slot_data = self:GetSlotData(i)
      if other_slot_data and other_slot_data.status == GUARD_SLOT_STATUS.EMPTY then
        table.insert(slots, i)
        found_count = found_count + 1
        if found_count >= required_slots then
          break
        end
      end
    end
  end

  -- 检查是否找到足够的插槽
  if found_count < required_slots then
    return nil
  end

  return slots
end

-- 获取某个召唤物在插槽中的索引
function LingSummonManager:GetGuardSlotIndex(inst)
  if inst.components.ling_guard then
    local saved_slots = inst.components.ling_guard:GetSlots()
    if saved_slots then
      local idx = saved_slots[1]
      local slot_data = self:GetSlotData(idx)
      if slot_data and slot_data.inst == inst then
        return idx
      end
    end
  end
  for i = 1, self.max_slots do
    local slot_data = self:GetSlotData(i)
    if slot_data and slot_data.inst == inst then
      return i
    end
  end
  return nil
end

-- 验证守卫是否属于这个玩家
function LingSummonManager:IsGuardOwnedByPlayer(guard_inst)
  if not guard_inst or not guard_inst:IsValid() then
    return false
  end

  -- 检查守卫是否在玩家的插槽中
  local slot_index = self:GetGuardSlotIndex(guard_inst)
  if slot_index then
    return true
  end

  -- 额外检查移除：不再使用召唤者ID
  return false
end

-- 设置插槽为召唤中状态
function LingSummonManager:SetSlotSummoning(slots, slot_type, level)
  -- 第一个插槽设为召唤中状态，并设置类型（基础/高级）和等级
  self:SetSlotData(slots[1], nil, slot_type or 0, level or 0, GUARD_SLOT_STATUS.SUMMONING)

  -- 其他插槽（如果有）设为禁用状态
  for i = 2, #slots do
    self:SetSlotData(slots[i], nil, 0, 0, GUARD_SLOT_STATUS.DISABLED)
  end
end

function LingSummonManager:SetGuardToSlot(guard_inst, slots)
  -- 通过组件判断基础/高级与等级
  local slot_type = SLOT_TYPE.BASIC
  if guard_inst.components.ling_guard and guard_inst.components.ling_guard:IsXianjing() then
    slot_type = SLOT_TYPE.ELITE
  end
  local lvl = (guard_inst.components.ling_guard and guard_inst.components.ling_guard.level) or 0

  -- 设置主插槽为占用状态
  self:SetSlotData(slots[1], guard_inst, slot_type, lvl, GUARD_SLOT_STATUS.OCCUPIED)

  -- 设置额外插槽为禁用状态（如果有）
  for i = 2, #slots do
    self:SetSlotData(slots[i], nil, 0, 0, GUARD_SLOT_STATUS.DISABLED)
  end

  return true
end

-- 取消正在进行的召唤：将相关插槽重置为空
function LingSummonManager:CancelSummon(slots)
  if not slots then
    return
  end
  for i = 1, #slots do
    local slot_index = slots[i]
    if slot_index >= 1 and slot_index <= self.max_slots then
      self:SetSlotData(slot_index, nil, 0, 0, GUARD_SLOT_STATUS.EMPTY)
    end
  end
end

function LingSummonManager:FindGuardIndex(inst)
  for i = 1, self.max_slots do
    local slot_data = self:GetSlotData(i)
    if slot_data and slot_data.inst == inst then
      return i
    end
  end
  return nil
end

function LingSummonManager:RemoveGuardFromSlot(guard_inst)
  if not guard_inst then
    return false
  end

  -- 使用组件中的saved_slots直接清理所有相关插槽
  if guard_inst.components.ling_guard then
    local saved_slots = guard_inst.components.ling_guard:GetSlots()
    if saved_slots then
      for i = 1, #saved_slots do
        local slot_index = saved_slots[i]
        if slot_index >= 1 and slot_index <= self.max_slots then
          self:SetSlotData(slot_index, nil, 0, 0, GUARD_SLOT_STATUS.EMPTY)
        end
      end
      if self.openedGuardPanelInst == guard_inst then
        self:RequestCloseGuardPanel()
      end
      return true
    end
  end

  return false
end

-- 获取所有槽位数据（从网络变量）
function LingSummonManager:GetAllSlots()
  local slots_data = {}
  for i = 1, self.max_slots do
    slots_data[i] = self:GetSlotData(i)
  end
  return slots_data
end

function LingSummonManager:GetSlotCount()
  return self.max_slots
end



-- UI同步相关方法已移除，现在直接通过网络变量同步

function LingSummonManager:OnFollowerLost(follower)
    self:RemoveGuardFromSlot(follower)
end

function LingSummonManager:OnFollowerAdded(follower)
  print("[LingSummonManager] OnFollowerAdded: 检测到follower添加", follower and follower.prefab or "nil")

  -- 仅处理令的召唤兽
  if not follower or not follower:HasTag("ling_summon") then
    print("[LingSummonManager] OnFollowerAdded: 不是召唤兽，忽略")
    return
  end
  if follower.components.ling_guard then
    follower.owner = self.inst
    local saved_slots = follower.components.ling_guard:GetSlots()
    self:SetGuardToSlot(follower, saved_slots)
  end
end

function LingSummonManager:RequestOpenContainer(guard_inst)
  if not guard_inst or not guard_inst:IsValid() then
    return false
  end
  if guard_inst.components.container then
    self.openedContainerInst = guard_inst
    guard_inst.components.container:Open(self.inst)
  end
end

function LingSummonManager:RequestCloseContainer()
  if not self.openedContainerInst or not self.openedContainerInst:IsValid() then
    return
  end
  local openedContainerInst = self.openedContainerInst
  self.openedContainerInst = nil
  openedContainerInst.components.container:Close(self.inst)
end

-- 回收守卫：通过 Action 驱动状态机执行
function LingSummonManager:RecallGuard(guard_inst)
  if not guard_inst or not guard_inst:IsValid() then
    return false
  end
  if not self:IsGuardOwnedByPlayer(guard_inst) then
    return false
  end
  -- 关闭相关UI
  if self.openedContainerInst == guard_inst then
    self:RequestCloseContainer()
  end
  if self.openedGuardPanelInst == guard_inst then
    self:RequestCloseGuardPanel(guard_inst)
  end
  -- 停止移动并派发带参动作到守卫自身
  if guard_inst.components and guard_inst.components.locomotor then
    guard_inst.components.locomotor:Stop()
  end
  local act = BufferedAction(guard_inst, guard_inst, ACTIONS.LING_RECALL_GUARD)
  guard_inst:PushBufferedAction(act)
  return true
end

function LingSummonManager:RequestOpenGuardPanel(guard_inst)
  if not guard_inst or not guard_inst:IsValid() or self.openedGuardPanelInst == guard_inst then
    print("[LingSummonManager] RequestOpenGuardPanel: guard_inst is invalid or already opened", guard_inst, guard_inst and guard_inst:IsValid() )
    return false
  end
  local inventory = self.inst.components.inventory
  if inventory and inventory.opencontainers then
    for container, _ in pairs(inventory.opencontainers) do
      if container:HasTag("ling_summon") and container.components.container:IsOpenedBy(self.inst) then
        container.components.container:Close(self.inst)
      end
      if container:HasTag("ling_guard_plant_club") and container.components.container:IsOpenedBy(self.inst) then
        container.components.container:Close(self.inst)
      end
      if container:HasTag("ling_guard_plant_container") and container.components.container:IsOpenedBy(self.inst) then
        container.components.container:Close(self.inst)
      end
    end
  end
  self.openedGuardPanelInst = guard_inst
  -- 打开面板时让清平表演 nerd 动作（避免打断繁忙/死亡状态）
  if guard_inst and guard_inst.sg and guard_inst.components.ling_guard and guard_inst.components.ling_guard:IsQingping() then
    local ok = true
    if guard_inst.components and guard_inst.components.health and guard_inst.components.health:IsDead() then
      ok = false
    end
    if ok and guard_inst.sg:HasStateTag("busy") then
      ok = false
    end
    if ok then
      guard_inst.sg:GoToState("nerd")
    end
  end

  SendModRPCToClient(GetClientModRPC("ling_summon", "open_guard_panel"), self.inst.userid, self.openedGuardPanelInst)
  -- 如果工作模式处于种植模式, 打开种植容器
  if guard_inst.components.ling_guard then
    local work_mode = guard_inst.components.ling_guard:GetWorkMode()
    if work_mode == CONSTANTS.GUARD_WORK_MODE.PLANT then
      if guard_inst.plant_container and guard_inst.plant_container.components.container then
        guard_inst.plant_container.components.container:Open(self.inst)
      end
      if guard_inst.plant_club and not guard_inst.components.ling_guard_plant:isPlanting() and guard_inst.plant_club.components.container then
        guard_inst.plant_club.components.container:Open(self.inst)
      end
    end
  end
end

function LingSummonManager:RequestCloseGuardPanel()
  if self.openedContainerInst then
    self:RequestCloseContainer()
  end
  if not self.openedGuardPanelInst then
    return
  end
  local guard_inst = self.openedGuardPanelInst
  SendModRPCToClient(GetClientModRPC("ling_summon", "close_guard_panel"), self.inst.userid)
  self.openedGuardPanelInst = nil
  -- 如果工作模式处于种植模式, 打开种植容器
  if guard_inst.components.ling_guard then
    local work_mode = guard_inst.components.ling_guard:GetWorkMode()
    if work_mode == CONSTANTS.GUARD_WORK_MODE.PLANT then
      if guard_inst.plant_container and guard_inst.plant_container.components.container then
        guard_inst.plant_container.components.container:Close(self.inst)
      end
      if guard_inst.plant_club and guard_inst.plant_club.components.container then
        guard_inst.plant_club.components.container:Close(self.inst)
      end
    end
  end
end

-- 召唤相关方法
function LingSummonManager:SummonBasic(slot_index)
  local slots = self:CanAssignToSlot(slot_index, getSlotCount(SLOT_TYPE.BASIC))
  if not slots then
    return false
  end

  -- 自动获取当前精英等级
  local elite_level = (self.inst.components.ling_elite and self.inst.components.ling_elite:GetEliteLevel()) or 0

  -- 检查诗意消耗（基础召唤默认按清平成本）
  local poetry_component = self.inst.components.ling_poetry
  if not poetry_component then
    return false
  end

  local cost = LING_TUNING.GetSummonCost("basic", elite_level, FORM.QINGPING) or 10

  -- 检查诗意是否足够
  if not poetry_component:HasEnough(cost) then
    return false
  end

  -- 开始施法动作，传递插槽信息
  self:StartSummonCasting(SLOT_TYPE.BASIC, elite_level, cost, slots)
  return true
end

function LingSummonManager:SummonXianjing(slot_index)
  -- 自动获取当前精英等级，检查等级要求（精英化2解锁）
  local elite_level = (self.inst.components.ling_elite and self.inst.components.ling_elite:GetEliteLevel()) or 0
  if elite_level < 2 then
    return false
  end

  -- 检查诗意消耗
  local poetry_component = self.inst.components.ling_poetry
  if not poetry_component then
    return false
  end

  local cost = LING_TUNING.GetSummonCost("elite", elite_level) or 15

  -- 检查诗意是否足够
  if not poetry_component:HasEnough(cost) then
    return false
  end

  local current = (self:GetSlotData(slot_index) or {}).inst
  if not current or not current:IsValid() then
    return false
  end

  local fusion_candidates = {}
  local all = self:GetAllSlots()
  for _, slot_data in pairs(all) do
    if slot_data.status == GUARD_SLOT_STATUS.OCCUPIED
      and slot_data.inst
      and slot_data.inst:IsValid()
      and slot_data.inst ~= current
      and slot_data.type == SLOT_TYPE.BASIC
      and not slot_data.inst.components.health:IsDead()
      and slot_data.inst.components.ling_guard:GetWorkMode() == CONSTANTS.GUARD_WORK_MODE.NONE then
        table.insert(fusion_candidates, slot_data.inst)
    end
  end

  -- 需要至少两个守卫进行融合
  if #fusion_candidates < 1 then
    if self.inst.components.talker then
      self.inst.components.talker:Say("需要至少两个召唤兽进行融合！")
    end
    return false
  end

  -- 选择血量最低一个
  table.sort(fusion_candidates, function(a, b)
    return a.components.health:GetPercent() < b.components.health:GetPercent()
  end)

  local guard1 = current
  local guard2 = fusion_candidates[1]
  local slots = { slot_index, self:FindGuardIndex(guard2) }
  self:SetSlotSummoning(slots, SLOT_TYPE.ELITE, elite_level)

  -- 扣除诗意
  poetry_component:Dirty(-cost)

  -- 开始融合过程，传递插槽信息
  self:StartGuardFusion(guard1, guard2, elite_level, slots)

  return true
end

-- 施法和生成相关方法
function LingSummonManager:StartSummonCasting(slot_type, level, cost, slots)
  -- 检查是否在忙碌状态
  if self.inst.sg and self.inst.sg:HasStateTag("busy") then
    print("[LingSummonManager] StartSummonCasting: 忙碌状态，无法施法")
    return false
  end
  self:SetSlotSummoning(slots, slot_type, level)
  -- 设置召唤数据
  self.inst.summon_data = {
    type = slot_type,
    level = level,
    cost = cost,
    slots = slots,
  }

  -- 进入召唤状态
  if self.inst.sg then
    self.inst.sg:GoToState("ling_summon", self.inst.summon_data)
  end

  return true
end

function LingSummonManager:SpawnGuardAtPosition(slot_type, elite_level, spawn_x, spawn_z, slots)

  local guard = SpawnPrefab(SlotTypeToPrefab(slot_type))
  if guard then
    guard.Transform:SetPosition(spawn_x, 0, spawn_z)

    -- 基础守卫默认形态由 prefab 内部设置为清平

    -- 使用组件设置召唤者和插槽信息
    if guard.components.ling_guard then
      guard.components.ling_guard:SetSlots(slots)
      guard.components.ling_guard:SetLevel(elite_level)
    end

    -- 设置跟随，插槽分配完全依靠 OnFollowerAdded 回调
    if guard.components.follower then
      guard.components.follower:SetLeader(self.inst)
    end
    -- 生成一个种植容器挂载上去
    local container = SpawnPrefab("ling_guard_plant_container")
    if container then
      guard.plant_container = container
      container.entity:SetParent(guard.entity)
      container.Transform:SetPosition(0, 0, 0)
    end
    -- 生成一个种植容器挂载上去
    local club = SpawnPrefab("ling_guard_plant_club")
    if club then
      guard.plant_club = club
      club.entity:SetParent(guard.entity)
      club.Transform:SetPosition(0, 0, 0)
    end
    return true
  end
end

-- 融合相关方法
function LingSummonManager:StartGuardFusion(guard1, guard2, elite_level, slots)
  -- 直接献祭两名守卫：播放特效后移除
  local function SacrificeGuard(guard)
    if guard and guard:IsValid() then
      local gx, gy, gz = guard.Transform:GetWorldPosition()
      local fx = SpawnPrefab("ling_guard_basic_fusion_fx")
      if fx then
        fx.Transform:SetPosition(gx, 0, gz)
      end
      guard:Remove()
    end
  end

  SacrificeGuard(guard1)
  SacrificeGuard(guard2)

  -- 在召唤者周围生成弦惊，并播放起手特效
  local leader = self.inst
  if leader and leader:IsValid() then
    local lx, ly, lz = leader.Transform:GetWorldPosition()
    local radius = 2 + math.random() * 1.5
    local angle = math.random() * 2 * math.pi
    local sx = lx + math.cos(angle) * radius
    local sz = lz + math.sin(angle) * radius

    local elite_guard = SpawnPrefab("ling_guard_elite")
    if elite_guard then
      elite_guard.Transform:SetPosition(sx, 0, sz)

      -- 起手 FX（临时使用 basic_start_fx）
      local startfx = SpawnPrefab("ling_guard_basic_start_fx")
      if startfx then
        startfx.Transform:SetPosition(sx, 0, sz)
      end

      if elite_guard.components.ling_guard then
        elite_guard.components.ling_guard:SetSlots(slots)
        elite_guard.components.ling_guard:SetLevel(elite_level)
      end

      if elite_guard.components.follower then
        elite_guard.components.follower:SetLeader(leader)
      end
    end
  end
end

function LingSummonManager:StartFusionAnimation(guard1, guard2, center_x, center_z, elite_level, slots)
  -- 让两个守卫进入融合状态，播放level_up动画
  if guard1.sg then
    guard1.sg:GoToState("fusion_levelup")
  end
  if guard2.sg then
    guard2.sg:GoToState("fusion_levelup")
  end

  -- 等待level_up动画播放完毕（大约0.5秒）
  self.inst:DoTaskInTime(0.5, function()
    if guard1:IsValid() and guard2:IsValid() then
      self:CompleteFusion(guard1, guard2, center_x, center_z, elite_level, slots)
    end
  end)
end

function LingSummonManager:CompleteFusion(guard1, guard2, center_x, center_z, elite_level, slots)
  -- 播放融合特效和音效
  local fx = SpawnPrefab("statue_transition_2")
  if fx then
    fx.Transform:SetPosition(center_x, 0, center_z)
  end
  -- 移除两个守卫
  guard1:Remove()
  guard2:Remove()

  -- 立即生成弦惊，播放start动画
  local elite_guard = SpawnPrefab("ling_guard_elite")
  if elite_guard then
    elite_guard.Transform:SetPosition(center_x, 0, center_z)

    -- 使用组件设置召唤者和插槽信息
    if elite_guard.components.ling_guard then
      elite_guard.components.ling_guard:SetSlots(slots)
      elite_guard.components.ling_guard:SetLevel(elite_level)
    end

    -- 设置跟随
    if elite_guard.components.follower then
      elite_guard.components.follower:SetLeader(self.inst)
    end
  end
end


function LingSummonManager:OptionalAllGuard(fn)
  local followers = self.inst.components.leader:GetFollowersByTag('ling_summon');
  for _, follower in pairs(followers) do
    fn(follower)
  end
end

-- 保存和加载方法
function LingSummonManager:OnSave()
    return {
        max_slots = self.max_slots
    }
end

function LingSummonManager:OnLoad(data)
    if data and data.max_slots then
        self:SetMaxSlots(data.max_slots)
    end
end

return LingSummonManager
