local CONSTANTS = require "ark_constants_ling"

local function GetEnterKnownLocationKey()
  return "cloudpavilion_enter_" .. tostring(TheShard:GetShardId())
end

local function GetEnterEntityKey()
  return "cloudpavilion_enter_" .. tostring(TheShard:GetShardId())
end

local LingCloudPavilionTransfer = Class(function(self, inst)
    self.inst = inst
end)

function LingCloudPavilionTransfer:CanEnterCloudPavilion(enterInst)
  -- 只有主世界才能进入云山亭
  return TheWorld.ismastershard
end

local function Teleport(inst, targetPos)
  if not targetPos then
    return
  end
  inst:SnapCamera()
  inst:ScreenFade(false, CONSTANTS.LING_TRANSFER_FADE_TIME)
  if inst.components.fader then
    inst.components.fader:Fade(1, 0, CONSTANTS.LING_TRANSFER_FADE_TIME, function(val)
      inst.AnimState:SetMultColour(1, 1, 1, val)
    end)
  end
  inst:DoTaskInTime(CONSTANTS.LING_TRANSFER_FADE_TIME, function()
    inst.Transform:SetPosition(targetPos[1], targetPos[2], targetPos[3])
    inst:SnapCamera()
    inst:ScreenFade(true, CONSTANTS.LING_TRANSFER_FADE_TIME)
    if inst.components.fader then
      inst.components.fader:Fade(0, 1, CONSTANTS.LING_TRANSFER_FADE_TIME, function(val)
        inst.AnimState:SetMultColour(1, 1, 1, val)
      end)
    end
  end)
end

function LingCloudPavilionTransfer:EnterCloudPavilion(enterInst)
  if not self:CanEnterCloudPavilion(enterInst) then
    return
  end
  local target = TheWorld.components.ling_interiorspawner:GetGlobalInstance()
  if not target or not target:IsValid() then
    return
  end

  if not self.inst.components.knownlocations then
    self.inst:AddComponent("knownlocations")
  end
  if not self.inst.components.entitytracker then
    self.inst:AddComponent("entitytracker")
  end
  local enterPos
  if enterInst then
    self.inst.components.entitytracker:TrackEntity(GetEnterEntityKey(), enterInst)
    enterPos = enterInst:GetPosition()
  else
    self.inst.components.entitytracker:ForgetEntity(GetEnterEntityKey())
    enterPos = self.inst:GetPosition()
  end
  self.inst.components.knownlocations:RememberLocation(GetEnterKnownLocationKey(), enterPos)
  Teleport(self.inst, target:GetPosition())
end

function LingCloudPavilionTransfer:ExitCloudPavilion()
  local enterPos = self.inst.components.knownlocations:GetLocation(GetEnterKnownLocationKey())
  if not enterPos then
    return
  end
  Teleport(self.inst, enterPos)
  self.inst.components.knownlocations:ForgetLocation(GetEnterKnownLocationKey())
  self.inst.components.entitytracker:ForgetEntity(GetEnterEntityKey())
end

return LingCloudPavilionTransfer