local CONSTANTS = require("ark_constants_ling")
local LING_GUARD_CONFIG = require("ling_guard_config")

local SafeCallHUD = GenSafeCall(function(player)
  return player and player.HUD
end)
local SafeCallLingGuardPanel = GenSafeCall(function(player, inst)
  return SafeCallHUD(player):GetGuardPanel(inst)
end)

local function OnNameDirty(inst)
  local leader = inst.replica.follower and inst.replica.follower:GetLeader()
  if not TheNet:IsDedicated() and ThePlayer == leader then
    SafeCallLingGuardPanel(ThePlayer, inst):SetGuardName(inst.replica.named._name:value())
  end
end

local LingGuardReplica = Class(function(self, inst)
  self.inst = inst
  self.state = NetState(self.inst, "ling_guard")
  self.state:OnAttached(function()
    SafeCallHUD(ThePlayer):OpenGuardPanel(self.inst)
    local leader = self.inst.replica.follower and self.inst.replica.follower:GetLeader()
    if not TheNet:IsDedicated() and ThePlayer == leader then
      self:SetGuardPositionColor(true)
    end
    OnNameDirty(inst)
  end)
  self.state:OnDetached(function()
    SafeCallHUD(ThePlayer):CloseGuardPanel(self.isnt)
    local leader = self.inst.replica.follower and self.inst.replica.follower:GetLeader()
    if not TheNet:IsDedicated() and ThePlayer == leader then
      self:SetGuardPositionColor(false)
    end
  end)
  self.state:Watch({"behavior_mode", "guard_pos_x", "guard_pos_y", "guard_pos_z"}, function()
    SafeCallLingGuardPanel(ThePlayer, self.inst):SetBehaviorMode(self.state.behavior_mode, true)
    local leader = self.inst.replica.follower and self.inst.replica.follower:GetLeader()
    if not TheNet:IsDedicated() and ThePlayer == leader then
      if self.state.behavior_mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        self:UpdateGuardPositionVisual()
        -- 如果面板打开了, 设置为绿色
        if SafeCallHUD(ThePlayer):GetGuardPanel(inst) then
          self:SetGuardPositionColor(true)
        end
      else
        self:RemoveGuardPositionVisual()
      end
    end
  end)
  self.state:Watch("work_mode", function()
    local panel = SafeCallLingGuardPanel(ThePlayer, self.inst):SyncWorkMode(self.state.work_mode)
  end)
  self.state:Watch({"current_health"}, function()
    local panel = SafeCallLingGuardPanel(ThePlayer, self.inst)
    if panel then
      panel.health:SetCurrent(self.state.current_health, true)
    end
  end)
  self.state:Watch({"max_health"}, function()
    local panel = SafeCallLingGuardPanel(ThePlayer, self.inst)
    if panel then
      panel.health:SetMax(self.state.max_health, true)
    end
  end)
  self.state:Watch("level", function()
    SafeCallLingGuardPanel(ThePlayer, self.inst):SetLevel(self.state.level)
  end)
  self.state:Watch("form", function()
    SafeCallLingGuardPanel(ThePlayer, self.inst):SetForm(self.state.form)
  end)

  self.inst:ListenForEvent("onremove", function()
    if self._guard_pos_inst and self._guard_pos_inst:IsValid() then
      self._guard_pos_inst:Remove()
    end
  end)

  self.inst:ListenForEvent("namedirty", OnNameDirty)
  self._guard_pos_inst = nil
end)

function LingGuardReplica:OpenPanel(doer)
  ArkLogger:Debug("LingGuardReplica:OpenPanel", doer, self.inst)
  if self.inst.components.ling_guard then
    self.inst.components.ling_guard:OpenPanel(doer)
  else
    SendModRPCToServer(GetModRPC("ling_summon", "guard_open_panel"), self.inst)
  end
end

function LingGuardReplica:ClosePanel(doer)
  ArkLogger:Debug("LingGuardReplica:ClosePanel", doer, self.inst)
  if self.inst.components.ling_guard then
    self.inst.components.ling_guard:ClosePanel(doer)
  else
    SendModRPCToServer(GetModRPC("ling_summon", "guard_close_panel"), self.inst)
  end
