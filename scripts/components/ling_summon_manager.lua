local CONSTANTS = require "ark_constants_ling"

local LING_TUNING = require("ling_guard_tuning")
local FORM = CONSTANTS.GUARD_FORM

local GUARD_LOCATION = CONSTANTS.GUARD_LOCATION
local GUARD_SLOT_STATUS = CONSTANTS.GUARD_SLOT_STATUS
local SLOT_ROLE = CONSTANTS.SLOT_ROLE

local MAX_GUARDS = 0;
-- 遍历 TUNING.LING.ELITE
for k, v in pairs(TUNING.LING.ELITE) do
  MAX_GUARDS = math.max(MAX_GUARDS, v.MAX_GUARDS)
end

local function getSlotCountByForm(form)
  return form == FORM.XIANJING and 2 or 1
end

local function clone_slots(slots)
  if not slots then
    return nil
  end
  local copied = {}
  for i = 1, #slots do
    copied[i] = slots[i]
  end
  return copied
end

local function EncodeWorldId(raw_world_id)
  local str = tostring(raw_world_id or "")
  local hash = 0
  for i = 1, #str do
    hash = (hash * 131 + string.byte(str, i)) % 65536
  end
  return hash
end

local function GetCurrentWorldId()
  return EncodeWorldId(TheShard and TheShard:GetShardId() or 0)
end

local function NormalizeWorldId(world_id)
  local as_number = tonumber(world_id)
  if as_number ~= nil then
    return math.floor(as_number) % 65536
  end
  return EncodeWorldId(world_id)
end

-- 寻找周围可用地块用于生成召唤物
local function FindValidSpawnPoint(inst, radius)
  local x, y, z = inst.Transform:GetWorldPosition()
  local pt = Vector3(x, 0, z)
  local offset = FindWalkableOffset(pt, math.random() * TWOPI, radius, 8, true, false, nil, false, true)
  if offset then
    return pt + offset
  end
  return nil
end

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

local function onmax_slots(self, value)
  self.inst.replica.ling_summon_manager.state.max_slots = value
end

local LingSummonManager = Class(function(self, inst)
  self.inst = inst
  self.max_slots = 0
  self.callerOpened = false
  self.ready_for_migration = false
  self.guard_slots = {}
  self.pending_sync_task = nil
  self.periodic_sync_task = self.inst:DoPeriodicTask(1, function()
    self:SyncCurrentWorldSlots()
  end)
  self:SetMaxSlots(3)
  self:RequestCurrentWorldSync(0)
end, nil, {
  max_slots = onmax_slots,
})

function LingSummonManager:OnRemoveFromEntity()
  if self.pending_sync_task then
    self.pending_sync_task:Cancel()
    self.pending_sync_task = nil
  end
  if self.periodic_sync_task then
    self.periodic_sync_task:Cancel()
    self.periodic_sync_task = nil
  end
end

-- 设置槽位数据到网络变量（通过 replica）
function LingSummonManager:SetSlotData(slot_index, data)
  self.inst.replica.ling_summon_manager:SetSlotData(slot_index, data)
end

-- 获取槽位数据（从 replica）
function LingSummonManager:GetSlotData(slot_index)
  return self.inst.replica.ling_summon_manager:GetSlotData(slot_index)
end

function LingSummonManager:DisableSlot(idx)
  if idx >= 1 and idx <= self.max_slots then
    self:SetSlotData(idx, {
      inst = nil,
      form = FORM.NONE,
      level = 0,
      status = GUARD_SLOT_STATUS.DISABLED,
      -- 其他世界
      world = GUARD_LOCATION.NONE,
      role = SLOT_ROLE.NONE,
      primary_slot = 0,
      slot_count = 1,
    })
  end
end

