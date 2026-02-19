local CONSTANTS = require "ark_constants_ling"
local LingCloudPavilionMist = require "widgets/ling_cloud_pavilion_mist"
-- 进入动作
-- AddAction('ENTER_CLOUD_PAVILION', STRINGS.ACTIONS.ENTER_CLOUD_PAVILION, function(act)
--     if act.target.components.ling_cloud_pavilion_enter then
--         act.target.components.ling_cloud_pavilion_enter:EnterCloudPavilion(act.doer)
--         return true
--     end
-- end)

-- AddComponentAction("SCENE", "ling_cloud_pavilion_enter", function(inst, doer, actions, right)
--     if right then
--         table.insert(actions, ACTIONS.ENTER_CLOUD_PAVILION)
--     end
-- end)

-- AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ENTER_CLOUD_PAVILION, "doshortaction"))
-- AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ENTER_CLOUD_PAVILION, "doshortaction"))

-- 帐篷作为云山亭的入口

AddPrefabPostInit("tent", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("ling_cloud_pavilion_enter")
end)


-- 离开动作
AddAction('EXIT_CLOUD_PAVILION', STRINGS.ACTIONS.EXIT_CLOUD_PAVILION, function(act)
    if act.target.components.ling_cloud_pavilion_exit then
        act.target.components.ling_cloud_pavilion_exit:ExitCloudPavilion(act.doer)
        return true
    end
end)
ACTIONS.EXIT_CLOUD_PAVILION.distance = 2
-- ACTIONS.EXIT_CLOUD_PAVILION.instant = true

AddComponentAction("SCENE", "ling_cloud_pavilion_exit", function(inst, doer, actions)
    table.insert(actions, ACTIONS.EXIT_CLOUD_PAVILION)
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.EXIT_CLOUD_PAVILION, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.EXIT_CLOUD_PAVILION, "doshortaction"))

-- 在云山亭里禁止睡觉
AddStategraphPostInit("wilson", function(sg)
    -- 禁止睡觉的state列表
    local no_sleep_states = { "bedroll", "tent" }
    for _, state_name in ipairs(no_sleep_states) do
        local state = sg.states[state_name]
        if state and state.onenter then
            local old_onenter = state.onenter
            state.onenter = function(inst, ...)
                inst.components.locomotor:Stop()
                -- 如果检测到周围有 ling_cloud_pavilion_interior_floor, 禁止睡觉, 返回原因
                if inst.ling_inHouse then
                    inst:PushEvent("performaction", { action = inst.bufferedaction })
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle")
                    if inst.components.talker ~= nil then
                        inst.components.talker:Say(GetString(inst, 'LING_CLOUD_PAVILION_PRIVATE_SLEEP'))
                    end
                    return
                end
                old_onenter(inst, ...)
            end
        end
    end
end)

-- ============================================================================
-- 私有工具函数 (从 ptribe_utils/utils.lua 简化版本)
-- ============================================================================

local function _FnDecorator(obj, key, beforeFn, afterFn, isUseBeforeReturn)
    assert(type(obj) == "table")
    assert(beforeFn == nil or type(beforeFn) == "function", "beforeFn must be nil or a function")
    assert(afterFn == nil or type(afterFn) == "function", "afterFn must be nil or a function")

    local oldVal = obj[key]

    obj[key] = function(...)
        local retTab, isSkipOld, newParam, r
        if beforeFn then
            retTab, isSkipOld, newParam = beforeFn(...)
        end

        if type(oldVal) == "function" and not isSkipOld then
            if newParam ~= nil then
                r = { oldVal(unpack(newParam)) }
            else
                r = { oldVal(...) }
            end
            if not isUseBeforeReturn then
                retTab = r
            end
        end

        if afterFn then
            retTab = afterFn(retTab, ...)
        end

        if retTab == nil then
            return nil
        end
        return unpack(retTab)
    end
end

