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

-- 布局/高度参数（关系化定义，便于维护关联）
local BASE_ROW_Y = -50                      -- 模式按钮容器的基准Y（所有模式按钮默认Y）
local COMMON_HOVER_DROP = -30               -- 普通与守模式 hover 相对基准下移（统一）
local COMMON_ACTIVE_DROP = -70              -- 普通与守模式 active 相对基准下移（统一）
local WORK_OPEN_EXTRA_DROP = -50            -- 当工作按钮打开时，守按钮与工作按钮共同额外下移

-- 模式按钮数据（Y使用统一基准，保证三种模式在未激活时同行对齐）
local BEHAVIOR_BUTTON_DATA = {
  {
    mode = GUARD_BEHAVIOR_MODE.CAUTIOUS,
    texture = "command_cautious.tex",
    position = {186, BASE_ROW_Y, 0},
    name = "cautious",
    hoverHeight = COMMON_HOVER_DROP,
    activeHeight = COMMON_ACTIVE_DROP,
  },
  {
    mode = GUARD_BEHAVIOR_MODE.ATTACK,
    texture = "command_attack.tex",
    position = {112, BASE_ROW_Y, 0},
    name = "attack",
    hoverHeight = COMMON_HOVER_DROP,
    activeHeight = COMMON_ACTIVE_DROP
  },
  {
    mode = GUARD_BEHAVIOR_MODE.GUARD,
    texture = "command_guard.tex",
    position = {36, BASE_ROW_Y, 0},
    name = "guard",
    hoverHeight = COMMON_HOVER_DROP,
    activeHeight = COMMON_ACTIVE_DROP,
    activeHeightWithWork = COMMON_ACTIVE_DROP + WORK_OPEN_EXTRA_DROP,  -- 仅在工作打开时额外下移
    hasWorkMode = true  -- 标记此按钮有工模式
  }
}

-- 工作选择器锚点（X/Y与守按钮对齐）
local WORK_SELECTOR_ANCHOR_X = 36
local WORK_SELECTOR_ANCHOR_Y = -125


-- 非守模式下的“隐藏位置”：相对锚点向上抬高一定距离，用于切到守模式时从更高处降落
local WORK_SELECTOR_HIDDEN_RAISE = 40
local WORK_SELECTOR_HIDDEN_Y = WORK_SELECTOR_ANCHOR_Y + WORK_SELECTOR_HIDDEN_RAISE


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

  self.work_selector = self:AddChild(LingGuardWorkMode(self.owner))
  self.work_selector:SetPosition(Vector3(WORK_SELECTOR_ANCHOR_X, WORK_SELECTOR_ANCHOR_Y, 0))
  self.work_selector.before_open_callback = function(done)
    self:BeforeWorkSelectorOpen(done)
  end
  self.work_selector.after_close_callback = function()
    self:AfterWorkSelectorClose()
  end

  -- 创建面板背景
  self.panel = self:AddChild(Image("images/ui_ling_guard_panel.xml", "bg.tex"))
  self.health = self:AddChild(LingGuardHealth(self.owner))
  -- self.health:SetPosition(252, -160.75, 0)
  self.health:SetPosition(262, -138, 0)

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

  -- 名称图标即为“形态切换按钮”
  self.name = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "name_qingping.tex"))
  self.name:SetPosition(222, 48, 0)
  self.name:SetFocusScale(BUTTON_FOCUS_SCALE)
  self.name:SetOnClick(function()
    if not self.guard_inst or not self.guard_inst:IsValid() then return end
    -- 弦惊不可切换
    if self.guard_inst.prefab == "ling_guard_elite" then return end
    local lvl = (self.guard_inst and self.guard_inst.replica and self.guard_inst.replica.ling_guard and self.guard_inst.replica.ling_guard.GetLevel and self.guard_inst.replica.ling_guard:GetLevel()) or 1
    local unlocked = lvl >= 2
    if not unlocked then return end
    local FORM = CONSTANTS.GUARD_FORM
    local is_x = (self.guard_inst and self.guard_inst.replica and self.guard_inst.replica.ling_guard and self.guard_inst.replica.ling_guard.IsXiaoyao and self.guard_inst.replica.ling_guard:IsXiaoyao()) or false
    local target = is_x and FORM.QINGPING or FORM.XIAOYAO
    SendModRPCToServer(GetModRPC("ling_summon", "change_guard_form"), self.guard_inst, target)
    -- 客户端刷新名称贴图与 hover
    self:UpdateNameButton()
  end)

  self.container_open = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "container_open.tex"))
  self.container_open:SetPosition(unpack(CONSTANTS.LING_GUARD_PANEL_OPEN_CONTAINER_POSITION))
  self.container_open:SetFocusScale(BUTTON_FOCUS_SCALE)
  self.container_open:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.OPEN_CONTAINER)
  self.container_open.onclick = function() self:OpenContainer() end

  self.close:SetOnClick(function() self:RequestClose() end)

  -- 事件代理（用于安全移除监听）
  self._on_behavior_mode_changed_proxy = function() self:_OnGuardBehaviorModeChanged() end
  self._on_guard_onremove_proxy = function() self:DetachGuard() end
  self._on_clienthealthdirty_proxy = function()
    self:RefreshHealthFromGuard()
  end
  -- 监听 replica form tinybyte 变更
  self._on_formdirty_proxy = function()
    self:UpdateNameButton()
  end
  -- 监听等级变化
  self._on_levelchanged_proxy = function()
    self:UpdateNameButton()
  end


  self:Hide()
