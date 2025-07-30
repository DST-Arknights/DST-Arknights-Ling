local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

-- 令的守卫面板关闭容器按钮组件
local LingCloseContainer = Class(Widget, function(self, owner, guard_panel)
    Widget._ctor(self, "LingCloseContainer")

    self.owner = owner
    self.guard_panel = guard_panel

    -- 创建关闭按钮
    self.close_button = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "container_close.tex"))
    self.close_button:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.CLOSE_CONTAINER)

    -- 设置点击事件
    self.close_button:SetOnClick(function()
        self:RequestClose()
    end)
end)

function LingCloseContainer:Open()
    self:Show()
end

-- 关闭方法，作为点击事件
function LingCloseContainer:RequestClose()
    -- 发送关闭容器的RPC请求
    SendModRPCToServer(GetModRPC("ling_summon", "request_close_container"))
    -- 隐藏关闭按钮
    self:Hide()
end

return LingCloseContainer
