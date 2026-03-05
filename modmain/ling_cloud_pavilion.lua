local CONSTANTS = require "ark_constants_ling"
local LingCloudPavilionMist = require "widgets/ling_cloud_pavilion_mist"

-- ============================================================================
-- 常量
-- ============================================================================

local INTERIOR_Z = CONSTANTS.INTERIOR_Z_THRESHOLD

local function IsInteriorZ(z)
    return z ~= nil and z >= INTERIOR_Z
end

-- ============================================================================
-- 进出动作
-- ============================================================================

-- 帐篷作为云山亭的入口
-- AddPrefabPostInit("tent", function(inst)
--     if not TheWorld.ismastersim then
--         return
--     end
--     inst:AddComponent("ling_cloud_pavilion_enter")
-- end)

-- 离开动作
AddAction('EXIT_CLOUD_PAVILION', STRINGS.ACTIONS.EXIT_CLOUD_PAVILION, function(act)
    if act.target.components.ling_cloud_pavilion_exit then
        act.target.components.ling_cloud_pavilion_exit:ExitCloudPavilion(act.doer)
        return true
    end
end)
ACTIONS.EXIT_CLOUD_PAVILION.distance = 2

AddComponentAction("SCENE", "ling_cloud_pavilion_exit", function(inst, doer, actions)
    table.insert(actions, ACTIONS.EXIT_CLOUD_PAVILION)
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.EXIT_CLOUD_PAVILION, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.EXIT_CLOUD_PAVILION, "doshortaction"))

-- 在云山亭里禁止睡觉
AddStategraphPostInit("wilson", function(sg)
    local no_sleep_states = { "bedroll", "tent" }
    for _, state_name in ipairs(no_sleep_states) do
        local state = sg.states[state_name]
        if state and state.onenter then
            local old_onenter = state.onenter
            state.onenter = function(inst, ...)
                inst.components.locomotor:Stop()
                if IsEntityInCloudPavilion(inst) then
                    inst:PushEvent("performaction", { action = inst.bufferedaction })
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle")
                    SayAndVoice(inst, 'LING_CLOUD_PAVILION_PRIVATE_SLEEP')
                    return
                end
                old_onenter(inst, ...)
            end
        end
    end
end)

-- ============================================================================
-- 哈姆雷特兼容 - 注册室内组件
-- ============================================================================

AddPrefabPostInit("forest", function(inst)
    inst:AddComponent("ling_interiorspawner")
end)
AddPrefabPostInit("cave", function(inst)
    inst:AddComponent("ling_interiorspawner")
end)

-- ============================================================================
-- 室内地皮检查（直接函数包装，替代 _FnDecorator）
-- ============================================================================

require "components/map"
local _ling_home = {}
local _ling_DIS = 28
local _ling_DIS_SQ = 28 * 28
local _ling_lastHome = {}

--- 检查坐标是否在室内地板范围内（带缓存）
local function CheckInteriorGround(x, y, z)
    if not IsInteriorZ(z) then
        return false
    end

    -- 缓存命中
    if _ling_lastHome.home then
        if _ling_lastHome.home:IsValid() then
            if VecUtil_DistSq(_ling_lastHome.pos[1], _ling_lastHome.pos[2], x, z) < _ling_DIS_SQ then
                return true
            end
        else
            _ling_lastHome.home = nil
            _ling_lastHome.pos = nil
        end
    end

    -- 缓冲表查找
    for ent, pos in pairs(_ling_home) do
        if ent:IsValid() then
            if VecUtil_DistSq(pos[1], pos[2], x, z) < _ling_DIS_SQ then
                _ling_lastHome.home = ent
                _ling_lastHome.pos = pos
                return true
            end
        else
            _ling_home[ent] = nil
        end
    end

    -- 实体搜索
    local ents = TheSim:FindEntities(x, 0, z, _ling_DIS, { "ling_cloud_pavilion_floor" })
    if #ents > 0 then
        for _, ent in ipairs(ents) do
            local ex, _, ez = ent.Transform:GetWorldPosition()
            _ling_home[ent] = { ex, ez }
            _ling_lastHome.home = ent
            _ling_lastHome.pos = { ex, ez }
        end
        return true
    end

    return false
end

