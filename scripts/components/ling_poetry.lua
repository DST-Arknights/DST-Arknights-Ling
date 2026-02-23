local function oncurrent_poetry(self, value)
  -- 只改整数
  self.inst.replica.ling_poetry.state.current_poetry = math.floor(value)
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
  self.poetry_recovery_while_idle_per_frames = data.POETRY_RECOVERY_WHILE_IDLE_PER_SECOND
  self.poetry_recovery_in_dream_per_frames = data.POETRY_RECOVERY_IN_DREAM_PER_SECOND
  self.max_poetry = data.MAX_POETRY
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
  self.current_poetry = math.clamp(self.current_poetry + diff, 0, self.max_poetry)
  self.inst:PushEvent("ling_poetry_changed", { diff = diff, current = self.current_poetry, max = self.max_poetry })
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
  return self.current_poetry >= amount
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
