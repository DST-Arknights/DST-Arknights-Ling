local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

local BUTTON_SIZE = 96  -- 主按钮大小
local PANEL_BUTTON_SIZE = 80  -- 面板按钮大小 (放大)
local PANEL_Y_OFFSET = 140  -- 面板Y偏移 (往上调整)
local HOVER_SCALE = 1.1  -- 鼠标悬停缩放比例

local ArkCommandUi = Class(Widget, function(self, owner)
  Widget._ctor(self, "ArkCommandUi")
  self.owner = owner
  self.summonUi = nil  -- 引用召唤UI组件，用于互相隐藏面板

  -- 创建命令按钮和面板
  self:CreateCommandButton()
  self:CreateCommandPanel()

  -- 初始状态隐藏面板
  self.commandPanel:Hide()

  -- 绑定点击事件
  self.commandButton:SetOnClick(function() self:ToggleCommandPanel() end)

  -- 将按钮移动到UI最后面
  self:MoveCommandButtonsToBack()
end)

-- 创建命令主按钮
function ArkCommandUi:CreateCommandButton()
  -- 创建可点击按钮 (先创建，确保点击区域正确)
  self.commandButton = self:AddChild(ImageButton("images/ui.xml", "white.tex", "white.tex", "white.tex", "white.tex"))
  self.commandButton:SetPosition(0, 0, 0)
  self.commandButton:ForceImageSize(BUTTON_SIZE, BUTTON_SIZE)
  self.commandButton:SetImageNormalColour(1, 1, 1, 0)  -- 完全透明
  self.commandButton:SetImageFocusColour(1, 1, 1, 0)   -- 完全透明

  -- 灰白色背景
  local background = self.commandButton:AddChild(Image("images/ui.xml", "white.tex"))
  background:SetSize(BUTTON_SIZE, BUTTON_SIZE)
  background:SetTint(0.23, 0.23, 0.23, 0.7)  -- 指定的背景色
  background:MoveToBack()

  -- 临时使用蓝色图标 (TODO: 后续替换为实际图标)
  local icon = self.commandButton:AddChild(Image("images/ui.xml", "white.tex"))
  icon:SetSize(BUTTON_SIZE * 0.6, BUTTON_SIZE * 0.6)
  icon:SetTint(0, 0.5, 1, 1.0)  -- 蓝色

  -- 边框
  local frame = self.commandButton:AddChild(Image("images/ark_skill.xml", "frame.tex"))
  frame:SetSize(BUTTON_SIZE, BUTTON_SIZE)

  -- 存储组件引用用于缩放
  self.commandButton.background = background
  self.commandButton.icon = icon
  self.commandButton.frame = frame

  -- 鼠标悬停效果 - 缩放整个按钮
  self.commandButton:SetOnGainFocus(function()
    self.commandButton:SetScale(HOVER_SCALE)
  end)
  self.commandButton:SetOnLoseFocus(function()
    self.commandButton:SetScale(1.0)
  end)

  -- 下方文字标签 (使用国际化)
  self.commandLabel = self:AddChild(Text(FALLBACK_FONT_FULL, 32))  -- 放大字体
  self.commandLabel:SetString(STRINGS.UI.LING_SUMMON.COMMAND)
  self.commandLabel:SetColour(1, 1, 1, 1)
  self.commandLabel:SetPosition(0, -BUTTON_SIZE/2 - 25, 0)  -- 调整间距
end

-- 创建命令面板
function ArkCommandUi:CreateCommandPanel()
  self.commandPanel = self:AddChild(Widget("CommandPanel"))
  self.commandPanel:SetPosition(0, PANEL_Y_OFFSET, 0)  -- 在主按钮上方，使用调整后的偏移

  -- 计算按钮间距和对齐
  local spacing = PANEL_BUTTON_SIZE + 25  -- 按钮间距
  local totalWidth = spacing * 2  -- 三个按钮的总宽度 (两个间距)
  local startX = -totalWidth / 2  -- 居中后，最左侧按钮的X位置

  -- 调整使最左侧与主按钮的左边缘对齐
  local mainButtonLeftEdge = -BUTTON_SIZE / 2  -- 主按钮左边缘
  local panelButtonLeftEdge = startX - PANEL_BUTTON_SIZE / 2  -- 面板按钮左边缘
  local alignmentOffset = mainButtonLeftEdge - panelButtonLeftEdge  -- 对齐偏移
  startX = startX + alignmentOffset

  -- 创建守按钮
  self.guardButton = self:CreateCommandPanelButton(startX, 0, STRINGS.UI.LING_COMMAND.GUARD, {0, 0, 1}, "guard")
  self.commandPanel:AddChild(self.guardButton.container)
  self.commandPanel:AddChild(self.guardButton.label)

  -- 创建攻按钮
  self.attackButton = self:CreateCommandPanelButton(startX + spacing, 0, STRINGS.UI.LING_COMMAND.ATTACK, {1, 0, 0}, "attack")
  self.commandPanel:AddChild(self.attackButton.container)
  self.commandPanel:AddChild(self.attackButton.label)

  -- 创建慎按钮
  self.cautiousButton = self:CreateCommandPanelButton(startX + spacing * 2, 0, STRINGS.UI.LING_COMMAND.CAUTIOUS, {0.5, 0, 0.5}, "cautious")
  self.commandPanel:AddChild(self.cautiousButton.container)
  self.commandPanel:AddChild(self.cautiousButton.label)
