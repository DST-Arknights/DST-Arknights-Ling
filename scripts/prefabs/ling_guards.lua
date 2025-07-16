local brain = require("brains/ling_guardbrain")
local guard_config = require("ling_guard_config")
local CONSTANTS = require("ark_constants_ling")

local assets = {
    Asset("ANIM", "anim/loong_0.zip"),
    Asset("ANIM", "anim/loong_1.zip"),
}

-- 行为模式常量
local BEHAVIOR_MODES = {
    CAUTIOUS = "cautious", -- 慎：类似阿比盖尔的行为
    GUARD = "guard",       -- 守：静止不动，攻击进入范围的敌人
    ATTACK = "attack",     -- 攻：锁定目标跟随攻击
}

-- 守卫类型常量
local GUARD_TYPE = CONSTANTS.GUARD_TYPE

-- 设置行为模式
local function SetBehaviorMode(inst, mode)
    if not BEHAVIOR_MODES[mode:upper()] then
        mode = "cautious" -- 默认为慎模式
    end

    inst.behavior_mode = mode
    inst:AddTag("behavior_" .. mode)

    -- 移除其他行为标签
    for _, behavior in pairs(BEHAVIOR_MODES) do
        if behavior ~= mode then
            inst:RemoveTag("behavior_" .. behavior)
        end
    end

    -- 重新设置战斗目标函数
    if inst.components and inst.components.combat then
        inst.components.combat:SetRetargetFunction(guard_config.COMBAT.RETARGET_PERIOD, function(inst)
            -- 融合过程中不寻找目标
            if inst.is_fusing then
                return nil
            end
            return GetRetargetFunction(inst)
        end)
    end
end

-- 使用配置中的集群战斗常量
local CLUSTER_COMBAT_RANGE = guard_config.CLUSTER.COMBAT_RANGE
local CLUSTER_SHARE_RANGE = guard_config.CLUSTER.SHARE_RANGE
local MAX_CLUSTER_SIZE = guard_config.CLUSTER.MAX_SIZE

-- 检查是否为有效的集群战斗目标
local function IsValidClusterTarget(inst, target)
    return target and target:IsValid()
           and inst.components.combat:CanTarget(target)
           and target:HasTag("monster")
           and not target:HasTag("ling_summon")
           and not target:HasTag("player")
           and not target:HasTag("companion")
end

