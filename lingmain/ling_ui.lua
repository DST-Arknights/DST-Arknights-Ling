
-- 诗意值ui
AddClassPostConstruct("widgets/statusdisplays", function(self)
  if not self.owner or self.owner.prefab ~= "ling" then
    return
  end
  local LingPoetryBadge = require "widgets/ling_poetry"
  self.ling_poetry = self:AddChild(LingPoetryBadge(self.owner))
  self.owner:DoTaskInTime(.5, function(owner)
    local heartX, heartY = self.heart:GetPosition():Get()
    local brainX, brainY = self.brain:GetPosition():Get()
    local stomachX, stomachY = self.stomach:GetPosition():Get()
    local offsetX = stomachX - heartX
    if brainY == heartY or brainY == stomachY then
      if self.heart:GetScale().x / self.ling_poetry:GetScale().x ~= 1 then
        self.ling_poetry:SetScale(self.heart:GetScale())
      end
      offsetX = stomachX - brainX
    end
    self.ling_poetry:SetPosition(stomachX + offsetX, stomachY, 0)
  end)
  local _SetGhostMode = self.SetGhostMode
  function self:SetGhostMode(ghost_mode, ...)
    _SetGhostMode(self, ghost_mode, ...)
    if ghost_mode then
      self.ling_poetry:Hide()
    else
      self.ling_poetry:Show()
    end
  end
end)
