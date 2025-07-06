local CONSTANTS = require "ark_constants_ling"

local GUARD_SLOT_STATUS = CONSTANTS.GUARD_SLOT_STATUS
local GUARD_TYPE = CONSTANTS.GUARD_TYPE

local function getSlotCount(type)
  return type == GUARD_TYPE.XIANJING and 2 or 1
end

local LingSummonManager = Class(function(self, inst)
  self.inst = inst
  self.max_slots = 3
  self.callerOpened = false
  self.openedGuardPanelInst = nil

  -- 召唤兽插槽管理
  self.slots = {} -- 插槽数组，每个插槽包含召唤兽信息
  self.attached_ui = nil -- 绑定的UI组件

  -- 初始化插槽
  self:InitializeSlots()
end)

-- 插槽管理相关方法
function LingSummonManager:InitializeSlots()
  for i = 1, self.max_slots do
    self.slots[i] = {
      guid = nil,
      inst = nil,
      type = nil,
      level = nil,
      status = GUARD_SLOT_STATUS.EMPTY
    }
  end
end

function LingSummonManager:SetMaxSlots(max_slots)
  local old_max = self.max_slots
  self.max_slots = max_slots

  -- 扩展插槽数组
  if max_slots > old_max then
    for i = old_max + 1, max_slots do
      self.slots[i] = {
        guid = nil,
        inst = nil,
        type = nil,
        level = nil,
        status = GUARD_SLOT_STATUS.EMPTY
      }
    end
  end

  -- 同步UI状态
  self:SyncStatus()
end

function LingSummonManager:CanAssignToSlot(slot_index, required_slots)
  required_slots = required_slots or 1

  -- 检查插槽范围
  if slot_index < 1 or slot_index + required_slots - 1 > self.max_slots then
    return nil
  end

  if self.slots[slot_index].status ~= GUARD_SLOT_STATUS.EMPTY then
    return nil
  end
  -- 遍历所有插槽,找到满足数量可用的,并返回
  local slots = {slot_index}
  local count = 1
  for i = 1, self.max_slots do
    if i ~= slot_index and self.slots[i].status == GUARD_SLOT_STATUS.EMPTY then
      count = count + 1
      table.insert(slots, i)
      if count >= required_slots then
        break
      end
    end
  end
  if count < required_slots then
    return nil
  end
  return slots
end

-- 设置插槽为召唤中状态
function LingSummonManager:SetSlotSummoning(slots)
  self.slots[slots[1]].status = GUARD_SLOT_STATUS.SUMMONING
  for i = 2, #slots do
    self.slots[slots[i]].status = GUARD_SLOT_STATUS.DISABLED
  end
  -- 同步UI状态
  self:SyncStatus()
end

-- 清除插槽的召唤中状态
function LingSummonManager:ClearSlotSummoning(slots)
  self.slots[slots[1]].status = GUARD_SLOT_STATUS.EMPTY
  for i = 2, #slots do
    self.slots[slots[i]].status = GUARD_SLOT_STATUS.EMPTY
  end

  -- 同步UI状态
  self:SyncStatus()
end

function LingSummonManager:SetGuardToSlot(guard_inst, slots)
  self.slots[slots[1]].status = GUARD_SLOT_STATUS.OCCUPIED
  self.slots[slots[1]].inst = guard_inst
  self.slots[slots[1]].type = guard_inst.prefab
  self.slots[slots[1]].level = guard_inst.level
  for i = 2, #slots do
    self.slots[i].status = GUARD_SLOT_STATUS.DISABLED
  end
  -- 同步UI状态
  self:SyncStatus()

  return true
end

function LingSummonManager:FindGuardIndex(inst)
  for i = 1, self.max_slots do
    if self.slots[i].inst == inst then
      return i
    end
  end
  return nil
end

function LingSummonManager:RemoveGuardFromSlot(guard_inst)
  if not guard_inst then
    return false
  end

  local slot_index = self:FindGuardIndex(guard_inst)
  if slot_index then
    self.slots[slot_index].status = GUARD_SLOT_STATUS.EMPTY
    self.slots[slot_index].inst = nil
    self.slots[slot_index].type = nil
    self.slots[slot_index].level = nil
    -- 同步UI状态
    self:SyncStatus()
    return true
  end

  return false
end

