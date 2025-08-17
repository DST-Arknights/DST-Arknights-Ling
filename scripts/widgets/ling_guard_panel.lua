local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"
local LingGuardWorkMode = require "widgets/ling_guard_workmode"
local LingGuardHealth = require "widgets/ling_guard_health"

local GUARD_BEHAVIOR_MODE = CONSTANTS.GUARD_BEHAVIOR_MODE
local GUARD_WORK_MODE = CONSTANTS.GUARD_WORK_MODE

local BUTTON_FOCUS_SCALE = { 1.1, 1.1, 1.1 }

-- 模式按钮动画时间
local MODE_BUTTON_ANIM_TIME = 0.15

-- 高度常量
local HEIGHT = {
  NORMAL = 0,
  HOVER = -30,
  HOVER_GUARD = -44,
  ACTIVE = -70,
  ACTIVE_GUARD = -80,
  ACTIVE_GUARD_WITH_WORK = -140  -- 守模式激活且有工模式时的额外下降
}

local LingGuardPanel = Class(Widget, function(self, owner)
  Widget._ctor(self, "LingGuardPanel")
  self.owner = owner
  -- 融合按钮

  self.fusionButton = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "fusion_button.tex"))
  self.fusionButton:SetPosition(314, 59, 0)
  self.fusionButton:SetFocusScale(BUTTON_FOCUS_SCALE)
  self.fusionButton:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.FUSION_BUTTON)

  self.plant_bg = self:AddChild(Image("images/ui_ling_guard_panel.xml", "plant_bg.tex"))
  local bg_pos = Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_PLANT_CONTAINER_CLOSED_POSITION))
  self.plant_bg:SetPosition(bg_pos)

  self.plant_club = self:AddChild(Image("images/ui_ling_guard_panel.xml", "plant_club.tex"))
  self.plant_club:SetPosition(bg_pos + Vector3(37, -78))

  -- 创建模式按钮
  self:CreateModeButtons()

  -- 创建面板背景
  self.panel = self:AddChild(Image("images/ui_ling_guard_panel.xml", "bg.tex"))

  self.health = self:AddChild(LingGuardHealth(self.owner))
  self.health:SetPosition(252, -160.75, 0)

  self.close = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "close.tex"))
  self.close:SetPosition(-305, -16, 0)
  self.close:SetFocusScale(BUTTON_FOCUS_SCALE)
  self.close:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.CLOSE_PANEL)

  self.rename = self:AddChild(Image("images/ui_ling_guard_panel.xml", "rename.tex"))
  self.rename:SetPosition(154, 35, 0)

  self.recall = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "recall.tex"))
  self.recall:SetPosition(178, -90, 0)
  self.recall:SetFocusScale(BUTTON_FOCUS_SCALE)
  self.recall:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.RECALL)

  self.name = self:AddChild(Image("images/ui_ling_guard_panel.xml", "name_qingping.tex"))
  self.name:SetPosition(222, 48, 0)

  self.container_open = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "container_open.tex"))
  self.container_open:SetPosition(unpack(CONSTANTS.LING_GUARD_PANEL_OPEN_CONTAINER_POSITION))
  self.container_open:SetFocusScale(BUTTON_FOCUS_SCALE)
  self.container_open:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.OPEN_CONTAINER)
  self.container_open.onclick = function() self:OpenContainer() end

  self.close:SetOnClick(function() self:RequestClose() end)

  self:Hide()
end)