function LingSummonManager:EmptySlot(idx)
  if idx >= 1 and idx <= self.max_slots then
    self:SetSlotData(idx, {
      inst = nil,
      form = FORM.NONE,
      level = 0,
      status = GUARD_SLOT_STATUS.EMPTY,
      world = GUARD_LOCATION.NONE,
      role = SLOT_ROLE.NONE,
      primary_slot = 0,
      slot_count = 1,
    })
  end
end

function LingSummonManager:SetGuardSlots(guard, slots)
  if guard and guard.GUID and slots and #slots > 0 then
    self.guard_slots[guard.GUID] = clone_slots(slots)
  end
end

function LingSummonManager:GetGuardSlots(guard)
  if not guard or not guard.GUID then
    return nil
  end
  local slots = self.guard_slots[guard.GUID]
  if slots then
    return clone_slots(slots)
  end
  local primary = self:GetGuardSlotIndex(guard)
  if primary then
    return self:GetSlotsByPrimary(primary)
  end
  return nil
end

function LingSummonManager:ClearGuardSlots(guard)
  if guard and guard.GUID then
    self.guard_slots[guard.GUID] = nil
  end
end

function LingSummonManager:GetSlotsByPrimary(primary_slot)
  if not primary_slot then
    return nil
  end
  local primary_data = self:GetSlotData(primary_slot)
  if not primary_data then
    return nil
  end
  local slots = {primary_slot}
  for i = 1, self.max_slots do
    if i ~= primary_slot then
      local slot_data = self:GetSlotData(i)
      if slot_data and slot_data.role == SLOT_ROLE.SECONDARY and slot_data.primary_slot == primary_slot then
        table.insert(slots, i)
      end
    end
  end
  table.sort(slots)
  return slots
end

function LingSummonManager:ClearSlotsByPrimary(primary_slot)
  local primary_data = self:GetSlotData(primary_slot)
  if primary_data and primary_data.inst then
    self:ClearGuardSlots(primary_data.inst)
  end
  local slots = self:GetSlotsByPrimary(primary_slot)
  if not slots then
    self:EmptySlot(primary_slot)
    return
  end
  for i = 1, #slots do
    self:EmptySlot(slots[i])
  end
end

function LingSummonManager:SetMaxSlots(max_slots)
  if max_slots <= self.max_slots then
    return
  end
  local old_max = self.max_slots
  self.max_slots = max_slots
  for i = old_max + 1, max_slots do
    if i <= MAX_GUARDS then
      self:EmptySlot(i)
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
  for i = 1, self.max_slots do
    local slot_data = self:GetSlotData(i)
    if slot_data and slot_data.inst == inst and slot_data.role ~= SLOT_ROLE.SECONDARY then
      return i
    end
  end
  return nil
end

-- 验证守卫是否属于这个玩家
function LingSummonManager:IsGuardOwnedByPlayer(guard_inst)
  -- 检查守卫是否在玩家的插槽中
  local slot_index = self:GetGuardSlotIndex(guard_inst)
  if slot_index then
    return true
  end
  return false
end

-- 设置插槽为召唤中状态
function LingSummonManager:SetSlotSummoning(slots, form, level)
  local world_id = GetCurrentWorldId()
  local primary_slot = slots[1]
  self:SetSlotData(primary_slot, {
    inst = nil,
    form = form,
    level = level,
    status = GUARD_SLOT_STATUS.SUMMONING,
    world = GUARD_LOCATION.CURRENT_WORLD,
    world_id = world_id,
    role = SLOT_ROLE.PRIMARY,
    primary_slot = primary_slot,
    slot_count = #slots,
  })
  for i = 2, #slots do
    self:SetSlotData(slots[i], {
      inst = nil,
      form = form,
      level = level,
      status = GUARD_SLOT_STATUS.DISABLED,
      world = GUARD_LOCATION.CURRENT_WORLD,
      world_id = world_id,
      role = SLOT_ROLE.SECONDARY,
      primary_slot = primary_slot,
      slot_count = #slots,
    })
  end
end