-- 直接包装 Map 方法（替代 _FnDecorator 间接层）
local _orig_IsAboveGroundAtPoint = Map.IsAboveGroundAtPoint
Map.IsAboveGroundAtPoint = function(self, x, y, z, ...)
    if CheckInteriorGround(x, y, z) then return true end
    return _orig_IsAboveGroundAtPoint(self, x, y, z, ...)
end

local _orig_IsPassableAtPoint = Map.IsPassableAtPoint
Map.IsPassableAtPoint = function(self, x, y, z, ...)
    if CheckInteriorGround(x, y, z) then return true end
    return _orig_IsPassableAtPoint(self, x, y, z, ...)
end

local _orig_IsVisualGroundAtPoint = Map.IsVisualGroundAtPoint
Map.IsVisualGroundAtPoint = function(self, x, y, z, ...)
    if CheckInteriorGround(x, y, z) then return true end
    return _orig_IsVisualGroundAtPoint(self, x, y, z, ...)
end

local _orig_CanPlantAtPoint = Map.CanPlantAtPoint
Map.CanPlantAtPoint = function(self, x, y, z, ...)
    if CheckInteriorGround(x, y, z) then return true end
    return _orig_CanPlantAtPoint(self, x, y, z, ...)
end

local _orig_GetTileCenterPoint = Map.GetTileCenterPoint
Map.GetTileCenterPoint = function(self, x, y, z, ...)
    if z and IsInteriorZ(z) then
        return math.floor(x / 4) * 4 + 2, 0, math.floor(z / 4) * 4 + 2
    end
    return _orig_GetTileCenterPoint(self, x, y, z, ...)
end

-- 室内不生成鸟
AddComponentPostInit("birdspawner", function(self)
    local _orig_GetSpawnPoint = self.GetSpawnPoint
    self.GetSpawnPoint = function(self, pt, ...)
        if pt and IsInteriorZ(pt.z) then
            return nil
        end
        return _orig_GetSpawnPoint(self, pt, ...)
    end
end)

-- ============================================================================
-- 天气抑制（无 debug.getupvalue，纯状态转换）
-- ============================================================================

local _ling_wasIndoors = false

AddClassPostConstruct("components/weather", function(self)
    if TheWorld.ismastersim then return end

    local _origOnUpdate = self.OnUpdate
    self.OnUpdate = function(self, dt, ...)
        if ThePlayer then
            local _, _, z = ThePlayer.Transform:GetWorldPosition()
            local isIndoors = IsInteriorZ(z)

            if isIndoors then
                -- 刚进入室内：一次性清理所有天气音效
                if not _ling_wasIndoors and TheWorld.SoundEmitter then
                    TheWorld.SoundEmitter:KillAllSounds()
                end
                _ling_wasIndoors = true
                return -- 跳过整个天气更新（不产生新音效/粒子）
            else
                _ling_wasIndoors = false
            end
        end

        return _origOnUpdate(self, dt, ...)
    end
    self.LongUpdate = self.OnUpdate
end)

-- ============================================================================
-- 摄像机调节
-- ============================================================================

local function OnDirtyCameraAnchor(inst)
    local anchor = inst.ling_netvarCameraAnchor:value()
    if anchor ~= nil then
        TheCamera:SetTarget(anchor)
        TheCamera:SetControllable(false)
        TheCamera:SetHeadingTarget(0)
        TheCamera:SetDistance(21.5)
        TheCamera.targetoffset = Vector3(2, 1.5, 0)
        TheCamera:Snap()
        local _ = inst and inst.HUD and inst.HUD.ling_cloud_pavilion_mist:CloudIdle()
    else
        TheCamera:SetControllable(true)
        TheCamera:SetDefault()
        TheCamera:SetTarget(TheFocalPoint)
        TheCamera:Snap()
        local _ = inst and inst.HUD and inst.HUD.ling_cloud_pavilion_mist:CloudOut()
    end
end

local function OnDirtyCloudPavilionMist(inst)
    if not inst or not inst.HUD or not inst.HUD.ling_cloud_pavilion_mist then
        return
    end
    if inst.ling_netvarCloudPavilionMist:value() then
        inst.HUD.ling_cloud_pavilion_mist:CloudIn()
    else
        inst.HUD.ling_cloud_pavilion_mist:CloudOut()
    end
end

-- ============================================================================
-- 玩家初始化
-- ============================================================================