end)

-- 创建模式按钮
function LingGuardPanel:CreateModeButtons()
  -- 模式按钮数据
  self.mode_buttons = {}
  self.mode_containers = {}  -- 存储按钮容器
  self.current_active_mode = nil
  self.work_mode_active = false  -- 工模式是否激活

  for _, data in ipairs(BEHAVIOR_BUTTON_DATA) do
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

-- 工作选择器纵向位置更新：
-- 根据是否处于守模式、以及工作是否打开，决定 Y 位置；X 锁定在锚点
function LingGuardPanel:UpdateWorkSelectorY(use_animation, callback, open_override)
  if not self.work_selector then
    if callback then callback() end
    return
  end
  -- 取消之前的移动动画（移动整个工作选择器根节点）
  self.work_selector:CancelMoveTo()

  local current_pos = self.work_selector:GetPosition()
  local is_guard = (self.current_active_mode == GUARD_BEHAVIOR_MODE.GUARD)
  local is_open = (open_override ~= nil) and open_override or (self.work_selector.is_open == true)
  local extra = (is_guard and is_open) and WORK_OPEN_EXTRA_DROP or 0

  -- 守模式：对齐到“关闭/打开”的中间位；非守模式：放在“隐藏位”
  local target_y = is_guard and (WORK_SELECTOR_ANCHOR_Y + COMMON_ACTIVE_DROP + extra) or WORK_SELECTOR_HIDDEN_Y
  local target_pos = Vector3(WORK_SELECTOR_ANCHOR_X, target_y, 0)

  if use_animation == false then
    self.work_selector:SetPosition(target_pos)
    if callback then callback() end
  else
    self.work_selector:MoveTo(current_pos, target_pos, MODE_BUTTON_ANIM_TIME, callback)
  end
end

-- 计算按钮的目标高度
function LingGuardPanel:GetButtonTargetHeight(button, state)
  local data = button.data
  if not data then return 0 end

  if state == "active" then
    -- 守模式在工作打开时有额外下降
    local is_open = (self.work_selector and self.work_selector.is_open)
    if data.hasWorkMode and is_open then
      return data.activeHeightWithWork or data.activeHeight
    else
      return data.activeHeight
    end
  elseif state == "hover" then
    return data.hoverHeight
  else
    return 0
  end
end

-- 模式按钮点击事件
function LingGuardPanel:OnModeButtonClick(mode)
  if self.guard_inst and self.guard_inst:IsValid() then
    -- 发送RPC到服务端改变模式
    SendModRPCToServer(GetModRPC("ling_summon", "change_guard_behavior"), self.guard_inst, mode)
  end
end
function LingGuardPanel:BeforeWorkSelectorOpen(done)
    local guard_button = self.mode_buttons[GUARD_BEHAVIOR_MODE.GUARD]
    if guard_button then
        local base_active = (guard_button.data and guard_button.data.activeHeight) or 0
        local target_height = base_active + WORK_OPEN_EXTRA_DROP
        self:AnimateButtonContainer(guard_button, target_height, true)
    end
    -- 先把工作选择器也一起下移到“打开时”的位置，再执行打开动画
    self:UpdateWorkSelectorY(true, done, true)
end

function LingGuardPanel:AfterWorkSelectorClose()
    local guard_button = self.mode_buttons[GUARD_BEHAVIOR_MODE.GUARD]
    if guard_button then
        local base_active = (guard_button.data and guard_button.data.activeHeight) or 0
        self:AnimateButtonContainer(guard_button, base_active, true)
    end
    -- 关闭后回到“中间位”
    self:UpdateWorkSelectorY(true, nil, false)
