local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"

local LingGuardHealth = Class(Widget, function(self, owner)
  Widget._ctor(self, "LingGuardHealth")
  self.owner = owner
  self.current_health = 0
  self.max_health = 1
  self.percent = 0

  -- 动画参数
  self.full_health_threshold = 0.9  -- 满值百分比阈值，90%认为是满血
  self.animation_duration = 0.3     -- 动画时长（秒）

  self.health_icons = {}  -- 存储血量图标
  self.current_visible_count = 0  -- 当前显示的图标数量
  self.target_visible_count = 0   -- 目标显示的图标数量

  self:CreateHealthBar()
end)

function LingGuardHealth:CreateHealthBar()
  local positions = {
    { -30, -46.25 },
    { 20, -31.25},
    { -10, 8.75 },
    { 20, 68.75},
  }

  for i, pos in ipairs(positions) do
    local health_icon = self:AddChild(Image("images/ui_ling_guard_panel.xml", "health.tex"))
    health_icon:SetPosition(pos[1], pos[2], 0)
    health_icon:SetTint(1, 1, 1, 0)  -- 初始设为透明
    self.health_icons[i] = health_icon
  end
end

-- 计算应该显示的血量图标数量
function LingGuardHealth:CalculateVisibleIcons(percent)
  local icon_count = #self.health_icons

  -- 如果血量百分比达到满值阈值，显示所有图标
  if percent >= self.full_health_threshold then
    return icon_count
  end

  -- 否则按比例计算显示数量
  return math.floor(percent * icon_count / self.full_health_threshold)
end

-- 执行图标显示/隐藏动画
function LingGuardHealth:AnimateIcon(icon_index, target_alpha, duration)
  local icon = self.health_icons[icon_index]
  if not icon then return end

  -- 取消之前的动画
  icon:CancelTintTo()

  -- 使用内置的 TintTo 方法
  local source_alpha = 0
  if target_alpha == 0 then
    source_alpha = 1
  end
  icon:TintTo({r = 1, g = 1, b = 1, a = source_alpha}, {r = 1, g = 1, b = 1, a = target_alpha}, duration)
end

-- 设置当前血量
function LingGuardHealth:SetCurrent(current, use_animation)
  self.current_health = current
  self:_UpdatePercent(use_animation)
end

-- 设置最大血量
function LingGuardHealth:SetMax(max, use_animation)
  self.max_health = max
  self:_UpdatePercent(use_animation)
end

-- 更新 percent 并刷新 UI
function LingGuardHealth:_UpdatePercent(use_animation)
  local new_percent = self.max_health > 0 and (self.current_health / self.max_health) or 0
  self.percent = new_percent

  -- 计算目标显示的图标数量
  self.target_visible_count = self:CalculateVisibleIcons(self.percent)

  -- 如果不使用动画，直接设置
  if not use_animation then
    for i = 1, #self.health_icons do
      local target_alpha = i <= self.target_visible_count and 1 or 0
      self.health_icons[i]:SetTint(1, 1, 1, target_alpha)
    end
    self.current_visible_count = self.target_visible_count
  else
    -- 使用动画过渡
    for i = 1, #self.health_icons do
      local should_be_visible = i <= self.target_visible_count
      local is_currently_visible = i <= self.current_visible_count

      -- 只对需要改变状态的图标执行动画
      if should_be_visible ~= is_currently_visible then
        local target_alpha = should_be_visible and 1 or 0
        self:AnimateIcon(i, target_alpha, self.animation_duration)
      end
    end

    self.current_visible_count = self.target_visible_count
  end

  -- 更新 hover 文本
  self:_UpdateHoverText()
end

-- 更新 hover 文本
function LingGuardHealth:_UpdateHoverText()
  local hover_fmt = STRINGS.UI.LING_GUARD_PANEL.HEALTH
  local text = string.format(hover_fmt, self.current_health, self.max_health, self.percent * 100)
  self:SetHoverText(text, { offset_x = 0, offset_y = -80 })
end



return LingGuardHealth
