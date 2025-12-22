local SafeCallLingPoetryUI = GenSafeCall(function(inst)
  return inst and inst.HUD and inst.HUD.controls and inst.HUD.controls.ling_poetry
end)

local SilenceFatigueReplica = Class(function(self, inst)
  self.inst = inst
  self.state = NetState(self.inst, {
    current_poetry = "float:classified",
    max_poetry = "byte:classified",
  })
  self.state:Attach(self.inst)
  self.state:Watch("current_poetry", function()
    ArkLogger:Debug("current_poetry", self.state.current_poetry)
    SafeCallLingPoetryUI(self.inst):SetCurrent(self.state.current_poetry)
  end)
  self.state:Watch("max_poetry", function()
    ArkLogger:Debug("max_poetry", self.state.max_poetry)
    SafeCallLingPoetryUI(self.inst):SetMax(self.state.max_poetry)
  end)
end)

function SilenceFatigueReplica:SetElite(level)
  local data = TUNING.LING.ELITE[level]
  self.state.max_poetry = data.MAX_POETRY
end

function SilenceFatigueReplica:SetPoetry(current_poetry)
  self.state.current_poetry = current_poetry
end

function SilenceFatigueReplica:GetCurrent()
  return self.state.current_poetry
end

function SilenceFatigueReplica:GetMax()
  return self.state.max_poetry
end

return SilenceFatigueReplica
