local function RescaleTimeline(self, val)
    local timeline = self.currentstate and self.currentstate.timeline
    if timeline then
        local key = "attackSpeedTime"
        for _, v in pairs(timeline) do
            if val == nil or val == 1 then
                v.time = v[key] or v.time
                v[key] = nil
            else
                v[key] = v[key] or v.time
                v.time = v.time / val
            end
        end
    end
end

AddComponentPostInit("combat", function(self)
  function self:SetAttackSpeed(speed)
    if speed == nil or speed == 0 then
      speed = 1
    end
    if not self.base_attack_period then
      self.base_attack_period = self.min_attack_period
    end
    self:SetAttackPeriod(self.base_attack_period / speed)
    self.inst.replica.combat:SetAttackSpeed(speed)
  end
  function self:GetAttackSpeed()
    return self.inst.replica.combat:GetAttackSpeed()
  end
end)
AddClassPostConstruct("components/combat_replica", function(self)
  self._attack_speed = net_float(self.inst.GUID, "combat._attack_speed")
  self._attack_speed:set(1)
  function self:SetAttackSpeed(speed)
    self._attack_speed:set(speed)
  end
  function self:GetAttackSpeed()
    return self._attack_speed:value() or 1
  end
end)


AddStategraphPostInit("wilson", function(sg)
    local OldAtackOnenter = sg.states["attack"].onenter
    sg.states["attack"].onenter = function(inst, ...)
        OldAtackOnenter(inst, ...)
        if not inst.components.rider:IsRiding() and inst.sg.currentstate.name == "attack" then
            local attack_speed = inst.components.combat:GetAttackSpeed()
            if attack_speed ~= 1 then
                inst.AnimState:SetDeltaTimeMultiplier(attack_speed)
                RescaleTimeline(inst.sg, attack_speed)
                if inst.sg.timeout then
                    inst.sg:SetTimeout(inst.sg.timeout / attack_speed)
                end
            end
        end
    end

    local OldAttackOnExit = sg.states["attack"].onexit
    sg.states["attack"].onexit = function(inst, ...)
        OldAttackOnExit(inst, ...)
        inst.AnimState:SetDeltaTimeMultiplier(1)
        RescaleTimeline(inst.sg)
    end
end)

AddStategraphPostInit("wilson_client", function(sg)
    local OldAtackOnenter = sg.states["attack"].onenter
    sg.states["attack"].onenter = function(inst, ...)
        OldAtackOnenter(inst, ...)

        if not inst.replica.rider:IsRiding() and inst.sg.currentstate.name == "attack" then
            local attack_speed = inst.replica.combat:GetAttackSpeed()
            if attack_speed ~= 1 then
                inst.AnimState:SetDeltaTimeMultiplier(attack_speed)
                RescaleTimeline(inst.sg, attack_speed)
                if inst.sg.timeout then
                    inst.sg:SetTimeout(inst.sg.timeout / attack_speed)
                end
            end
        end
    end

    local OldAttackOnExit = sg.states["attack"].onexit
    sg.states["attack"].onexit = function(inst, ...)
        OldAttackOnExit(inst, ...)
        inst.AnimState:SetDeltaTimeMultiplier(1)
        RescaleTimeline(inst.sg)
    end
end)