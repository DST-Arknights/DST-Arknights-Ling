require "behaviours/wander"
require "behaviours/follow"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/leash"

local BrainCommon = require "brains/braincommon"

local CONSTANTS = require("ark_constants_ling")
local getGuardConfig = require("ling_guard_config").getGuardConfig

local Targeting = require("ling_targeting")


-- 调试输出（风筝相关）
local function KDbg(inst, ...)
    -- 日志已关闭，保留空壳方便需要时快速启用
    -- print("[LingAI]", inst.prefab or "", inst.GUID, ...)
end

local function GetLeader(inst)
    return inst.components.follower.leader
end

local function RescueLeaderAction(inst)
    return BufferedAction(inst, GetLeader(inst), ACTIONS.UNPIN)
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



-- 根据模式与附近威胁，返回“理想逃跑安全点”用于影响 RunAway 的朝向
-- 思路：
-- 1) 先确定基础锚点（守点/主人），仅在“越界”时启用作为吸引项；
-- 2) 扫描附近威胁（复用 ling_targeting 的威胁判定），构造“远离向量（排斥合力）”；
-- 3) 将排斥合力与锚点吸引向量做矢量合成，得到期望的逃离方向；
-- 4) 返回 inst 附近朝该方向的一点作为 safe_point，RunAway 内部会用 sp 与“远离猎手”的方向做 0.5 插值，避免直线撞墙。
local function GetKiteSafePoint(inst)
    local mode = inst.components.ling_guard and inst.components.ling_guard:GetBehaviorMode()
    local cfg = getGuardConfig(inst) or {}

    -- 1) 基础锚点判定：仅在越界时吸引回锚点
    local anchor = nil
    if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        local guard_pos = GetGuardPos(inst)
        if guard_pos ~= nil then
            local r = (cfg.GUARD_RANGE or 0)
            if r > 0 then
                local distsq = inst:GetDistanceSqToPoint(guard_pos.x, guard_pos.y, guard_pos.z)
                if distsq > r * r then
                    anchor = guard_pos -- 越界：回守圈
                end
            end
        end
    else
        local leader = GetLeader(inst)
        if leader ~= nil and leader:IsValid() then
            local defend = (cfg.LEADER_DEFENSE_DIST or 0)
            if defend > 0 then
                local distsq = inst:GetDistanceSqToInst(leader)
                if distsq > defend * defend then
                    anchor = leader:GetPosition() -- 越界：回主人
                end
            end
        end
    end

    -- 2) 扫描威胁，构造排斥合力（避免只“远离当前 target”而冲向其他敌人堆）
    local function add_threats_from(center, radius, acc, seen)
        if center == nil or radius == nil or radius <= 0 then return end
        local ents = TheSim:FindEntities(center.x, center.y, center.z, radius, {"_combat"}, {"playerghost","INLIMBO","player","companion","wall","ling_summon"})
        for _, e in ipairs(ents) do
            if e ~= nil and e:IsValid() and not seen[e] and Targeting.IsThreatToGuard(inst, e) then
                seen[e] = true
                table.insert(acc, e)
            end
        end
    end

    local threats, seen = {}, {}
    local pt = inst:GetPosition()
    local detect_r = (cfg.KITE and (cfg.KITE.DETECTION_RANGE or cfg.KITE.RUN_DISTANCE)) or 12
    add_threats_from(pt, detect_r, threats, seen)

    local leader = GetLeader(inst)
    if leader ~= nil and leader:IsValid() then
        local defend = (cfg.LEADER_DEFENSE_DIST or 0)
        if defend > 0 then
            add_threats_from(leader:GetPosition(), defend, threats, seen)
        end
    end
    if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        local guard_pos = GetGuardPos(inst)
        local guard_r = (cfg.GUARD_RANGE or 0)
        if guard_pos ~= nil and guard_r > 0 then
            add_threats_from(guard_pos, guard_r, threats, seen)
        end
    end

    -- 3) 合成方向：排斥合力 + 锚点吸引
    local rx, rz = 0, 0
    if #threats > 0 then
        local x, y, z = pt:Get()
        for _, e in ipairs(threats) do
            local ex, ey, ez = e.Transform:GetWorldPosition()
            local dx, dz = x - ex, z - ez
            local d2 = dx*dx + dz*dz
            if d2 > 0.25 then -- 避免极小距离的爆表
                local d = math.sqrt(d2)
                -- 基础权重：离得越近排斥越强；若其正在攻击自己/主人，权重再提高
                local w = 1 / math.max(d, 1)
                if e.components and e.components.combat then
                    if e.components.combat:TargetIs(inst) or (leader and e.components.combat:TargetIs(leader)) then
                        w = w * 1.6
                    end
                end
                rx = rx + (dx / d) * w
                rz = rz + (dz / d) * w
            end
        end
    end

    local ax, az = 0, 0
    if anchor ~= nil then
        local x, y, z = pt:Get()
        local tx, ty, tz = anchor:Get()
        local dx, dz = tx - x, tz - z
        local d2 = dx*dx + dz*dz
        if d2 > 0.0001 then
            local d = math.sqrt(d2)
            local w_anchor = 0.9 -- 锚点吸引权重（只在越界时存在）
            ax = (dx / d) * w_anchor
            az = (dz / d) * w_anchor
        end
    end

    local vx, vz = rx + ax, rz + az
    local len2 = vx*vx + vz*vz
    if len2 < 0.0001 then
        -- 无法计算合成方向：
        -- 1) 若越界，有锚点则返回锚点；
        -- 2) 否则返回 nil，交由 RunAway 使用默认“反猎手”方向
        return anchor
    end

    local len = math.sqrt(len2)
    local dirx, dirz = vx/len, vz/len
    local lookahead = 8 -- 提前量长度仅用于取角度
    return pt + Vector3(dirx * lookahead, 0, dirz * lookahead)