-- 创建模式按钮
function LingGuardPanel:CreateModeButtons()
  -- 模式按钮数据
  self.mode_buttons = {}
  self.mode_containers = {}  -- 存储按钮容器
  self.current_active_mode = nil
  self.work_mode_active = false  -- 工模式是否激活

  local button_data = {
    {
      mode = GUARD_BEHAVIOR_MODE.CAUTIOUS,
      texture = "command_cautious.tex",
      position = {186, -30, 0},
      name = "cautious",
      hoverHeight = HEIGHT.HOVER,
      activeHeight = HEIGHT.ACTIVE,
    },
    {
      mode = GUARD_BEHAVIOR_MODE.ATTACK,
      texture = "command_attack.tex",
      position = {112, -30, 0},
      name = "attack",
      hoverHeight = HEIGHT.HOVER,
      activeHeight = HEIGHT.ACTIVE
    },
    {
      mode = GUARD_BEHAVIOR_MODE.GUARD,
      texture = "command_guard.tex",
      position = {36, -30, 0},
      name = "guard",
      hoverHeight = HEIGHT.HOVER_GUARD,
      activeHeight = HEIGHT.ACTIVE_GUARD,
      activeHeightWithWork = HEIGHT.ACTIVE_GUARD_WITH_WORK,  -- 有工模式时的额外下降高度
      hasWorkMode = true  -- 标记此按钮有工模式
    }
  }

  for _, data in ipairs(button_data) do
    -- 为每个按钮创建一个容器Widget
    local container = self:AddChild(Widget("mode_container_" .. data.name))
    container:SetPosition(unpack(data.position))

    -- 在容器中创建按钮
    local button = container:AddChild(ImageButton("images/ui_ling_guard_panel.xml", data.texture))
    button:SetPosition(0, 0, 0)  -- 相对于容器的位置
    button.scale_on_focus = false -- 禁用默认的缩放效果

    -- 存储按钮和容器信息
    button.mode = data.mode
    button.container = container
    button.base_position = {unpack(data.position)}
    button.is_active = false
    button.is_hovering = false
    button.data = data  -- 存储完整的数据引用

    -- 设置点击事件
    button:SetOnClick(function()
      print("[LingGuardPanel] OnModeButtonClick", data.mode)
      self:OnModeButtonClick(data.mode)
    end)

    -- 设置初始 hovertext
    self:UpdateModeButtonHoverText(button)

    -- 自定义hover事件
    button:SetOnGainFocus(function()
      if not button.is_active then
        button.is_hovering = true
        local target_height = self:GetButtonTargetHeight(button, "hover")
        self:AnimateButtonContainer(button, target_height)
      end
    end)

    button:SetOnLoseFocus(function()
      if not button.is_active then
        button.is_hovering = false
        local target_height = self:GetButtonTargetHeight(button, "normal")
        self:AnimateButtonContainer(button, target_height)
      end
    end)

    self.mode_buttons[data.mode] = button
    self.mode_containers[data.mode] = container
  end

  -- 守模式容器上追加工模式组件（同级关系）
  local guard_container = self.mode_containers[GUARD_BEHAVIOR_MODE.GUARD]
  self.work_selector = guard_container:AddChild(LingGuardWorkMode(self.owner))
  self.work_selector:SetPosition(0, -83, 0)
  -- 初始状态隐藏工作模式选择器
  self.work_selector:Hide()
  self.work_selector:SetOnWorkModeButtonClick(function(mode)
    self:OnWorkModeButtonClick(mode)
  end)

  self.work_button = guard_container:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "work_selector.tex"))
  -- worker按钮初始位置比最终位置高20像素
  self.work_button_final_y = -105  -- 最终位置
  self.work_button_initial_y = self.work_button_final_y + 20  -- 初始位置（高20像素）
  self.work_button:SetPosition(0, self.work_button_initial_y, 0)
  self.work_button.scale_on_focus = false -- 禁用默认的缩放效果
  self.work_button:SetImageFocusColour(1, 1, 1, 0.5) -- 添加白色高亮, rgba
  self.work_button:SetImageNormalColour(1, 1, 1, 1) -- 设置正常状态颜色
  -- 初始 hovertext 将在 UpdateWorkButtonHoverText 中设置
  -- 工作按钮总是显示，不再隐藏

  -- 工模式按钮点击事件
  self.work_button:SetOnClick(function()
    print("[LingGuardPanel] OnWorkButtonClick")
    self:OnWorkButtonClick()
  end)
end

-- 模式按钮容器动画
function LingGuardPanel:AnimateButtonContainer(button, target_height, use_animation, callback)
  if not button or not button.base_position or not button.container then
    return
  end

  -- 取消之前的移动动画
  button.container:CancelMoveTo()

  local target_y = button.base_position[2] + target_height
  local current_pos = button.container:GetPosition()
  local target_pos = Vector3(button.base_position[1], target_y, button.base_position[3])

  if use_animation == false then
    -- 直接设置位置，不使用动画
    button.container:SetPosition(target_pos)
    if callback then
      callback()
    end
  else
    -- 使用动画
    button.container:MoveTo(Vector3(current_pos.x, current_pos.y, current_pos.z), target_pos, MODE_BUTTON_ANIM_TIME, callback)
  end