end

-- 创建面板按钮
function ArkCommandUi:CreateCommandPanelButton(x, y, text, color, command_type)
  -- 创建可点击按钮 (先创建，确保点击区域正确)
  local button = ImageButton("images/ui.xml", "white.tex", "white.tex", "white.tex", "white.tex")
  button:SetPosition(x, y, 0)
  button:ForceImageSize(PANEL_BUTTON_SIZE, PANEL_BUTTON_SIZE)
  button:SetImageNormalColour(1, 1, 1, 0)  -- 完全透明
  button:SetImageFocusColour(1, 1, 1, 0)   -- 完全透明

  -- 灰白色背景
  local background = button:AddChild(Image("images/ui.xml", "white.tex"))
  background:SetSize(PANEL_BUTTON_SIZE, PANEL_BUTTON_SIZE)
  background:SetTint(0.23, 0.23, 0.23, 0.7)  -- 指定的背景色
  background:MoveToBack()

  -- 临时使用纯色图标 (TODO: 后续替换为实际图标)
  local icon = button:AddChild(Image("images/ui.xml", "white.tex"))
  icon:SetSize(PANEL_BUTTON_SIZE * 0.6, PANEL_BUTTON_SIZE * 0.6)
  icon:SetTint(color[1], color[2], color[3], 1.0)

  -- 边框
  local frame = button:AddChild(Image("images/ark_skill.xml", "frame.tex"))
  frame:SetSize(PANEL_BUTTON_SIZE, PANEL_BUTTON_SIZE)

  -- 存储组件引用用于缩放
  button.background = background
  button.icon = icon
  button.frame = frame

  -- 鼠标悬停效果 - 缩放整个按钮
  button:SetOnGainFocus(function()
    button:SetScale(HOVER_SCALE)
  end)
  button:SetOnLoseFocus(function()
    button:SetScale(1.0)
  end)

  -- 下方文字标签 (放大字体)
  local label = Text(FALLBACK_FONT_FULL, 28)  -- 放大字体
  label:SetString(text)
  label:SetColour(1, 1, 1, 1)
  label:SetPosition(x, y - PANEL_BUTTON_SIZE/2 - 20, 0)  -- 调整间距

  -- 绑定点击事件
  button:SetOnClick(function()
    SendModRPCToServer(GetModRPC("ling_summon", "command_guards"), command_type)
  end)

  return {container = button, label = label, button = button}
end

-- 切换命令面板
function ArkCommandUi:ToggleCommandPanel()
  if self.commandPanel:IsVisible() then
    self.commandPanel:Hide()
  else
    -- 隐藏召唤面板
    if self.summonUi then
      self.summonUi:HidePanel()
    end
    self.commandPanel:Show()
    -- 确保面板保持在最后面
    self:MoveCommandButtonsToBack()
  end
end

-- 将命令按钮区域移动到UI最后面
function ArkCommandUi:MoveCommandButtonsToBack()
  -- 移动主要命令按钮到最后面
  self.commandButton:MoveToBack()
  self.commandLabel:MoveToBack()

  -- 移动面板到最后面
  self.commandPanel:MoveToBack()

  -- 移动面板内的按钮到最后面
  if self.guardButton then
    self.guardButton.container:MoveToBack()
    self.guardButton.label:MoveToBack()
  end
  if self.attackButton then
    self.attackButton.container:MoveToBack()
    self.attackButton.label:MoveToBack()
  end
  if self.cautiousButton then
    self.cautiousButton.container:MoveToBack()
    self.cautiousButton.label:MoveToBack()
  end
end

-- 设置位置
function ArkCommandUi:SetPosition(x, y, z)
  Widget.SetPosition(self, x, y, z)
end

-- 隐藏面板
function ArkCommandUi:HidePanel()
  if self.commandPanel then
    self.commandPanel:Hide()
  end
end

-- 设置召唤UI引用
function ArkCommandUi:SetSummonUi(summonUi)
  self.summonUi = summonUi
end

return ArkCommandUi
