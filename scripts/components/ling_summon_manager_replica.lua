local utils = require "ark_utils_ling"
local CONSTANTS = require "ark_constants_ling"

local MAX_GUARDS = 0;
-- 遍历 TUNING.LING.ELITE
for k, v in pairs(TUNING.LING.ELITE) do
  MAX_GUARDS = math.max(MAX_GUARDS, v.MAX_GUARDS)
end

local SafeCallLingPoetryUI = GenSafeCall(function(inst)
  return inst and inst.HUD and inst.HUD.controls and inst.HUD.controls.ling_poetry
end)

local LingSummonManagerReplica = Class(function(self, inst)
  self.inst = inst
  local stateDefine = {
    max_slots = "tinybyte:classified",
  }
  local watchGroup = {}
  for i = 1, MAX_GUARDS do
    stateDefine["inst_" .. i] = "entity:classified"
    stateDefine["form_" .. i] = "tinybyte:classified"
    stateDefine["level_" .. i] = "tinybyte:classified"
    stateDefine["status_" .. i] = "tinybyte:classified"
    stateDefine["word_" .. i] = "tinybyte:classified"
    watchGroup[i] = {
      "inst_" .. i,
      "form_" .. i,
      "level_" .. i,
      "status_" .. i,
      "word_" .. i,
    }
  end
  self.state = NetState(self.inst, stateDefine)
  self.state:Attach(self.inst)
  for i, v in pairs(watchGroup) do
    self.state:Watch(v, function()
      SafeCallLingPoetryUI(self.inst):OnSlotDataChanged(i)
    end)
  end
  self.state:Watch("max_slots", function()
    SafeCallLingPoetryUI(self.inst):SetMaxSlots(self.state.max_slots)
  end)
end)
-- 设置最大槽位数（由服务端调用）
function LingSummonManagerReplica:SetMaxSlots(max_slots)
  self.state.max_slots = max_slots
end

-- 获取最大槽位数
function LingSummonManagerReplica:GetMaxSlots()
  return self.state.max_slots
end

-- 获取槽位数据
function LingSummonManagerReplica:GetSlotData(slot_index)
  if slot_index and slot_index >= 1 and slot_index <= MAX_GUARDS then
    return {
      inst = self.state["inst_" .. slot_index],
      form = self.state["form_" .. slot_index],
      level = self.state["level_" .. slot_index],
      status = self.state["status_" .. slot_index],
      world = self.state["word_" .. slot_index],
      index = slot_index
    }
  end
  return nil
end

function LingSummonManagerReplica:SetSlotData(slot_index, data)
  if slot_index and slot_index >= 1 and slot_index <= MAX_GUARDS then
    if data.inst ~= nil then
      self.state["inst_" .. slot_index] = data.inst
    end
    if data.form ~= nil then
      self.state["form_" .. slot_index] = data.form
    end
    if data.level ~= nil then
      self.state["level_" .. slot_index] = data.level
    end
    if data.status ~= nil then
      self.state["status_" .. slot_index] = data.status
    end
    if data.world ~= nil then
      self.state["word_" .. slot_index] = data.world
    end
  end
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
  return self.state.max_slots
end

-- 获取可用的槽位数据列表（基于 max_slots）
function LingSummonManagerReplica:GetAvailableSlotsData()
  local available_slots = {}
  local max_slots = self.state.max_slots
  for i = 1, max_slots do
    local slot_data = self:GetSlotData(i)
    if slot_data and slot_data.status ~= CONSTANTS.GUARD_SLOT_STATUS.DISABLED then
      table.insert(available_slots, slot_data)
    end
  end
  return available_slots
end

function LingSummonManagerReplica:GetGuardSlotIndex(inst)
  for i = 1, MAX_GUARDS do
    local slot_data = self:GetSlotData(i)
    if slot_data and slot_data.inst == inst then
      return i
    end
  end
  return nil
end

function LingSummonManagerReplica:SummonBasic(slot_index)
  if self.inst.components.ling_summon_manager then
    self.inst.components.ling_summon_manager:SummonBasic(slot_index)
  else
    SendModRPCToServer(GetModRPC("ling_summon", "summon_basic"), slot_index)
  end
end

return LingSummonManagerReplica