end



-- 战斗态
local function IsInCombatMode(inst)
    return inst.components and inst.components.combat and inst.components.combat.target ~= nil
end

-- 守态：追击范围限制（相对守点）

-- 工作目标检索（以守点为中心）
local TOWORK_CANT_TAGS = { "fire", "smolder", "event_trigger", "waxedplant", "INLIMBO", "NOCLICK" }


local function _WorkModeToTags(work_mode)
    if work_mode == CONSTANTS.GUARD_WORK_MODE.CHOP then
        return { "CHOP_workable" }
    elseif work_mode == CONSTANTS.GUARD_WORK_MODE.MINE then
        return { "MINE_workable" }
    elseif work_mode == CONSTANTS.GUARD_WORK_MODE.DIG then
        return { "DIG_workable" }
    elseif work_mode == CONSTANTS.GUARD_WORK_MODE.HAMMER then
        return { "HAMMER_workable" }
    end
    -- NONE / DIG_LAND / PLANT 或其它未实现：不做工作
    return nil
end

local function _WorkModeAcceptsAction(work_mode, act)
    if act == nil then return false end
    if work_mode == CONSTANTS.GUARD_WORK_MODE.CHOP then
        return act == ACTIONS.CHOP
    elseif work_mode == CONSTANTS.GUARD_WORK_MODE.MINE then
        return act == ACTIONS.MINE
    elseif work_mode == CONSTANTS.GUARD_WORK_MODE.DIG then
        return act == ACTIONS.DIG
    elseif work_mode == CONSTANTS.GUARD_WORK_MODE.HAMMER then
        return act == ACTIONS.HAMMER
    end
    return false
end

-- 挖掘（DIG）竞争锁：避免多个守卫同时挖同一目标
local function _IsDigReservedByOther(target, inst)
    local until_t = target._ling_dig_reserved_until
    local by = target._ling_dig_reserved_by
    return until_t ~= nil and GetTime() < until_t and by ~= nil and by ~= inst
end

local function _ReserveDigFor(target, inst, dur)
    target._ling_dig_reserved_by = inst
    target._ling_dig_reserved_until = GetTime() + (dur or 1.2)
end