function LingSummonManager:InsertGuardToSlot(guard, slots)
  if not guard or not slots or #slots == 0 then
    return
  end
  local world_id = GetCurrentWorldId()
  local primary_slot = slots[1]
  self:SetSlotData(primary_slot, {
    inst = guard,
    form = guard.components.ling_guard.form,
    level = guard.components.ling_guard.level,
    status = GUARD_SLOT_STATUS.OCCUPIED,
    world = GUARD_LOCATION.CURRENT_WORLD,
    world_id = world_id,
    role = SLOT_ROLE.PRIMARY,
    primary_slot = primary_slot,
    slot_count = #slots,
  })
  for i = 2, #slots do
    self:SetSlotData(slots[i], {
      inst = guard,
      form = guard.components.ling_guard.form,
      level = guard.components.ling_guard.level,
      status = GUARD_SLOT_STATUS.DISABLED,
      world = GUARD_LOCATION.CURRENT_WORLD,
      world_id = world_id,
      role = SLOT_ROLE.SECONDARY,
      primary_slot = primary_slot,
      slot_count = #slots,
    })
  end
  self:SetGuardSlots(guard, slots)
end

function LingSummonManager:FindGuardIndex(inst)
  for i = 1, self.max_slots do
    local slot_data = self:GetSlotData(i)
    if slot_data and slot_data.inst == inst and slot_data.role ~= SLOT_ROLE.SECONDARY then
      return i
    end
  end
  return nil
end

function LingSummonManager:RemoveGuardFromSlot(guard_inst)
  if not guard_inst then
    return false
  end

  if guard_inst.components.ling_guard then
    if (guard_inst.components.ling_guard:IsPanelOpenedBy(self.inst)) then
      guard_inst.components.ling_guard:ClosePanel(self.inst)
    end
  end
  local slots = self:GetGuardSlots(guard_inst)
  if not slots then
    local primary = self:GetGuardSlotIndex(guard_inst)
    if primary then
      slots = self:GetSlotsByPrimary(primary)
    end
  end

  if slots then
    for i = 1, #slots do
      self:EmptySlot(slots[i])
    end
    self:ClearGuardSlots(guard_inst)
    return true
  end

  return false
end

function LingSummonManager:RequestCurrentWorldSync(delay)
  if self.pending_sync_task then
    self.pending_sync_task:Cancel()
    self.pending_sync_task = nil
  end
  self.pending_sync_task = self.inst:DoTaskInTime(delay or 0.5, function()
    self.pending_sync_task = nil
    self:SyncCurrentWorldSlots()
  end)
end

function LingSummonManager:SyncCurrentWorldSlots()
  if self.ready_for_migration then
    return
  end
  local world_id = GetCurrentWorldId()
  for i = 1, self.max_slots do
    local slot_data = self:GetSlotData(i)
    if slot_data and slot_data.role ~= SLOT_ROLE.SECONDARY and slot_data.status == GUARD_SLOT_STATUS.OCCUPIED then
      local is_same_world = NormalizeWorldId(slot_data.world_id) == world_id
      if is_same_world then
        local guard_inst = slot_data.inst
        local is_alive = guard_inst and guard_inst:IsValid() and not (guard_inst.components.health and guard_inst.components.health:IsDead())
        local still_following = is_alive and self.inst.components.leader and self.inst.components.leader.followers and self.inst.components.leader.followers[guard_inst] ~= nil
        if still_following then
          if slot_data.world ~= GUARD_LOCATION.CURRENT_WORLD then
            self:SetSlotData(i, { world = GUARD_LOCATION.CURRENT_WORLD })
          end
        else
          self:ClearSlotsByPrimary(i)
        end
      else
        if slot_data.world ~= GUARD_LOCATION.OTHER_WORLD then
          self:SetSlotData(i, { world = GUARD_LOCATION.OTHER_WORLD })
        end
      end
    end
  end
end

function LingSummonManager:SetForm(guard_inst, form)
  local index = self:FindGuardIndex(guard_inst)
  if index then
    self:SetSlotData(index, { form = form })
  end
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

