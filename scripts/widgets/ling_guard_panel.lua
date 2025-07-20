local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"

local GUARD_BEHAVIOR_MODE = CONSTANTS.GUARD_BEHAVIOR_MODE

local function ScaleOnFocus(button, scaleFactor)
  button.focus_scale = {scaleFactor, scaleFactor, scaleFactor}
end

local BUTTON_FOCUS_SCALE = 1.1

-- 模式按钮高度常量
local MODE_BUTTON_HEIGHT = {
  NORMAL = 0,      -- 普通状态高度
  HOVER = -33,      -- hover状态高度
  ACTIVE = -66,     -- 激活状态高度
}

-- 模式按钮动画时间
local MODE_BUTTON_ANIM_TIME = 0.15

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


  -- 创建模式按钮
  self:CreateModeButtons()

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

-- 创建模式按钮
function LingGuardPanel:CreateModeButtons()
  -- 模式按钮数据
  self.mode_buttons = {}
  self.current_active_mode = nil

  local button_data = {
    {
      mode = GUARD_BEHAVIOR_MODE.CAUTIOUS,
      texture = "command_cautious.tex",
      position = {186, -21, 0},
      name = "cautious"
    },
    {
      mode = GUARD_BEHAVIOR_MODE.ATTACK,
      texture = "command_attack.tex",
      position = {112, -21, 0},
      name = "attack"
    },
    {
      mode = GUARD_BEHAVIOR_MODE.GUARD,
      texture = "command_guard.tex",
      position = {36, -21, 0},
      name = "guard"
    }
  }

  for _, data in ipairs(button_data) do
    local button = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", data.texture))
    button:SetPosition(unpack(data.position))
    button.scale_on_focus = false -- 禁用默认的缩放效果

    -- 存储按钮信息
    button.mode = data.mode
    button.base_position = {unpack(data.position)}
    button.is_active = false
    button.is_hovering = false

    -- 设置点击事件
    button:SetOnClick(function()
      self:OnModeButtonClick(data.mode)
    end)

    -- 自定义hover事件
    local old_OnGainFocus = button.OnGainFocus
    button.OnGainFocus = function(btn)
      if not btn.is_active then
        btn.is_hovering = true
        self:AnimateModeButton(btn, MODE_BUTTON_HEIGHT.HOVER)
      end
      if old_OnGainFocus then
        old_OnGainFocus(btn)
      end
    end

    local old_OnLoseFocus = button.OnLoseFocus
    button.OnLoseFocus = function(btn)
      if not btn.is_active then
        btn.is_hovering = false
        self:AnimateModeButton(btn, MODE_BUTTON_HEIGHT.NORMAL)
      end
      if old_OnLoseFocus then
        old_OnLoseFocus(btn)
      end
    end

    self.mode_buttons[data.mode] = button
  end

  -- 守模式上追加一个工模式
  local guard_button = self.mode_buttons[GUARD_BEHAVIOR_MODE.GUARD]
  local work_button = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "work_selector.tex"))
  work_button:SetPosition(36, -238, 0)
  work_button.scale_on_focus = false -- 禁用默认的缩放效果
end

-- 模式按钮动画
function LingGuardPanel:AnimateModeButton(button, target_height)
  if not button or not button.base_position then
    return
  end

  -- 取消之前的移动动画
  button:CancelMoveTo()

  local target_y = button.base_position[2] + target_height
  local current_pos = button:GetPosition()

  -- 直接使用 MoveTo 进行动画
  button:MoveTo(Vector3(current_pos.x, current_pos.y, current_pos.z),
                Vector3(button.base_position[1], target_y, button.base_position[3]),
                MODE_BUTTON_ANIM_TIME)
end

-- 模式按钮点击事件
function LingGuardPanel:OnModeButtonClick(mode)
  if self.guard_inst and self.guard_inst:IsValid() then
    -- 发送RPC到服务端改变模式
    SendModRPCToServer(GetModRPC("ling_summon", "change_guard_behavior"), self.guard_inst, mode)
  end
end

-- 激活指定模式按钮
function LingGuardPanel:ActivateModeButton(mode)
  -- 取消之前激活的按钮
  if self.current_active_mode and self.mode_buttons[self.current_active_mode] then
    local old_button = self.mode_buttons[self.current_active_mode]
    old_button.is_active = false
    if not old_button.is_hovering then
      self:AnimateModeButton(old_button, MODE_BUTTON_HEIGHT.NORMAL)
    else
      self:AnimateModeButton(old_button, MODE_BUTTON_HEIGHT.HOVER)
    end
  end

  -- 激活新按钮
  if self.mode_buttons[mode] then
    local button = self.mode_buttons[mode]
    button.is_active = true
    button.is_hovering = false -- 激活状态不响应hover
    self:AnimateModeButton(button, MODE_BUTTON_HEIGHT.ACTIVE)
    self.current_active_mode = mode
  end
end

-- 供replica组件调用的接口，更新UI状态
function LingGuardPanel:OnBehaviorModeChanged(mode)
  self:ActivateModeButton(mode)
end

function LingGuardPanel:Open(guard_inst)
  self.guard_inst = guard_inst

  -- 从replica读取当前模式并激活对应按钮
  if guard_inst and guard_inst.replica and guard_inst.replica.ling_guard then
    local current_mode = guard_inst.replica.ling_guard:GetBehaviorMode()
    self:ActivateModeButton(current_mode)
  end

  self:Show()
end

function LingGuardPanel:Close()
  self:Hide()
  self.guard_inst = nil
end

function LingGuardPanel:RequestClose(guard_inst)
  SendModRPCToServer(GetModRPC("ling_summon", "request_close_guard_panel"), self.guard_inst)
  self:Close()
end

function LingGuardPanel:OpenContainer()
  if self.guard_inst then
    SendModRPCToServer(GetModRPC("ling_summon", "request_open_container"), self.guard_inst)
    self.container_open:Hide()
  end
end

return LingGuardPanel