end

-- 激活指定模式按钮
function LingGuardPanel:ActivateModeButton(mode, use_animation)
  -- 检查是否需要先关闭工作模式
  local need_close_work_mode = false
  local old_is_guard_mode = false

  if self.current_active_mode and self.mode_buttons[self.current_active_mode] then
    old_is_guard_mode = (self.current_active_mode == GUARD_BEHAVIOR_MODE.GUARD)
    -- 如果之前是守模式且工作模式激活，且现在要切换到非守模式，需要先关闭工作模式
    if old_is_guard_mode and (self.work_selector and self.work_selector.is_open) and mode ~= GUARD_BEHAVIOR_MODE.GUARD then
      need_close_work_mode = true
    end
  end

  if need_close_work_mode then
    -- 先关闭工作模式，等待动画完成后再切换（位置/守按钮回弹交由 AfterWorkSelectorClose 统一处理）
    self.work_selector:Close(true, function()
      self:DoActivateModeButton(mode, use_animation)
    end)
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

    local target_height = old_button.is_hovering and self:GetButtonTargetHeight(old_button, "hover") or 0
    self:AnimateButtonContainer(old_button, target_height, use_animation)
  end

  -- 激活新按钮
  if self.mode_buttons[mode] then
    local button = self.mode_buttons[mode]
    button.is_active = true
    button.is_hovering = false -- 激活状态不响应hover
    local target_height = self:GetButtonTargetHeight(button, "active")

    -- 先更新当前模式，确保后续位置计算读取到守模式
    self.current_active_mode = mode

    if mode == GUARD_BEHAVIOR_MODE.GUARD then
      self:AnimateButtonContainer(button, target_height, use_animation, function()
        if not self.work_selector then return end
        self.work_selector:Show()
        if use_animation then
          -- 动画方式下放（位置由 is_open 决定是否额外下降）
          self:UpdateWorkSelectorY(true, nil, nil)
        else
          -- 无动画场景（比如面板已在守模式下直接打开），立刻对齐到目标位置
          self:UpdateWorkSelectorY(false, nil, nil)
        end
      end)
    else
      self:AnimateButtonContainer(button, target_height, use_animation)
      -- 非守模式：工作按钮应处于隐藏态，并停在“隐藏位置”。
      -- 为避免与“从守模式切出”的动画收尾重复，这里仅在“非从守模式切出”的情况下立即隐藏并定位。
      if self.work_selector and old_mode ~= GUARD_BEHAVIOR_MODE.GUARD then
        self.work_selector:Hide()
        self:UpdateWorkSelectorY(false, nil, false)
      end
    end
  end

  -- 工作选择器显示/隐藏：仅在“从守模式切换到其他模式且工作未打开”时，收起并隐藏
  if old_mode == GUARD_BEHAVIOR_MODE.GUARD and mode ~= GUARD_BEHAVIOR_MODE.GUARD and not (self.work_selector and self.work_selector.is_open) then
    self:UpdateWorkSelectorY(use_animation, function()
      if self.work_selector then self.work_selector:Hide() end
    end, false)
  end
end

-- 供replica组件调用的接口，更新UI状态
function LingGuardPanel:OnBehaviorModeChanged(mode)
  self:ActivateModeButton(mode, true)  -- 使用动画
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

-- 绑定/解绑守卫实例与监听（仿照 LingGuardWorkMode 的 Attach/Detach 模式）
function LingGuardPanel:AttachGuard(inst)
  if self.guard_inst == inst then
    return
  end
  self:DetachGuard()
  if inst and inst:IsValid() then
    self.guard_inst = inst
    -- 监听行为模式变化与移除
    inst:ListenForEvent("behaviormodechanged", self._on_behavior_mode_changed_proxy, inst)
    inst:ListenForEvent("onremove", self._on_guard_onremove_proxy, inst)
    inst:ListenForEvent("clienthealthdirty", self._on_clienthealthdirty_proxy, inst)
    inst:ListenForEvent("ling_guard_formdirty", self._on_formdirty_proxy, inst)
    inst:ListenForEvent("levelchanged", self._on_levelchanged_proxy, inst)


    -- 子控件：工作选择器也附着到守卫
    if self.work_selector then
      self.work_selector:AttachGuard(inst)
    end
    -- 面板打开效果：守卫范围标记改为绿色；并同步当前模式到按钮（无动画，直接对齐）
    if inst.replica and inst.replica.ling_guard then
      inst.replica.ling_guard:SetGuardPositionColor(true)
      local current_mode = inst.replica.ling_guard:GetBehaviorMode()
      self:ActivateModeButton(current_mode, false)
    end
    -- 初次同步：名称贴图/hover 与 血量
    self:UpdateNameButton()
    self:RefreshHealthFromGuard()
  end
