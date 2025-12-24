local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"

local GUARD_WORK_MODE = CONSTANTS.GUARD_WORK_MODE

-- 文案映射，避免冗长分支
local WORK_NAME_MAP = {
  [GUARD_WORK_MODE.CHOP]    = STRINGS.UI.LING_GUARD_WORKMODE.CHOP,
  [GUARD_WORK_MODE.DIG]     = STRINGS.UI.LING_GUARD_WORKMODE.DIG,
  [GUARD_WORK_MODE.DIG_LAND]= STRINGS.UI.LING_GUARD_WORKMODE.DIG_LAND,
  [GUARD_WORK_MODE.HAMMER]  = STRINGS.UI.LING_GUARD_WORKMODE.HAMMER,
  [GUARD_WORK_MODE.MINE]    = STRINGS.UI.LING_GUARD_WORKMODE.MINE,
  [GUARD_WORK_MODE.PLANT]   = STRINGS.UI.LING_GUARD_WORKMODE.PLANT,
}


local LingGuardWorkMode = Class(Widget, function(self, owner)
  Widget._ctor(self, "LingGuardWorkMode")
  self.owner = owner
  self.current_active_mode = GUARD_WORK_MODE.NONE
  self.BUTTON_WIDTH = 64
  self.TOTAL_POSITIONS = 7  -- 总共7个位置
  self.WORK_BUTTON_COUNT = 6  -- 6个工作按钮
  self.SCISSOR_TIME = 0.2
  self.MOVE_TIME = 0.2

  self:CreateWorkButtons()
  self:CreateWorkSwitch()
  self.is_open = false

  -- 如果在创建时就传入了守卫实例，立即绑定
end)

-- 创建工模式按钮
function LingGuardWorkMode:CreateWorkButtons()
  -- 工模式按钮数据
  self.work_buttons = {}

  -- 工作模式按钮数据，从位置1开始（位置0为中心空位）
  local button_data = {
    {
      mode = GUARD_WORK_MODE.CHOP,
      texture = "work_chop.tex",
      name = "chop",
      position_index = 1  -- 第2个位置（索引1）
    },
    {
      mode = GUARD_WORK_MODE.DIG,
      texture = "work_dig.tex",
      name = "dig",
      position_index = 2  -- 第3个位置（索引2）
    },
    {
      mode = GUARD_WORK_MODE.DIG_LAND,
      texture = "work_dig_land.tex",
      name = "dig_land",
      position_index = 3  -- 第4个位置（索引3）
    },
    {
      mode = GUARD_WORK_MODE.HAMMER,
      texture = "work_hammer.tex",
      name = "hammer",
      position_index = 4  -- 第5个位置（索引4）
    },
    {
      mode = GUARD_WORK_MODE.MINE,
      texture = "work_mine.tex",
      name = "mine",
      position_index = 5  -- 第6个位置（索引5）
    },
    {
      mode = GUARD_WORK_MODE.PLANT,
      texture = "work_plant.tex",
      name = "plant",
      position_index = 6  -- 第7个位置（索引6）
    }
  }

  -- 创建容器，容器的中心点就是整个UI的中心点
  self.container = self:AddChild(Widget("container"))

  -- 创建背景图，只覆盖工作按钮的位置（位置1-6）
  self.bg = self.container:AddChild(Image("images/ui.xml", "white.tex"))
  -- 225, 228, 189,
  self.bg:SetTint(0.88, 0.88, 0.74, 1)
  self.bg:ScaleToSize(self.BUTTON_WIDTH * self.WORK_BUTTON_COUNT, self.BUTTON_WIDTH)
  -- 背景图的位置：从第1个位置开始，到第6个位置结束
  -- 背景图的中心应该在第3.5个位置（1+6)/2 = 3.5
  local bg_center_x = (1 + self.WORK_BUTTON_COUNT) * self.BUTTON_WIDTH / 2
  self.bg:SetPosition(bg_center_x, 0, 0)

  -- 创建工作模式按钮
  for _, data in ipairs(button_data) do
    local button = self.container:AddChild(ImageButton("images/ui_ling_guard_panel.xml", data.texture))
    -- 按钮位置：position_index * BUTTON_WIDTH（第0个位置是中心空位）
    local button_x = data.position_index * self.BUTTON_WIDTH
    button:SetPosition(button_x, 0, 0)
    button:SetFocusScale(1.1, 1.1, 1.1)

    -- 存储按钮的原始位置索引
    button.position_index = data.position_index

    button:SetOnClick(function()
      self:OnWorkModeButtonClick(data.mode)
    end)

    -- 设置 hovertext
    self:UpdateWorkButtonHoverText(button, data.mode)

    self.work_buttons[data.mode] = button
  end

  -- 初始化时设置为原点一格的裁剪
  local center_scissor = self:GetCenterGridScissorRange()
  self.container:SetScissor(center_scissor.x, center_scissor.y, center_scissor.w, center_scissor.h)
  self.container:Hide()
  self.bg:Hide()