local function _ChainFindUpvalue(fn, ...)
    local function _FindUpvalue(fn, upvalueName)
        local i = 1
        while true do
            local name, value = debug.getupvalue(fn, i)
            if not name then break end
            if name == upvalueName then
                return value, i
            end
            i = i + 1
        end
    end

    local val = fn
    local i
    for _, name in ipairs({ ... }) do
        val, i = _FindUpvalue(val, name)
        if i == nil then
            return nil
        end
    end
    return val
end

-- ============================================================================
-- 哈姆雷特兼容 (带前缀避免冲突)
-- ============================================================================

AddPrefabPostInit("forest", function(inst)
    inst:AddComponent("ling_interiorspawner")
end)
AddPrefabPostInit("cave", function(inst)
    inst:AddComponent("ling_interiorspawner")
end)

-- ============================================================================
-- 室内地皮检查 (带前缀避免冲突)
-- ============================================================================

require "components/map"
local _ling_home = {}     --室内的中心坐标，由于地皮一定在中心
local _ling_DIS = 28      --室内的最大半径
local _ling_DIS_SQ = 28 * 28
local _ling_lastHome = {} --缓冲，短时间内在一个房间附近求值的可能性较大

local function _ling_CheckPointBefore(self, x, y, z)
    if z >= 950 then
        -- 缓存
        if _ling_lastHome.home then
            if _ling_lastHome.home:IsValid() then
                if VecUtil_DistSq(_ling_lastHome.pos[1], _ling_lastHome.pos[2], x, z) < _ling_DIS_SQ then
                    return { true }, true
                end
            else
                _ling_lastHome.home = nil
                _ling_lastHome.pos = nil
            end
        end

        -- 缓冲表
        for ent, pos in pairs(_ling_home) do
            if ent:IsValid() then
                if VecUtil_DistSq(pos[1], pos[2], x, z) < _ling_DIS_SQ then
                    _ling_lastHome.home = ent
                    _ling_lastHome.pos = pos
                    return { true }, true
                end
            else
                _ling_home[ent] = nil
            end
        end

        -- 查找
        local ents = TheSim:FindEntities(x, 0, z, _ling_DIS, { "ling_cloud_pavilion_floor" })
        if #ents > 0 then
            for _, ent in ipairs(ents) do
                local ex, _, ez = ent.Transform:GetWorldPosition()
                _ling_home[ent] = { ex, ez }
                _ling_lastHome.home = ent
                _ling_lastHome.pos = { ex, ez }
            end
            return { true }, true
        end
    end
end

local function _ling_GetTileCenterPointBefore(self, x, y, z)
    if z and z >= 950 then
        return { math.floor(x / 4) * 4 + 2, 0, math.floor(z / 4) * 4 + 2 }, true
    end
end

-- 根据 components/deployable.lua 判断需要覆盖的方法
_FnDecorator(Map, "IsAboveGroundAtPoint", _ling_CheckPointBefore)
_FnDecorator(Map, "IsPassableAtPoint", _ling_CheckPointBefore)
_FnDecorator(Map, "IsVisualGroundAtPoint", _ling_CheckPointBefore)
_FnDecorator(Map, "CanPlantAtPoint", _ling_CheckPointBefore)
_FnDecorator(Map, "GetTileCenterPoint", _ling_GetTileCenterPointBefore)

AddComponentPostInit("birdspawner", function(self)
    -- 室内不会生成鸟
    _FnDecorator(self, "GetSpawnPoint", function(self, pt)
        return nil, pt.z >= 950
    end)
end)

-- ============================================================================
-- 防雨 (带前缀避免冲突)
-- ============================================================================

local _ling_StopAmbientRainSound, _ling_StopTreeRainSound, _ling_StopUmbrellaRainSound, _ling_StopBarrierSound
local _ling_rainfx, _ling_snowfx, _ling_lunarhailfx