end

-- 兼容旧的方法名
function LingGuardPanel:AnimateModeButton(button, target_height, use_animation)
  self:AnimateButtonContainer(button, target_height, use_animation)
end

-- worker按钮动画
function LingGuardPanel:AnimateWorkButton(to_final_position, use_animation, callback)
  if not self.work_button then
    return
  end

  -- 取消之前的移动动画
  self.work_button:CancelMoveTo()

  local target_y = to_final_position and self.work_button_final_y or self.work_button_initial_y
  local current_pos = self.work_button:GetPosition()
  local target_pos = Vector3(0, target_y, 0)

  if use_animation == false then
    -- 直接设置位置，不使用动画
    self.work_button:SetPosition(target_pos)
    if callback then
      callback()
    end
  else
    -- 使用动画
    self.work_button:MoveTo(Vector3(current_pos.x, current_pos.y, current_pos.z), target_pos, MODE_BUTTON_ANIM_TIME, callback)
  end
end

-- 计算按钮的目标高度
function LingGuardPanel:GetButtonTargetHeight(button, state)
  local data = button.data
  if not data then return HEIGHT.NORMAL end

  if state == "active" then
    -- 如果是守模式且工模式激活，使用特殊高度
    if data.hasWorkMode and self.work_mode_active then
      return data.activeHeightWithWork or data.activeHeight
    else
      return data.activeHeight
    end
  elseif state == "hover" then
    return data.hoverHeight
  else
    return HEIGHT.NORMAL
  end
end

-- 模式按钮点击事件
function LingGuardPanel:OnModeButtonClick(mode)
  if self.guard_inst and self.guard_inst:IsValid() then
    -- 发送RPC到服务端改变模式
    SendModRPCToServer(GetModRPC("ling_summon", "change_guard_behavior"), self.guard_inst, mode)
  end
end

function LingGuardPanel:OnWorkModeButtonClick(mode)
  if self.guard_inst and self.guard_inst:IsValid() then
    -- 发送RPC到服务端改变工模式
    SendModRPCToServer(GetModRPC("ling_summon", "change_guard_work"), self.guard_inst, mode)
  end
end

-- 工模式按钮点击事件
function LingGuardPanel:OnWorkButtonClick()
  print("[LingGuardPanel] OnWorkButtonClick")
  if self.work_mode_active then
    -- 先播放workSelector的close动画
    self.work_selector:Close(function()
      -- 动画完成后，隐藏工作选择器并播放守widget动画收上去
      self.work_selector:Hide()
      local guard_button = self.mode_buttons[GUARD_BEHAVIOR_MODE.GUARD]
      if guard_button and guard_button.is_active then
        local target_height = self:GetButtonTargetHeight(guard_button, "active")
        self:AnimateButtonContainer(guard_button, target_height)
      end
    end)

    -- 立即设置状态和发送RPC（但动画表现从先前位置收回）
    self.work_mode_active = false
    self.work_selector:ActiveWorkMode(GUARD_WORK_MODE.NONE)
    self:OnWorkModeButtonClick(GUARD_WORK_MODE.NONE)
  else
    -- 显示工模式选择器
    self.work_mode_active = true

    -- 先显示工作选择器
    self.work_selector:Show()

    -- 先重新计算守模式按钮高度（额外下降）
    local guard_button = self.mode_buttons[GUARD_BEHAVIOR_MODE.GUARD]
    if guard_button and guard_button.is_active then
      local target_height = self:GetButtonTargetHeight(guard_button, "active")
        -- 守widget动画完成后，打开workSelector的open动画
      local work_mode = self.guard_inst.replica.ling_guard:GetWorkMode()
      self.work_selector:ActiveWorkMode(work_mode, false, true)  -- 不使用动画直接激活
      self:AnimateButtonContainer(guard_button, target_height, true, function()
        self.work_selector:Open()
      end)
    else
      -- 如果守模式按钮不是激活状态，直接打开工作选择器
      self.work_selector:Open()
    end
  end

  -- 更新工作按钮的 hovertext
  self:UpdateWorkButtonHoverText()
