require "behaviours/wander"
require "behaviours/follow"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/leash"

local CONSTANTS = require("ark_constants_ling")
local GetModeConfig = require("ark_common_ling").GetModeConfig


-- 调试输出（风筝相关）
local function KDbg(inst, ...)
    -- 日志已关闭，保留空壳方便需要时快速启用
    -- print("[LingAI]", inst.prefab or "", inst.GUID, ...)
end

-- 寻找最近的玩家（优先主人）
local function FindNearestPlayer(inst)
    if inst.components.follower and inst.components.follower.leader then
        return inst.components.follower.leader
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, 20, true)
    local nearest_player, min_dist
    min_dist = math.huge
    for _, player in ipairs(players) do
        if player:IsValid() and not player:HasTag("playerghost") then
            local d = inst:GetDistanceSqToInst(player)
            if d < min_dist then
                min_dist = d
                nearest_player = player
            end
        end
    end
    return nearest_player
end

local function GetFollowPos(inst)
    local leader = FindNearestPlayer(inst)
    if leader then
        return leader:GetPosition()
    elseif inst.components.knownlocations then
        return inst.components.knownlocations:GetLocation("home") or inst:GetPosition()
    end
    return inst:GetPosition()
end

-- 守点
local function GetGuardPos(inst)
    if inst.components.ling_guard and inst.components.ling_guard.guard_pos then
        return inst.components.ling_guard.guard_pos
    end
    local leader = FindNearestPlayer(inst)
    return leader and leader:GetPosition() or inst:GetPosition()
end

-- 敌对检测（用于风筝/安全）
local function FindNearbyHostileEnemies(inst, radius)
    local x, y, z = inst.Transform:GetWorldPosition()
    local enemies = TheSim:FindEntities(x, y, z, radius, {"_combat"}, {"player", "companion", "wall", "INLIMBO", "ling_summon"})
    local hostile = {}
    for _, e in ipairs(enemies) do
        if e:IsValid() and e.components and e.components.combat then
            local is_hostile = false
            if e.components.combat.target == inst then
                is_hostile = true
            end
            local leader = inst.components.follower and inst.components.follower.leader or nil
            if not is_hostile and leader and e.components.combat.target == leader then
                is_hostile = true
            end
            if not is_hostile then
                local near_guards = TheSim:FindEntities(x, y, z, 15, {"ling_summon"})
                for _, g in ipairs(near_guards) do
                    if g ~= inst and g.components and g.components.combat and e.components.combat.target == g then
                        is_hostile = true
                        break
                    end
                end
            end
            if not is_hostile and inst.components.combat and inst.components.combat.target == e then
                is_hostile = true
            end
            if is_hostile then
                table.insert(hostile, e)
            end
        end
    end
    return hostile
end

-- 风筝
local function ShouldKite(inst)
    local _, common = GetModeConfig(inst)
    local in_cd = inst.components and inst.components.combat and inst.components.combat:InCooldown()
    if not in_cd then
        if inst._ling_is_kiting then inst._ling_is_kiting = false end
        return false
    end
    -- 仅针对当前战斗目标计算距离，避免误选其它单位
    local target = inst.components and inst.components.combat and inst.components.combat.target or nil
    if target == nil or not target:IsValid() then
        if inst._ling_is_kiting then inst._ling_is_kiting = false end
        return false
    end
    local mind2 = inst:GetDistanceSqToInst(target)
    local run_d = common.KITE.RUN_DISTANCE or 8
    local stop_d = common.KITE.STOP_DISTANCE or (run_d + 2)
    local running = inst._ling_is_kiting == true
    if running then
        if mind2 < stop_d * stop_d then
            -- 调试: kiting
            return true
        else
            -- 调试: exit_kite: pass stop
            inst._ling_is_kiting = false
            return false
        end
    else
        if mind2 < run_d * run_d then
            -- 调试: enter_kite
            inst._ling_is_kiting = true
            return true
        else
            -- 调试: no_enter_kite
            return false
        end
    end

local function ShouldKiteTarget(hunter, inst)
    -- 仅对当前战斗目标进行规避
    return inst.components and inst.components.combat and inst.components.combat:TargetIs(hunter)
        and hunter ~= nil and hunter:IsValid()
        and (hunter.components.health == nil or not hunter.components.health:IsDead())
end

end

local function GetKiteTarget(inst)
    local _, common = GetModeConfig(inst)
    local hostile = FindNearbyHostileEnemies(inst, common.KITE.DETECTION_RANGE)
    local closest, best = nil, math.huge
    for _, e in ipairs(hostile) do
        local d = inst:GetDistanceSqToInst(e)
        if d < best then
            best = d
            closest = e
        end
    end
    -- 调试: kite_target
    return closest
end

-- 战斗态
local function IsInCombatMode(inst)
    return inst.components and inst.components.combat and inst.components.combat.target ~= nil
end

