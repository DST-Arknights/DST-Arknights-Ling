local SilenceFatigueReplica = Class(function(self, inst)
  self.inst = inst
  self._current_poetry = net_float(inst.GUID, "ling_poetry._current_poetry", "poetrychanged")
  self._max_poetry = net_byte(inst.GUID, "ling_poetry._max_poetry", "maxpoetrychanged")
  if not TheWorld.ismastersim then
    self.inst:ListenForEvent("maxpoetrychanged", function()
      print("maxpoetrychanged", self._max_poetry:value())
      if ThePlayer.HUD.controls and ThePlayer.HUD.controls.status then
        ThePlayer.HUD.controls.status.ling_poetry:SetMax(self._max_poetry:value())
      end
    end, inst)
    self.inst:ListenForEvent("poetrychanged", function()
      print("poetrychanged", self._current_poetry:value())
      if ThePlayer.HUD.controls and ThePlayer.HUD.controls.status then
        ThePlayer.HUD.controls.status.ling_poetry:SetCurrent(self._current_poetry:value())
      end
    end, inst)
  end
end)

function SilenceFatigueReplica:SetElite(level)
  local data = TUNING.LING.ELITE[level]
  self._max_poetry:set(data.MAX_POETRY)
end

function SilenceFatigueReplica:SetPoetry(current_poetry)
  current_poetry = math.ceil(current_poetry)
  self._current_poetry:set(current_poetry)
end

return SilenceFatigueReplica
