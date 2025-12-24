local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"

local GUARD_SLOT_STATUS = CONSTANTS.GUARD_SLOT_STATUS
local GUARD_FORM = CONSTANTS.GUARD_FORM
local GUARD_LOCATION = CONSTANTS.GUARD_LOCATION

local LingGuardPanelCall = Class(Widget, function(self, owner)
    Widget._ctor(self, "LingGuardPanelCall")
    self.owner = owner
    self.slot_data = {}

    self.button = self:AddChild(ImageButton("images/ui_ling_guard_panel_call.xml", "summary.tex"))
    self.button.focus_scale = {1.1, 1.1, 1.1}
    self.button:SetPosition(0, 0, 0)
end)

-- 设置槽位数据，每次调用覆盖并刷新UI
function LingGuardPanelCall:SetSlotData(slot_data)
    self.slot_data = slot_data or {}
    self:_RefreshUI()
end

function LingGuardPanelCall:_RefreshUI()
    if not self.button then return end

    -- 刷新贴图
    self.button:SetTextures("images/ui_ling_guard_panel_call.xml", self:_GetTexture())

    -- 刷新悬停文本
    self.button:SetHoverText(self:_GetHoverText(), {
        font = NEWFONT_OUTLINE, offset_x = 0, offset_y = 15, colour = {1,1,1,1}
    })

    -- 刷新按钮状态
    local status = self.slot_data.status
    local world = self.slot_data.world
    if world == GUARD_LOCATION.OTHER_WORLD then
        self.button.image:SetTint(0.3, 0.3, 0.3, 0.5)
        self.button:SetClickable(false)
    else
        if status == GUARD_SLOT_STATUS.SUMMONING then
            self.button.image:SetTint(0.5, 0.5, 0.5, 0.7)
            self.button:SetClickable(false)
        else
            self.button.image:SetTint(1, 1, 1, 1)
            self.button:SetClickable(true)
        end
    end
end

function LingGuardPanelCall:_GetTexture()
    if self.slot_data.status == GUARD_SLOT_STATUS.EMPTY then
        return "summary.tex"
    end
    local form = self.slot_data.form
    if form == GUARD_FORM.XIANJING then
        return "xianjing.tex"
    elseif form == GUARD_FORM.XIAOYAO then
        return "xiaoyao.tex"
    elseif form == GUARD_FORM.QINGPING then
        return "qingping.tex"
    end
    return "summary.tex"
end

function LingGuardPanelCall:_GetHoverText()
    if self.slot_data.word == GUARD_LOCATION.OTHER_WORLD then
        return STRINGS.UI.LING_SUMMON.OTHER_WORLD
    end
    if self.slot_data.status == GUARD_SLOT_STATUS.SUMMONING then
        return STRINGS.UI.LING_SUMMON.SUMMONING:format(self:_GetTypeName())
    end
    return self:_GetGuardName()
end

function LingGuardPanelCall:_GetGuardName()
    local inst = self.slot_data.inst
    if inst and inst:IsValid() and inst.replica.ling_guard then
        return inst.replica.ling_guard.state.name
    end
    return self:_GetTypeName()
end

function LingGuardPanelCall:_GetTypeName()
    ArkLogger:Debug("LingGuardPanelCall:_GetTypeName", self.slot_data.form)
    local form = self.slot_data.form
    if form == GUARD_FORM.XIANJING then
        return STRINGS.UI.LING_SUMMON.XIANJING
    elseif form == GUARD_FORM.XIAOYAO then
        return STRINGS.UI.LING_SUMMON.XIAOYAO
    elseif form == GUARD_FORM.QINGPING then
        return STRINGS.UI.LING_SUMMON.QINGPING
    end
    return STRINGS.UI.LING_GUARD_PANEL_CALL.SUMMARY
end

function LingGuardPanelCall:OnMouseButton(button, down, x, y)
    local status = self.slot_data.status
    if status == GUARD_SLOT_STATUS.SUMMONING or self.slot_data.world == GUARD_LOCATION.OTHER_WORLD then
        return true
    end

    if button == MOUSEBUTTON_LEFT and down then
        if status == GUARD_SLOT_STATUS.EMPTY then
            self.owner.replica.ling_summon_manager:SummonBasic(self.slot_data.index)
        elseif status == GUARD_SLOT_STATUS.OCCUPIED then
            if self.slot_data and self.slot_data.inst then
                self.slot_data.inst.replica.ling_guard:OpenPanel(ThePlayer)
            end
        end
        return true
    end
end

return LingGuardPanelCall