function LingSummonManager:GetSlotData(slot_index)
  if slot_index and slot_index >= 1 and slot_index <= self.max_slots then
    return self.slots[slot_index]
  end
  return nil
end

function LingSummonManager:GetAllSlots()
  return self.slots
end

function LingSummonManager:GetSlotCount()
  return self.max_slots
end

function LingSummonManager:IsSlotEmpty(slot_index)
  if slot_index and slot_index >= 1 and slot_index <= self.max_slots then
    return self.slots[slot_index].guard_inst == nil
  end
  return false
end

function LingSummonManager:GetGuardInSlot(slot_index)
  if slot_index and slot_index >= 1 and slot_index <= self.max_slots then
    return self.slots[slot_index].guard_inst
  end
  return nil
end

function LingSummonManager:GetSlotInfo(slot_index)
  if slot_index and slot_index >= 1 and slot_index <= self.max_slots then
    local slot = self.slots[slot_index]
    return {
      guard_inst = slot.guard_inst,
      guard_type = slot.guard_type,
      guard_level = slot.guard_level,
      slot_occupied = slot.slot_occupied,
      is_empty = slot.guard_inst == nil
    }
  end
  return nil
end

-- UI同步相关方法
function LingSummonManager:SyncStatus()
  -- 如果召唤面板打开，重新打开以刷新状态
  if self.callerOpened then
    self:RequestOpenCaller()
  end
end

function LingSummonManager:OnFollowerLost(follower)
    self:RemoveGuardFromSlot(follower)
end

function LingSummonManager:OnFollowerAdded(follower)
  print("[LingSummonManager] OnFollowerAdded: 检测到follower添加", follower and follower.prefab or "nil")

  -- 检查是否是召唤兽
  if not follower or not follower:HasTag("ling_summon") then
    print("[LingSummonManager] OnFollowerAdded: 不是召唤兽，忽略")
    return
  end
  if not follower.saved_summoner_userid == self.inst.userid then
    print("[LingSummonManager] OnFollowerAdded: 不是自己的召唤兽，忽略")
    return
  end
  self:SetGuardToSlot(follower, follower.saved_slots)
end

function LingSummonManager:RequestOpenCaller()
  self.callerOpened = true

  -- 生成插槽摘要数据
  local summaries = {}
  for i = 1, self.max_slots do
    local slot = self.slots[i]
    table.insert(summaries, {
      type = slot.type,
      status = slot.status,
      name = slot.inst and slot.inst.components.named and slot.inst.components.named.name or nil,
      index = i
    })
  end

  SendModRPCToClient(GetClientModRPC("ling_summon", "open_caller"), self.inst.userid, json.encode(summaries),
    self.max_slots)
end

function LingSummonManager:RequestCloseCaller()
  self.callerOpened = false
end

function LingSummonManager:RequestOpenGuardPanel(slot_index)
  if not slot_index or slot_index < 1 or slot_index > self.max_slots then
    return false
  end

  local slot = self.slots[slot_index]
  if not slot.guard_inst or not slot.guard_inst:IsValid() then
    return false
  end

  -- 生成召唤兽数据
  local guard_data = {
    guid = slot.guard_inst.GUID,
    type = slot.guard_type,
    level = slot.guard_level,
    slot_index = slot_index,
    -- 可以添加更多召唤兽信息，如血量、状态等
    health_percent = slot.guard_inst.components.health and slot.guard_inst.components.health:GetPercent() or 1
  }

  self.openedGuardPanelInst = slot.guard_inst
  SendModRPCToClient(GetClientModRPC("ling_summon", "open_guard_panel"), self.inst.userid, json.encode(guard_data))
  return true
end

function LingSummonManager:RequestCloseGuardPanel()
  self.openedGuardPanelInst = nil
end

-- 召唤相关方法
function LingSummonManager:SummonQingping(slot_index)
  local slots = self:CanAssignToSlot(slot_index, getSlotCount(GUARD_TYPE.QINGPING))
  if not slots then
    return false
  end

  -- 自动获取当前精英等级
  local elite_level = (self.inst.components.ling_elite and self.inst.components.ling_elite:GetEliteLevel()) or 0

  -- 检查诗意消耗
  local poetry_component = self.inst.components.ling_poetry
  if not poetry_component then
    return false
  end

  local config = TUNING.LING_GUARDS.QINGPING.LEVELS[elite_level]
  local cost = config and config.SUMMON_COST or 10

  -- 检查诗意是否足够
  if not poetry_component:HasEnough(cost) then
    return false
  end

  -- 开始施法动作，传递插槽信息
  self:StartSummonCasting(GUARD_TYPE.QINGPING, elite_level, cost, slots)
  return true
