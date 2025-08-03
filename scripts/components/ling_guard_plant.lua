local function onlevel(self, level)
    print("[LingGuardPlant] onlevel", level)
  self.inst.replica.ling_guard_plant:SetLevel(level)
  self._enabledSlots = self.inst.replica.ling_guard_plant:GetEnabledSlotsByLevel(level)
end

local LingGuardPlant = Class(function(self, inst)
    self.inst = inst
    self._enabledSlots = {}
    self:SetLevel(1)
end, nil, {
  level = onlevel
})

-- 判断某个索引是否有效
function LingGuardPlant:IsValidIndex(index)
    local enabledSlots = self:GetEnabledSlots()
    for _, enabledIdx in ipairs(enabledSlots) do
        if index == enabledIdx then
            return true
        end
    end
    return false
end

function LingGuardPlant:GetEnabledSlots()
    return self._enabledSlots
end

function LingGuardPlant:SetLevel(level)
    self.level = level
end

function LingGuardPlant:GetLevel()
    return self.level
end

function LingGuardPlant:OnSave()
    return { level = self.level }
end

function LingGuardPlant:OnLoad(data)
    if data and data.level then
        self.level = data.level
    end
end

return LingGuardPlant
