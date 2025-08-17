local LingGuardPlantReplica = Class(function(self, inst)
    self.inst = inst
    self._level = net_tinybyte(inst.GUID, "ling_guard_plant_replica._level", "ling_guard_plant_replica.leveldirty")
    self._planting = net_bool(inst.GUID, "ling_guard_plant_replica._planting", "ling_guard_plant_replica.plantingdirty")
    if not TheWorld.ismastersim then
        self.inst:ListenForEvent("ling_guard_plant_replica.leveldirty", function()
            self._enabledSlots = self:GetEnabledSlotsByLevel(self._level:value())
        end, inst)
    end
    self._enabledSlots = { 1 }
end)

function LingGuardPlantReplica:GetEnabledSlotsByLevel(level)
    local res = {}
    for i = 1, level do
        table.insert(res, i)
    end
    return res
end

function LingGuardPlantReplica:SetLevel(level)
    self._level:set(level)
end

function LingGuardPlantReplica:GetLevel()
    return self._level:value()
end

function LingGuardPlantReplica:SetPlanting(planting)
    self._planting:set(planting)
end

function LingGuardPlantReplica:isPlanting()
    return self._planting:value()
end

function LingGuardPlantReplica:GetEnabledSlots()
    return self._enabledSlots
end

return LingGuardPlantReplica