function LingSummonManager:OnFollowerLost(follower)
  ArkLogger:Debug("LingSummonManager:OnFollowerLost: 检测到follower丢失", follower)
    if not follower then
        return
    end
    -- 取消关联时，关闭召唤兽的技能
    if follower.components.ling_guard_skill then
      follower.components.ling_guard_skill:DeactivateAllSkills()
    end
    if not self.ready_for_migration then
      self:RemoveGuardFromSlot(follower)
    end
    self:RequestCurrentWorldSync(0.1)
end
-- 更新守卫的迁移状态（当behavior_mode变化时调用）
function LingSummonManager:PrepareForMigration()
    self.ready_for_migration = true
    -- 遍历所有守卫，设置迁移状态
    local slots = self:GetAllSlots()
    for i, slot_data in ipairs(slots) do
      ArkLogger:Debug("LingSummonManager:PrepareForMigration: 检查守卫 跟随迁移", slot_data.inst and slot_data.inst.components.ling_guard:CanMigrate())
        if slot_data.inst and slot_data.inst:IsValid() and slot_data.inst.components.ling_guard and slot_data.inst.components.ling_guard:CanMigrate() then
          slot_data.inst.components.ling_guard:PrepareForMigration()
          slot_data.inst:PushEvent("despawn")
        end
    end
end

function LingSummonManager:OnFollowerAdded(follower)
  ArkLogger:Debug("LingSummonManager:OnFollowerAdded: 检测到follower添加", follower)
  -- 仅处理令的召唤兽
  if not follower or not follower.components.ling_guard then
    ArkLogger:Debug("LingSummonManager:OnFollowerAdded: 不是召唤兽，忽略")
    return
  end
  follower.owner = self.inst
  local slots = self:GetGuardSlots(follower)

  if not slots then
    for i = 1, self.max_slots do
      local slot_data = self:GetSlotData(i)
      if slot_data and slot_data.status == GUARD_SLOT_STATUS.OCCUPIED and slot_data.inst == nil and slot_data.role ~= SLOT_ROLE.SECONDARY then
        if slot_data.form == follower.components.ling_guard.form and slot_data.level == follower.components.ling_guard.level then
          slots = self:GetSlotsByPrimary(i)
          break
        end
      end
    end
  end

  if not slots then
    ArkLogger:Warn("LingSummonManager:OnFollowerAdded: 未找到槽位，尝试兜底分配")
    local required = getSlotCountByForm(follower.components.ling_guard.form)
    for i = 1, self.max_slots do
      slots = self:CanAssignToSlot(i, required)
      if slots then
        break
      end
    end
  end

  if slots then
    self:InsertGuardToSlot(follower, slots)
  else
    ArkLogger:Warn("LingSummonManager:OnFollowerAdded: 槽位分配失败", follower)
  end

  -- 关联时，检查令的技能状态并同步
  if follower.components.ling_guard_skill then
    follower.components.ling_guard_skill:SyncWithOwner()
  end
  self:RequestCurrentWorldSync(0.1)
end

-- 召唤相关方法
function LingSummonManager:SummonBasic(slot_index, pos)
  ArkLogger:Debug("LingSummonManager:SummonBasic", slot_index, pos)
  if self.inst.sg:HasStateTag("busy") then
    return false
  end
  local form = FORM.QINGPING
  local slots = self:CanAssignToSlot(slot_index, getSlotCountByForm(form))
  if not slots then
    return false
  end

  -- 自动获取当前精英等级
  local elite_level = (self.inst.components.ark_elite and self.inst.components.ark_elite.elite) or 1

  -- 诗意直接扣掉
  if self.inst.components.ling_poetry then
    local cfg = LING_TUNING.GetLevelGuardConfig(form, elite_level)
    local cost = cfg and cfg.SUMMON_COST or 0
    if not self.inst.components.ling_poetry:HasEnough(cost) then
      -- TODO: 可以说话提示诗意不足
      return false
    end
    self.inst.components.ling_poetry:Dirty(-cost)
  end
  if pos == nil then
    pos = FindValidSpawnPoint(self.inst, 3)
    if not pos then
      return false
    end
  end
  self:SetSlotSummoning(slots, form, elite_level)
  self.inst.sg:GoToState("ling_summon", {
    form = form,
    level = elite_level,
    slots = slots,
    pos = pos,
  })
  return true
