local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"

local GUARD_SLOT_STATUS = CONSTANTS.GUARD_SLOT_STATUS
local SLOT_TYPE = CONSTANTS.GUARD_SLOT_TYPE

local LingGuardPanelCall = Class(Widget, function(self, slot_data, owner)
    Widget._ctor(self, "LingGuardPanelCall")
    self.owner = owner
    self.slot_data = slot_data

    -- 创建按钮
    self:CreateButton()

    -- 注册槽位 dirty 监听（创建-销毁模型）
    self:_AttachSlotDirtyListeners()
    -- 基于当前 slot_data 做一次增量应用（含必要的实例监听挂载）
    self:OnSlotDataDirty(self.slot_data)

    -- 初始化按钮状态
    self:UpdateButtonState()
end)

-- 槽位数据脏更新（增量刷新）
function LingGuardPanelCall:OnSlotDataDirty(new_data)
    local old = self.slot_data or {}
    self.slot_data = new_data

    -- 根据占用状态挂/卸守卫实例监听
    if new_data.status == GUARD_SLOT_STATUS.OCCUPIED and new_data.inst and new_data.inst:IsValid() then
        self:_AttachInstListeners()
    else
        self:_DetachInstListeners()
    end

    -- 贴图：类型或实例变化需要刷新；基础类型下形态变化由 inst 的 formdirty 处理
    if (old.type ~= new_data.type) or (old.inst ~= new_data.inst) then
        if self.button then
            local new_texture = self:GetButtonTexture()
            self.button:SetTextures("images/ui_ling_guard_panel_call.xml", new_texture)
        end
    end

    -- 状态或名称变化：刷新交互与 hover
    if (old.status ~= new_data.status) or (old.inst ~= new_data.inst) or (old.level ~= new_data.level) then
        self:UpdateButtonState()
    end
end


-- 创建按钮
function LingGuardPanelCall:CreateButton()
    local bg = self:GetButtonTexture()

    self.button = self:AddChild(ImageButton("images/ui_ling_guard_panel_call.xml", bg))
    self.button.focus_scale = {1.1, 1.1, 1.1}
    self.button:SetPosition(0, 0, 0)
end

-- 获取按钮贴图
function LingGuardPanelCall:GetButtonTexture()
    if self.slot_data.type == SLOT_TYPE.ELITE then
        return "xianjing.tex"
    elseif self.slot_data.type == SLOT_TYPE.BASIC then
        local inst = self.slot_data.inst
        local is_x = (inst and inst:IsValid() and inst.replica and inst.replica.ling_guard and inst.replica.ling_guard.IsXiaoyao and inst.replica.ling_guard:IsXiaoyao()) or false
        return is_x and "xiaoyao.tex" or "qingping.tex"
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
    if self.slot_data.inst and self.slot_data.inst:IsValid() and self.slot_data.inst.replica.named then
        return self.slot_data.inst.replica.named._name:value()
    else
        return self:GetTypeName()
    end
end

-- 获取类型名称
function LingGuardPanelCall:GetTypeName()
    if self.slot_data.type == SLOT_TYPE.ELITE then
        return STRINGS.UI.LING_SUMMON.XIANJING
    elseif self.slot_data.type == SLOT_TYPE.BASIC then
        local inst = self.slot_data.inst
        local is_x = (inst and inst:IsValid() and inst.replica and inst.replica.ling_guard and inst.replica.ling_guard.IsXiaoyao and inst.replica.ling_guard:IsXiaoyao()) or false
        return is_x and STRINGS.UI.LING_SUMMON.XIAOYAO or STRINGS.UI.LING_SUMMON.QINGPING
    else
        return STRINGS.UI.LING_GUARD_PANEL_CALL.SUMMARY
    end
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
                SendModRPCToServer(GetModRPC("ling_summon", "summon_guard"), self.slot_data.index)
            elseif self.slot_data.status == GUARD_SLOT_STATUS.OCCUPIED then
                SendModRPCToServer(GetModRPC("ling_summon", "request_open_guard_panel"), self.slot_data.inst)
            end
        end
        return true
    end
end


-- 监听/反监听 槽位里的守卫实例（用于形态变化实时更新贴图）
function LingGuardPanelCall:_AttachInstListeners()
    local inst = self.slot_data and self.slot_data.inst
    if not (inst and inst:IsValid()) then
        return
    end
    if self._listened_inst == inst then
        return
    end
    self:_DetachInstListeners()
    self._listened_inst = inst
    if not self._on_formdirty_proxy then
        self._on_formdirty_proxy = function() self:OnInstFormDirty() end
    end
    if not self._on_inst_onremove_proxy then
        self._on_inst_onremove_proxy = function() self:_DetachInstListeners() end
    end
    inst:ListenForEvent("ling_guard_formdirty", self._on_formdirty_proxy, inst)
    inst:ListenForEvent("onremove", self._on_inst_onremove_proxy, inst)
end

function LingGuardPanelCall:_DetachInstListeners()
    local inst = self._listened_inst
    if inst and inst:IsValid() then
        if self._on_formdirty_proxy then
            inst:RemoveEventCallback("ling_guard_formdirty", self._on_formdirty_proxy, inst)
        end
        if self._on_inst_onremove_proxy then
            inst:RemoveEventCallback("onremove", self._on_inst_onremove_proxy, inst)
        end
    end
    self._listened_inst = nil
end

function LingGuardPanelCall:OnInstFormDirty()
    -- 仅需刷新按钮贴图；hover 文案由 UpdateButtonState 统一管理
    if self.button then
        local new_texture = self:GetButtonTexture()
        self.button:SetTextures("images/ui_ling_guard_panel_call.xml", new_texture)
    end
end

function LingGuardPanelCall:OnRemove()
    self:_DetachInstListeners()
end

return LingGuardPanelCall













