local LingCloudPavilionTransfer = Class(function(self, inst)
    self.inst = inst
    self.enterPos = nil
    self.enterInst = nil
end)

function LingCloudPavilionTransfer:OnSave()
    local data = {}
    if self.enterPos then
        data.enterPos = self.enterPos
    end
    if self.enterInst then
        data.enterInst = self.enterInst.GUID
    end
    return data, data.enterInst and {data.enterInst} or nil
end

function LingCloudPavilionTransfer:OnLoad(data)
    if data.enterPos then
        self.enterPos = data.enterPos
    end
end

function LingCloudPavilionTransfer:LoadPostPass(newents, savedata)
    if savedata.enterInst then
        self.enterInst = newents[savedata.enterInst]
    end
end

function LingCloudPavilionTransfer:CanEnterCloudPavilion(enterInst)
  -- 只有主世界才能进入云山亭
  return TheWorld.ismastershard
end

local function Teleport(inst, targetPos)
  if not targetPos then
    return
  end
  inst:SnapCamera()
  inst:ScreenFade(false, 1)
  inst:DoTaskInTime(1, function()
    inst.Transform:SetPosition(targetPos[1], targetPos[2], targetPos[3])
    inst:SnapCamera()
    inst:ScreenFade(true, 1)
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
  local x, y, z = target.Transform:GetWorldPosition()
  if enterInst then
    self.enterInst = enterInst
    local enterX, enterY, enterZ = enterInst.Transform:GetWorldPosition()
    self.enterPos = { enterX, enterY, enterZ }
  else
    self.enterInst = nil
    local enterX, enterY, enterZ = self.inst.Transform:GetWorldPosition()
    self.enterPos = { enterX, enterY, enterZ }
  end
  Teleport(self.inst, {x, y, z})
end

function LingCloudPavilionTransfer:ExitCloudPavilion()
  if not self.enterPos then
    return
  end
  Teleport(self.inst, self.enterPos)
  self.enterPos = nil
  self.enterInst = nil
end

return LingCloudPavilionTransfer