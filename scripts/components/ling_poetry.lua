local function oncurrent_poetry(self, value)
  self.inst.replica.ling_poetry.state.current_poetry = value
end

local function onmax_poetry(self, value)
  self.inst.replica.ling_poetry.state.max_poetry = value
end

local LingPoetry = Class(function(self, inst)
  self.inst = inst
  self.poetry_recovery_while_idle_per_frames = 0
  self.poetry_recovery_in_dream_per_frames = 0
  self.current_poetry = 0
  self.max_poetry = 0
  self.inst:StartUpdatingComponent(self)
  self:SetElite(1)
end, nil, {
  current_poetry = oncurrent_poetry,
  max_poetry = onmax_poetry,
})

function LingPoetry:SetElite(level)
  local data = TUNING.LING.ELITE[level]
  if not data then
    return
  end
  self.level = level
  self.poetry_recovery_while_idle_per_frames = data.POETRY_RECOVERY_WHILE_IDLE_PER_SECOND * FRAMES
  self.poetry_recovery_in_dream_per_frames = data.POETRY_RECOVERY_IN_DREAM_PER_SECOND * FRAMES
  self.max_poetry = data.MAX_POETRY
  -- TODO: 测试模式 - 初始化时设为满值
  self.current_poetry = self.max_poetry -- 测试期间总是满诗意
end

function LingPoetry:OnSave()
  return {
    level = self.level,
  }
end

function LingPoetry:OnLoad(data)
  if data then
    self:SetElite(data.level)
  end
end

function LingPoetry:Dirty(diff)
  -- TODO: 测试模式 - 诗意永远满值，扣除不会真实减少
  -- 诗意组件已测试完成，暂时绕过真实的诗意消耗
  self.current_poetry = self.max_poetry -- 强制设为满值
  -- self.current_poetry = math.clamp(self.current_poetry + diff, 0, self.max_poetry)
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
  -- if self.inst:InDream() then
  if true then
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