end

function LingGuardWorkMode:SetWorkMode(mode, use_animation, force)
  self:ActiveWorkMode(mode, use_animation, force)
  if not self.is_open then
    self:_SyncScissorWithState()
  end
end

-- 创建工作选择器按钮
function LingGuardWorkMode:CreateWorkSwitch()
  self.work_switch = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "work_selector.tex"))
  self.work_switch:SetPosition(0, -21, 0)
  self.work_switch.scale_on_focus = false;
  self.work_switch:SetImageFocusColour(1, 1, 1, 0.5) -- 添加白色高亮, rgba
  self.work_switch:SetImageNormalColour(1, 1, 1, 1) -- 设置正常状态颜
  self.work_switch:SetOnClick(function()
    self:OnWorkButtonClick()
  end)
end

-- 点击工作按钮
function LingGuardWorkMode:OnWorkButtonClick()
  if not self.is_open then
    if self.before_open_callback then
      self.before_open_callback(function()
        if self._guard_inst and self._guard_inst.replica and self._guard_inst.replica.ling_guard then
          self.current_active_mode = self._guard_inst.replica.ling_guard:GetWorkMode()
          self:UpdateWorkSwitchHoverText()
        end
        self:Open()
      end)
    else
      if self._guard_inst and self._guard_inst.replica and self._guard_inst.replica.ling_guard then
        self.current_active_mode = self._guard_inst.replica.ling_guard:GetWorkMode()
        self:UpdateWorkSwitchHoverText()
      end
      self:Open()
    end
  else
    -- 先本地启动关闭动画，再发送 RPC；赋 NONE 也在 Close 内部统一处理
    self:Close(true, function()
      if self.after_close_callback then
        self.after_close_callback()
      end
    end)
  end
end

-- 获取中心单格裁剪范围
function LingGuardWorkMode:GetCenterGridScissorRange()
  return self:GetCenterGridScissorRangeForMode(self.current_active_mode)
end

-- 根据给定模式获取中心单格裁剪范围
function LingGuardWorkMode:GetCenterGridScissorRangeForMode(mode)
  local center_x = 0
  if mode and mode ~= GUARD_WORK_MODE.NONE then
    local btn = self.work_buttons and self.work_buttons[mode] or nil
    if btn and btn.position_index then
      center_x = btn.position_index * self.BUTTON_WIDTH
    end
  end
  return {
    x = center_x - self.BUTTON_WIDTH/2,
    y = -self.BUTTON_WIDTH/2,
    w = self.BUTTON_WIDTH,
    h = self.BUTTON_WIDTH
  }
end


-- 获取全部按钮区域裁剪范围
function LingGuardWorkMode:GetAllGridScissorRange()
  -- 始终覆盖从 none(-0.5) 到 第6格(6.5) 的整条区域，避免受当前模式影响
  local left = -0.5 * self.BUTTON_WIDTH
  local right = 6.5 * self.BUTTON_WIDTH
  return {
    x = left,
    y = -self.BUTTON_WIDTH/2,
    w = right - left,
    h = self.BUTTON_WIDTH
  }
end

-- 根据当前开合状态同步裁剪窗口到正确区域
function LingGuardWorkMode:_SyncScissorWithState()
  if not self.container then return end
  if self.is_open then
    -- 打开态直接使用“全条区域”裁剪
    local s = self:GetAllGridScissorRange()
    self.container:SetScissor(s.x, s.y, s.w, s.h)
  else
    -- 关闭态仅显示当前模式所在中心格（NONE 时为 0 格）
    local s = self:GetCenterGridScissorRangeForMode(self.current_active_mode)
    self.container:SetScissor(s.x, s.y, s.w, s.h)
  end
end

function LingGuardWorkMode:ActiveWorkMode(mode, use_animation, force)
  if not force and (not self.is_open or self.current_active_mode == mode) then
    return
  end

  -- 计算容器需要移动的距离，使选中的按钮移动到中心位置（位置0）
  local target_x = 0

  if mode == GUARD_WORK_MODE.NONE then
    -- 没有选中任何工作模式，容器回到原位
    target_x = 0
  else
    local button = self.work_buttons[mode]
    if button and button.position_index then
      -- 计算需要移动的距离：将按钮的位置移动到中心（位置0）
      -- 如果按钮在位置3，那么容器需要向左移动3个单位，即 -3 * BUTTON_WIDTH
      target_x = -button.position_index * self.BUTTON_WIDTH
    end
  end

  -- 执行动画
  local current_pos = self.container:GetPosition()
  local target_pos = Vector3(target_x, current_pos.y, current_pos.z)

  if use_animation then
    self.container:MoveTo(current_pos, target_pos, self.MOVE_TIME)
  else
    self.container:SetPosition(target_pos)
  end

  self.current_active_mode = mode
  self:UpdateWorkSwitchHoverText()
