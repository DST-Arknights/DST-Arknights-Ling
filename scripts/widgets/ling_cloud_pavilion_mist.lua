local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local LingCloudPavilionMist = Class(Widget, function(self)
  Widget._ctor(self, "LingCloudPavilionMist")
  self:SetScaleMode(SCALEMODE_PROPORTIONAL)
  self:SetHAnchor(ANCHOR_MIDDLE)
  self:SetVAnchor(ANCHOR_MIDDLE)
  self.anim = self:AddChild(UIAnim())
  self.anim:GetAnimState():SetBank("ling_cloud_pavilion_mist")
  self.anim:GetAnimState():SetBuild("ling_cloud_pavilion_mist")
  self.anim:GetAnimState():PlayAnimation("cloud_idle", true)
  self.anim:SetScale(0.9)
  self.inAnimLength = 1.2
  self.outAnimLength = 1.2
  self:Hide()
  self._hide_task = nil
end)

function LingCloudPavilionMist:CloudIn()
  if self._hide_task then
    self._hide_task:Cancel()
    self._hide_task = nil
  end
  self:Show()
  self.anim:GetAnimState():PlayAnimation("cloud_in", false)
  -- 动画内tint渐变
  self:TintTo({r = 1, g = 1, b = 1, a = 0 }, {r = 1, g = 1, b = 1, a = 1}, self.inAnimLength)
  self.anim:GetAnimState():PushAnimation("cloud_idle", true)
end

function LingCloudPavilionMist:CloudOut()
  if self._hide_task then
    self._hide_task:Cancel()
    self._hide_task = nil
  end
  self.anim:GetAnimState():PlayAnimation("cloud_out", false)
  -- 动画内tint渐变
  self:TintTo({r = 1, g = 1, b = 1, a = 1 }, {r = 1, g = 1, b = 1, a = 0}, self.outAnimLength)
  self._hide_task = self.inst:DoTaskInTime(self.outAnimLength, function()
    self._hide_task = nil
    self:Hide()
  end)
end

return LingCloudPavilionMist
