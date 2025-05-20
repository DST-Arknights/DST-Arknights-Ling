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
  self.inst.replica.ling_poetry:SetElite(level)
end

function LingPoetry:OnSave()
  return {current_poetry = self.current_poetry}
end

function LingPoetry:OnLoad(data)
  if data and data.current_poetry then
    self:Dirty(data.current_poetry)
  end
end

function LingPoetry:Dirty(diff)
  self.current_poetry = math.clamp(self.current_poetry + diff, 0, self.max_poetry)
  self.inst.replica.ling_poetry:SetPoetry(self.current_poetry)
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
