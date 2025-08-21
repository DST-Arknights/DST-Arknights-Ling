local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"

local GUARD_SLOT_STATUS = CONSTANTS.GUARD_SLOT_STATUS
local GUARD_TYPE = CONSTANTS.GUARD_TYPE

local LingGuardPanelCall = Class(Widget, function(self, slot_data, owner)
    Widget._ctor(self, "LingGuardPanelCall")
    self.owner = owner
    self.slot_data = slot_data

    -- 创建按钮
    self:CreateButton()

    -- 初始化按钮状态
    self:UpdateButtonState()
end)

-- 创建按钮
function LingGuardPanelCall:CreateButton()
    local bg = self:GetButtonTexture()

    self.button = self:AddChild(ImageButton("images/ui_ling_guard_panel_call.xml", bg))
    self.button.focus_scale = {1.1, 1.1, 1.1}
    self.button:SetPosition(0, 0, 0)
end

-- 获取按钮贴图
function LingGuardPanelCall:GetButtonTexture()
    if self.slot_data.type == GUARD_TYPE.QINGPING then
        return "qingping.tex"
    elseif self.slot_data.type == GUARD_TYPE.XIAOYAO then
        return "xiaoyao.tex"
    elseif self.slot_data.type == GUARD_TYPE.XIANJING then
        return "xianjing.tex"
    else
        return "summary.tex"
    end
end

-- 更新按钮状态
function LingGuardPanelCall:UpdateButtonState()
    if not self.button then
        return
    end

    local hover_text = self:GetHoverText()
    self.button:SetHoverText(hover_text, { font = NEWFONT_OUTLINE, offset_x = 0, offset_y = 15, colour = {1,1,1,1}})

    -- 根据状态设置按钮外观
    if self.slot_data.status == GUARD_SLOT_STATUS.SUMMONING then
        self.button.image:SetTint(0.5, 0.5, 0.5, 0.7)
        self.button:SetClickable(false)
    elseif self.slot_data.status == GUARD_SLOT_STATUS.OTHER_WORLD then
        self.button.image:SetTint(0.3, 0.3, 0.3, 0.5)
        self.button:SetClickable(false)
    else
        self.button.image:SetTint(1, 1, 1, 1)
        self.button:SetClickable(true)
    end
end

-- 获取悬停文本
function LingGuardPanelCall:GetHoverText()
    if self.slot_data.status == GUARD_SLOT_STATUS.SUMMONING then
        local type_name = self:GetTypeName()
        return STRINGS.UI.LING_SUMMON.SUMMONING:format(type_name)
    elseif self.slot_data.status == GUARD_SLOT_STATUS.OTHER_WORLD then
        local name = self:GetGuardName()
        return STRINGS.UI.LING_SUMMON.OTHER_WORLD:format(name)
    else
        return self:GetGuardName()
    end
end

-- 获取召唤兽名字
function LingGuardPanelCall:GetGuardName()
    if self.slot_data.inst and self.slot_data.inst:IsValid() and self.slot_data.inst.components.named then
        return self.slot_data.inst.components.named.name
    else
        return self:GetTypeName()
    end
end

-- 获取类型名称
function LingGuardPanelCall:GetTypeName()
    if self.slot_data.type == GUARD_TYPE.QINGPING then
        return STRINGS.UI.LING_SUMMON.QINGPING
    elseif self.slot_data.type == GUARD_TYPE.XIAOYAO then
        return STRINGS.UI.LING_SUMMON.XIAOYAO
    elseif self.slot_data.type == GUARD_TYPE.XIANJING then
        return STRINGS.UI.LING_SUMMON.XIANJING
    else
        return STRINGS.UI.LING_GUARD_PANEL_CALL.SUMMARY
    end
end

-- 更新槽位数据
function LingGuardPanelCall:UpdateSlotData(slot_data)
    print("LingGuardPanelCall:UpdateSlotData")
    if not slot_data then
        return
    end
    print("LingGuardPanelCall:UpdateSlotData", slot_data.type, slot_data.status)

    -- 更新slot_data
    self.slot_data = slot_data

    -- 更新按钮贴图
    if self.button then
        local new_texture = self:GetButtonTexture()
        self.button:SetTextures("images/ui_ling_guard_panel_call.xml", new_texture)
    end

    -- 更新按钮状态
    self:UpdateButtonState()
end

function LingGuardPanelCall:OnMouseButton(button, down, x, y)
    print("LingGuardPanelCall:OnMouseButton", self.slot_data.type, self.slot_data.status)

    -- 召唤中状态和不在这个世界状态不响应点击
    if self.slot_data.status == GUARD_SLOT_STATUS.SUMMONING or
       self.slot_data.status == GUARD_SLOT_STATUS.OTHER_WORLD then
        return true
    end

    if button == MOUSEBUTTON_LEFT then
        if down then
            print("LingGuardPanelCall:OnMouseButton", "MOUSEBUTTON_LEFT", "down", self.slot_data.type, self.slot_data.status)
            if self.slot_data.status == GUARD_SLOT_STATUS.EMPTY then
                -- 空插槽，召唤清平到指定插槽
                SendModRPCToServer(GetModRPC("ling_summon", "summon_guard"), GUARD_TYPE.QINGPING, self.slot_data.index)
            elseif self.slot_data.status == GUARD_SLOT_STATUS.OCCUPIED then
                SendModRPCToServer(GetModRPC("ling_summon", "request_open_guard_panel"), self.slot_data.inst)
            end
        end
        return true
    end
end

return LingGuardPanelCall