end

function LingGuardWorkMode:OnWorkModeButtonClick(mode)
    -- 先更新自身UI
    self:ActiveWorkMode(mode, true)
    -- 发送RPC到服务端
    if self._guard_inst and self._guard_inst:IsValid() then
        SendModRPCToServer(GetModRPC("ling_summon", "change_guard_work"), self._guard_inst, mode)
    end
end

-- 打开动画：从中心向两边展开
function LingGuardWorkMode:Open(use_animation, callback)
    if use_animation == nil then
      use_animation = true
    end
    if self.is_open then
        if callback then callback() end
        return
    end


    -- 目标裁剪区域：覆盖整个按钮区域
    local target_scissor = self:GetAllGridScissorRange()

    self.is_open = true
    -- 打开前再兜底同步一次，并把容器位移到正确位置（无动画，强制）
    -- 注意：Open 不再做容器位移，AttachGuard/事件监听会负责把容器保持在正确位置
    self.container:Show()
    self.bg:Show()
    if use_animation then
      -- 起始裁剪区域：只显示中心一格（自身位置）
      local start_scissor = self:GetCenterGridScissorRange()
      self.container:ScissorTo(start_scissor, target_scissor, self.SCISSOR_TIME, function()
          -- 动画完成后，保持在“全条区域”裁剪即可
          if callback then callback() end
      end)
    else
      self.container:SetScissor(target_scissor.x, target_scissor.y, target_scissor.w, target_scissor.h)
      if callback then callback() end
    end
end

-- 关闭动画：从两边向中心收缩
function LingGuardWorkMode:Close(use_animation, callback)
    if use_animation == nil then
      use_animation = true
    end
    if not self.is_open then
        if callback then callback() end
        return
    end

    -- 记录关闭前用于动画的视觉模式
    local visual_mode = self.current_active_mode
    -- 起始裁剪区域：覆盖整个按钮区域（以关闭前状态计算）
    local start_scissor = self:GetAllGridScissorRange()

    self.is_open = false
    -- 在关闭流程内统一切换为 NONE（不移动容器，仅更新悬浮文案）
    self.current_active_mode = GUARD_WORK_MODE.NONE
    self:UpdateWorkSwitchHoverText()

    if use_animation then
      -- 目标裁剪区域：只显示中心一格（以视觉模式为中心）
      local target_scissor = self:GetCenterGridScissorRangeForMode(visual_mode)
      self.container:ScissorTo(start_scissor, target_scissor, self.SCISSOR_TIME, function()
        -- 动画结束后，将容器无动画对齐到当前模式（此时为 NONE），并同步裁剪窗口
        self:ActiveWorkMode(self.current_active_mode, false, true)
        self:_SyncScissorWithState()
        if callback then callback() end
      end)
    else
      -- 立即无动画对齐到当前模式（此时为 NONE），并同步裁剪窗口
      self:ActiveWorkMode(self.current_active_mode, false, true)
      self:_SyncScissorWithState()
      if callback then callback() end
    end
    if self._guard_inst and self._guard_inst:IsValid() then
      SendModRPCToServer(GetModRPC("ling_summon", "change_guard_work"), self._guard_inst, GUARD_WORK_MODE.NONE)
    end
end

-- 更新工作按钮的 hovertext（映射表实现，避免分支）
function LingGuardWorkMode:UpdateWorkButtonHoverText(button, mode)
  if not button or not mode then return end
  local work_name = WORK_NAME_MAP[mode] or ""
  local hover_text = STRINGS.UI.LING_GUARD_WORKMODE.WORK_PREFIX:format(work_name)
  button:SetHoverText(hover_text, { offset_x = 0, offset_y = -80 })
end

function LingGuardWorkMode:UpdateWorkSwitchHoverText()
  local hover_text = self.current_active_mode == GUARD_WORK_MODE.NONE and
    STRINGS.UI.LING_GUARD_WORKMODE.SELECT_WORK or
    STRINGS.UI.LING_GUARD_WORKMODE.STOP_WORK
  self.work_switch:SetHoverText(hover_text, { offset_x = 0, offset_y = -80 })
end

return LingGuardWorkMode
