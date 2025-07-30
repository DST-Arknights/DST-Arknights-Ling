local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local ling_guard_panel_call = require "widgets/ling_guard_panel_call"
local CONSTANTS = require "ark_constants_ling"

local LingPoetryBadge = Class(Badge, function(self, owner)
  Badge._ctor(self, "ling_poetry", owner)
  self.max_poetry = 0
  self.current_poetry = 0

  -- 拖拽相关状态
  self.is_dragging = false
  self.drag_offset = Vector3(0, 0, 0)

  -- 位置保存相关
  self.save_key = "ling_poetry_position"
  self.position_loaded = false

  -- 双击检测相关
  self.last_click_time = 0
  self.double_click_threshold = 0.5  -- 双击时间阈值（秒）

  -- 屏幕边界检查相关
  self.screen_margin = 50  -- 距离屏幕边缘的最小距离
  self.last_screen_size = {w = 0, h = 0}

  -- 启用鼠标交互
  self:SetClickable(true)

  -- 加载保存的位置
  self:LoadPosition()

  -- 监听窗口大小变化
  self:StartUpdating()  -- 启用 OnUpdate 来检查屏幕大小变化
  self:SetOnGainFocus(function() self:SetScale(1.1, 1.1, 1.1) end)
  self:SetOnLoseFocus(function() self:SetScale(1, 1, 1) end)
  self.panelCallOpened = false
  self.buttons = {}
  self.slot_buttons = {} -- 存储槽位按钮的映射，key为slot_index
  self.last_slot_count = 0 -- 记录上次的槽位数量，用于检测变化
end)

