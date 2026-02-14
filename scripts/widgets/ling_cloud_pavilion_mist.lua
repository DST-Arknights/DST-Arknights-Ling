local Widget = require "widgets/widget"
local UIImageAnim = require "widgets/uiimageanim"

local LingCloudPavilionMist = Class(Widget, function(self)
  Widget._ctor(self, "LingCloudPavilionMist")

  self:SetScaleMode(SCALEMODE_PROPORTIONAL)
  self:SetHAnchor(ANCHOR_MIDDLE)
  self:SetVAnchor(ANCHOR_MIDDLE)

  self.anim = self:AddChild(UIImageAnim("imageanim/ling_cloud_pavilion_mist"))
  self.anim:SetScale(0.9)
  self._hide_task = nil
  self._transition_task = nil
  self._pending_out_after_in = false

  self:Hide()
end)

function LingCloudPavilionMist:_CancelTransitionTask()
  if self._transition_task then
    self._transition_task:Cancel()
    self._transition_task = nil
  end
end

function LingCloudPavilionMist:_PlayOutNow()
  self:Show()
  self.anim:PlayAnimation("out", false)

  local duration = self.anim:GetAnimationDuration("out")
  self._hide_task = self.inst:DoTaskInTime(duration, function()
    self._hide_task = nil
    self:Hide()
  end)
end

function LingCloudPavilionMist:CloudIn()
  local current_anim = self.anim:GetCurrentAnimationName()
  if current_anim == "in" then
    self._pending_out_after_in = false
    return
  end

  if current_anim == "idle" then
    return
  end

  self._pending_out_after_in = false

  if self._hide_task then
    self._hide_task:Cancel()
    self._hide_task = nil
  end
  self:_CancelTransitionTask()

  self:Show()
  self.anim:PlayAnimation("in", false)

  local in_duration = self.anim:GetAnimationDuration("in")
  self._transition_task = self.inst:DoTaskInTime(in_duration, function()
    self._transition_task = nil

    if self._pending_out_after_in then
      self._pending_out_after_in = false
      self:_PlayOutNow()
      return
    end

    self.anim:PlayAnimation("idle", true)
  end)
end

function LingCloudPavilionMist:CloudIdle()
  local current_anim = self.anim:GetCurrentAnimationName()
  if current_anim == "idle" or current_anim == "in" then
    return
  end

  if self._hide_task then
    self._hide_task:Cancel()
    self._hide_task = nil
  end
  self:_CancelTransitionTask()
  self._pending_out_after_in = false

  self:Show()
  self.anim:PlayAnimation("idle", true)
end

function LingCloudPavilionMist:CloudOut()
  local current_anim = self.anim:GetCurrentAnimationName()
  if current_anim == "out" then
    return
  end

  if current_anim == "in" then
    self._pending_out_after_in = true
    return
  end

  self._pending_out_after_in = false

  if self._hide_task then
    self._hide_task:Cancel()
    self._hide_task = nil
  end
  self:_CancelTransitionTask()
  self:_PlayOutNow()
end

function LingCloudPavilionMist:Pause()
  self.anim:Pause()
end

function LingCloudPavilionMist:Resume()
  self.anim:Resume()
end

return LingCloudPavilionMist