end

function LingSummonManager:SummonXiaoyao(slot_index)
  local slots = self:CanAssignToSlot(slot_index, getSlotCount(GUARD_TYPE.XIAOYAO))
  if not slots then
    return false
  end

  -- 自动获取当前精英等级，检查等级要求（需要精一，即elite_level >= 1）
  local elite_level = (self.inst.components.ling_elite and self.inst.components.ling_elite:GetEliteLevel()) or 0
  if elite_level < 1 then
    return false
  end

  -- 检查诗意消耗
  local poetry_component = self.inst.components.ling_poetry
  if not poetry_component then
    return false
  end

  local config = TUNING.LING_GUARDS.XIAOYAO.LEVELS[elite_level]
  local cost = config and config.SUMMON_COST or 12

  -- 检查诗意是否足够
  if not poetry_component:HasEnough(cost) then
    return false
  end

  -- 开始施法动作，传递插槽信息
  self:StartSummonCasting(GUARD_TYPE.XIAOYAO, elite_level, cost, slots)
  return true
end

function LingSummonManager:SummonXianjing(slot_index)
  -- 自动获取当前精英等级，检查等级要求（需要精二，即elite_level >= 2）
  local elite_level = (self.inst.components.ling_elite and self.inst.components.ling_elite:GetEliteLevel()) or 0
  if elite_level < 2 then
    return false
  end

  -- 检查诗意消耗
  local poetry_component = self.inst.components.ling_poetry
  if not poetry_component then
    return false
  end

  local config = TUNING.LING_GUARDS.XIANJING.LEVELS[elite_level]
  local cost = config and config.SUMMON_COST or 15

  -- 检查诗意是否足够
  if not poetry_component:HasEnough(cost) then
    return false
  end

  local fusion_candidates = {}
  local guid = self.slots[slot_index]
  local current = Ents[guid]
  if not current or not current:IsValid() then
    return false
  end

  -- 寻找跟随令的清平和逍遥
  local x, y, z = self.inst.Transform:GetWorldPosition()
  local guards = TheSim:FindEntities(x, y, z, 30, {"ling_summon"}, {"INLIMBO"})

  for _, guard in ipairs(guards) do
    if guard.components.follower and guard.components.follower.leader == self.inst
      and guard ~= current
      and (guard.guard_type == GUARD_TYPE.QINGPING or guard.guard_type == GUARD_TYPE.XIAOYAO)
      and not guard.components.health:IsDead() then
      table.insert(fusion_candidates, guard)
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
  self:SetSlotSummoning(slots)

  -- 扣除诗意
  poetry_component:Dirty(-cost)

  -- 开始融合过程，传递插槽信息
  self:StartGuardFusion(guard1, guard2, elite_level, slots)

  return true
end