end

-- 激活指定模式按钮
function LingGuardPanel:ActivateModeButton(mode, use_animation)
  -- 检查是否需要先关闭工作模式
  local need_close_work_mode = false
  local old_is_guard_mode = false

  if self.current_active_mode and self.mode_buttons[self.current_active_mode] then
    old_is_guard_mode = (self.current_active_mode == GUARD_BEHAVIOR_MODE.GUARD)
    -- 如果之前是守模式且工作模式激活，且现在要切换到非守模式，需要先关闭工作模式
    if old_is_guard_mode and self.work_mode_active and mode ~= GUARD_BEHAVIOR_MODE.GUARD then
      need_close_work_mode = true
    end
  end

  if need_close_work_mode then
    -- 先关闭工作模式，等待动画完成后再切换
    self.work_selector:Close(function()
      -- 工作模式关闭动画完成后，隐藏工作选择器并继续执行模式切换
      self.work_selector:Hide()
      self:DoActivateModeButton(mode, use_animation)
      -- 延迟执行worker按钮动画，与守按钮动画一起
      if old_is_guard_mode and mode ~= GUARD_BEHAVIOR_MODE.GUARD then
        self:AnimateWorkButton(false, use_animation)
      end
    end)

    -- 立即设置工作模式状态
    self.work_mode_active = false
    self.work_selector:ActiveWorkMode(GUARD_WORK_MODE.NONE)
    self:OnWorkModeButtonClick(GUARD_WORK_MODE.NONE)
    self:UpdateWorkButtonHoverText()
  else
    -- 直接执行模式切换
    self:DoActivateModeButton(mode, use_animation)
  end
end

-- 实际执行模式按钮激活的方法
function LingGuardPanel:DoActivateModeButton(mode, use_animation)
  local old_mode = self.current_active_mode

  -- 取消之前激活的按钮
  if self.current_active_mode and self.mode_buttons[self.current_active_mode] then
    local old_button = self.mode_buttons[self.current_active_mode]
    old_button.is_active = false

    local target_height = old_button.is_hovering and self:GetButtonTargetHeight(old_button, "hover") or HEIGHT.NORMAL
    self:AnimateButtonContainer(old_button, target_height, use_animation)
  end

  -- 激活新按钮
  if self.mode_buttons[mode] then
    local button = self.mode_buttons[mode]
    button.is_active = true
    button.is_hovering = false -- 激活状态不响应hover
    local target_height = self:GetButtonTargetHeight(button, "active")
    self:AnimateButtonContainer(button, target_height, use_animation)
    self.current_active_mode = mode
  end

  -- worker按钮动画：守模式激活时下移，取消时上移（但不在工作模式关闭时执行，避免重复）
  if mode == GUARD_BEHAVIOR_MODE.GUARD then
    -- 激活守模式，worker按钮下移到最终位置
    self:AnimateWorkButton(true, use_animation)
  elseif old_mode == GUARD_BEHAVIOR_MODE.GUARD and not self.work_mode_active then
    -- 从守模式切换到其他模式，worker按钮上移到初始位置（仅在工作模式未激活时）
    self:AnimateWorkButton(false, use_animation)
  end
end

-- 供replica组件调用的接口，更新UI状态
function LingGuardPanel:OnBehaviorModeChanged(mode)
  self:ActivateModeButton(mode, true)  -- 使用动画
end

function LingGuardPanel:OnWorkModeChanged(mode)
  -- 处于守模式才处理
  if not self:IsVisible() then
    return
  end
  if not self.guard_inst or not self.guard_inst.replica.ling_guard then
    return
  end
  local current_mode = self.guard_inst.replica.ling_guard:GetBehaviorMode()
  if current_mode ~= GUARD_BEHAVIOR_MODE.GUARD then
    return
  end

  -- 更新工作模式状态
  local work_mode = self.guard_inst.replica.ling_guard:GetWorkMode()
  local new_work_mode_active = (work_mode ~= GUARD_WORK_MODE.NONE)

  -- 如果工作模式状态发生变化，更新显示/隐藏
  if new_work_mode_active ~= self.work_mode_active then
    if new_work_mode_active then
      -- 激活工作模式，显示并打开工作选择器
      self.work_selector:Show()
      self.work_selector:Open()
    else
      -- 关闭工作模式，关闭并隐藏工作选择器
      self.work_selector:Close(function()
        self.work_selector:Hide()
      end)
    end
  end

  self.work_mode_active = new_work_mode_active
  self.work_selector:ActiveWorkMode(work_mode)
  self:UpdateWorkButtonHoverText()
