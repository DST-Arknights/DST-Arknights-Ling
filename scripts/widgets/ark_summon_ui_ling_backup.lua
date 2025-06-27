local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

local BUTTON_SIZE = 96  -- 主按钮大小
local PANEL_BUTTON_SIZE = 80  -- 面板按钮大小 (放大)
local IMAGE_SIZE = 128  -- 原始图片尺寸
local PANEL_Y_OFFSET = 140  -- 面板Y偏移 (往上调整)
local HOVER_SCALE = 1.1  -- 鼠标悬停缩放比例

local ArkSummonUi = Class(Widget, function(self, owner)
  Widget._ctor(self, "ArkSummonUi")
  self.owner = owner
  self.commandUi = nil  -- 引用命令UI组件，用于互相隐藏面板

  -- 创建召唤按钮和面板
  self:CreateSummonButton()
  self:CreateSummonPanel()

  -- 初始状态隐藏面板
  self.summonPanel:Hide()

  -- 绑定点击事件
  self.summonButton:SetOnClick(function() self:ToggleSummonPanel() end)

  -- 将按钮移动到UI最后面
  self:MoveSummonButtonsToBack()
end)

-- 创建召唤主按钮
function ArkSummonUi:CreateSummonButton()
  -- 创建可点击按钮 (先创建，确保点击区域正确)
  self.summonButton = self:AddChild(ImageButton("images/ui.xml", "white.tex", "white.tex", "white.tex", "white.tex"))
  self.summonButton:SetPosition(0, 0, 0)
  self.summonButton:ForceImageSize(BUTTON_SIZE, BUTTON_SIZE)
  self.summonButton:SetImageNormalColour(1, 1, 1, 0)  -- 完全透明
  self.summonButton:SetImageFocusColour(1, 1, 1, 0)   -- 完全透明

  -- 灰白色背景
  local background = self.summonButton:AddChild(Image("images/ui.xml", "white.tex"))
  background:SetSize(BUTTON_SIZE, BUTTON_SIZE)
  background:SetTint(0.23, 0.23, 0.23, 0.7)  -- 指定的背景色
  background:MoveToBack()

  -- 使用新的召唤者图标 (缩放到合适尺寸)
  local icon = self.summonButton:AddChild(Image("images/ling_guard_ui.xml", "ling_summoner.tex"))
  icon:SetSize(BUTTON_SIZE * 0.8, BUTTON_SIZE * 0.8)  -- 缩放图片

  -- 边框
  local frame = self.summonButton:AddChild(Image("images/ark_skill.xml", "frame.tex"))
  frame:SetSize(BUTTON_SIZE, BUTTON_SIZE)

  -- 存储组件引用用于缩放
  self.summonButton.background = background
  self.summonButton.icon = icon
  self.summonButton.frame = frame

  -- 鼠标悬停效果 - 缩放整个按钮
  self.summonButton:SetOnGainFocus(function()
    self.summonButton:SetScale(HOVER_SCALE)
  end)
  self.summonButton:SetOnLoseFocus(function()
    self.summonButton:SetScale(1.0)
  end)

  -- 下方文字标签 (使用国际化)
  self.summonLabel = self:AddChild(Text(FALLBACK_FONT_FULL, 32))  -- 放大字体
  self.summonLabel:SetString(STRINGS.UI.LING_SUMMON.SUMMON)
  self.summonLabel:SetColour(1, 1, 1, 1)
  self.summonLabel:SetPosition(0, -BUTTON_SIZE/2 - 25, 0)  -- 调整间距
end