end

function LingGuardPanel:DetachGuard()
  if not self.guard_inst then
    return
  end
  local inst = self.guard_inst
  if inst and inst:IsValid() then
    inst:RemoveEventCallback("behaviormodechanged", self._on_behavior_mode_changed_proxy, inst)
    inst:RemoveEventCallback("onremove", self._on_guard_onremove_proxy, inst)
    inst:RemoveEventCallback("clienthealthdirty", self._on_clienthealthdirty_proxy, inst)
    inst:RemoveEventCallback("ling_guard_formdirty", self._on_formdirty_proxy, inst)
    inst:RemoveEventCallback("levelchanged", self._on_levelchanged_proxy, inst)
    if inst.replica and inst.replica.ling_guard then
      inst.replica.ling_guard:SetGuardPositionColor(false)
    end
  end

  if self.work_selector then
    self.work_selector:DetachGuard()
  end
  self.guard_inst = nil
end

function LingGuardPanel:UpdateNameButton()
  if not self.name then return end
  local inst = self.guard_inst
  if not inst or not inst:IsValid() then return end
  if inst.prefab == "ling_guard_elite" then
    self.name:SetTextures("images/ui_ling_guard_panel.xml", "name_xianjing.tex", "images/ui_ling_guard_panel.xml")
    self.name:SetHoverText(nil)
    return
  end
  local is_x = (inst and inst.replica and inst.replica.ling_guard and inst.replica.ling_guard.IsXiaoyao and inst.replica.ling_guard:IsXiaoyao()) or false
  local lvl = (inst and inst.replica and inst.replica.ling_guard and inst.replica.ling_guard.GetLevel and inst.replica.ling_guard:GetLevel()) or 1
  local unlocked = lvl >= 2
  if is_x then
    self.name:SetTextures("images/ui_ling_guard_panel.xml", "name_xiaoyao.tex", "name_xiaoyao.tex")
  else
    self.name:SetTextures("images/ui_ling_guard_panel.xml", "name_qingping.tex", "name_qingping.tex")
  end
  local hover = is_x and STRINGS.UI.LING_GUARD_PANEL.SWITCH_TO_QINGPING or STRINGS.UI.LING_GUARD_PANEL.SWITCH_TO_XIAOYAO
  if not unlocked then hover = hover .. STRINGS.UI.LING_GUARD_PANEL.LOCKED_SUFFIX end
  self.name:SetHoverText(hover, { offset_x = 0, offset_y = 80 })
end

function LingGuardPanel:RefreshHealthFromGuard()
  if not self.guard_inst or not self.guard_inst:IsValid() then return end
  local p
  if self.guard_inst.components and self.guard_inst.components.healthsyncer then
    p = self.guard_inst.components.healthsyncer:GetPercent()
  end
  if p ~= nil then
    self.health:SetPercent(p, false)
    local hover_fmt = (STRINGS and STRINGS.UI and STRINGS.UI.LING_GUARD_PANEL and STRINGS.UI.LING_GUARD_PANEL.HEALTH_PERCENT) or "Health: %d%%"
    local percent_text = string.format(hover_fmt, math.floor(p * 100 + 0.5))
    if self.health.SetHoverText then
      self.health:SetHoverText(percent_text, { offset_x = 0, offset_y = -80 })
    end
  end
end

function LingGuardPanel:_OnGuardBehaviorModeChanged()
  if not self.guard_inst or not self.guard_inst:IsValid() then
    return
  end
  if not self.guard_inst.replica or not self.guard_inst.replica.ling_guard then
    return
  end
  local mode = self.guard_inst.replica.ling_guard:GetBehaviorMode()
  -- 行为模式变化：用动画反馈
  self:ActivateModeButton(mode, true)
end

function LingGuardPanel:Open(guard_inst)
  if not guard_inst or not guard_inst:IsValid() or not (guard_inst.replica and guard_inst.replica.ling_guard) then
    return
  end
  --
  self:AttachGuard(guard_inst)

  self:RefreshPlanting()
  self:Show()
end

function LingGuardPanel:Close()
  if not self.guard_inst then
    self:Hide()
    return
  end
  self:DetachGuard()
  self:Hide()
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


return LingGuardPanel
