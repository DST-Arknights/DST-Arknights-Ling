local Widget = require "widgets/widget"
local ArkSkill = require "widgets/ark_skill_ling"

local SKILL_OFFSET_X = 220
local BUTTON_SIZE = 96  -- 一级按钮大小 (增大)
local SKILL_WIDTH = 128   -- 特别的, SKILL_WIDTH 要与 ark_skill_ling.lua 里的 SKILL_WIDTH 保持一致

local ArkSkillUi = Class(Widget, function(self, owner, config)
  Widget._ctor(self, "ArkSkillUi")
  self.owner = owner
  self.skills = {}

  -- 添加技能按钮
  for i, config in ipairs(config.skills) do
    self:AddSkill(config, i)
  end

end)

function ArkSkillUi:AddSkill(config, idx)
  local skill = self:AddChild(ArkSkill(self.owner, config, idx))
  skill:SetPosition(SKILL_OFFSET_X * #self.skills, 0, 0)
  table.insert(self.skills, skill)
end

function ArkSkillUi:GetSkill(index)
  return self.skills[index]
end

function ArkSkillUi:GetSkillConfig(index)
  return self.skills[index].config
end

return ArkSkillUi
