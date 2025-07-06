local Widget = require "widgets/widget"local Image = require "widgets/image"
local Text = require "widgets/text"local ImageButton = require "widgets/imagebutton"
local LingGuardPanelCall = Class(Widget, function(self, callBind, owner)
    Widget._ctor(self, "LingGuardPanelCall")
    self.owner = owner
    self.callBind = callBind
    local bg;
    if callBind.type == 'qingping' then
        bg = "qingping.tex"
    elseif callBind.type == 'xiaoyao' then
        bg = "xiaoyao.tex"
    elseif callBind.type == 'xianjing' then
        bg = "xianjing.tex"
    else
        bg = "summary.tex"
    end

    -- 创建按钮, 当鼠标移上去显示name
    self.button = self:AddChild(ImageButton("images/ui_ling_guard_panel_call.xml", bg))
    self.button.focus_scale = {1.1, 1.1, 1.1}
    self.button:SetPosition(0, 0, 0)
    self.button:SetHoverText(callBind.name, { font = NEWFONT_OUTLINE, offset_x = 0, offset_y = 15, colour = {1,1,1,1}})

    -- 如果是召唤中状态，添加灰色蒙层
    if callBind.status == 'summoning' then
        self.button.image:SetTint(0.5, 0.5, 0.5, 0.7)
    end
end)

function LingGuardPanelCall:OnMouseButton(button, down, x, y)
    -- 召唤中状态不响应点击
    if self.callBind.status == 'summoning' then
        return true
    end

    if button == MOUSEBUTTON_LEFT then
        if down then
            if self.callBind.status == 'empty' then
                -- 空插槽，召唤清平到指定插槽
                SendModRPCToServer(GetModRPC("ling_summon", "summon_guard"), 'qingping', self.callBind.index)
            elseif self.callBind.status == 'occupied' then
                -- 已有召唤兽，打开管理面板，传递插槽索引
                SendModRPCToServer(GetModRPC("ling_summon", "request_open_guard_panel"), self.callBind.index)
            end
        end
        return true
    end
end

return LingGuardPanelCall