end

function LingGuardPanel:RefreshPlanting()
  if not self.guard_inst or not self.guard_inst.replica.ling_guard_plant then
    return
  end
  if self.guard_inst.replica.ling_guard_plant:isPlanting() then
    self.plant_club:Hide()
  else
    self.plant_club:Show()
  end
end

function LingGuardPanel:Open(guard_inst)
  self.guard_inst = guard_inst

  -- 重置工模式状态
  self.work_mode_active = false
  -- 初始状态隐藏工作选择器
  self.work_selector:Hide()

  -- 更新所有按钮的 hovertext
  self:UpdateAllModeButtonHoverTexts()

  -- 从replica读取当前模式并激活对应按钮（不使用动画，直接设置）
  if guard_inst and guard_inst.replica.ling_guard then
    local work_mode = guard_inst.replica.ling_guard:GetWorkMode()
    print("[LingGuardPanel] OnOpen work_mode:", work_mode)
    if work_mode ~= GUARD_WORK_MODE.NONE then
      self.work_mode_active = true
      -- 如果工作模式激活，显示工作选择器并直接设置为打开状态
      self.work_selector:Show()
      -- 直接设置为打开状态，不播放动画
      self.work_selector.is_open = true
      self.work_selector:SetScissor(-500, -300, 1000, 600)  -- 设置大的裁剪区域来模拟取消裁剪
    end
    self.work_selector:ActiveWorkMode(work_mode, false)  -- 不使用动画直接激活
    local current_mode = guard_inst.replica.ling_guard:GetBehaviorMode()
    self:ActivateModeButton(current_mode, false)  -- 不使用动画直接激活
  end

  -- 读取并设置血量百分比
  if guard_inst and guard_inst.components.healthsyncer then
    local health_percent = guard_inst.components.healthsyncer:GetPercent()
    self.health:SetPercent(health_percent, false)  -- 打开时不使用动画
  end

  -- 更新工作按钮的 hovertext
  self:UpdateWorkButtonHoverText()

  self:RefreshPlanting()
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

-- 更新模式按钮的 hovertext
function LingGuardPanel:UpdateModeButtonHoverText(button)
  if not button or not button.mode then
    return
  end

  local mode_name = ""
  if button.mode == GUARD_BEHAVIOR_MODE.CAUTIOUS then
    mode_name = STRINGS.UI.LING_COMMAND.CAUTIOUS
  elseif button.mode == GUARD_BEHAVIOR_MODE.ATTACK then
    mode_name = STRINGS.UI.LING_COMMAND.ATTACK
  elseif button.mode == GUARD_BEHAVIOR_MODE.GUARD then
    mode_name = STRINGS.UI.LING_COMMAND.GUARD
  end

  local hover_text = STRINGS.UI.LING_GUARD_PANEL.MODE_PREFIX:format(mode_name)
  button:SetHoverText(hover_text, { offset_x = 0, offset_y = -300 })
end

-- 更新所有模式按钮的 hovertext
function LingGuardPanel:UpdateAllModeButtonHoverTexts()
  for mode, button in pairs(self.mode_buttons) do
    self:UpdateModeButtonHoverText(button)
  end
end

-- 更新工作按钮的 hovertext
function LingGuardPanel:UpdateWorkButtonHoverText()
  if not self.work_button then
    return
  end

  local hover_text = self.work_mode_active and
    STRINGS.UI.LING_GUARD_PANEL.STOP_WORK or
    STRINGS.UI.LING_GUARD_PANEL.SELECT_WORK

  self.work_button:SetHoverText(hover_text, { offset_x = 0, offset_y = -100 })
end

return LingGuardPanel
