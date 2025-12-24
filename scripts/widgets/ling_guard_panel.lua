local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"
local LingGuardWorkMode = require "widgets/ling_guard_workmode"
local LingGuardHealth = require "widgets/ling_guard_health"

local GUARD_BEHAVIOR_MODE = CONSTANTS.GUARD_BEHAVIOR_MODE
local GUARD_WORK_MODE = CONSTANTS.GUARD_WORK_MODE

local BUTTON_FOCUS_SCALE = { 1.1, 1.1, 1.1 }
local MODE_BUTTON_ANIM_TIME = 0.15

-- 布局参数
local BASE_ROW_Y = -50
local COMMON_HOVER_DROP = -30
local COMMON_ACTIVE_DROP = -70
local WORK_OPEN_EXTRA_DROP = -50

local BEHAVIOR_BUTTON_DATA = {
    [GUARD_BEHAVIOR_MODE.CAUTIOUS] = {
        texture = "command_cautious.tex",
        pos = Vector3(186, BASE_ROW_Y, 0),
        name = "cautious",
        hover_height = COMMON_HOVER_DROP,
        active_height = COMMON_ACTIVE_DROP,
        str = "CAUTIOUS"
    },
    [GUARD_BEHAVIOR_MODE.ATTACK] = {
        texture = "command_attack.tex",
        pos = Vector3(112, BASE_ROW_Y, 0),
        name = "attack",
        hover_height = COMMON_HOVER_DROP,
        active_height = COMMON_ACTIVE_DROP,
        str = "ATTACK"
    },
    [GUARD_BEHAVIOR_MODE.GUARD] = {
        texture = "command_guard.tex",
        pos = Vector3(36, BASE_ROW_Y, 0),
        name = "guard",
        hover_height = COMMON_HOVER_DROP,
        active_height = COMMON_ACTIVE_DROP,
        active_height_work = COMMON_ACTIVE_DROP + WORK_OPEN_EXTRA_DROP,
        hasWorkMode = true,
        str = "GUARD"
    }
}

local WORK_SELECTOR_ANCHOR = Vector3(36, -125, 0)
local WORK_SELECTOR_HIDDEN_Y = WORK_SELECTOR_ANCHOR.y + 40

local LingGuardPanel = Class(Widget, function(self, owner, guard)
    Widget._ctor(self, "LingGuardPanel")
    self.owner = owner
    self.guard = guard
    
    -- 模式按钮初始化
    self:_CreateModeButtons()
    
    self.plant_bg = self:AddChild(Image("images/ui_ling_guard_panel.xml", "plant_bg.tex"))
    self.plant_bg:SetPosition(CONSTANTS.LING_GUARD_PANEL_PLANT_CONTAINER_CLOSED_POSITION)
    -- 工作模式初始化
    self:_InitWorkSelector()
    -- 基础组件初始化
    self:_InitBaseUI()
end)

function LingGuardPanel:_InitBaseUI()
    self.fusionButton = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "fusion_button.tex"))
    self.fusionButton:SetPosition(314, 59, 0)
    self.fusionButton:SetFocusScale(BUTTON_FOCUS_SCALE)
    self.fusionButton:SetOnClick(function()
        if self.guard then self.guard.replica.ling_guard:Fusion() end
    end)

    self.panel = self:AddChild(Image("images/ui_ling_guard_panel.xml", "bg.tex"))
    self.health = self:AddChild(LingGuardHealth(self.owner))
    self.health:SetPosition(262, -138, 0)

    self.close = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "close.tex"))
    self.close:SetPosition(-305, -16, 0)
    self.close:SetOnClick(function()
        if self.guard then self.guard.replica.ling_guard:ClosePanel(ThePlayer) end
    end)

    -- 名字渲染容器
    self.rename_text_root = self:AddChild(Widget("rename_text_root"))
    self.rename_text_root:SetPosition(158, 35, 0)
    self.rename_chars = {}
    self.rename_font = UIFONT
    self.rename_font_size = 70
    self.rename_char_spacing = math.floor(self.rename_font_size * 0.6)

    self.recall = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "recall.tex"))
    self.recall:SetPosition(178, -90, 0)
    self.recall:SetOnClick(function()
        if self.guard then self.guard.replica.ling_guard:Recall() end
    end)

    self.name = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "name_qingping.tex"))
    self.name:SetPosition(222, 48, 0)
    self.name:SetOnClick(function()
        local target = (self.form == CONSTANTS.GUARD_FORM.XIAOYAO) and CONSTANTS.GUARD_FORM.QINGPING or CONSTANTS.GUARD_FORM.XIAOYAO
        if self.guard then self.guard.replica.ling_guard:SetForm(target) end
    end)

    self.container_open = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "container_open.tex"))
    self.container_open:SetPosition(CONSTANTS.LING_GUARD_PANEL_OPEN_CONTAINER_POSITION)
    self.container_open:SetOnClick(function()
        if self.guard then 
            self.guard.replica.ling_guard:OpenContainer(ThePlayer)
            self.container_open:Hide()
        end
    end)
