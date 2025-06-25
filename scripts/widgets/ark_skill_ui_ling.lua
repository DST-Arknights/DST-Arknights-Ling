local Widget = require "widgets/widget"
local ArkSkill = require "widgets/ark_skill_ling"
local ArkSummonUi = require "widgets/ark_summon_ui_ling"
local ArkCommandUi = require "widgets/ark_command_ui_ling"

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

  -- 添加功能按钮区域
  self:CreateFunctionButtons()
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

-- 创建功能按钮
function ArkSkillUi:CreateFunctionButtons()
  -- 计算功能按钮的起始位置（在技能按钮右边）
  local startX = SKILL_OFFSET_X * #self.skills - (SKILL_WIDTH - BUTTON_SIZE) / 2

  -- 创建召唤UI组件
  self.summonUi = self:AddChild(ArkSummonUi(self.owner))
  self.summonUi:SetPosition(startX, - (SKILL_WIDTH - BUTTON_SIZE) / 2, 0)

  -- 创建命令UI组件
  self.commandUi = self:AddChild(ArkCommandUi(self.owner))
  self.commandUi:SetPosition(startX + 120, - (SKILL_WIDTH - BUTTON_SIZE) / 2, 0)

  -- 设置相互引用，用于互相隐藏面板
  self.summonUi:SetCommandUi(self.commandUi)
  self.commandUi:SetSummonUi(self.summonUi)

  -- 将功能按钮区域移动到UI最后面
  self:MoveFunctionButtonsToBack()
end











-- 将功能按钮区域移动到UI最后面
function ArkSkillUi:MoveFunctionButtonsToBack()
  -- 移动召唤UI组件到最后面
  if self.summonUi then
    self.summonUi:MoveSummonButtonsToBack()
  end

  -- 移动命令UI组件到最后面
  if self.commandUi then
    self.commandUi:MoveCommandButtonsToBack()
  end
end

return ArkSkillUi