end

-- 融合

function LingSummonManager:Fusion(guard_inst)
  if self.inst.sg:HasStateTag("busy") then
    return false
  end
  -- 精英化检查
  local elite_level = self.inst.components.ark_elite and self.inst.components.ark_elite.elite or 0
  if elite_level < 3 then
    return false
  end
  -- 插槽索引检查（从 guard_inst 获取）
  if not guard_inst or not guard_inst:IsValid() then
    return false
  end
  local slot_index = self:GetGuardSlotIndex(guard_inst)
  if not slot_index then
    return false
  end
  local slotData = self:GetSlotData(slot_index)
  local current = guard_inst
  -- 可融合检查
  local fusion_candidates = {}
  local all = self:GetAllSlots()
  for _, slot_data in pairs(all) do
    if slot_data.status == GUARD_SLOT_STATUS.OCCUPIED
      and slot_data.inst
      and slot_data.inst:IsValid()
      and slot_data.inst ~= current
      and (slot_data.form == FORM.QINGPING or slot_data.form == FORM.XIAOYAO)
      and not slot_data.inst.components.health:IsDead()
      and slot_data.inst.components.ling_guard:GetWorkMode() == CONSTANTS.GUARD_WORK_MODE.NONE then
        table.insert(fusion_candidates, slot_data.inst)
    end
  end

  -- 需要至少两个守卫进行融合
  if #fusion_candidates < 1 then
    if self.inst.components.talker then
      -- TODO: 说话提示
    end
    return false
  end
  local pos = FindValidSpawnPoint(self.inst, 3)
  if not pos then
    return false
  end
  local form = FORM.XIANJING
  if self.inst.components.ling_poetry then
    local cfg = LING_TUNING.GetLevelGuardConfig(form, elite_level)
    local cost = cfg and cfg.SUMMON_COST or 0
    if not self.inst.components.ling_poetry:HasEnough(cost) then
      -- TODO: 可以说话提示诗意不足
      return false
    end
    -- 立即扣除
    self.inst.components.ling_poetry:Dirty(-cost)
  end
  -- 选择血量最低一个
  table.sort(fusion_candidates, function(a, b)
    return a.components.health:GetPercent() < b.components.health:GetPercent()
  end)
  local guard1 = current
  local guard2 = fusion_candidates[1]
  local slots = { slot_index, self:FindGuardIndex(guard2) }
  self:SetSlotSummoning(slots, form, elite_level)
  SacrificeGuard(guard1)
  SacrificeGuard(guard2)
  -- 特效
  local startfx = SpawnPrefab("ling_guard_basic_start_fx")
  startfx.Transform:SetPosition(pos:Get())
  self:SpawnGuardAtPosition(form, elite_level, pos, slots)
  -- 添加buff
  self.inst:AddDebuff("so_is_writ_an_ode_to_wine_buff" .. guard1.GUID, "so_is_writ_an_ode_to_wine_buff")
  return true
end

