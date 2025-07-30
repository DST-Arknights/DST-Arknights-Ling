local CONSTANTS = require("ark_constants_ling")

local LingGuardReplica = Class(function(self, inst)
    self.inst = inst
    
    -- 行为模式网络变量
    self._behavior_mode = net_tinybyte(inst.GUID, "ling_guard_._behavior_mode", "behaviormodechanged")
    
    self._work_mode = net_tinybyte(inst.GUID, "ling_guard_._work_mode", "workmodechanged")

    if not TheWorld.ismastersim then
        -- 监听行为模式变化
        self.inst:ListenForEvent("behaviormodechanged", function()
            self:OnBehaviorModeChanged()
        end, inst)
        self.inst:ListenForEvent("workmodechanged", function()
            self:OnWorkModeChanged()
        end, inst)
    end
end)

-- 当行为模式变化时调用
function LingGuardReplica:OnBehaviorModeChanged()
    -- 更新守卫面板UI
    local mode = self._behavior_mode:value()
    print("[LingGuardBehaviorReplica] Behavior mode changed to:", mode)

    -- 如果守卫面板正在显示这个守卫，更新UI状态
    if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_guard_panel then
        local panel = ThePlayer.HUD.controls.ling_guard_panel
        if panel.guard_inst == self.inst then
            panel:OnBehaviorModeChanged(mode)
        end
    end
end

-- 设置行为模式（由服务端调用）
function LingGuardReplica:SetBehaviorMode(mode)
    self._behavior_mode:set(mode)
end

-- 获取行为模式
function LingGuardReplica:GetBehaviorMode()
    return self._behavior_mode:value()
end

-- 获取行为模式名称（用于UI显示）
function LingGuardReplica:GetBehaviorModeName()
    local mode = self._behavior_mode:value()
    
    if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS then
        return "慎"
    elseif mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        return "守"
    elseif mode == CONSTANTS.GUARD_BEHAVIOR_MODE.ATTACK then
        return "攻"
    else
        return "未知"
    end
end



function LingGuardReplica:OnWorkModeChanged()
    -- 更新守卫面板UI
    local mode = self._work_mode:value()
    print("[LingGuardBehaviorReplica] Work mode changed to:", mode)

    -- 如果守卫面板正在显示这个守卫，更新UI状态
    if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_guard_panel then
        local panel = ThePlayer.HUD.controls.ling_guard_panel
        if panel.guard_inst == self.inst then
            panel:OnWorkModeChanged(mode)
        end
    end
end

-- 设置工模式（由服务端调用）
function LingGuardReplica:SetWorkMode(mode)
    self._work_mode:set(mode)
end

-- 获取工模式
function LingGuardReplica:GetWorkMode()
    return self._work_mode:value()
end

return LingGuardReplica