end

-- 获取守卫位置
function LingGuardReplica:GetGuardPosition()
  return Vector3(self.state.guard_pos_x, self.state.guard_pos_y, self.state.guard_pos_z)
end

-- 更新守卫位置视觉效果
function LingGuardReplica:UpdateGuardPositionVisual()
  if not self._guard_pos_inst then
    self._guard_pos_inst = SpawnPrefab("reticuleaoecatapultwakeup")
    self._guard_pos_inst:AddTag("CLASSIFIED")
    local cfg = LING_GUARD_CONFIG
    local guardcfg = (cfg.MODE and cfg.MODE.GUARD) or (cfg.GUARD) or {}
    local range = guardcfg.GUARD_RANGE or 16
    local scale = range / 16 -- 缩放比例，使范围大小与守卫范围一致（16为动画对应范围）
    self._guard_pos_inst.Transform:SetScale(scale, scale, scale) -- 设置缩放比例
  end
  self._guard_pos_inst.Transform:SetPosition(self:GetGuardPosition():Get())
end

-- 移除守卫位置视觉效果
function LingGuardReplica:RemoveGuardPositionVisual()
  if self._guard_pos_inst and self._guard_pos_inst:IsValid() then
    self._guard_pos_inst:Remove()
    self._guard_pos_inst = nil
  end
end

-- 设置守卫位置标记颜色（绿色用于面板打开时）
function LingGuardReplica:SetGuardPositionColor(is_green)
  if self._guard_pos_inst and self._guard_pos_inst:IsValid() then
    if is_green then
      -- 设置为绿色（面板打开时）
      self._guard_pos_inst.AnimState:SetMultColour(0, 1, 0, 1)
    else
      -- 恢复原色（白色）
      self._guard_pos_inst.AnimState:SetMultColour(1, 1, 1, 1)
    end
  end
end

function LingGuardReplica:SetBehaviorMode(mode)
  if self.inst.components.ling_guard then
    self.inst.components.ling_guard:SetBehaviorMode(mode)
  else
    SendModRPCToServer(GetModRPC("ling_summon", "guard_set_behavior_mode"), self.inst, mode)
  end
end

function LingGuardReplica:SetWorkMode(mode)
  if self.inst.components.ling_guard then
    self.inst.components.ling_guard:SetWorkMode(mode)
  else
    SendModRPCToServer(GetModRPC("ling_summon", "guard_set_work_mode"), self.inst, mode)
  end
end

function LingGuardReplica:Fusion()
  if self.inst.components.follower and self.inst.components.follower.leader then
    if self.inst.components.follower.leader.components.ling_summon_manager then
      self.inst.components.follower.leader.components.ling_summon_manager:Fusion(self.inst)
    end
  else
    SendModRPCToServer(GetModRPC("ling_summon", "guard_fusion"), self.inst)
  end
end

function LingGuardReplica:OpenContainer(doer)
  if self.inst.components.ling_guard then
    self.inst.components.ling_guard:OpenContainer(doer)
  else
    SendModRPCToServer(GetModRPC("ling_summon", "guard_open_container"), self.inst)
  end
end

function LingGuardReplica:CloseContainer(doer)
  if self.inst.components.ling_guard then
    self.inst.components.ling_guard:CloseContainer(doer)
  else
    SendModRPCToServer(GetModRPC("ling_summon", "guard_close_container"), self.inst)
  end
end

function LingGuardReplica:SetForm(form)
    if self.inst.components.ling_guard then
        self.inst.components.ling_guard:SetForm(form)
    else
        SendModRPCToServer(GetModRPC("ling_summon", "guard_set_form"), self.inst, form)
    end
end

function LingGuardReplica:Recall()
  if self.inst.components.ling_guard then
    self.inst.components.ling_guard:Recall()
  else
    SendModRPCToServer(GetModRPC("ling_summon", "guard_recall"), self.inst)
  end
end

function LingGuardReplica:OnRemoveFromEntity()
  self.inst:RemoveEventCallback("namedirty", OnNameDirty)
end

return LingGuardReplica
