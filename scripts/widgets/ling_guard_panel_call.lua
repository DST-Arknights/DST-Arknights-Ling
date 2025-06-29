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
end)

return LingGuardPanelCall