AddPlayerPostInit(function(inst)
    inst.ling_netvarCameraAnchor = net_entity(inst.GUID, "ling_netvarCameraAnchor", "DirtyCameraAnchor")
    inst.ling_netvarCloudPavilionMist = net_bool(inst.GUID, "ling_netvarCloudPavilionMist", "DirtyCloudPavilionMist")
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("DirtyCameraAnchor", OnDirtyCameraAnchor)
        inst:ListenForEvent("DirtyCloudPavilionMist", OnDirtyCloudPavilionMist)
    end

    if not TheWorld.ismastersim then return end
    -- 温度调节（直接包装，替代 _FnDecorator）
    local _origTempOnUpdate = inst.components.temperature.OnUpdate
    inst.components.temperature.OnUpdate = function(self, dt, ...)
        if IsEntityInCloudPavilion(inst) then
            local cur = self:GetCurrent()
            if cur > 30 then
                self:SetTemperature(self.current - 0.1)
            elseif cur < 20 then
                self:SetTemperature(self.current + 0.1)
            end
            return
        end
        return _origTempOnUpdate(self, dt, ...)
    end

    -- 湿度调节
    local _origMoistOnUpdate = inst.components.moisture.OnUpdate
    inst.components.moisture.OnUpdate = function(self, dt, ...)
        if IsEntityInCloudPavilion(inst) then
            if self.moisture > 0 then
                self:DoDelta(-0.1)
            end
            return
        end
        return _origMoistOnUpdate(self, dt, ...)
    end

    -- 脚步声
    local _origGetCurrentTileType = inst.GetCurrentTileType
    inst.GetCurrentTileType = function(self, ...)
        local x, y, z = self.Transform:GetWorldPosition()
        if IsInteriorZ(z) then
            return WORLD_TILES.WOODFLOOR, GetTileInfo(WORLD_TILES.WOODFLOOR)
        end
        if _origGetCurrentTileType then
            return _origGetCurrentTileType(self, ...)
        end
    end
end)

-- ============================================================================
-- 睡袋传送（进出云山亭）
-- ============================================================================

AddComponentPostInit("sleepingbaguser", function(self)
    self._ling_transfer_task = nil
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
        local timeout = math.random(4, 6)
        self._ling_transfer_task = nil
        if self.inst.ling_netvarCloudPavilionMist ~= nil then
            self._ling_transfer_task = self.inst:DoTaskInTime(math.max(timeout - 3, 0), function()
                if self.inst.ling_netvarCloudPavilionMist ~= nil then
                    self.inst.ling_netvarCloudPavilionMist:set(true)
                end
            end)
        end
        self.inst:DoTaskInTime(timeout, function()
            if not self.inst.sleepingbag then
                if self._ling_transfer_task ~= nil then
                    self._ling_transfer_task:Cancel()
                    self._ling_transfer_task = nil
                    self.inst.ling_netvarCloudPavilionMist:set(false)
                end
                return
            end
            self.inst.components.ling_cloud_pavilion_transfer:EnterCloudPavilion()
            self.inst:DoTaskInTime(CONSTANTS.LING_TRANSFER_FADE_TIME, function()
                self.inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
                self.inst:Show()
            end)
        end)
        return unpack(res)
    end
    local _DoWakeUp = self.DoWakeUp
    function self:DoWakeUp(nostatechange)
        if not TheWorld.ismastershard then
            return _DoWakeUp(self, nostatechange)
        end
        if not TheWorld.ismastersim then
            return _DoWakeUp(self, nostatechange)
        end
        if not self.inst.components.ling_cloud_pavilion_transfer then
            return _DoWakeUp(self, nostatechange)
        end
        if self.inst.ling_netvarCloudPavilionMist ~= nil then
            if self._ling_transfer_task ~= nil then
                self._ling_transfer_task:Cancel()
                self._ling_transfer_task = nil
            end
            if not IsEntityInCloudPavilion(self.inst) then
                self.inst.ling_netvarCloudPavilionMist:set(false)
            end
        end
        return _DoWakeUp(self, nostatechange)
    end
end)

-- ============================================================================
-- HUD 迷雾效果
-- ============================================================================

AddClassPostConstruct("screens/playerhud", function(self)
    self.ling_cloud_pavilion_mist = self.root:AddChild(LingCloudPavilionMist())
end)
