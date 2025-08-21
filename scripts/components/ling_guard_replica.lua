local CONSTANTS = require("ark_constants_ling")
local BitField = require("ark_utils_ling").BitField
local LING_GUARD_CONFIG = require("ling_guard_config")

-- 创建坐标BitField处理器（模块级）
local _pos_bitfield = BitField.create({
    enabled = {bits = 1, default = 0},  -- 是否启用位置标记
    x = {bits = 15, signed = true, default = 0},  -- X坐标 (-16384 到 16383)
    z = {bits = 15, signed = true, default = 0},  -- Z坐标 (-16384 到 16383)
    -- 剩余1位保留
})

local LingGuardReplica = Class(function(self, inst)
    self.inst = inst

    -- 行为模式网络变量
    self._behavior_mode = net_tinybyte(inst.GUID, "ling_guard_._behavior_mode", "behaviormodechanged")

    self._work_mode = net_tinybyte(inst.GUID, "ling_guard_._work_mode", "workmodechanged")

    -- 守卫位置网络变量 - 使用BitField打包坐标
    self._guard_pos_data = net_uint(inst.GUID, "ling_guard_._guard_pos_data", "guardposdirty")

    -- 客户端状态
    self._guard_pos = nil
    self._guard_pos_inst = nil

    if not TheWorld.ismastersim then
        -- 监听行为模式变化
        self.inst:ListenForEvent("behaviormodechanged", function()
            self:OnBehaviorModeChanged()
        end, inst)
        self.inst:ListenForEvent("workmodechanged", function()
            self:OnWorkModeChanged()
        end, inst)
        -- 监听守卫位置变化
        self.inst:ListenForEvent("guardposdirty", function()
            self:OnGuardPosDirty()
        end, inst)
        -- 监听消失时, 如果有范围标志, 一同移除掉
        self.inst:ListenForEvent("onremove", function()
            self:RemoveGuardPositionVisual()
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

-- 设置守卫位置（由服务端调用）
function LingGuardReplica:SetGuardPosition(guard_pos)
    print("[LingGuardReplica] SetGuardPosition", guard_pos and guard_pos.x or "nil", guard_pos and guard_pos.z or "nil")
    if guard_pos then
        -- 使用 BitField 打包坐标数据
        local packed_data = _pos_bitfield.pack({
            enabled = 1,
            x = math.floor(guard_pos.x),
            z = math.floor(guard_pos.z)
        })
        self._guard_pos_data:set(packed_data)
    else
        -- 禁用位置标记
        local packed_data = _pos_bitfield.pack({
            enabled = 0,
            x = 0,
            z = 0
        })
        self._guard_pos_data:set(packed_data)
    end
    print("[LingGuardReplica] SetGuardPosition", self._guard_pos_data:value())
end

-- 获取守卫位置
function LingGuardReplica:GetGuardPosition()
    return self._guard_pos
end

-- 处理守卫位置数据变化
function LingGuardReplica:OnGuardPosDirty()
    -- 解包坐标数据到 _guard_pos
    local packed_data = self._guard_pos_data:value()
    print("[LingGuardReplica] OnGuardPosDirty", packed_data)
    local unpacked = _pos_bitfield.unpack(packed_data)
    print("[LingGuardReplica] OnGuardPosDirty", unpacked.enabled, unpacked.x, unpacked.z)

    if unpacked.enabled == 1 then
        -- 设置位置并启用视觉效果
        self._guard_pos = Vector3(unpacked.x, 0, unpacked.z)
        self:UpdateGuardPositionVisual()
    else
        -- 清除位置并禁用视觉效果
        self._guard_pos = nil
        self:RemoveGuardPositionVisual()
    end
end

-- 更新守卫位置视觉效果
function LingGuardReplica:UpdateGuardPositionVisual()
    if self._guard_pos then
        if not self._guard_pos_inst then
            self._guard_pos_inst = SpawnPrefab("reticuleaoecatapultwakeup")
            local cfg = LING_GUARD_CONFIG
            local guardcfg = (cfg.MODE and cfg.MODE.GUARD) or (cfg.GUARD) or {}
            local range = guardcfg.GUARD_RANGE or 16
            local scale = range / 16  -- 缩放比例，使范围大小与守卫范围一致（16为动画对应范围）
            self._guard_pos_inst.Transform:SetScale(scale, scale, scale)  -- 设置缩放比例

            -- 检查面板是否正在显示这个守卫，如果是则设置为红色
            if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_guard_panel then
                local panel = ThePlayer.HUD.controls.ling_guard_panel
                if panel:IsVisible() and panel.guard_inst == self.inst then
                    self:SetGuardPositionColor(true)
                end
            end
        end
        if self._guard_pos_inst and self._guard_pos_inst:IsValid() then
            self._guard_pos_inst.Transform:SetPosition(self._guard_pos:Get())
        end
    else
        self:RemoveGuardPositionVisual()
    end
end

-- 移除守卫位置视觉效果
function LingGuardReplica:RemoveGuardPositionVisual()
    if self._guard_pos_inst and self._guard_pos_inst:IsValid() then
        self._guard_pos_inst:Remove()
        self._guard_pos_inst = nil
    end
end

-- 设置守卫位置标记颜色（绿色用于面板打开时）
function LingGuardReplica:SetGuardPositionColor(is_green)
    if self._guard_pos_inst and self._guard_pos_inst:IsValid() then
        if is_green then
            -- 设置为绿色（面板打开时）
            self._guard_pos_inst.AnimState:SetMultColour(1, 0, 0, 1)
        else
            -- 恢复原色（白色）
            self._guard_pos_inst.AnimState:SetMultColour(1, 1, 1, 1)
        end
    end
end

-- 组件移除时清理
function LingGuardReplica:OnRemoveFromEntity()
    self:RemoveGuardPositionVisual()
end

return LingGuardReplica