-- 开始工作条件
local function StartWorkingCondition(inst)
    local guardConfig = getGuardConfig(inst)
    local mode = inst.components.ling_guard and inst.components.ling_guard:GetBehaviorMode()
    if mode ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then return false end
    if IsInCombatMode(inst) then return false end
    local work_mode = inst.components.ling_guard:GetWorkMode()
    local tags = _WorkModeToTags(work_mode)
    if tags == nil then return false end

    -- 缓存检查：如果已有工作目标且仍有效，直接返回 true
    local cached_target = inst._ling_work_target
    if cached_target and cached_target:IsValid() then
        local w = cached_target.components and cached_target.components.workable
        if w and w:CanBeWorked() then
            local act = w:GetWorkAction()
            if _WorkModeAcceptsAction(work_mode, act) then
                return true
            end
        end
    end

    -- 简化目标搜索：只检查是否存在，不详细验证
    local center = GetGuardPos(inst)
    local r = guardConfig.GUARD_RANGE
    local ents = TheSim:FindEntities(center.x, center.y, center.z, r, tags, TOWORK_CANT_TAGS)
    if #ents > 0 then return true end

    -- 砍树模式下检查树桩
    if work_mode == CONSTANTS.GUARD_WORK_MODE.CHOP then
        local stump_ents = TheSim:FindEntities(center.x, center.y, center.z, r, { "DIG_workable", "stump" }, TOWORK_CANT_TAGS)
        if #stump_ents > 0 then return true end
    end

    return false
end

-- 猪人风格工作流：保持工作动作（优化版）
local function KeepWorkingAction(inst)
    local guardConfig = getGuardConfig(inst)
    local mode = inst.components.ling_guard:GetBehaviorMode()
    if mode ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        inst._ling_work_target = nil
        return nil
    end
    if IsInCombatMode(inst) then
        inst._ling_work_target = nil
        return nil
    end

    local work_mode = inst.components.ling_guard:GetWorkMode()
    local tags = _WorkModeToTags(work_mode)
    if tags == nil then
        inst._ling_work_target = nil
        return nil
    end

    -- 优先继续记忆目标
    local target = inst._ling_work_target
    if target and target:IsValid() then
        local w = target.components and target.components.workable
        if w and w:CanBeWorked() then
            local act = w:GetWorkAction()
            if _WorkModeAcceptsAction(work_mode, act) and inst:IsNear(target, (guardConfig.GUARD_RANGE or 16) + 2) then
                if act == ACTIONS.DIG then
                    _ReserveDigFor(target, inst, 1.2) -- 续期挖掘锁，防止并发
                end
                return BufferedAction(inst, target, act)
            end
        end
        -- 记忆目标无效，清除
        inst._ling_work_target = nil
    end

    -- 寻找新工作目标（优化：减少条件检查）
    local center = GetGuardPos(inst)
    local r = guardConfig.GUARD_RANGE or 16

    -- 砍树模式：找树桩
    if work_mode == CONSTANTS.GUARD_WORK_MODE.CHOP then
        local stump_ents = TheSim:FindEntities(center.x, center.y, center.z, r, { "DIG_workable", "stump" }, TOWORK_CANT_TAGS)
        for _, tgt in ipairs(stump_ents) do
            if tgt.entity:IsVisible() and tgt:HasTag("stump") then
                local w = tgt.components and tgt.components.workable
                if w and w:CanBeWorked() and w:GetWorkAction() == ACTIONS.DIG then
                    if not _IsDigReservedByOther(tgt, inst) then
                        inst._ling_work_target = tgt
                        _ReserveDigFor(tgt, inst, 1.2)
                        return BufferedAction(inst, tgt, ACTIONS.DIG)
                    end
                end
            end
        end
    end
    -- 先找主要工作目标（带 DIG 锁）
    local ents = TheSim:FindEntities(center.x, center.y, center.z, r, tags, TOWORK_CANT_TAGS)
    for _, tgt in ipairs(ents) do
        if tgt.entity:IsVisible() then
            local w = tgt.components and tgt.components.workable
            if w and w:CanBeWorked() then
                local act = w:GetWorkAction()
                if _WorkModeAcceptsAction(work_mode, act) then
                    -- 若是挖掘类工作，加锁避免并发
                    if act == ACTIONS.DIG and _IsDigReservedByOther(tgt, inst) then
                        -- 被其他人预定，跳过
                    else
                        inst._ling_work_target = tgt
                        if act == ACTIONS.DIG then
                            _ReserveDigFor(tgt, inst, 1.2)
                        end
                        return BufferedAction(inst, tgt, act)
                    end
                end
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