function LingPoetryBadge:OpenCallPanel()
  self:CloseCallPanel()

  -- 直接从 replica 获取可用槽位数据
  local replica = self.owner.replica.ling_summon_manager
  if not replica then
    return
  end

  local available_slots = replica:GetAvailableSlotsData()
  print("available_slots", #available_slots)
  if #available_slots == 0 then
    return
  end

  -- 记录当前槽位数量
  self.last_slot_count = #available_slots

  -- 根据可用槽位数量，生成按钮并围绕本UI做360均分旋转布局
  local angle_step = 360 / #available_slots
  local radius = 105  -- 调整这个值以改变按钮的半径
  local offsetX = 0
  local offsetY = 0

  for i, slot_data in ipairs(available_slots) do
    -- 从90度开始(最上面)，顺时针旋转
    local angle = 90 - (i - 1) * angle_step
    local x = radius * math.cos(angle / 180 * math.pi)
    local y = radius * math.sin(angle / 180 * math.pi)

    local callPanel = self:AddChild(ling_guard_panel_call(slot_data, self.owner))
    callPanel:SetPosition(x + offsetX, y + offsetY, 0)
    callPanel:SetRotation(-angle + 90)

    table.insert(self.buttons, callPanel)
    self.slot_buttons[slot_data.index] = callPanel
  end

  self.panelCallOpened = true
end

function LingPoetryBadge:CloseCallPanel()
  for _, button in ipairs(self.buttons) do
    button:Kill()
  end
  self.buttons = {}
  self.slot_buttons = {} -- 清理槽位按钮映射
  self.panelCallOpened = false
end


function LingPoetryBadge:SetMax(max)
  self.max_poetry = max
  self:SetPercent(self.current_poetry / self.max_poetry, self.max_poetry)
end

function LingPoetryBadge:SetCurrent(current)
  self.current_poetry = current
  self:SetPercent(self.current_poetry / self.max_poetry, self.max_poetry)
end

-- 当槽位数据变化时调用
function LingPoetryBadge:OnSlotDataChanged(slot_index)
  -- 如果面板未打开，跳过
  if not self.panelCallOpened then
    return
  end

  -- 检查槽位数量是否发生变化
  local replica = self.owner.replica.ling_summon_manager
  if replica then
    local current_slot_count = replica:GetAvailableSlotCount()
    if current_slot_count ~= self.last_slot_count then
      -- 槽位数量发生变化，重新绘制按钮
      self:RedrawButtons()
      return
    end
  end

  -- 槽位数量没有变化，只更新对应按钮
  local button = self.slot_buttons[slot_index]
  if button and replica then
    local slot_data = replica:GetSlotData(slot_index)
    if slot_data then
      button:UpdateSlotData(slot_data)
    end
  end
end

-- 重新绘制按钮
function LingPoetryBadge:RedrawButtons()
  if self.panelCallOpened then
    self:OpenCallPanel() -- 重新打开面板，会自动清理旧按钮并创建新按钮
  end
end

-- 监听屏幕大小变化
function LingPoetryBadge:OnUpdate(dt)
  local screen_w, screen_h = TheSim:GetScreenSize()

  -- 检查屏幕大小是否改变
  if screen_w ~= self.last_screen_size.w or screen_h ~= self.last_screen_size.h then
    self.last_screen_size.w = screen_w
    self.last_screen_size.h = screen_h

    -- 如果位置已经加载，检查当前位置是否还在屏幕边界内
    if self.position_loaded then
      local current_pos = self:GetPosition()
      if not self:IsPositionValid(current_pos.x, current_pos.y) then
        -- 位置超出边界，修正位置
        local x, y, z, was_clamped = self:ClampToScreenBounds(current_pos.x, current_pos.y, current_pos.z)
        self:SetPosition(x, y, z)
        -- 保存修正后的位置
        if was_clamped then
          self:SavePosition()
        end
      end
    end
  end
end

-- 计算鼠标在当前 Widget 坐标系下的位置
function LingPoetryBadge:GetMouseLocalPosition()
  local mouse_pos = TheInput:GetScreenPosition()

  if self.parent then
    -- 获取父级的世界坐标和缩放
    local parent_world_pos = self.parent:GetWorldPosition()
    local parent_scale = self.parent:GetScale()

    -- 计算相对于父级的坐标
    local relative_pos = mouse_pos - parent_world_pos

    -- 应用缩放修正
    return Vector3(
      relative_pos.x / parent_scale.x,
      relative_pos.y / parent_scale.y,
      relative_pos.z / parent_scale.z
    )
  else
    -- 如果没有父级，直接返回屏幕坐标
    return mouse_pos
  end
end

-- 自定义的 FollowMouse 实现，支持坐标系转换
function LingPoetryBadge:StartDragging()
  if self.followhandler == nil then
    -- 计算初始偏移
    local current_pos = self:GetPosition()
    local mouse_local_pos = self:GetMouseLocalPosition()
    self.drag_offset = current_pos - mouse_local_pos

    -- 添加鼠标移动处理器
    self.followhandler = TheInput:AddMoveHandler(function(mx, my)
      if self.is_dragging then
        local mouse_local_pos = self:GetMouseLocalPosition()
        local new_pos = mouse_local_pos + self.drag_offset
        -- 限制在屏幕边界内
        local x, y, z, was_clamped = self:ClampToScreenBounds(new_pos.x, new_pos.y, new_pos.z)
        self:SetPosition(x, y, z)
      end
    end)
  end
end

-- 停止拖拽
function LingPoetryBadge:StopDragging()
  if self.followhandler ~= nil then
    self.followhandler:Remove()
    self.followhandler = nil
  end
end

-- 获取屏幕边界信息
function LingPoetryBadge:GetScreenBounds()
  local screen_w, screen_h = TheSim:GetScreenSize()

  -- 现在 LingPoetryBadge 直接是 topright_root 的子元素
  -- topright_root 的锚点是右上角 (ANCHOR_RIGHT + ANCHOR_TOP)
  -- 坐标系统：右上角为 (0, 0)，左下角为 (-screen_w, -screen_h)

  local bounds = {
    left = -screen_w + self.screen_margin,      -- 屏幕左边缘
    right = -self.screen_margin,                -- 屏幕右边缘（距离右边缘一定距离）
    top = -self.screen_margin,                  -- 屏幕上边缘（距离上边缘一定距离）
    bottom = -screen_h + self.screen_margin     -- 屏幕下边缘
  }

  -- 考虑父级的缩放（topright_root 的缩放）
  if self.parent then
    local parent_scale = self.parent:GetScale()
    bounds.left = bounds.left / parent_scale.x
    bounds.right = bounds.right / parent_scale.x
    bounds.top = bounds.top / parent_scale.y
    bounds.bottom = bounds.bottom / parent_scale.y
  end

  return bounds
end

-- 检查并修正位置，确保在屏幕边界内
function LingPoetryBadge:ClampToScreenBounds(x, y, z)
  local bounds = self:GetScreenBounds()

  -- 限制在边界内
  local clamped_x = math.max(bounds.left, math.min(bounds.right, x))
  local clamped_y = math.max(bounds.bottom, math.min(bounds.top, y))

  -- 检查是否发生了位置修正
  local was_clamped = (clamped_x ~= x) or (clamped_y ~= y)

  return clamped_x, clamped_y, z or 0, was_clamped
end

-- 检查位置是否在屏幕边界内
function LingPoetryBadge:IsPositionValid(x, y)
  local bounds = self:GetScreenBounds()
  return x >= bounds.left and x <= bounds.right and y >= bounds.bottom and y <= bounds.top
end

-- 保存当前位置
function LingPoetryBadge:SavePosition()
  local pos = self:GetPosition()
  local save_data = {
    x = pos.x,
    y = pos.y,
    z = pos.z
  }

  local json_str = json.encode(save_data)
  TheSim:SetPersistentString(self.save_key, json_str, false)
end

-- 加载保存的位置
function LingPoetryBadge:LoadPosition()
  TheSim:GetPersistentString(self.save_key, function(load_success, str)
    if load_success and str and str ~= "" then
      local success, save_data = pcall(function() return json.decode(str) end)
      if success and save_data and save_data.x and save_data.y then
        -- 延迟设置位置，确保父级组件已经初始化完成
        self.inst:DoTaskInTime(0.1, function()
          -- 检查位置是否在屏幕边界内，如果不在则修正
          local x, y, z, was_clamped = self:ClampToScreenBounds(save_data.x, save_data.y, save_data.z or 0)
          self:SetPosition(x, y, z)
          self.position_loaded = true

          -- 如果位置被修正了，保存新位置
          if was_clamped then
            self:SavePosition()
          end
        end)
      end
    end
  end)
end

-- 重置位置（删除保存的位置数据）
function LingPoetryBadge:ResetPosition()
  TheSim:SetPersistentString(self.save_key, "", false)
  self.position_loaded = false

  -- 重新设置为默认位置
  if self.parent and self.parent.heart and self.parent.stomach then
    local heartX, heartY = self.parent.heart:GetPosition():Get()
    local stomachX, stomachY = self.parent.stomach:GetPosition():Get()
    local offsetX = stomachX - heartX
    if self.parent.brain then
      local brainX, brainY = self.parent.brain:GetPosition():Get()
      if brainY == heartY or brainY == stomachY then
        offsetX = stomachX - brainX
      end
    end
    self:SetPosition(stomachX + offsetX, stomachY, 0)
  end
end

-- 重写鼠标按钮事件处理
function LingPoetryBadge:OnMouseButton(button, down, x, y)
  print("LingPoetryBadge:OnMouseButton")

  -- 调用父类的处理方法
  Badge.OnMouseButton(self, button, down, x, y)
  -- 左键切换ling_guard_panel显示状态
  if button == MOUSEBUTTON_LEFT then
    if down then
      if self.panelCallOpened then
        self:CloseCallPanel()
      else
        if (ThePlayer.HUD.controls.ling_guard_panel:IsVisible()) then
          ThePlayer.HUD.controls.ling_guard_panel:RequestClose()
        else 
          self:OpenCallPanel()
        end
      end
    end
    return true
  end

  -- 只处理右键拖拽 (1001 是右键常量)
  if button == MOUSEBUTTON_RIGHT then
    if down then
      -- 检测双击
      local current_time = GetTime()
      local time_since_last_click = current_time - self.last_click_time

      if time_since_last_click <= self.double_click_threshold then
        -- 双击右键：重置位置
        self:ResetPosition()
        self.last_click_time = 0  -- 重置点击时间，避免三击
        return true
      else
        -- 单击右键：开始拖拽
        self.last_click_time = current_time
        self.is_dragging = true

        -- 添加视觉反馈：稍微缩放表示正在拖拽
        self:SetScale(0.95, 0.95, 1)

        -- 开始跟随鼠标
        self:StartDragging()

        return true
      end
    else
      -- 停止拖拽
      self.is_dragging = false

      -- 恢复原始缩放
      self:SetScale(1, 1, 1)

      -- 停止跟随鼠标
      self:StopDragging()

      -- 保存当前位置
      self:SavePosition()

      return true
    end
  end
end

-- 重写 Kill 方法，确保清理拖拽相关的资源
function LingPoetryBadge:Kill()
  -- 停止拖拽并清理资源
  self:StopDragging()
  self.is_dragging = false

  -- 停止更新
  self:StopUpdating()

  -- 调用父类的 Kill 方法
  Badge.Kill(self)
end

return LingPoetryBadge
