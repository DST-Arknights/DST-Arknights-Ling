
-- 诗意值ui
AddClassPostConstruct("widgets/controls", function(self)
  if not self.owner or self.owner.prefab ~= "ling" then
    return
  end
  local LingPoetryBadge = require "widgets/ling_poetry"
  -- 将诗意值 UI 直接添加到 topright_root，这样坐标系统更简单
  self.ling_poetry = self.topright_root:AddChild(LingPoetryBadge(self.owner))

  self.owner:DoTaskInTime(.5, function(owner)
    -- 只有在没有保存位置的情况下才设置默认位置
    if not self.ling_poetry.position_loaded then
      -- 获取 statusdisplays 的位置作为参考
      local status_pos = self.status:GetPosition()
      local status_world_pos = self.status:GetWorldPosition()
      local topright_world_pos = self.topright_root:GetWorldPosition()

      -- 计算相对于 topright_root 的位置
      local relative_x = status_world_pos.x - topright_world_pos.x
      local relative_y = status_world_pos.y - topright_world_pos.y

      -- 设置默认位置（在状态显示的右侧）
      self.ling_poetry:SetPosition(relative_x + 80, relative_y, 0)
      self.ling_poetry:SetScale(self.status:GetScale())
    end
  end)

  -- 监听幽灵模式变化
  local _SetGhostMode = self.status.SetGhostMode
  function self.status:SetGhostMode(ghost_mode, ...)
    _SetGhostMode(self, ghost_mode, ...)
    if self.parent and self.parent.ling_poetry then
      if ghost_mode then
        self.topright_root.ling_guard_panel:Hide()
        self.parent.ling_poetry:Hide()
      else
        self.parent.ling_poetry:Show()
      end
    end
  end

  
  local LingGuardPanel = require "widgets/ling_guard_panel"
  self.topright_root.ling_guard_panel = self.topright_root:AddChild(LingGuardPanel(self.owner))
  self.topright_root.ling_guard_panel:SetPosition(-800, -400, 0)
  self.topright_root.ling_guard_panel:SetScale(0.6, 0.6, 0.6)
  -- 同时在 topright_root 上也存储一个引用，方便 ling_poetry 访问
  self.topright_root.ling_guard_panel:Hide();
end)