-- 竞争锁：拾取目标的临时预定，避免重叠范围的守卫竞争同一物品
local function _IsReservedByOther(item, inst)
    local until_t = item._ling_pick_reserved_until
    local by = item._ling_pick_reserved_by
    return until_t ~= nil and GetTime() < until_t and by ~= nil and by ~= inst
end

local function _ReserveItemFor(item, inst, dur)
    item._ling_pick_reserved_by = inst
    item._ling_pick_reserved_until = GetTime() + (dur or 1.0)
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
    local guardConfig = getGuardConfig(inst)
    local r = guardConfig.GUARD_RANGE or 16
    local ents = TheSim:FindEntities(center.x, center.y, center.z, r, nil, {"INLIMBO", "NOCLICK"})
    local nearest, best = nil, math.huge
    for _, item in ipairs(ents) do
        local invitem = item.components and item.components.inventoryitem or nil
        if item:IsValid() and invitem
            and (invitem.canbepickedup ~= false) and not invitem:IsHeld()
            and not (item.components.burnable and (item.components.burnable:IsBurning() or item.components.burnable:IsSmoldering()))
            and not _IsReservedByOther(item, inst)
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
        -- 先行预定，防止其他守卫在本tick竞争
        _ReserveItemFor(nearest, inst, 0.6)
        inst._ling_pick_cooldown_end = GetTime() + 0.20
        return BufferedAction(inst, nearest, ACTIONS.PICKUP)
    end
    return nil
end

local LingGuardBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LingGuardBrain:OnStart()
    local guardConfig = getGuardConfig(self.inst)

    local root = PriorityNode({
        -- 追击
        WhileNode(function() local combat = self.inst.components and self.inst.components.combat or nil return combat ~= nil and (combat.target == nil or not combat:InCooldown()) end, "AttackNoCD",
            ChaseAndAttack(self.inst)),
        -- 救援
        WhileNode( function() return GetLeader(self.inst) and GetLeader(self.inst).components.pinnable and GetLeader(self.inst).components.pinnable:IsStuck() end, "Leader Phlegmed",
            DoAction(self.inst, RescueLeaderAction, "Rescue Leader", true) ),
        -- 风筝
        WhileNode(function()
            local c = self.inst.components and self.inst.components.combat or nil
            return c ~= nil and c.target ~= nil and c:InCooldown()
        end, "KiteHostileEnemies",
            RunAway(self.inst, { fn = function(guy) return self.inst.components and self.inst.components.combat and self.inst.components.combat:TargetIs(guy) end, tags = {"_combat"}, notags = {"INLIMBO"} }, guardConfig.KITE.DETECTION_RANGE or guardConfig.KITE.RUN_DISTANCE, guardConfig.KITE.STOP_DISTANCE, nil, nil, nil, nil, GetKiteSafePoint)),

        -- 先拾取后工作：PickupGuardRange 提前于 GuardWork
        WhileNode(function()
            local mode = self.inst.components.ling_guard and self.inst.components.ling_guard:GetBehaviorMode() or CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS
            return mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD
        end, "PickupGuardRange",
            DoAction(self.inst, function()
                return TryPickupAnyInGuardRange(self.inst)
            end)),

        -- 守形态：工作循环（猪人风格，去掉调试日志）
        WhileNode(function()
            return StartWorkingCondition(self.inst)
        end, "GuardWork",
            LoopNode{
                DoAction(self.inst, function()
                    return KeepWorkingAction(self.inst)
                end, "work", true)
            }),
        Leash(self.inst, function() return GetGuardPos(self.inst) end, 30, 10),
        -- 慎/攻：跟随
        WhileNode(function()
            local mode = self.inst.components.ling_guard and self.inst.components.ling_guard:GetBehaviorMode() or CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS
            return mode ~= CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD
        end, "FollowLeader",
            Follow(self.inst, FindNearestPlayer,
                guardConfig.FOLLOW.MIN or 0,
                guardConfig.FOLLOW.TARGET or 5,
                guardConfig.FOLLOW.MAX or 10)),
        Wander(self.inst, GetGuardPos, 16),
    }, .5)
    self.bt = BT(self.inst, root)
end

return LingGuardBrain