end

function LingGuardPanel:_CreateModeButtons()
    self.mode_buttons = {}
    self.current_active_mode = nil

    for mode, data in pairs(BEHAVIOR_BUTTON_DATA) do
        local container = self:AddChild(Widget("mode_container_" .. data.name))
        container:SetPosition(data.pos)

        local button = container:AddChild(ImageButton("images/ui_ling_guard_panel.xml", data.texture))
        button.scale_on_focus = false
        button.mode = mode
        button.data = data
        button.container = container
        
        button:SetOnClick(function()
            if self.guard then self.guard.replica.ling_guard:SetBehaviorMode(mode) end
        end)

        -- 提取 Hover Text 逻辑
        local mode_str = STRINGS.UI.LING_COMMAND[data.str]
        button:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.MODE_PREFIX:format(mode_str), { offset_x = 0, offset_y = -300 })

        button:SetOnGainFocus(function()
            if not button.is_active then
                button.is_hovering = true
                self:_AnimateButtonContainer(button, data.hover_height)
            end
        end)

        button:SetOnLoseFocus(function()
            if not button.is_active then
                button.is_hovering = false
                self:_AnimateButtonContainer(button, 0)
            end
        end)

        self.mode_buttons[mode] = button
    end
end

function LingGuardPanel:_InitWorkSelector()
    self.work_selector = self:AddChild(LingGuardWorkMode(self.owner, self.guard))
    self.work_selector:SetPosition(WORK_SELECTOR_ANCHOR)
    self.work_selector.before_open_callback = function(done)
        self:BeforeWorkSelectorOpen(done)
    end
    self.work_selector.after_close_callback = function()
        self:AfterWorkSelectorClose()
    end
end

-- 通用高度计算
function LingGuardPanel:_GetButtonTargetHeight(button, state)
    local data = button.data
    if state == "active" then
        local is_open = self.work_selector and self.work_selector.is_open
        return (data.hasWorkMode and is_open) and data.active_height_work or data.active_height
    elseif state == "hover" then
        return data.hover_height
    end
    return 0
end

function LingGuardPanel:_AnimateButtonContainer(button, target_height, use_animation, callback)
    if not button then return end
    button.container:CancelMoveTo()
    
    local dest_pos = Vector3(button.data.pos.x, button.data.pos.y + target_height, 0)
    if use_animation == false then
        button.container:SetPosition(dest_pos)
        if callback then callback() end
    else
        local start_pos = button.container:GetPosition()
        button.container:MoveTo(start_pos, dest_pos, MODE_BUTTON_ANIM_TIME, callback)
    end
end

function LingGuardPanel:_UpdateWorkSelectorY(use_animation, callback, open_override)
    if not self.work_selector then return end
    self.work_selector:CancelMoveTo()

    local is_guard = (self.current_active_mode == GUARD_BEHAVIOR_MODE.GUARD)
    local is_open = (open_override ~= nil) and open_override or self.work_selector.is_open
    
    local target_y = is_guard and (WORK_SELECTOR_ANCHOR.y + COMMON_ACTIVE_DROP) or WORK_SELECTOR_HIDDEN_Y
    if is_guard and is_open then target_y = target_y + WORK_OPEN_EXTRA_DROP end

    local dest_pos = Vector3(WORK_SELECTOR_ANCHOR.x, target_y, 0)
    if use_animation == false then
        self.work_selector:SetPosition(dest_pos)
        if callback then callback() end
    else
        self.work_selector:MoveTo(self.work_selector:GetPosition(), dest_pos, MODE_BUTTON_ANIM_TIME, callback)
    end
end

function LingGuardPanel:BeforeWorkSelectorOpen(done)
    local btn = self.mode_buttons[GUARD_BEHAVIOR_MODE.GUARD]
    if btn then
        self:_AnimateButtonContainer(btn, btn.data.active_height_work, true)
    end
    self:_UpdateWorkSelectorY(true, done, true)
end

function LingGuardPanel:AfterWorkSelectorClose()
    local btn = self.mode_buttons[GUARD_BEHAVIOR_MODE.GUARD]
    if btn then
        self:_AnimateButtonContainer(btn, btn.data.active_height, true)
    end
    self:_UpdateWorkSelectorY(true, nil, false)
end

function LingGuardPanel:SetBehaviorMode(mode, use_animation)
    -- 如果从守模式切走且工作台开着，先关工作台
    if self.current_active_mode == GUARD_BEHAVIOR_MODE.GUARD and mode ~= GUARD_BEHAVIOR_MODE.GUARD 
       and self.work_selector and self.work_selector.is_open then
        self.work_selector:Close(true, function()
            self:DoActivateModeButton(mode, use_animation)
        end)
    else
        self:DoActivateModeButton(mode, use_animation)
    end
end

