require "behaviours/wander"
require "behaviours/follow"
require "behaviours/chaseandattack"
require "behaviours/runaway"

-- 加载配置
local CONFIG = require("ling_guard_config")

-- 寻找最近的玩家
local function FindNearestPlayer(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, 20, true)

    if #players > 0 then
        -- 如果有主人，优先跟随主人
        if inst.components.follower and inst.components.follower.leader then
            return inst.components.follower.leader
        end

        -- 否则跟随最近的玩家
        local nearest_player = nil
        local min_dist = math.huge

        for _, player in ipairs(players) do
            if player:IsValid() and not player:HasTag("playerghost") then
                local dist = inst:GetDistanceSqToInst(player)
                if dist < min_dist then
                    min_dist = dist
                    nearest_player = player
                end
            end
        end

        return nearest_player
    end

    return nil
end

-- 获取跟随位置
local function GetFollowPos(inst)
    local leader = FindNearestPlayer(inst)
    if leader then
        return leader:GetPosition()
    elseif inst.components.knownlocations then
        return inst.components.knownlocations:GetLocation("home") or inst:GetPosition()
    end
    return inst:GetPosition()
end

-- 寻找附近的敌对敌人（用于风筝）
local function FindNearbyHostileEnemies(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local enemies = TheSim:FindEntities(x, y, z, CONFIG.KITE.DETECTION_RANGE,
        {"_combat"}, {"player", "companion", "wall", "INLIMBO", "ling_summon"})

    local hostile_enemies = {}
    for _, enemy in ipairs(enemies) do
        if enemy:IsValid() and enemy.components and enemy.components.combat then
            -- 检查是否对守卫或其主人有敌意，或者是潜在威胁
            local is_hostile = false

            -- 如果敌人正在攻击守卫
            if enemy.components.combat.target == inst then
                is_hostile = true
            end

            -- 如果敌人正在攻击守卫的主人
            local leader = inst.components.follower and inst.components.follower.leader
            if leader and enemy.components.combat.target == leader then
                is_hostile = true
            end

            -- 如果敌人正在攻击其他守卫
            if not is_hostile then
                local nearby_guards = TheSim:FindEntities(x, y, z, 15, {"ling_summon"})
                for _, guard in ipairs(nearby_guards) do
                    if guard ~= inst and guard.components and guard.components.combat
                       and enemy.components.combat.target == guard then
                        is_hostile = true
                        break
                    end
                end
            end

            -- 如果守卫正在攻击这个敌人，也认为它是敌对的
            if not is_hostile and inst.components and inst.components.combat
               and inst.components.combat.target == enemy then
                is_hostile = true
            end

            if is_hostile then
                table.insert(hostile_enemies, enemy)
            end
        end
    end

    return hostile_enemies
end

-- 检查是否需要风筝（攻击冷却中且有敌对敌人在附近）
local function ShouldKite(inst)
    -- 必须在攻击冷却期间
    if not inst.components or not inst.components.combat or not inst.components.combat:InCooldown() then
        return false
    end

    -- 检查是否有敌对敌人在危险范围内
    local hostile_enemies = FindNearbyHostileEnemies(inst)
    for _, enemy in ipairs(hostile_enemies) do
        local dist_sq = inst:GetDistanceSqToInst(enemy)
        if dist_sq < CONFIG.KITE.SAFE_DISTANCE * CONFIG.KITE.SAFE_DISTANCE then
            return true
        end
    end

    return false
end

-- 获取风筝目标（最近的敌对敌人）
local function GetKiteTarget(inst)
    local hostile_enemies = FindNearbyHostileEnemies(inst)
    if #hostile_enemies == 0 then
        return nil
    end

    -- 找到最近的敌人
    local closest_enemy = nil
    local min_dist_sq = math.huge

    for _, enemy in ipairs(hostile_enemies) do
        local dist_sq = inst:GetDistanceSqToInst(enemy)
        if dist_sq < min_dist_sq then
            min_dist_sq = dist_sq
            closest_enemy = enemy
        end
    end

    return closest_enemy
end

-- 检查是否可以攻击（不在冷却且在攻击范围内）
local function CanAttackNow(inst)
    if not inst.components or not inst.components.combat then
        return false
    end
    local target = inst.components.combat.target
    if target == nil or inst.components.combat:InCooldown() then
        return false
    end
    local attack_range = inst.components.combat:GetAttackRange()
    return inst:GetDistanceSqToInst(target) <= attack_range * attack_range
end

-- 检查是否处于战斗模式（有目标或有敌对敌人）
local function IsInCombatMode(inst)
    -- 有当前攻击目标
    if inst.components and inst.components.combat and inst.components.combat.target ~= nil then
        return true
    end

    -- 检查是否有敌对敌人在附近
    local hostile_enemies = FindNearbyHostileEnemies(inst)
    return #hostile_enemies > 0
end

-- 检查是否应该优先处理战斗
local function ShouldPrioritizeCombat(inst)
    -- 如果行为模式不是guard，且处于战斗模式，则优先处理战斗
    local behavior_mode = inst.behavior_mode or "cautious"
    if behavior_mode ~= "guard" and IsInCombatMode(inst) then
        return true
    end

    -- guard模式下，只有在攻击范围内有敌人时才优先处理战斗
    if behavior_mode == "guard" then
        if not inst.components or not inst.components.combat then
            return false
        end
        local attack_range = inst.components.combat.attackrange or 4
        local x, y, z = inst.Transform:GetWorldPosition()
        local nearby_enemy = FindEntity(inst, attack_range, function(guy)
            return guy:IsValid() and guy.components and guy.components.combat
                   and not guy:HasTag("player") and not guy:HasTag("companion")
                   and not guy:HasTag("ling_summon")
        end, {"_combat"}, {"player", "companion", "wall", "INLIMBO", "ling_summon"})

        return nearby_enemy ~= nil
    end

    return false
end

local LingGuardBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LingGuardBrain:OnStart()
    local root = PriorityNode(
    {
        -- 攻击冷却时的智能风筝：躲避所有敌对敌人
        WhileNode(function() return ShouldKite(self.inst) end, "KiteHostileEnemies",
            RunAway(self.inst, GetKiteTarget,
                   CONFIG.KITE.RUN_DISTANCE,
                   CONFIG.KITE.STOP_DISTANCE)),

        -- 主动寻找并攻击敌人（这是关键！）
        ChaseAndAttack(self.inst, CONFIG.COMBAT.ATTACK_CHASE_TIME, CONFIG.COMBAT.ATTACK_CHASE_DIST),

        -- 跟随最近的玩家
        Follow(self.inst, FindNearestPlayer,
               CONFIG.FOLLOW.MIN_FOLLOW_DIST,
               CONFIG.FOLLOW.TARGET_FOLLOW_DIST,
               CONFIG.FOLLOW.MAX_FOLLOW_DIST),

        -- 在跟随位置附近游荡
        Wander(self.inst, GetFollowPos, CONFIG.FOLLOW.MAX_WANDER_DIST),
    }, .25)

    self.bt = BT(self.inst, root)
end

return LingGuardBrain