-- 创建召唤面板
function ArkSummonUi:CreateSummonPanel()
  self.summonPanel = self:AddChild(Widget("SummonPanel"))
  self.summonPanel:SetPosition(0, PANEL_Y_OFFSET, 0)  -- 在主按钮上方，使用调整后的偏移

  -- 计算按钮间距和对齐
  local spacing = PANEL_BUTTON_SIZE + 25  -- 按钮间距
  local totalWidth = spacing * 2  -- 三个按钮的总宽度 (两个间距)
  local startX = -totalWidth / 2  -- 居中后，最左侧按钮的X位置

  -- 调整使最左侧与主按钮的左边缘对齐
  local mainButtonLeftEdge = -BUTTON_SIZE / 2  -- 主按钮左边缘
  local panelButtonLeftEdge = startX - PANEL_BUTTON_SIZE / 2  -- 面板按钮左边缘
  local alignmentOffset = mainButtonLeftEdge - panelButtonLeftEdge  -- 对齐偏移
  startX = startX + alignmentOffset

  -- 创建清平按钮
  self.qingpingButton = self:CreateSummonPanelButton(startX, 0, "ling_guard_qingping.tex", STRINGS.UI.LING_SUMMON.QINGPING, "qingping")
  self.summonPanel:AddChild(self.qingpingButton.container)
  self.summonPanel:AddChild(self.qingpingButton.label)

  -- 创建逍遥按钮
  self.xiaoyaoButton = self:CreateSummonPanelButton(startX + spacing, 0, "ling_guard_xiaoyao.tex", STRINGS.UI.LING_SUMMON.XIAOYAO, "xiaoyao")
  self.summonPanel:AddChild(self.xiaoyaoButton.container)
  self.summonPanel:AddChild(self.xiaoyaoButton.label)

  -- 创建弦惊按钮
  self.xianjingButton = self:CreateSummonPanelButton(startX + spacing * 2, 0, "ling_guard_xianjing.tex", STRINGS.UI.LING_SUMMON.XIANJING, "xianjing")
  self.summonPanel:AddChild(self.xianjingButton.container)
  self.summonPanel:AddChild(self.xianjingButton.label)
end

-- 创建面板按钮
function ArkSummonUi:CreateSummonPanelButton(x, y, icon, text, summon_type)
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

  -- 图标 (缩放到合适尺寸)
  local iconImage = button:AddChild(Image("images/ling_guard_ui.xml", icon))
  iconImage:SetSize(PANEL_BUTTON_SIZE * 0.8, PANEL_BUTTON_SIZE * 0.8)  -- 缩放图片

  -- 边框
  local frame = button:AddChild(Image("images/ark_skill.xml", "frame.tex"))
  frame:SetSize(PANEL_BUTTON_SIZE, PANEL_BUTTON_SIZE)

  -- 存储组件引用用于缩放
  button.background = background
  button.icon = iconImage
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
    SendModRPCToServer(GetModRPC("ling_summon", "summon_guard"), summon_type)
  end)

  return {container = button, label = label, button = button}
end

-- 切换召唤面板
function ArkSummonUi:ToggleSummonPanel()
  if self.summonPanel:IsVisible() then
    self.summonPanel:Hide()
  else
    -- 隐藏命令面板
    if self.commandUi then
      self.commandUi:HidePanel()
    end
    self.summonPanel:Show()
    -- 确保面板保持在最后面
    self:MoveSummonButtonsToBack()
  end
end

-- 将召唤按钮区域移动到UI最后面
function ArkSummonUi:MoveSummonButtonsToBack()
  -- 移动主要召唤按钮到最后面
  self.summonButton:MoveToBack()
  self.summonLabel:MoveToBack()

  -- 移动面板到最后面
  self.summonPanel:MoveToBack()

  -- 移动面板内的按钮到最后面
  if self.qingpingButton then
    self.qingpingButton.container:MoveToBack()
    self.qingpingButton.label:MoveToBack()
  end
  if self.xiaoyaoButton then
    self.xiaoyaoButton.container:MoveToBack()
    self.xiaoyaoButton.label:MoveToBack()
  end
  if self.xianjingButton then
    self.xianjingButton.container:MoveToBack()
    self.xianjingButton.label:MoveToBack()
  end
end

-- 设置位置
function ArkSummonUi:SetPosition(x, y, z)
  Widget.SetPosition(self, x, y, z)
end

-- 隐藏面板
function ArkSummonUi:HidePanel()
  if self.summonPanel then
    self.summonPanel:Hide()
  end
end

-- 设置命令UI引用
function ArkSummonUi:SetCommandUi(commandUi)
  self.commandUi = commandUi
end

return ArkSummonUi
