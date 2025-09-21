local PoemUseable = Class(function(self, inst)
    self.inst = inst
    self.onusefn = nil
    self.canusefn = nil
end)

function PoemUseable:SetOnUseFn(fn)
    self.onusefn = fn
end

function PoemUseable:SetCanUseFn(fn)
    self.canusefn = fn
end

function PoemUseable:CanUse(doer)
    return self.canusefn == nil or self.canusefn(self.inst, doer) ~= false
end

function PoemUseable:Use(doer)
    return self.onusefn == nil or self.onusefn(self.inst, doer) ~= false
end

return PoemUseable
