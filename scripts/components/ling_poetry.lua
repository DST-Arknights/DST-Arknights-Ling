local LingPoetry = Class(function(self, inst)
  self.inst = inst
  self.poetry_recovery_while_idle_per_frames = 0
  self.poetry_recovery_in_dream_per_frames = 0
  self.current_poetry = 0
  self.max_poetry = 0
  self.inst:StartUpdatingComponent(self)
end)

function LingPoetry:SetElite(level)
  local data = TUNING.LING.ELITE[level]
  self.poetry_recovery_while_idle_per_frames = data.POETRY_RECOVERY_WHILE_IDLE_PER_SECOND * FRAMES
  self.poetry_recovery_in_dream_per_frames = data.POETRY_RECOVERY_IN_DREAM_PER_SECOND * FRAMES
  self.max_poetry = data.MAX_POETRY
  -- TODO: 测试模式 - 初始化时设为满值
  self.current_poetry = self.max_poetry -- 测试期间总是满诗意
  self.inst.replica.ling_poetry:SetElite(level)
end

function LingPoetry:OnSave()
  return {
    current_poetry = self.current_poetry,
    max_poetry = self.max_poetry,
    poetry_recovery_while_idle_per_frames = self.poetry_recovery_while_idle_per_frames,
    poetry_recovery_in_dream_per_frames = self.poetry_recovery_in_dream_per_frames
  }
end

function LingPoetry:OnLoad(data)
  if data then
    if data.current_poetry then
      self:Dirty(data.current_poetry)
    end
    if data.max_poetry then
      self.max_poetry = data.max_poetry
    end
    if data.poetry_recovery_while_idle_per_frames then
      self.poetry_recovery_while_idle_per_frames = data.poetry_recovery_while_idle_per_frames
    end
    if data.poetry_recovery_in_dream_per_frames then
      self.poetry_recovery_in_dream_per_frames = data.poetry_recovery_in_dream_per_frames
    end
  end
end

function LingPoetry:Dirty(diff)
  -- TODO: 测试模式 - 诗意永远满值，扣除不会真实减少
  -- 诗意组件已测试完成，暂时绕过真实的诗意消耗
  self.current_poetry = self.max_poetry -- 强制设为满值
  -- self.current_poetry = math.clamp(self.current_poetry + diff, 0, self.max_poetry)
  self.inst.replica.ling_poetry:SetPoetry(self.current_poetry)
end

-- 获取当前诗意值
function LingPoetry:GetCurrent()
  return self.current_poetry
end

-- 获取最大诗意值
function LingPoetry:GetMax()
  return self.max_poetry
end

-- 检查诗意是否足够
function LingPoetry:HasEnough(amount)
  -- TODO: 测试模式 - 诗意检查总是返回true
  return true -- 测试期间总是有足够诗意
  -- return self.current_poetry >= amount
end

function LingPoetry:OnUpdate(dt)
  if self.inst.components.sanity:IsInsane() then
    return
  end
  if self.inst:InDream() then
    local diff = self.poetry_recovery_in_dream_per_frames * dt
    self:Dirty(diff)
  else
    if self.inst:HasTag('idle') then
      local diff = self.poetry_recovery_while_idle_per_frames * dt
      self:Dirty(diff)
    end
  end
end

return LingPoetry
