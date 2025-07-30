local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"

local GUARD_WORK_MODE = CONSTANTS.GUARD_WORK_MODE

local LingGuardWorkMode = Class(Widget, function(self, owner)
  Widget._ctor(self, "LingGuardWorkMode")
  self.owner = owner
  self.current_active_mode = GUARD_WORK_MODE.NONE
  self.BUTTON_WIDTH = 64
  self.TOTAL_POSITIONS = 7  -- 总共7个位置
  self.WORK_BUTTON_COUNT = 6  -- 6个工作按钮
  self.SCISSOR_TIME = 0.2
  self:CreateWorkButtons()
  self:Hide()
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

  -- 初始化裁剪区域为单个按钮大小（默认隐藏状态）
  self.is_open = false

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
  self:SetScissor(center_scissor.x, center_scissor.y, center_scissor.w, center_scissor.h)
end

-- 获取中心单格裁剪范围
function LingGuardWorkMode:GetCenterGridScissorRange()
  return {
    x = -self.BUTTON_WIDTH/2,
    y = -self.BUTTON_WIDTH/2,
    w = self.BUTTON_WIDTH,
    h = self.BUTTON_WIDTH
  }
end

-- 获取全部按钮区域裁剪范围
function LingGuardWorkMode:GetAllGridScissorRange()
  -- 获取容器当前位置，计算按钮区域的实际范围
  local container_pos = self.container:GetPosition()

  -- 计算当前按钮区域的左右边界（相对于self的坐标系）
  -- 排除最左边的空位，只包含实际工作按钮（位置1-6）
  local buttons_left = container_pos.x + self.BUTTON_WIDTH/2  -- 第1个按钮的左边缘
  local buttons_right = container_pos.x + self.BUTTON_WIDTH * 6.5  -- 第6个按钮的右边缘

  return {
    x = buttons_left,
    y = -self.BUTTON_WIDTH/2,
    w = buttons_right - buttons_left,
    h = self.BUTTON_WIDTH
  }
end

function LingGuardWorkMode:ActiveWorkMode(mode, use_animation, force)
  if self.current_active_mode == mode then
    return
  end
  if not force and not self.is_open then
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
    self.container:MoveTo(current_pos, target_pos, 0.2)
  else
    self.container:SetPosition(target_pos)
  end

  self.current_active_mode = mode
end

function LingGuardWorkMode:GetCurrentActiveMode()
  return self.current_active_mode
end

function LingGuardWorkMode:SetOnWorkModeButtonClick(fn)
    self.on_work_mode_click_fn = fn
end

function LingGuardWorkMode:OnWorkModeButtonClick(mode)
    -- 激活选中的工作模式（带动画）
    self:ActiveWorkMode(mode, true)

    -- 调用外部回调
    if self.on_work_mode_click_fn then
        self.on_work_mode_click_fn(mode)
    end
end

-- 打开动画：从中心向两边展开
function LingGuardWorkMode:Open(callback)
    self:Show()
    if self.is_open then
        if callback then callback() end
        return
    end

    -- 起始裁剪区域：只显示中心一格（自身位置）
    local start_scissor = self:GetCenterGridScissorRange()

    -- 目标裁剪区域：覆盖整个按钮区域
    local target_scissor = self:GetAllGridScissorRange()

    self.is_open = true
    self:ScissorTo(start_scissor, target_scissor, self.SCISSOR_TIME, function()
        -- 动画完成后，设置大的裁剪区域来模拟取消裁剪
        self:SetScissor(-500, -300, 1000, 600)
        if callback then callback() end
    end)
end

-- 关闭动画：从两边向中心收缩
function LingGuardWorkMode:Close(callback)
    if not self.is_open then
        if callback then callback() end
        return
    end

    -- 起始裁剪区域：覆盖整个按钮区域
    local start_scissor = self:GetAllGridScissorRange()

    -- 目标裁剪区域：只显示中心一格（自身位置）
    local target_scissor = self:GetCenterGridScissorRange()

    self.is_open = false
    self:ScissorTo(start_scissor, target_scissor, self.SCISSOR_TIME, callback)
end

-- 更新工作按钮的 hovertext
function LingGuardWorkMode:UpdateWorkButtonHoverText(button, mode)
  if not button or not mode then
    return
  end

  local work_name = ""
  if mode == GUARD_WORK_MODE.CHOP then
    work_name = STRINGS.UI.LING_GUARD_WORKMODE.CHOP
  elseif mode == GUARD_WORK_MODE.DIG then
    work_name = STRINGS.UI.LING_GUARD_WORKMODE.DIG
  elseif mode == GUARD_WORK_MODE.DIG_LAND then
    work_name = STRINGS.UI.LING_GUARD_WORKMODE.DIG_LAND
  elseif mode == GUARD_WORK_MODE.HAMMER then
    work_name = STRINGS.UI.LING_GUARD_WORKMODE.HAMMER
  elseif mode == GUARD_WORK_MODE.MINE then
    work_name = STRINGS.UI.LING_GUARD_WORKMODE.MINE
  elseif mode == GUARD_WORK_MODE.PLANT then
    work_name = STRINGS.UI.LING_GUARD_WORKMODE.PLANT
  end

  local hover_text = STRINGS.UI.LING_GUARD_WORKMODE.WORK_PREFIX:format(work_name)
  button:SetHoverText(hover_text, { offset_x = 0, offset_y = -80 })
end

return LingGuardWorkMode