function LingSummonManager:SpawnGuardAtPosition(form, elite_level, pos, slots)
  local guard = SpawnPrefab(form == FORM.XIANJING and "ling_guard_elite" or "ling_guard_basic")
  guard.Transform:SetPosition(pos:Get())
  self:SetGuardSlots(guard, slots)
  guard.components.ling_guard:SetLevel(elite_level, true)
  guard.components.follower:SetLeader(self.inst)

  if guard.components.ling_guard_plant then
    local plant_container = SpawnPrefab("ling_guard_plant_container")
    plant_container.entity:SetParent(guard.entity)
    plant_container.Transform:SetPosition(0, 0, 0)
    guard.plant_container = plant_container
    local plant_club = SpawnPrefab("ling_guard_plant_club")
    plant_club.entity:SetParent(guard.entity)
    plant_club.Transform:SetPosition(0, 0, 0)
    guard.plant_club = plant_club
    -- 设置等级
    guard.components.ling_guard_plant:SetLevel(elite_level)
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
  ArkLogger:Debug("LingSummonManager:OnSave")
  local data = {
    max_slots = self.max_slots,
    migrationguards = {},
    slots = {},
  }
  local migration_saved = {}
  -- 保存所有待迁移的守卫
  local slots_data = self:GetAllSlots()
  for _, slot_data in ipairs(slots_data) do
    table.insert(data.slots, {
      form = slot_data.form,
      level = slot_data.level,
      status = slot_data.status,
      world_id = slot_data.world_id,
      role = slot_data.role,
      primary_slot = slot_data.primary_slot,
      slot_count = slot_data.slot_count,
    })
    local ready_for_migration = slot_data.inst and slot_data.inst:IsValid() and slot_data.inst.ready_for_migration
    if ready_for_migration then
      local guid = slot_data.inst.GUID
      if not migration_saved[guid] then
        migration_saved[guid] = true
        local save_record = slot_data.inst:GetSaveRecord()
        table.insert(data.migrationguards, save_record)
      end
    end
  end
  return data
end

function LingSummonManager:OnLoad(data)
    ArkLogger:Debug("LingSummonManager:OnLoad", self.inst.migrationpets, data and data.migrationguards)
    if data and data.max_slots then
        self:SetMaxSlots(data.max_slots)
    end
    if data and data.slots then
    local broken_summoning_primaries = {}
    for i, slot_data in ipairs(data.slots) do
      if slot_data.status == GUARD_SLOT_STATUS.SUMMONING then
        broken_summoning_primaries[i] = true
      end
    end
        local world_id = GetCurrentWorldId()
        for i, slot_data in ipairs(data.slots) do
          ArkLogger:Debug("LingSummonManager:OnLoad:", i, slot_data.status)
      local primary_slot = slot_data.primary_slot or 0
      local is_broken_summoning = slot_data.status == GUARD_SLOT_STATUS.SUMMONING
      local is_broken_secondary = slot_data.role == SLOT_ROLE.SECONDARY and broken_summoning_primaries[primary_slot]
      if is_broken_summoning or is_broken_secondary then
        self:EmptySlot(i)
      else
            local is_occupied = slot_data.status == GUARD_SLOT_STATUS.OCCUPIED
            local world = GUARD_LOCATION.NONE
            local slot_world_id = NormalizeWorldId(slot_data.world_id)
            if is_occupied then
              world = slot_world_id == world_id and GUARD_LOCATION.CURRENT_WORLD or GUARD_LOCATION.OTHER_WORLD
            end
            self:SetSlotData(i, {
                inst = nil,
                form = slot_data.form,
                level = slot_data.level,
                status = slot_data.status,
                world_id = slot_world_id,
                world = world,
                role = slot_data.role or SLOT_ROLE.NONE,
        primary_slot = primary_slot,
                slot_count = slot_data.slot_count or 1,
            })
      end
        end
    end
    if data and data.migrationguards and self.inst.migrationpets then
      ArkLogger:Debug("LingSummonManager:OnLoad: 读取待迁移守卫", #data.migrationguards)
        for _, guard_data in ipairs(data.migrationguards) do
          ArkLogger:Debug("LingSummonManager:OnLoad: 读取待迁移守卫", guard_data)
            local guard = SpawnSaveRecord(guard_data)
            if guard then
                table.insert(self.inst.migrationpets, guard)
            end
        end
    end
      self:RequestCurrentWorldSync(1)
end

return LingSummonManager
