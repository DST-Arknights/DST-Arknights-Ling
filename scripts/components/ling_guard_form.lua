local CONSTANTS = require("ark_constants_ling")
local FORM = CONSTANTS.GUARD_FORM

local LingGuardForm = Class(function(self, inst)
    self.inst = inst
    self.form = FORM.QINGPING -- default
end)

-- Internal: apply tags and notify
local function apply_form(self, form)
    local inst = self.inst
    -- remove old tags
    inst:RemoveTag(FORM.QINGPING)
    inst:RemoveTag(FORM.XIAOYAO)
    -- add new tag
    if form == FORM.XIAOYAO then
        inst:AddTag(FORM.XIAOYAO)
    else
        inst:AddTag(FORM.QINGPING)
        form = FORM.QINGPING
    end
    self.form = form
    inst:PushEvent("ling_form_changed", { form = form })
end

function LingGuardForm:SetForm(form)
    if form ~= FORM.QINGPING and form ~= FORM.XIAOYAO then
        -- allow string inputs for robustness
        if form == "qingping" then
            form = FORM.QINGPING
        elseif form == "xiaoyao" then
            form = FORM.XIAOYAO
        else
            form = FORM.QINGPING
        end
    end
    -- apply (always ensure tags)
    apply_form(self, form)
end

function LingGuardForm:ToggleForm()
    local nextf = (self.form == FORM.QINGPING) and FORM.XIAOYAO or FORM.QINGPING
    self:SetForm(nextf)
end

function LingGuardForm:GetForm()
    return self.form
end

function LingGuardForm:OnSave()
    return { form = self.form }
end

function LingGuardForm:OnLoad(data)
    if data and data.form then
        -- backward compat: accept string or constant
        local f = data.form
        if f == "qingping" then f = FORM.QINGPING
        elseif f == "xiaoyao" then f = FORM.XIAOYAO end
        self.form = (f == FORM.XIAOYAO) and FORM.XIAOYAO or FORM.QINGPING
    end
    -- Re-apply to ensure tags and event consumers sync
    apply_form(self, self.form)
end

return LingGuardForm

