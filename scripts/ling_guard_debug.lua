-- 令的守卫调试工具
-- 用于测试和调试守卫的行为

local function DebugGuardBehavior(guard)
    if not guard or not guard:IsValid() then
        print("无效的守卫")
        return
    end
    
    print("=== 守卫调试信息 ===")
    local type_str = "未知"
    if guard.components and guard.components.ling_guard then
        type_str = guard.components.ling_guard:IsXianjing() and "ELITE" or "BASIC"
    end
    print("守卫类型:", type_str)
    print("行为模式:", guard.behavior_mode or "未知")
    print("等级:", guard.components.ling_guard and guard.components.ling_guard:GetLevel() or "未知")
    
    -- 战斗信息
    if guard.components.combat then
        print("当前目标:", guard.components.combat.target and guard.components.combat.target.prefab or "无")
        print("攻击范围:", guard.components.combat:GetAttackRange())
        print("攻击冷却:", guard.components.combat:InCooldown() and "是" or "否")
        print("攻击间隔:", guard.components.combat.min_attack_period or "未知")
    end
    
    -- 跟随信息
    if guard.components.follower then
        print("主人:", guard.components.follower.leader and guard.components.follower.leader.prefab or "无")
    end
    
    -- 健康信息
    if guard.components.health then
        print("血量:", guard.components.health.currenthealth .. "/" .. guard.components.health.maxhealth)
    end
    
    -- 位置信息
    local x, y, z = guard.Transform:GetWorldPosition()
    print("位置:", string.format("(%.1f, %.1f, %.1f)", x, y, z))
    
    -- 附近敌人信息
    local enemies = TheSim:FindEntities(x, y, z, 15, {"_combat"}, {"player", "companion", "wall", "INLIMBO", "ling_summon"})
    print("附近敌人数量:", #enemies)
    for i, enemy in ipairs(enemies) do
        if i <= 3 then -- 只显示前3个
            local dist = guard:GetDistanceSqToInst(enemy)
            print("  敌人" .. i .. ":", enemy.prefab, "距离:", string.format("%.1f", math.sqrt(dist)))
        end
    end
    
    print("==================")
end

-- 测试守卫的retarget函数
local function TestGuardRetarget(guard)
    if not guard or not guard:IsValid() or not guard.components or not guard.components.combat then
        print("无效的守卫或缺少combat组件")
        return
    end

    print("=== 测试守卫寻敌 ===")

    -- 手动调用retarget函数
    local retarget_fn = guard.components.combat.retargetfn
    if retarget_fn then
        local target = retarget_fn(guard)
        print("寻敌结果:", target and target.prefab or "无目标")

        if target then
            local dist = guard:GetDistanceSqToInst(target)
            print("目标距离:", string.format("%.1f", math.sqrt(dist)))
        end
    else
        print("守卫没有retarget函数")
    end

    print("==================")
end

-- 测试brain函数
local function TestBrainFunctions(guard)
    if not guard or not guard:IsValid() then
        print("无效的守卫")
        return
    end

    print("=== 测试Brain函数 ===")

    -- 测试ShouldKite函数
    local brain_file = require("brains/ling_guardbrain")
    print("Brain文件加载:", brain_file and "成功" or "失败")

    -- 测试附近敌人检测
    local x, y, z = guard.Transform:GetWorldPosition()
    local enemies = TheSim:FindEntities(x, y, z, 15, {"_combat"}, {"player", "companion", "wall", "INLIMBO", "ling_summon"})
    print("附近实体数量:", #enemies)

    for i, enemy in ipairs(enemies) do
        if i <= 5 then -- 只显示前5个
            local has_combat = enemy.components and enemy.components.combat
            print("  实体" .. i .. ":", enemy.prefab, "有combat组件:", has_combat and "是" or "否")
        end
    end

    print("==================")
end

-- 强制守卫攻击最近的敌人
local function ForceGuardAttack(guard)
    if not guard or not guard:IsValid() or not guard.components or not guard.components.combat then
        print("无效的守卫或缺少combat组件")
        return
    end
    
    local x, y, z = guard.Transform:GetWorldPosition()
    local enemies = TheSim:FindEntities(x, y, z, 15, {"_combat"}, {"player", "companion", "wall", "INLIMBO", "ling_summon"})
    
    if #enemies > 0 then
        local closest_enemy = enemies[1]
        local min_dist = guard:GetDistanceSqToInst(closest_enemy)
        
        for _, enemy in ipairs(enemies) do
            local dist = guard:GetDistanceSqToInst(enemy)
            if dist < min_dist then
                min_dist = dist
                closest_enemy = enemy
            end
        end
        
        print("强制攻击:", closest_enemy.prefab, "距离:", string.format("%.1f", math.sqrt(min_dist)))
        guard.components.combat:SetTarget(closest_enemy)
    else
        print("附近没有敌人")
    end
end

-- 简单设置全局函数
_G.DebugGuardBehavior = DebugGuardBehavior
_G.TestGuardRetarget = TestGuardRetarget
_G.TestBrainFunctions = TestBrainFunctions
_G.ForceGuardAttack = ForceGuardAttack

-- 便捷函数：调试最近的守卫
_G.DebugNearestGuard = function()
    local player = ThePlayer
    if not player then
        print("找不到玩家")
        return
    end

    local x, y, z = player.Transform:GetWorldPosition()
    local guards = TheSim:FindEntities(x, y, z, 20, {"ling_summon"})

    if #guards > 0 then
        local nearest_guard = guards[1]
        local min_dist = player:GetDistanceSqToInst(nearest_guard)

        for _, guard in ipairs(guards) do
            local dist = player:GetDistanceSqToInst(guard)
            if dist < min_dist then
                min_dist = dist
                nearest_guard = guard
            end
        end

        print("调试最近的守卫:", nearest_guard.prefab)
        DebugGuardBehavior(nearest_guard)
        TestGuardRetarget(nearest_guard)
        TestBrainFunctions(nearest_guard)
    else
        print("附近没有守卫")
    end
end

print("令的守卫调试工具已加载")
print("可用命令:")
print("  DebugNearestGuard() - 调试最近的守卫")
print("  DebugGuardBehavior(guard) - 调试指定守卫")
print("  TestGuardRetarget(guard) - 测试守卫寻敌")
print("  TestBrainFunctions(guard) - 测试Brain函数")
print("  ForceGuardAttack(guard) - 强制守卫攻击最近敌人")