local function _ling_WeatherClientOnUpdateBefore()
    if not ThePlayer or TheWorld.ismastersim then return end

    local _, _, z = ThePlayer.Transform:GetWorldPosition()
    if z > 950 then
        if _ling_StopAmbientRainSound then
            _ling_StopAmbientRainSound()
        end
        if _ling_StopTreeRainSound then
            _ling_StopTreeRainSound()
        end
        if _ling_StopUmbrellaRainSound then
            _ling_StopUmbrellaRainSound()
        end
        if _ling_StopBarrierSound then
            _ling_StopBarrierSound()
        end

        if _ling_rainfx then
            _ling_rainfx.particles_per_tick = 0
            _ling_rainfx.splashes_per_tick = 0
        end
        if _ling_lunarhailfx then
            _ling_lunarhailfx.particles_per_tick = 0
            _ling_lunarhailfx.splashes_per_tick = 0
        end
        if _ling_snowfx then
            _ling_snowfx.particles_per_tick = 0
        end

        return nil, true
    end
end

AddClassPostConstruct("components/weather", function(self)
    if TheWorld.ismastersim then
        -- 主机端暂不处理
    else
        _ling_StopAmbientRainSound = _ChainFindUpvalue(self.OnUpdate, "StopAmbientRainSound")
        _ling_StopTreeRainSound = _ChainFindUpvalue(self.OnUpdate, "StopTreeRainSound")
        _ling_StopUmbrellaRainSound = _ChainFindUpvalue(self.OnUpdate, "StopUmbrellaRainSound")
        _ling_StopBarrierSound = _ChainFindUpvalue(self.OnUpdate, "StopBarrierSound")

        _ling_rainfx = _ChainFindUpvalue(self.OnPostInit, "_rainfx")
        _ling_snowfx = _ChainFindUpvalue(self.OnPostInit, "_snowfx")
        _ling_lunarhailfx = _ChainFindUpvalue(self.OnPostInit, "_lunarhailfx")

        _FnDecorator(self, "OnUpdate", _ling_WeatherClientOnUpdateBefore)
        self.LongUpdate = self.OnUpdate
    end
end)

-- ============================================================================
-- 温度和湿度调节 (带前缀避免冲突)
-- ============================================================================

local function _ling_OnTemperatureUpdateBefore(self)
    if self.inst.ling_inHouse then
        local cur = self:GetCurrent()
        if cur > 30 then
            self:SetTemperature(self.current - 0.1)
        elseif cur < 20 then
            self:SetTemperature(self.current + 0.1)
        end
        return nil, true
    end
end

local function _ling_OnMoistureUpdateBefore(self)
    if self.inst.ling_inHouse then
        if self.moisture > 0 then
            self:DoDelta(-0.1)
        end
        return nil, true
    end
end

-- ============================================================================
-- 摄像机调节 (带前缀避免冲突)
-- ============================================================================

local function _ling_OnDirtyCameraAnchor(inst)
    local anchor = inst.ling_netvarCameraAnchor:value()
    if anchor ~= nil then
        -- 室内模式：立即锁定到地板实体，不随玩家移动
        TheCamera:SetTarget(anchor)
        TheCamera:SetControllable(false)

        -- 设置相机参数
        TheCamera:SetHeadingTarget(0)
        TheCamera:SetDistance(21.5)
        TheCamera.targetoffset = Vector3(2, 1.5, 0)
        -- 立即快照相机到目标位置（不是渐进式移动）
        TheCamera:Snap()
        ThePlayer.HUD.ling_cloud_pavilion_mist:CloudIdle()
    else
        -- 室外模式：恢复默认
        TheCamera:SetControllable(true)
        TheCamera:SetDefault()
        TheCamera:SetTarget(TheFocalPoint)
        TheCamera:Snap()
        ThePlayer.HUD.ling_cloud_pavilion_mist:CloudOut()
    end
end

local function _ling_OnDirtyCloudPavilionMist(inst)
    if inst.ling_netvarCloudPavilionMist:value() then
        ThePlayer.HUD.ling_cloud_pavilion_mist:CloudIn()
    else
        ThePlayer.HUD.ling_cloud_pavilion_mist:CloudOut()
    end
end

-- ============================================================================
-- 脚步声 (带前缀避免冲突)
-- ============================================================================