-- 守态：追击范围限制（相对守点）
local function TargetWithinGuardChase(inst)
    local cur = select(1, GetModeConfig(inst))
    local target = inst.components.combat and inst.components.combat.target or nil
    if not (cur and target and target:IsValid()) then
        return false
    end
    local guardpos = GetGuardPos(inst)
    local gx, gy, gz = guardpos:Get()
    local tx, ty, tz = target.Transform:GetWorldPosition()
    local dx, dz = tx - gx, tz - gz
    return dx*dx + dz*dz <= (cur.CHASE_RANGE or 24) * (cur.CHASE_RANGE or 24)
end

-- 工作目标检索（以守点为中心）
local TOWORK_CANT_TAGS = { "fire", "smolder", "event_trigger", "waxedplant", "INLIMBO", "NOCLICK" }
local WORK_TAGS = { "CHOP_workable", "MINE_workable", "DIG_workable", "HAMMER_workable" }
local function PickValidActionFrom(target)
    local w = target.components and target.components.workable or nil
    if not (w and w:CanBeWorked()) then return nil end
    local a = w:GetWorkAction()
    if a == ACTIONS.CHOP or a == ACTIONS.MINE or a == ACTIONS.DIG or a == ACTIONS.HAMMER then
        return a
    end
    return nil
end

local function TryFindWorkBufferedAction(inst)
    local modecfg, common, mode = GetModeConfig(inst)
    if mode ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then return nil end
    if inst.guard_type == CONSTANTS.GUARD_TYPE.XIANJING then return nil end

    -- 安全检测
    local safer = (modecfg.WORK and modecfg.WORK.SAFE_RADIUS) or 8
    local hostile = FindNearbyHostileEnemies(inst, safer)
    if #hostile > 0 or IsInCombatMode(inst) then
        return nil
    end

    local center = GetGuardPos(inst)
    local r = modecfg.GUARD_RANGE or 16
    local ents = TheSim:FindEntities(center.x, center.y, center.z, r, nil, TOWORK_CANT_TAGS, WORK_TAGS)
    for _, tgt in ipairs(ents) do
        if tgt.entity:IsVisible() and (not tgt.components.burnable or (not tgt.components.burnable:IsBurning() and not tgt.components.burnable:IsSmoldering())) then
            local act = PickValidActionFrom(tgt)
            if act ~= nil then
                return BufferedAction(inst, tgt, act)
            end
        end
    end
    return nil
end

-- 拾取可用性：允许“有 inventory”或“有容器且未满”均可
local function HasPickupCapacity(inst)
    -- 仅检查是否具备拾取所需的inventory组件；具体容量在逐物品上判定
    return inst.components ~= nil and inst.components.inventory ~= nil
end

local function _PickupCooldownActive(inst)
    local colldown =  inst._ling_pick_cooldown_end ~= nil and GetTime() < inst._ling_pick_cooldown_end
    return colldown
end


local function CanAcceptPickup(inst, item)
    if item == nil or item.components == nil or item.components.inventoryitem == nil then
        return false
    end
    local inv = inst.components and inst.components.inventory or nil
    if inv ~= nil then
        local slot = inv:GetNextAvailableSlot(item)
        if slot ~= nil then
            return true
        end
    end
    local container = inst.components and inst.components.container or nil
    if container ~= nil and container:CanTakeItemInSlot(item, nil) then
        if container:AcceptsStacks() then
            for k = 1, container:GetNumSlots() do
                local other = container:GetItemInSlot(k)
                if other == nil then
                    return true
                elseif other.prefab == item.prefab and other.skinname == item.skinname and other.components.stackable ~= nil and not other.components.stackable:IsFull() then
                    return true
                end
            end
            return false
        else
            for k = 1, container:GetNumSlots() do
                if container:GetItemInSlot(k) == nil then
                    return true
                end
            end
            return false
        end
    end
    return false
end


local function TryPickupAnyInGuardRange(inst)
    if inst.sg:HasStateTag("busy") or _PickupCooldownActive(inst) then return nil end
    if not HasPickupCapacity(inst) then return nil end
    local center = GetGuardPos(inst)
    local modecfg = GetModeConfig(inst)
    local r = (modecfg and modecfg.GUARD_RANGE) or 16
    local ents = TheSim:FindEntities(center.x, center.y, center.z, r, nil, {"INLIMBO", "NOCLICK"})
    local nearest, best = nil, math.huge
    for _, item in ipairs(ents) do
        local invitem = item.components and item.components.inventoryitem or nil
        if item:IsValid() and invitem
            and (invitem.canbepickedup ~= false) and not invitem:IsHeld()
            and not (item.components.burnable and (item.components.burnable:IsBurning() or item.components.burnable:IsSmoldering()))
            and CanAcceptPickup(inst, item)
        then
            local d = inst:GetDistanceSqToInst(item)
            if d < best then
                best = d
                nearest = item
            end
        end
    end
    if nearest ~= nil then
        inst._ling_pick_cooldown_end = GetTime() + 0.20
        return BufferedAction(inst, nearest, ACTIONS.PICKUP)
    end
    return nil
