local brain = require("brains/ling_guardbrain")
local guard_config = require("ling_guard_config")
local CONSTANTS = require("ark_constants_ling")

local assets = {
    Asset("ANIM", "anim/loong_0.zip"),
    Asset("ANIM", "anim/loong_1.zip"),
}

-- 移除旧的行为模式常量，现在使用 CONSTANTS.GUARD_BEHAVIOR_MODE

-- 守卫类型常量
local GUARD_TYPE = CONSTANTS.GUARD_TYPE

-- 守卫配置表
local GUARD_CONFIGS = {
    [GUARD_TYPE.QINGPING] = {
        guard_type = CONSTANTS.GUARD_TYPE.QINGPING,
        prefab_name = "qingping",
        state_graph = "SGling_guards",
        anim_bank = "loong_0",
        anim_build = "loong_0",
        scale = nil, -- 默认缩放
        has_container = true,
        can_sleep = true,
        light_radius = 1,
        physics_radius = 10,
        physics_height = 0.5,
        tags = {},
    },
    [GUARD_TYPE.XIAOYAO] = {
        guard_type = CONSTANTS.GUARD_TYPE.XIAOYAO,
        prefab_name = "xiaoyao",
        state_graph = "SGling_guards",
        anim_bank = "loong_0",
        anim_build = "loong_0",
        scale = nil, -- 默认缩放
        has_container = true,
        can_sleep = true,
        light_radius = 1,
        physics_radius = 10,
        physics_height = 0.5,
        tags = {},
    },
    [GUARD_TYPE.XIANJING] = {
        guard_type = CONSTANTS.GUARD_TYPE.XIANJING,
        prefab_name = "xianjing",
        state_graph = "SGling_guards",
        anim_bank = "loong_1",
        anim_build = "loong_1",
        scale = 0.54, -- 0.3 * 1.8
        has_container = false,
        can_sleep = false,
        light_radius = 3,
        physics_radius = 10,
        physics_height = 0.5,
        tags = {"NOBLOCK"}, -- 地面单位但无体积碰撞
    },
}

local function OnAttacked(inst, data)
    if data.attacker == nil then
        return
    end
    local leader = inst.components.follower.leader
    if leader == nil then
        return
    end
    inst.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("ling_summon") and dude.components.follower and dude.components.follower.leader == leader
    end, 10)
end

local function OnNewTarget(inst, data)
    if data.target == nil then
        return
    end
    local leader = inst.components.follower.leader
    if leader == nil then
        return
    end
    inst.combat:ShareTarget(data.target, 30, function(dude)
        return dude:HasTag("ling_summon") and dude.components.follower and dude.components.follower.leader == leader
    end, 10)
end

-- 通用守卫构造函数
local function MakeGuard(config)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddLight()
        inst.entity:AddNetwork()

        -- 设置动画
        inst.AnimState:SetBank(config.anim_bank)
        inst.AnimState:SetBuild(config.anim_build)
        if config.scale then
            inst.AnimState:SetScale(config.scale, config.scale, config.scale)
        end
        inst.AnimState:PlayAnimation("idle", true)

        -- 添加基础标签
        inst:AddTag(config.prefab_name)
        inst:AddTag("companion")
        inst:AddTag("ling_summon")

        -- 添加配置中的特殊标签
        for _, tag in ipairs(config.tags) do
            inst:AddTag(tag)
        end

        -- 设置物理属性
        MakeCharacterPhysics(inst, config.physics_radius, config.physics_height)

        -- 设置Transform面数
        inst.Transform:SetFourFaced()

        -- 设置阴影
        inst.DynamicShadow:SetSize(1.5, 0.75)

        inst.entity:SetPristine()

        inst:AddComponent("healthsyncer")

        if not TheWorld.ismastersim then
            -- 客户端监听生命变化
            inst:ListenForEvent("clienthealthdirty", function(inst, data)
                local leader = inst.replica.follower:GetLeader()
                print("[LingGuard] clienthealthdirty", data.percent)
                if leader and leader.HUD and leader.HUD.controls and leader.HUD.controls.ling_guard_panel and leader.HUD.controls.ling_guard_panel.guard_inst == inst then
                    print("[LingGuard] clienthealthdirty update panel", data.percent)
                    leader.HUD.controls.ling_guard_panel.health:SetPercent(data.percent, true)
                end
            end)
            return inst
        end

        -- 存储守卫类型
        inst.guard_type = config.guard_type

        -- 基础组件
        inst:AddComponent("health")
        -- 启用最大血量保存功能
        inst.components.health.save_maxhealth = true

        inst:AddComponent("combat")

        inst:AddComponent("locomotor")

        inst:AddComponent("follower")
        inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true

        -- 添加守卫行为管理组件
        inst:AddComponent("ling_guard")
        -- 设置初始等级（1 = 无精英化）
        inst.components.ling_guard:SetLevel(1)

        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")
        inst:AddComponent("knownlocations")
        inst:AddComponent("talker")

        if config.has_container then
            inst:AddComponent("container")
            inst.components.container:WidgetSetup(config.prefab_name)
        end

        -- 睡眠组件（根据配置决定是否添加）
        if config.can_sleep then
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
        inst:AddComponent("timer")
        inst:AddComponent("ling_guard_plant")

        -- 设置光照效果（参考萤火虫的光照范围）
        local light_intensity = 0.5  -- 萤火虫的光照强度
        inst.Light:SetRadius(config.light_radius)
        inst.Light:SetIntensity(light_intensity)
        inst.Light:SetFalloff(1)
        inst.Light:SetColour(0.8, 0.8, 1.0) -- 淡蓝色光
        inst.Light:Enable(true)

        -- 设置大脑和状态图
        inst:SetBrain(brain)
        inst:SetStateGraph(config.state_graph)

        -- 保存附加容器
        inst.OnSave = function(inst, data)
            if inst.plant_container then
                data.plant_container = inst.plant_container:GetSaveRecord()
            end
            if inst.plant_club then
                data.plant_club = inst.plant_club:GetSaveRecord()
            end
        end
        inst.OnPreLoad = function(inst, data)
            if data then
                if data.plant_container then
                    inst.plant_container = SpawnSaveRecord(data.plant_container)
                    if inst.plant_container then
                        inst.plant_container.entity:SetParent(inst.entity)
                        inst.plant_container.Transform:SetPosition(0, 0, 0)
                    end
                end
                if data.plant_club then
                    inst.plant_club = SpawnSaveRecord(data.plant_club)
                    if inst.plant_club then
                        inst.plant_club.entity:SetParent(inst.entity)
                        inst.plant_club.Transform:SetPosition(0, 0, 0)
                    end
                end
            end
        end
        inst.OnRemoveEntity = function(inst)
            if inst.plant_container then
                inst.plant_container.components.container:DropEverything(inst:GetPosition(), true)
                inst.plant_container:Remove()
            end
            if inst.plant_club then
                inst.plant_club.components.container:DropEverything(inst:GetPosition(), true)
                inst.plant_club:Remove()
            end
        end
        return inst
    end

    return Prefab(config.prefab_name, fn, assets)
end

return MakeGuard(GUARD_CONFIGS[GUARD_TYPE.QINGPING]), MakeGuard(GUARD_CONFIGS[GUARD_TYPE.XIAOYAO]), MakeGuard(GUARD_CONFIGS[GUARD_TYPE.XIANJING])