function LingGuardPanel:DoActivateModeButton(mode, use_animation)
    local old_mode = self.current_active_mode
    
    -- 取消旧按钮激活
    if old_mode and self.mode_buttons[old_mode] then
        local old_btn = self.mode_buttons[old_mode]
        old_btn.is_active = false
        local h = old_btn.is_hovering and old_btn.data.hover_height or 0
        self:_AnimateButtonContainer(old_btn, h, use_animation)
    end

    -- 激活新按钮
    self.current_active_mode = mode
    local btn = self.mode_buttons[mode]
    if btn then
        btn.is_active = true
        btn.is_hovering = false
        local h = self:_GetButtonTargetHeight(btn, "active")
        
        self:_AnimateButtonContainer(btn, h, use_animation, function()
            if mode == GUARD_BEHAVIOR_MODE.GUARD then
                -- 弦惊(elite)不显示工作模式
                local is_elite = self.guard and self.guard.prefab == "ling_guard_elite"
                if is_elite then 
                    self.work_selector:Hide() 
                else
                    self.work_selector:Show()
                    self:_UpdateWorkSelectorY(use_animation)
                end
            end
        end)
    end

    -- 处理工作台隐藏逻辑
    if old_mode == GUARD_BEHAVIOR_MODE.GUARD and mode ~= GUARD_BEHAVIOR_MODE.GUARD then
        self:_UpdateWorkSelectorY(use_animation, function() self.work_selector:Hide() end)
    end
end

function LingGuardPanel:SetForm(form)
    self.form = form
    -- 集中管理显示逻辑
    local is_xianjing = form == CONSTANTS.GUARD_FORM.XIANJING
    local is_xiaoyao = form == CONSTANTS.GUARD_FORM.XIAOYAO

    if self.container_open then 
        if is_xianjing then self.container_open:Hide() else self.container_open:Show() end
    end
    
    if self.work_selector and is_xianjing then self.work_selector:Hide() end

    self:RefreshName()
    self:RefreshFusionButton()
end

function LingGuardPanel:RefreshName()
    local form = self.form
    if form == CONSTANTS.GUARD_FORM.XIANJING then
        self.name:SetTextures("images/ui_ling_guard_panel.xml", "name_xianjing.tex")
        self.name:ClearHoverText()
    else
        local is_x = form == CONSTANTS.GUARD_FORM.XIAOYAO
        local tex = is_x and "name_xiaoyao.tex" or "name_qingping.tex"
        self.name:SetTextures("images/ui_ling_guard_panel.xml", tex)
        
        local hover = is_x and STRINGS.UI.LING_GUARD_PANEL.SWITCH_TO_QINGPING or STRINGS.UI.LING_GUARD_PANEL.SWITCH_TO_XIAOYAO
        if self.level < 2 then hover = hover .. STRINGS.UI.LING_GUARD_PANEL.LOCKED_SUFFIX end
        self.name:SetHoverText(hover, { offset_x = 0, offset_y = 80 })
    end
end

function LingGuardPanel:RefreshFusionButton()
    if self.form == CONSTANTS.GUARD_FORM.XIANJING then
        self.fusionButton:Hide()
    else
        self.fusionButton:Show()
        if self.level >= 2 then -- 假设等级2解锁
            self.fusionButton:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.FUSION_BUTTON)
            self.fusionButton.image:SetTint(1, 1, 1, 1)
            self.fusionButton:SetClickable(true)
        else
            local prefix = STRINGS.UI.LING_GUARD_PANEL_CALL.SUMMARY
            local name = STRINGS.UI.LING_SUMMON.XIANJING
            local suffix = STRINGS.UI.LING_GUARD_PANEL.LOCKED_SUFFIX
            self.fusionButton:SetHoverText(string.format("%s:%s%s", prefix, name, suffix))
            self.fusionButton.image:SetTint(0.5, 0.5, 0.5, 0.7)
            self.fusionButton:SetClickable(false)
        end
    end
end

function LingGuardPanel:_ClearRenameChars()
    if self.rename_chars then
        for _, w in ipairs(self.rename_chars) do w:Kill() end
    end
    self.rename_chars = {}
end

function LingGuardPanel:SetGuardName(name)
    self:_ClearRenameChars()
    if not name or name == "" then return end

    local chars = {}
    for uchar in string.gmatch(name, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end

    local n = #chars
    if n == 0 then return end
    
    local spacing = self.rename_char_spacing
    local y0 = (n - 1) * spacing * 0.5
    for i, ch in ipairs(chars) do
        local text = self.rename_text_root:AddChild(Text(self.rename_font, self.rename_font_size, ch))
        text:SetPosition(0, y0 - (i - 1) * spacing, 0)
        table.insert(self.rename_chars, text)
    end
end

function LingGuardPanel:SetHealth(health)
    self.health:SetPercent(health, false)
    local hover_fmt = STRINGS.UI.LING_GUARD_PANEL.HEALTH_PERCENT
    local percent_text = string.format(hover_fmt, math.floor(health * 100 + 0.5))
    self.health:SetHoverText(percent_text, { offset_x = 0, offset_y = -80 })
end

return LingGuardPanel