local function _ling_GetCurrentTileTypeBefore(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if z > 950 then
        return { WORLD_TILES.WOODFLOOR, GetTileInfo(WORLD_TILES.WOODFLOOR) }, true
    end
end

-- ============================================================================
-- 玩家初始化 (带前缀避免冲突)
-- ============================================================================

AddPlayerPostInit(function(inst)
    inst.ling_netvarCameraAnchor = net_entity(inst.GUID, "ling_netvarCameraAnchor", "DirtyCameraAnchor")
    inst.ling_netvarCloudPavilionMist = net_bool(inst.GUID, "ling_netvarCloudPavilionMist", "DirtyCloudPavilionMist")
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("DirtyCameraAnchor", _ling_OnDirtyCameraAnchor)
        inst:ListenForEvent("DirtyCloudPavilionMist", _ling_OnDirtyCloudPavilionMist)
    end

    if not TheWorld.ismastersim then return end

    -- 添加带前缀的 ptribe_entnearby 组件
    if not inst.components.ling_ptribe_entnearby then
        inst:AddComponent("ling_ptribe_entnearby")
    end

    -- 注意：这里需要根据实际的 GetMaxDisSq 和 MarkTestFn 来调整
    -- 如果这些函数在其他地方定义，需要确保它们存在
    if inst.components.ling_ptribe_entnearby.AddMark then
        inst.components.ling_ptribe_entnearby:AddMark("ptribe_playerMark", {
            period = 5,
            maxDisSq = GetMaxDisSq,
            radius = TUNING.TRIBE_MAX_DIS,
            testFn = MarkTestFn
        })
    end

    inst.ling_inHouse = false --是否在屋里，控制温度的变化
    _FnDecorator(inst.components.temperature, "OnUpdate", _ling_OnTemperatureUpdateBefore)
    _FnDecorator(inst.components.moisture, "OnUpdate", _ling_OnMoistureUpdateBefore)
    _FnDecorator(inst, "GetCurrentTileType", _ling_GetCurrentTileTypeBefore)
end)

AddComponentPostInit("sleepingbaguser", function(self)
    local _DoSleep = self.DoSleep
    function self:DoSleep(bed)
        if not TheWorld.ismastershard then
            return _DoSleep(self, bed)
        end
        if not TheWorld.ismastersim then
            return _DoSleep(self, bed)
        end
        if not self.inst.components.ling_cloud_pavilion_transfer then
            return _DoSleep(self, bed)
        end
        local res = { _DoSleep(self, bed) }
        -- 4-6秒后随机迁移
        local timeout = math.random(4, 6)
        -- 迁移前最最多2秒的时候, 播放云
        local task = self.inst:DoTaskInTime(math.max(timeout - 3, 0), function()
            if self.inst.ling_netvarCloudPavilionMist ~= nil then
                self.inst.ling_netvarCloudPavilionMist:set(true)
            end
        end)
        self.inst:DoTaskInTime(timeout, function()
            if not self.inst.sleepingbag then
                task:Cancel()
                if self.inst.ling_netvarCloudPavilionMist ~= nil then
                    self.inst.ling_netvarCloudPavilionMist:set(false)
                end
                return
            end
            -- 检查附近有没有 ling_cloud_pavilion_exit_door, 有就跳出, 没有就进入
            local x, y, z = self.inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 10, { "ling_cloud_pavilion_exit_door" })
            if #ents > 0 then
                self.inst.components.ling_cloud_pavilion_transfer:ExitCloudPavilion()
            else
                self.inst.components.ling_cloud_pavilion_transfer:EnterCloudPavilion()
                self.inst:DoTaskInTime(CONSTANTS.LING_TRANSFER_FADE_TIME, function()
                    self.inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
                    self.inst:Show()
                end)
            end
        end)
        return unpack(res)
    end
end)

AddClassPostConstruct("screens/playerhud", function(self)
    self.ling_cloud_pavilion_mist = self.root:AddChild(LingCloudPavilionMist())
end)