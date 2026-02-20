local Widget = require "widgets/widget"
local UIImageAnim = require "widgets/uiimageanim"

local LingCloudPavilionMist = Class(Widget, function(self)
  Widget._ctor(self, "LingCloudPavilionMist")

  self:SetScaleMode(SCALEMODE_PROPORTIONAL)
  self:SetHAnchor(ANCHOR_MIDDLE)
  self:SetVAnchor(ANCHOR_MIDDLE)

  self.anim = self:AddChild(UIImageAnim("imageanim/ling_cloud_pavilion_mist"))
  self.anim:SetScale(0.9)
  self._task = nil
  self._playing_forward = nil -- nil=stopped, true=forward(in), false=reverse(out)

  self:Hide()
end)

function LingCloudPavilionMist:_CancelTask()
  if self._task then
    self._task:Cancel()
    self._task = nil
  end
end

function LingCloudPavilionMist:CloudIn()
  local current_anim = self.anim:GetCurrentAnimationName()
  if current_anim == "idle" or self._playing_forward == true then
    return
  end

  self:_CancelTask()
  self:Show()

  local duration = self.anim:GetAnimationDuration("in")
  local remaining

  if self._playing_forward == false then
    -- Currently reversing (going out), just flip multiplier
    remaining = duration - self.anim:GetCurrentAnimationTime()
  else
    -- Start fresh
    self.anim:PlayAnimation("in", false)
    remaining = duration
  end

  self.anim:SetDeltaTimeMultiplier(1)
  self._playing_forward = true
  self._task = self.inst:DoTaskInTime(remaining, function()
    self._task = nil
    self._playing_forward = nil
    self.anim:SetDeltaTimeMultiplier(1)
    self.anim:PlayAnimation("idle", true)
  end)
end

function LingCloudPavilionMist:CloudIdle()
  local current_anim = self.anim:GetCurrentAnimationName()
  if current_anim == "idle" or self._playing_forward == true then
    return
  end

  self:_CancelTask()
  self._playing_forward = nil
  self:Show()
  self.anim:SetDeltaTimeMultiplier(1)
  self.anim:PlayAnimation("idle", true)
end

function LingCloudPavilionMist:CloudOut()
  if self._playing_forward == false then
    return
  end

  self:_CancelTask()

  local duration = self.anim:GetAnimationDuration("in")
  local remaining

  if self._playing_forward == true then
    -- Currently playing forward (going in), just flip multiplier
    remaining = self.anim:GetCurrentAnimationTime()
  else
    -- From idle or hidden, start reversed from end
    self:Show()
    self.anim:PlayAnimation("in", false)
    self.anim:SetCurrentAnimationTime(duration)
    remaining = duration
  end

  self.anim:SetDeltaTimeMultiplier(-1)
  self._playing_forward = false
  self._task = self.inst:DoTaskInTime(remaining, function()
    self._task = nil
    self._playing_forward = nil
    self.anim:SetDeltaTimeMultiplier(1)
    self:Hide()
  end)
end

function LingCloudPavilionMist:Pause()
  self.anim:Pause()
end

function LingCloudPavilionMist:Resume()
  self.anim:Resume()
end

return LingCloudPavilionMist
