local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

local function ScaleOnFocus(button, scaleFactor)
  button:SetOnGainFocus(function()
    button:SetScale(scaleFactor)
  end)
  button:SetOnLoseFocus(function()
    button:SetScale(1.0)
  end)
end

local function scalePosition(x, y, z, scale)
  return x * scale, y * scale, z * scale
end

local BUTTON_FOCUS_SCALE = 1.1
local BUTTON_SCALE = 1.0

local LingGuardPanel = Class(Widget, function(self, owner)
  Widget._ctor(self, "LingGuardPanel")
  self.owner = owner
  -- 融合按钮

  self.fusionButton = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "fusion_button.tex"))
  self.fusionButton:SetPosition(scalePosition(314, 59, 0, BUTTON_SCALE))
  ScaleOnFocus(self.fusionButton, BUTTON_FOCUS_SCALE)

  self.plantBg = self:AddChild(Image("images/ui_ling_guard_panel.xml", "plant_bg.tex"))
  self.plantBg:SetPosition(scalePosition(-184, -321, 0, BUTTON_SCALE))

  self.plantStart = self:AddChild(Image("images/ui_ling_guard_panel.xml", "plant_start.tex"))
  self.plantStart:SetPosition(scalePosition(-198, -408, 0, BUTTON_SCALE))

  self.commandCautious = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "command_cautious.tex"))
  self.commandCautious:SetPosition(scalePosition(186, -21, 0, BUTTON_SCALE))

  self.command_attack = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "command_attack.tex"))
  self.command_attack:SetPosition(scalePosition(112, -21, 0, BUTTON_SCALE))

  self.command_guard = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "command_guard.tex"))
  self.command_guard:SetPosition(scalePosition(36, -21, 0, BUTTON_SCALE))

  -- 创建面板背景
  self.panel = self:AddChild(Image("images/ui_ling_guard_panel.xml", "bg.tex"))

  self.close = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "close.tex"))
  self.close:SetPosition(scalePosition(-305, -16, 0, BUTTON_SCALE))
  ScaleOnFocus(self.close, BUTTON_FOCUS_SCALE)

  self.rename = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "rename.tex"))
  self.rename:SetPosition(scalePosition(154, 35, 0, BUTTON_SCALE))
  ScaleOnFocus(self.rename, BUTTON_FOCUS_SCALE)

  self.recall = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "recall.tex"))
  self.recall:SetPosition(scalePosition(178, -90, 0, BUTTON_SCALE))
  ScaleOnFocus(self.recall, BUTTON_FOCUS_SCALE)

  self.name = self:AddChild(Image("images/ui_ling_guard_panel.xml", "name_qingping.tex"))
  self.name:SetPosition(scalePosition(222, 48, 0, BUTTON_SCALE))

  self.container_open = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "container_open.tex"))
  self.container_open:SetPosition(scalePosition(-63, -11, 0, BUTTON_SCALE))
  ScaleOnFocus(self.container_open, BUTTON_FOCUS_SCALE)

  self.container_close = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "container_close.tex"))
  self.container_close:SetPosition(scalePosition(54, 111, 0, BUTTON_SCALE))
  ScaleOnFocus(self.container_close, BUTTON_FOCUS_SCALE)

  self.close:SetOnClick(function() self:RequestClose() end)

  self:Hide()
end)

function LingGuardPanel:RequestOpen(guard)
  SendModRPCToServer(GetModRPC("ling_summon", "request_open_guard_panel"), guard)
end

function LingGuardPanel:Open(guard)
  self:Show()
end

function LingGuardPanel:RequestClose()
  self:Hide()
  SendModRPCToServer(GetModRPC("ling_summon", "request_close_guard_panel"))
end

return LingGuardPanel
