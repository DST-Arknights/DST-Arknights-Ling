local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local LingPoetryBadge = Class(Badge, function(self, owner)
  Badge._ctor(self, "ling_poetry", owner)
  self.max_poetry = 0
  self.current_poetry = 0
end)

function LingPoetryBadge:SetMax(max)
  self.max_poetry = max
  self:SetPercent(self.current_poetry / self.max_poetry, self.max_poetry)
end

function LingPoetryBadge:SetCurrent(current)
  self.current_poetry = current
  self:SetPercent(self.current_poetry / self.max_poetry, self.max_poetry)
end

return LingPoetryBadge