end

local LingGuardBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LingGuardBrain:OnStart()
    local modecfg, common, mode = GetModeConfig(self.inst)

    local children = {
        -- 风筝
        WhileNode(function()
            local r = ShouldKite(self.inst)
            -- 调试: cond_kite
            return r
        end, "KiteHostileEnemies",
            RunAway(self.inst, { fn = function(guy) return self.inst.components and self.inst.components.combat and self.inst.components.combat:TargetIs(guy) end, tags = {"_combat"}, notags = {"INLIMBO"} }, common.KITE.RUN_DISTANCE, common.KITE.STOP_DISTANCE)),
    }

    -- 调试: tick

    -- 守形态分支
    table.insert(children, WhileNode(function()
        local m = select(3, GetModeConfig(self.inst))
        local cond = m == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD and IsInCombatMode(self.inst) and TargetWithinGuardChase(self.inst)
        -- 调试: cond_guard_chase
        return cond
    end, "GuardChase",
        ChaseAndAttack(self.inst, modecfg.ATTACK.CHASE_TIME, modecfg.ATTACK.CHASE_DIST)))

    -- 先拾取后工作：PickupGuardRange 提前于 GuardWork
    table.insert(children, WhileNode(function()
        local cond = select(3, GetModeConfig(self.inst)) == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD
        -- 调试: cond_pickup_guard
        return cond
    end, "PickupGuardRange",
        DoAction(self.inst, function()
            local act = TryPickupAnyInGuardRange(self.inst)
            return act
        end)))

    table.insert(children, WhileNode(function()
        local cond = select(3, GetModeConfig(self.inst)) == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD
        -- 调试: cond_guard_work
        return cond
    end, "GuardWork",
        DoAction(self.inst, function()
            local act = TryFindWorkBufferedAction(self.inst)
            return act
        end)))

    -- 慎/攻：战斗追击
    table.insert(children, WhileNode(function()
        local cfg, _, m = GetModeConfig(self.inst)
        local cond = m ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD and IsInCombatMode(self.inst)
        -- 调试: cond_chase_other
        return cond
    end, "ChaseOtherModes",
        ChaseAndAttack(self.inst, (select(1, GetModeConfig(self.inst)).ATTACK or {}).CHASE_TIME or 20, (select(1, GetModeConfig(self.inst)).ATTACK or {}).CHASE_DIST or 15)))

    -- 守形态：回守点
    table.insert(children, WhileNode(function()
        local cond = select(3, GetModeConfig(self.inst)) == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD
        -- 调试: cond_leash_guard
        return cond
    end, "LeashToGuard",
        Leash(self.inst, function() return GetGuardPos(self.inst) end, ((select(1, GetModeConfig(self.inst)).GUARD_RANGE) or 16), 0.5)))

    -- 慎/攻：跟随
    table.insert(children, WhileNode(function()
        local cond = select(3, GetModeConfig(self.inst)) ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD
        -- 调试: cond_follow_other
        return cond
    end, "FollowLeader",
        Follow(self.inst, FindNearestPlayer,
            (select(1, GetModeConfig(self.inst)).FOLLOW or {}).MIN or common.FOLLOW.MIN,
            (select(1, GetModeConfig(self.inst)).FOLLOW or {}).TARGET or common.FOLLOW.TARGET,
            (select(1, GetModeConfig(self.inst)).FOLLOW or {}).MAX or common.FOLLOW.MAX)))

    -- 游荡（非守形态围绕跟随点，守形态围绕守点小范围）
    table.insert(children, WhileNode(function()
        local cond = select(3, GetModeConfig(self.inst)) ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD
        KDbg(self.inst, "cond_wander_follow", cond and "true" or "false")
        return cond
    end, "WanderFollowPos",
        Wander(self.inst, GetFollowPos, (select(1, GetModeConfig(self.inst)).FOLLOW or {}).WANDER_DIST or common.FOLLOW.WANDER_DIST)))

    table.insert(children, WhileNode(function()
        local cur, common, m = GetModeConfig(self.inst)
        local in_cd = self.inst.components and self.inst.components.combat and self.inst.components.combat:InCooldown()
        local has_hostile = false
        if in_cd then
            has_hostile = #FindNearbyHostileEnemies(self.inst, common.KITE.DETECTION_RANGE) > 0
        end
        local ok = m == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD and not (in_cd and has_hostile)
        -- 调试: cond_wander_guard
        return ok
    end, "WanderGuardPos",
        Wander(self.inst, GetGuardPos, math.min(((select(1, GetModeConfig(self.inst)).GUARD_RANGE) or 16) * .25, 6))))

    local root = PriorityNode(children, .25)
    self.bt = BT(self.inst, root)
end

return LingGuardBrain