-- 寻找集群战斗目标
local function FindClusterTarget(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local nearby_guards = TheSim:FindEntities(x, y, z, CLUSTER_COMBAT_RANGE, {"ling_summon"}, {"INLIMBO"})

    -- 统计每个目标被多少守卫攻击
    local target_counts = {}
    local valid_targets = {}

    for _, guard in ipairs(nearby_guards) do
        if guard ~= inst and guard.components.combat and guard.components.combat.target then
            local target = guard.components.combat.target
            if IsValidClusterTarget(inst, target) then
                target_counts[target] = (target_counts[target] or 0) + 1
                valid_targets[target] = true
            end
        end
    end

    -- 优先选择被攻击次数较少的目标，实现负载均衡
    local best_target = nil
    local min_attackers = math.huge

    for target, count in pairs(target_counts) do
        -- 如果目标被攻击的守卫数量少于最大集群大小的一半，可以加入
        if count < MAX_CLUSTER_SIZE / 2 and count < min_attackers then
            min_attackers = count
            best_target = target
        end
    end

    -- 如果找到了合适的集群目标
    if best_target then
        return best_target
    end

    return nil
end

-- 获取战斗目标的函数（根据行为模式）
function GetRetargetFunction(inst)
    local mode = inst.behavior_mode or "cautious"

    -- 优先检查集群战斗目标（除了守模式）
    if mode ~= "guard" then
        local cluster_target = FindClusterTarget(inst)
        if cluster_target then
            return cluster_target
        end
    end

    if mode == "guard" then
        -- 守模式：只攻击进入攻击范围的敌人，不主动追击
        local range = inst.components.combat.attackrange or 4
        local target = FindEntity(inst, range, function(guy)
            return IsValidClusterTarget(inst, guy)
        end, {"_combat"}, {"player", "companion", "wall", "INLIMBO"})

        -- 守模式下也检查集群目标，但优先级较低
        if not target then
            target = FindClusterTarget(inst)
        end

        return target

    elseif mode == "attack" then
        -- 攻模式：主动寻找并攻击敌人
        return FindEntity(inst, 15, function(guy)
            return IsValidClusterTarget(inst, guy)
        end, {"_combat"}, {"player", "companion", "wall", "INLIMBO"})

    else -- cautious 慎模式
        -- 慎模式：优先攻击主人的目标，然后攻击攻击主人的敌人，最后主动攻击附近敌人
        local leader = inst.components.follower and inst.components.follower.leader

        -- 1. 优先攻击主人的目标
        if leader and leader.components.combat then
            local leader_target = leader.components.combat.target
            if IsValidClusterTarget(inst, leader_target) then
                return leader_target
            end
        end

        -- 2. 攻击正在攻击主人的敌人
        if leader then
            local leader_x, leader_y, leader_z = leader.Transform:GetWorldPosition()
            local monsters = TheSim:FindEntities(leader_x, leader_y, leader_z, 10, {"monster", "_combat"}, {"player", "companion", "wall", "INLIMBO", "ling_summon"})
            for _, monster in ipairs(monsters) do
                if monster.components.combat and monster.components.combat.target == leader
                   and IsValidClusterTarget(inst, monster) then
                    return monster
                end
            end
        end

        -- 3. 主动攻击附近的敌人（较小范围，保持慎重）
        local target = FindEntity(inst, 8, function(guy)
            return IsValidClusterTarget(inst, guy)
        end, {"_combat"}, {"player", "companion", "wall", "INLIMBO"})

        return target
    end
end

-- 等级设置函数
local function SetLevel(inst, level, preserve_health)
    if not level or level < 1 or level > 4 then
        level = 1
    end

    inst.level = level
    local guard_type = inst.guard_type or "qingping"
    local config_key = guard_type:upper()
    local config = TUNING.LING_GUARDS[config_key] and TUNING.LING_GUARDS[config_key].LEVELS[level]

    if not config then
        print("Warning: No config found for guard type", guard_type, "level", level)
        return
    end

    -- 设置生命值
    if inst.components.health then
        local old_health_percent = nil
        if preserve_health then
            -- 保存当前血量百分比
            old_health_percent = inst.components.health:GetPercent()
        end

        inst.components.health:SetMaxHealth(config.HEALTH)

        if preserve_health and old_health_percent then
            -- 恢复血量百分比
            inst.components.health:SetPercent(old_health_percent)
        else
            -- 只有在不保持血量时才设置为满血
            inst.components.health:SetCurrentHealth(config.HEALTH)
        end
    end

    -- 设置攻击力
    if inst.components.combat then
        inst.components.combat:SetDefaultDamage(config.DAMAGE)
        inst.components.combat:SetRange(config.ATTACK_RANGE)
        inst.components.combat:SetAttackPeriod(config.ATTACK_PERIOD)
    end

    -- 设置移动速度
    if inst.components.locomotor then
        inst.components.locomotor.walkspeed = config.WALK_SPEED
        inst.components.locomotor.runspeed = config.RUN_SPEED
    end

    -- 设置免伤
    inst.damage_reduction = config.DAMAGE_REDUCTION

    -- 添加等级标签
    for i = 1, 4 do
        inst:RemoveTag(guard_type .. "_level_" .. i)
    end
    inst:AddTag(guard_type .. "_level_" .. level)

    -- 触发升级事件（只有等级真正改变时才触发）
    if inst.old_level and inst.old_level ~= level then
        inst:PushEvent("level_changed", {old_level = inst.old_level, new_level = level})
    end
    inst.old_level = level
end

-- 通用守卫构造函数
local function MakeGuard(guard_type, prefab_name, state_graph)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddLight()
        inst.entity:AddNetwork()

        -- 设置动画
        if guard_type == "xianjing" then
            -- 弦惊使用loong_1模型
            inst.AnimState:SetBank("loong_1")
            inst.AnimState:SetBuild("loong_1")
            -- 弦惊使用0.54倍模型大小（0.3 * 1.8）
            inst.AnimState:SetScale(0.54, 0.54, 0.54)
        else
            -- 清平和逍遥使用loong_0模型
            inst.AnimState:SetBank("loong_0")
            inst.AnimState:SetBuild("loong_0")
        end
        inst.AnimState:PlayAnimation("idle", true)

        -- 添加基础标签
        inst:AddTag(guard_type)
        inst:AddTag("companion")
        inst:AddTag("ling_summon")  -- 令的召唤物标签，防止互相攻击

        -- 根据守卫类型设置特殊属性
        if guard_type == "xianjing" then
            -- 弦惊：地面单位但无体积碰撞
            inst:AddTag("NOBLOCK")
            MakeCharacterPhysics(inst, 10, 0.5)
            -- 不设置为飞行单位，避免方形光照
        else
            -- 清平/逍遥：正常物理
            MakeCharacterPhysics(inst, 10, 0.5)
        end

        -- 设置Transform面数
        inst.Transform:SetFourFaced()

        -- 设置阴影
        inst.DynamicShadow:SetSize(1.5, 0.75)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -- 存储守卫类型
        inst.guard_type = guard_type

        -- 基础组件
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(300)
        -- 启用最大血量保存功能
        inst.components.health.save_maxhealth = true

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(30)
        inst.components.combat:SetRange(4)
        inst.components.combat:SetAttackPeriod(4)
        -- 战斗目标函数将在SetBehaviorMode中设置

        inst:AddComponent("locomotor")
        inst.components.locomotor.walkspeed = 2.5
        inst.components.locomotor.runspeed = 5

        inst:AddComponent("follower")
        inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true

        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")
        inst:AddComponent("knownlocations")
        inst:AddComponent("talker")

        if guard_type == GUARD_TYPE.QINGPING or guard_type == GUARD_TYPE.XIAOYAO then
            inst:AddComponent("container")
            inst.components.container:WidgetSetup(guard_type)
            -- inst.components.container.skipautoclose = true
        end

        -- 睡眠组件（仅清平和逍遥，弦惊不会睡眠）
        if guard_type ~= "xianjing" then
            inst:AddComponent("sleeper")
            inst.components.sleeper:SetResistance(2)  -- 睡眠阻抗
            inst.components.sleeper.testperiod = 5    -- 每5秒检查一次睡眠条件

            -- 引入源码中的标准睡眠检查函数
            local function StandardSleepChecks(inst)
                return not (inst.components.homeseeker ~= nil and
                        inst.components.homeseeker.home ~= nil and
                            inst.components.homeseeker.home:IsValid() and
                            inst:IsNear(inst.components.homeseeker.home, 40))
                    and not (inst.components.combat ~= nil and inst.components.combat.target ~= nil)
                    and not (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
                    and not (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen())
                    and not (inst.components.teamattacker ~= nil and inst.components.teamattacker.inteam)
                    and not (inst.sg and inst.sg:HasStateTag("busy"))
            end

            local function StandardWakeChecks(inst)
                return (inst.components.combat ~= nil and inst.components.combat.target ~= nil)
                    or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
                    or (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen())
                    or (inst.components.teamattacker ~= nil and inst.components.teamattacker.inteam)
                    or (inst.components.health ~= nil and inst.components.health.takingfiredamage)
            end

            -- 自定义睡眠测试函数：血量低于50且夜晚时睡觉，同时满足标准睡眠条件
            inst.components.sleeper.sleeptestfn = function(inst)
                if inst.components.health and inst.components.health.currenthealth < 50 then
                    return StandardSleepChecks(inst) and TheWorld.state.isnight
                end
                return false
            end

            -- 自定义醒来测试函数：血量恢复到80%或天亮时醒来，或者满足标准醒来条件
            inst.components.sleeper.waketestfn = function(inst)
                if StandardWakeChecks(inst) then
                    return true
                end
                if inst.components.health then
                    local health_recovered = inst.components.health.currenthealth >= inst.components.health.maxhealth * 0.8
                    local is_day = not TheWorld.state.isnight
                    return health_recovered or is_day
                end
                return not TheWorld.state.isnight
            end

            -- 睡眠时回血处理
            inst:ListenForEvent("gotosleep", function(inst)
                -- 开始回血任务
                if inst.sleep_heal_task then
                    inst.sleep_heal_task:Cancel()
                end
                inst.sleep_heal_task = inst:DoPeriodicTask(1, function()
                    if inst.components.health and not inst.components.health:IsDead()
                       and inst.components.sleeper and inst.components.sleeper:IsAsleep() then
                        local max_health = inst.components.health.maxhealth
                        local current_health = inst.components.health.currenthealth
                        if current_health < max_health then
                            local heal_amount = max_health * 0.02  -- 每秒回复2%最大生命值
                            inst.components.health:DoDelta(heal_amount)
                        end
                    end
                end)
            end)

            inst:ListenForEvent("onwakeup", function(inst)
                -- 停止回血任务
                if inst.sleep_heal_task then
                    inst.sleep_heal_task:Cancel()
                    inst.sleep_heal_task = nil
                end
            end)
        end

        -- 设置光照效果（参考萤火虫的光照范围）
        local light_radius = 1  -- 萤火虫的光照半径
        local light_intensity = 0.5  -- 萤火虫的光照强度
        if guard_type == "xianjing" then
            -- 弦惊的光照范围为基础召唤物的3倍
            light_radius = 3
        end
        inst.Light:SetRadius(light_radius)
        inst.Light:SetIntensity(light_intensity)
        inst.Light:SetFalloff(1)
        inst.Light:SetColour(0.8, 0.8, 1.0) -- 淡蓝色光
        inst.Light:Enable(true)

        -- 设置大脑和状态图
        inst:SetBrain(brain)
        inst:SetStateGraph(state_graph or "SGling_guards")

        -- 设置等级函数
        inst.SetLevel = SetLevel

        -- 设置行为模式函数
        inst.SetBehaviorMode = SetBehaviorMode

        -- 默认设置为1级（但不要在这里调用，因为会覆盖加载的血量）
        inst.level = 1
        inst.behavior_mode = "cautious"

        -- 延迟设置等级和行为模式，确保在Health组件加载完成后
        inst:DoTaskInTime(0, function()
            if not inst._loaded_from_save then
                -- 只有在不是从存档加载时才设置默认值
                inst:SetLevel(1)
                inst:SetBehaviorMode("cautious")
            end
        end)

        -- 免伤处理
        inst:ListenForEvent("attacked", function(inst, data)
            if inst.damage_reduction and inst.damage_reduction > 0 and data.damage then
                local reduced_damage = data.damage * (1 - inst.damage_reduction)
                data.damage = reduced_damage
            end
        end)

        -- 保存和加载功能
        inst.OnSave = function(inst, data)
            data.level = inst.level
            data.behavior_mode = inst.behavior_mode
            data.guard_type = inst.guard_type
            -- 保存召唤者和插槽信息
            data.saved_summoner_userid = inst.saved_summoner_userid
            data.saved_slots = inst.saved_slots
        end

        inst.OnLoad = function(inst, data)
            -- 标记为从存档加载
            inst._loaded_from_save = true
            if data then
                -- 恢复召唤者和插槽信息
                inst.saved_summoner_userid = data.saved_summoner_userid
                inst.saved_slots = data.saved_slots
            end

            -- 延迟设置等级和行为模式，确保不覆盖Health组件的加载
            inst:DoTaskInTime(0, function()
                if data and data.level then
                    inst:SetLevel(data.level, true)  -- 传入true保持血量百分比
                end
                -- 始终设置行为模式，确保combat组件有正确的retarget函数
                inst:SetBehaviorMode((data and data.behavior_mode) or "cautious")
            end)

            -- Health组件会自动加载血量，不需要我们手动处理
        end

        return inst
    end

    return Prefab(prefab_name, fn, assets)
end

-- 创建清平预制体
local function MakeQingping()
    return MakeGuard("qingping", "qingping", "SGling_guards")
end

-- 创建逍遥预制体
local function MakeXiaoyao()
    return MakeGuard("xiaoyao", "xiaoyao", "SGling_guards")
end

-- 创建弦惊预制体
local function MakeXianjing()
    return MakeGuard("xianjing", "xianjing", "SGling_guards")
end

return MakeQingping(), MakeXiaoyao(), MakeXianjing()
