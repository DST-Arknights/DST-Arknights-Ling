local utils = require "ark_utils_ling"
local CONSTANTS = require "ark_constants_ling"

local MAX_GUARDS = 0;
-- 遍历 TUNING.LING.ELITE
for k, v in pairs(TUNING.LING.ELITE) do
  MAX_GUARDS = math.max(MAX_GUARDS, v.MAX_GUARDS)
end

local LingSummonManagerReplica = Class(function(self, inst)
  self.inst = inst
  self._slots = {}

  -- 添加 max_slots 网络变量
  self._max_slots = net_tinybyte(inst.GUID, "ling_summon_manager._max_slots", "maxslotsdirty")

  if not TheWorld.ismastersim then
    -- 监听 max_slots 变化
    self.inst:ListenForEvent("maxslotsdirty", function()
      print("[LingSummonManagerReplica] maxslotsdirty", self._max_slots:value())
      self:OnMaxSlotsChanged()
    end, inst)
  end

  for i = 1, MAX_GUARDS do
    self._slots[i] = {}
    self._slots[i].inst = net_entity(inst.GUID, "ling_summon_manager._slots_" .. i .. "_inst", "slotinstdirty_" .. i)
    self._slots[i].type = net_tinybyte(inst.GUID, "ling_summon_manager._slots_" .. i .. "_type", "slottypedirty_" .. i)
    self._slots[i].level = net_tinybyte(inst.GUID, "ling_summon_manager._slots_" .. i .. "_level", "slotleveldirty_" .. i)
    self._slots[i].status = net_tinybyte(inst.GUID, "ling_summon_manager._slots_" .. i .. "_status", "slotstatusdirty_" .. i)
    self._slots[i].status:set(CONSTANTS.GUARD_SLOT_STATUS.DISABLED)
    if not TheWorld.ismastersim then
      -- 监听每个槽位的网络变量变化，分别监听不同的dirty事件但触发同一个方法
      self.inst:ListenForEvent("slotinstdirty_" .. i, function()
        print("[LingSummonManagerReplica] slotinstdirty_" .. i)
        self:OnSlotChanged(i)
      end, inst)
      self.inst:ListenForEvent("slottypedirty_" .. i, function()
        print("[LingSummonManagerReplica] slottypedirty_" .. i)
        self:OnSlotChanged(i)
      end, inst)
      self.inst:ListenForEvent("slotleveldirty_" .. i, function()
        print("[LingSummonManagerReplica] slotleveldirty_" .. i)
        self:OnSlotChanged(i)
      end, inst)
      self.inst:ListenForEvent("slotstatusdirty_" .. i, function()
        print("[LingSummonManagerReplica] slotstatusdirty_" .. i)
        self:OnSlotChanged(i)
      end, inst)
    end
  end
end)

-- 当槽位数据变化时调用
function LingSummonManagerReplica:OnSlotChanged(slot_index)
  if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_poetry then
    -- 通知 UI 更新槽位按钮
    ThePlayer.HUD.controls.ling_poetry:OnSlotDataChanged(slot_index)
  end
end

-- 当最大槽位数变化时调用
function LingSummonManagerReplica:OnMaxSlotsChanged()
  if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_poetry then
    -- 通知 UI 重新绘制按钮（槽位数量变化）
    ThePlayer.HUD.controls.ling_poetry:RedrawButtons()
  end
end

-- 设置最大槽位数（由服务端调用）
function LingSummonManagerReplica:SetMaxSlots(max_slots)
  self._max_slots:set(max_slots)
end

-- 获取最大槽位数
function LingSummonManagerReplica:GetMaxSlots()
  return self._max_slots:value()
end

-- 获取槽位数据
function LingSummonManagerReplica:GetSlotData(slot_index)
  if slot_index and slot_index >= 1 and slot_index <= MAX_GUARDS and self._slots[slot_index] then
    local slot = self._slots[slot_index]
    return {
      inst = slot.inst:value(),
      type = slot.type:value(),
      level = slot.level:value(),
      status = slot.status:value(),
      index = slot_index
    }
  end
  return nil
end

-- 获取所有槽位数据
function LingSummonManagerReplica:GetAllSlotsData()
  local slots_data = {}
  for i = 1, MAX_GUARDS do
    slots_data[i] = self:GetSlotData(i)
  end
  return slots_data
end

-- 获取可用的槽位数量（基于 max_slots，更可靠）
function LingSummonManagerReplica:GetAvailableSlotCount()
  return self._max_slots:value()
end

-- 获取可用的槽位数据列表（基于 max_slots）
function LingSummonManagerReplica:GetAvailableSlotsData()
  local available_slots = {}
  local max_slots = self._max_slots:value()
  for i = 1, max_slots do
    local slot_data = self:GetSlotData(i)
    if slot_data then
      print("[LingSummonManagerReplica] GetAvailableSlotsData", i, slot_data.type, slot_data.status)
      table.insert(available_slots, slot_data)
    end
  end
  return available_slots
end

return LingSummonManagerReplica