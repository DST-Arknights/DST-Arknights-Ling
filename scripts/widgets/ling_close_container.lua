local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

-- 令的守卫面板关闭容器按钮组件
local LingCloseContainer = Class(Widget, function(self, owner, guard)
    Widget._ctor(self, "LingCloseContainer")

    self.owner = owner
    self.guard = guard

    -- 创建关闭按钮
    self.close_button = self:AddChild(ImageButton("images/ui_ling_guard_panel.xml", "container_close.tex"))
    self.close_button:SetHoverText(STRINGS.UI.LING_GUARD_PANEL.CLOSE_CONTAINER)

    -- 设置点击事件
    self.close_button:SetOnClick(function()
        self.guard.replica.ling_guard:CloseContainer(self.owner)
    end)
end)

return LingCloseContainer
