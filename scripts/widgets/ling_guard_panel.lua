local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"

local function ScaleOnFocus(button, scaleFactor)
  button.focus_scale = {scaleFactor, scaleFactor, scaleFactor}
end

local BUTTON_FOCUS_SCALE = 1.1

local LingGuardPanel = Class(Widget, function(self, owner)
  Widget._ctor(self, "LingGuardPanel")
  self.owner = owner
  self.data = nil
  -- 融合按钮

  self.fusionButton = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "fusion_button.tex"))
  self.fusionButton:SetPosition(314, 59, 0)
  ScaleOnFocus(self.fusionButton, BUTTON_FOCUS_SCALE)

  self.plantBg = self:AddChild(Image("images/ui_ling_guard_panel.xml", "plant_bg.tex"))
  self.plantBg:SetPosition(-184, -321, 0)

  self.plantStart = self:AddChild(Image("images/ui_ling_guard_panel.xml", "plant_start.tex"))
  self.plantStart:SetPosition(-198, -408, 0)

  self.commandCautious = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "command_cautious.tex"))
  self.commandCautious:SetPosition(186, -21, 0)

  self.command_attack = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "command_attack.tex"))
  self.command_attack:SetPosition(112, -21, 0)

  self.command_guard = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "command_guard.tex"))
  self.command_guard:SetPosition(36, -21, 0)

  -- 创建面板背景
  self.panel = self:AddChild(Image("images/ui_ling_guard_panel.xml", "bg.tex"))

  self.close = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "close.tex"))
  self.close:SetPosition(-305, -16, 0)
  ScaleOnFocus(self.close, BUTTON_FOCUS_SCALE)

  self.rename = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "rename.tex"))
  self.rename:SetPosition(154, 35, 0)
  ScaleOnFocus(self.rename, BUTTON_FOCUS_SCALE)

  self.recall = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "recall.tex"))
  self.recall:SetPosition(178, -90, 0)
  ScaleOnFocus(self.recall, BUTTON_FOCUS_SCALE)

  self.name = self:AddChild(Image("images/ui_ling_guard_panel.xml", "name_qingping.tex"))
  self.name:SetPosition(222, 48, 0)

  self.container_open = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "container_open.tex"))
  self.container_open:SetPosition(unpack(CONSTANTS.LING_GUARD_PANEL_OPEN_CONTAINER_POSITION))
  ScaleOnFocus(self.container_open, BUTTON_FOCUS_SCALE)
  self.container_open.onclick = function() self:OpenContainer() end

  self.close:SetOnClick(function() self:RequestClose() end)

  self:Hide()
end)

function LingGuardPanel:RequestOpen(guard)
  SendModRPCToServer(GetModRPC("ling_summon", "request_open_guard_panel"), guard)
end

function LingGuardPanel:Open(data, inst)
  self.data = data
  self.bindInst = inst
  self:Show()
end

function LingGuardPanel:Close()
  self:Hide()
  self.data = nil
end

function LingGuardPanel:RequestClose()
  SendModRPCToServer(GetModRPC("ling_summon", "request_close_guard_panel"))
  local ling_close_container = ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_close_container
  if ling_close_container and ling_close_container:IsVisible() then
    ling_close_container:RequestClose()
  end
  self:Close()
end

function LingGuardPanel:OpenContainer()
  SendModRPCToServer(GetModRPC("ling_summon", "request_open_container"), self.data.slot_index)
  self.container_open:Hide()
end

return LingGuardPanel
