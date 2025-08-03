local LingGuardPlantReplica = Class(function(self, inst)
    self.inst = inst
    self._level = net_tinybyte(inst.GUID, "ling_guard_plant_replica._level", "ling_guard_plant_replica.leveldirty")
    if not TheWorld.ismastersim then
        self.inst:ListenForEvent("ling_guard_plant_replica.leveldirty", function()
            self._enabledSlots = self:GetEnabledSlotsByLevel(self._level:value())
        end, inst)
    end
    self._enabledSlots = { 1 }
end)

function LingGuardPlantReplica:GetEnabledSlotsByLevel(level)
    print ("[LingGuardPlantReplica] GetEnabledSlotsByLevel", level)
    if level == 1 then
        return { 1, 2 }
    elseif level == 2 then
        return { 1, 2, 3 }
    elseif level == 3 then
        return { 1, 2, 3, 4 }
    end
    return { 1 }
end

function LingGuardPlantReplica:SetLevel(level)
    self._level:set(level)
end

function LingGuardPlantReplica:GetLevel()
    return self._level:value()
end

function LingGuardPlantReplica:GetEnabledSlots()
    return self._enabledSlots
end

return LingGuardPlantReplica