-- 施法和生成相关方法
function LingSummonManager:StartSummonCasting(type, level, cost, slots)
  -- 检查是否在忙碌状态
  if self.inst.sg and self.inst.sg:HasStateTag("busy") then
    return false
  end
  self:SetSlotSummoning(slots)
  -- 设置召唤数据
  self.inst.summon_data = {
    type = type,
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

function LingSummonManager:SpawnGuardAtPosition(guard_type, elite_level, spawn_x, spawn_z, slots)

  local guard = SpawnPrefab(guard_type)
  if guard then
    guard.Transform:SetPosition(spawn_x, 0, spawn_z)
    guard.saved_slots = slots
    guard.saved_summoner_userid = self.inst.userid

    -- 设置等级
    guard:SetLevel(elite_level)

    -- 设置跟随，插槽分配完全依靠 OnFollowerAdded 回调
    if guard.components.follower then
      guard.components.follower:SetLeader(self.inst)
    end

    return true
  end

  return false
end

-- 融合相关方法
function LingSummonManager:StartGuardFusion(guard1, guard2, elite_level, slots)
  -- 计算融合中心点
  local g1_x, g1_y, g1_z = guard1.Transform:GetWorldPosition()
  local g2_x, g2_y, g2_z = guard2.Transform:GetWorldPosition()
  local center_x = (g1_x + g2_x) / 2
  local center_z = (g1_z + g2_z) / 2

  -- 停止守卫的所有行为
  guard1.components.locomotor:Stop()
  guard2.components.locomotor:Stop()

  -- 设置融合标记，防止被其他系统干扰
  guard1.is_fusing = true
  guard2.is_fusing = true

  -- 设置无敌状态，防止融合过程被打断
  if guard1.components.health then
    guard1.components.health.invulnerable = true
  end
  if guard2.components.health then
    guard2.components.health.invulnerable = true
  end

  -- 让两个守卫互相移动接近
  local function MoveToCenter(guard, target_x, target_z)
    if guard and guard:IsValid() and not guard.components.health:IsDead() then
      guard.components.locomotor:GoToPoint(Vector3(target_x, 0, target_z))
    end
  end

  MoveToCenter(guard1, center_x, center_z)
  MoveToCenter(guard2, center_x, center_z)

  -- 检查融合进度的任务
  local fusion_task
  fusion_task = self.inst:DoPeriodicTask(0.1, function()
    -- 检查守卫是否还存在且有效
    if not guard1:IsValid() or not guard2:IsValid() or guard1.components.health:IsDead()
      or guard2.components.health:IsDead() then
      if fusion_task then
        fusion_task:Cancel()
      end
      return
    end

    -- 检查距离
    local g1_x, g1_y, g1_z = guard1.Transform:GetWorldPosition()
    local g2_x, g2_y, g2_z = guard2.Transform:GetWorldPosition()
    local distance = math.sqrt((g1_x - g2_x) ^ 2 + (g1_z - g2_z) ^ 2)

    -- 当两个守卫足够接近时开始融合动画
    if distance < 2 then
      fusion_task:Cancel()
      self:StartFusionAnimation(guard1, guard2, center_x, center_z, elite_level, slots)
    end
  end)

  -- 超时保护，10秒后强制融合
  self.inst:DoTaskInTime(10, function()
    if fusion_task then
      fusion_task:Cancel()
    end
    if guard1:IsValid() and guard2:IsValid() then
      self:StartFusionAnimation(guard1, guard2, center_x, center_z, elite_level, slots)
    end
  end)
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
  local xianjing = SpawnPrefab("xianjing")
  if xianjing then
    xianjing.Transform:SetPosition(center_x, 0, center_z)
    xianjing.saved_slots = slots
    xianjing.saved_summoner_userid = self.inst.userid

    -- 设置等级
    xianjing:SetLevel(elite_level)

    -- 设置跟随
    if xianjing.components.follower then
      xianjing.components.follower:SetLeader(self.inst)
    end
  end
end

-- 行为控制相关方法
function LingSummonManager:SwitchQingpingBehaviorMode()
  -- 寻找附近的清平
  local x, y, z = self.inst.Transform:GetWorldPosition()
  local qingpings = TheSim:FindEntities(x, y, z, 20, {"qingping"})

  local behavior_modes = {"cautious", "guard", "attack"}
  local mode_names = {
    cautious = "慎",
    guard = "守",
    attack = "攻"
  }

  for _, qingping in ipairs(qingpings) do
    if qingping.components.follower and qingping.components.follower.leader == self.inst then
      -- 获取当前模式
      local current_mode = qingping.behavior_mode or "cautious"

      -- 切换到下一个模式
      local current_index = 1
      for i, mode in ipairs(behavior_modes) do
        if mode == current_mode then
          current_index = i
          break
        end
      end

      local next_index = (current_index % #behavior_modes) + 1
      local next_mode = behavior_modes[next_index]

      -- 设置新模式
      qingping:SetBehaviorMode(next_mode)

      -- 显示提示信息
      if self.inst.components.talker then
        self.inst.components.talker:Say("清平模式: " .. mode_names[next_mode])
      end
    end
  end
end

function LingSummonManager:OptionalAllGuard(fn)
  local followers = self.inst.components.leader:GetFollowersByTag('ling_summon');
  for _, follower in pairs(followers) do
    fn(follower)
  end
end

-- 注意：不再需要保存加载方法，插槽关系通过follower机制自动恢复

return LingSummonManager
