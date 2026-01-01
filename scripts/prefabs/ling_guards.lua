local brain = require("brains/ling_guardbrain")
local CONSTANTS = require("ark_constants_ling")
local getGuardConfig = require("ling_guard_config").getGuardConfig

local FORM = CONSTANTS.GUARD_FORM

local assets = {
    Asset("ANIM", "anim/loong_0.zip"),
    Asset("ANIM", "anim/loong_1.zip"),
}

-- 创建持续点亮视野的图标
local function CreateFogRevealerIcon(inst)
    if inst._fog_icon == nil then
        inst._fog_icon = SpawnPrefab("globalmapicon")
        inst._fog_icon.MiniMapEntity:SetIsFogRevealer(true)
        inst._fog_icon:AddTag("fogrevealer")
        inst._fog_icon:TrackEntity(inst)
    end
end

-- 移除视野图标
local function RemoveFogRevealerIcon(inst)
    if inst._fog_icon ~= nil then
        inst._fog_icon:Remove()
        inst._fog_icon = nil
    end
end

---------------------------------------------------------------------
-- 目标：提供两个干净的预制体：
--   1) ling_guard_basic：普通守卫（可切换 清平/逍遥 形态；默认 清平）
--   2) ling_guard_elite：高级守卫（弦惊；无切换）
-- 要点：
--   - 不再使用 guard_type；类型由 inst.prefab 与组件判定
--   - 逍遥固定装备远程武器；清平无武器（纯近战）
--   - 状态图攻击动画选择依赖 inst.prefab + 组件 ling_guard_form
---------------------------------------------------------------------
-- 公共存取/移除：容器与附属实体
local function OnSave_Common(inst, data)
    ArkLogger:Debug("ling_guard:OnSave", inst)
    if inst.plant_container then data.plant_container = inst.plant_container:GetSaveRecord() end
    if inst.plant_club then data.plant_club = inst.plant_club:GetSaveRecord() end
end

local function OnPreLoad_Common(inst, data)
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

local function OnRemoveEntity_Common(inst)
    if inst.plant_container then
        inst.plant_container.components.container:DropEverything(inst:GetPosition(), true)
        inst.plant_container:Remove()
    end
    if inst.plant_club then
        inst.plant_club.components.container:DropEverything(inst:GetPosition(), true)
        inst.plant_club:Remove()
    end
    -- 若存在固定武器（普通守卫-逍遥），一并清理
    if inst._ling_fixed_weapon and inst._ling_fixed_weapon:IsValid() then
        inst._ling_fixed_weapon:Remove()
        inst._ling_fixed_weapon = nil
    end
    RemoveFogRevealerIcon(inst)
end


-- 选择目标（依赖外部 targeting 模块）
local function NormalRetargetFn(inst)
    local targeting = require("ling_targeting")
    if inst.is_fusing then
        return nil
    end
    return targeting.SelectTarget(inst)
end

-- 保持目标：根据行为模式限制追击范围
local function KeepTargetFn(inst, target)
    if target == nil or not target:IsValid() then return false end
    if target:HasTag("INLIMBO") then return false end
    if target.components and target.components.health and target.components.health:IsDead() then return false end
    if not (inst.components and inst.components.combat and inst.components.combat:CanTarget(target)) then return false end

    local guardConfig = getGuardConfig(inst)
    local mode = inst.components.ling_guard and inst.components.ling_guard:GetBehaviorMode() or CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS

    if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        -- 若目标正在攻击守卫本体，直接允许
        if target.components and target.components.combat and target.components.combat:TargetIs(inst) then
            return true
        end
        -- 正在攻击主人：以主人为中心判定
        local leader = inst.components.follower and inst.components.follower.leader or nil
        if leader ~= nil and target.components and target.components.combat and target.components.combat:TargetIs(leader) then
            local allow_r = guardConfig.LEADER_DEFENSE_DIST
            return leader:GetDistanceSqToInst(target) <= allow_r * allow_r
        end
        -- 否则按守点为中心判定
        local guardpos = inst.components.ling_guard and inst.components.ling_guard.guard_pos or (inst.components.follower and inst.components.follower.leader and inst.components.follower.leader:GetPosition()) or inst:GetPosition()
        local gx, gy, gz = guardpos:Get()
        local tx, ty, tz = target.Transform:GetWorldPosition()
        local dx, dz = tx - gx, tz - gz
        local allow_r = guardConfig.CHASE_RANGE
        return dx*dx + dz*dz <= allow_r * allow_r
    else
        -- 其它形态：使用与主人的距离限制
        local chase_d = guardConfig.LEADER_DEFENSE_DIST
        return inst:GetDistanceSqToInst(target) <= chase_d * chase_d
    end
end

-- 固定远程武器（用于逍遥）：
local function CreateFixedRangedWeapon(owner)
    local ent = CreateEntity()
    ent.entity:AddTransform()
    ent:AddTag("NOCLICK")
    ent.persists = false

    ent:AddComponent("weapon")
    ent.components.weapon:SetRange(2, (owner and owner._ling_ranged_range) or 15)
    ent.components.weapon:SetProjectile("bishop_charge")
    ent.components.weapon:SetDamage(function(attacker, target)
        return (attacker.components.combat and attacker.components.combat.defaultdamage) or 20
    end)

    ent._owner = owner
    owner:ListenForEvent("onremove", function()
        if ent and ent:IsValid() then ent:Remove() end
    end)
    return ent
end

-- 根据形态切换基础武装
local function SetupBasicForm(inst, form)
    -- 清理旧武器
    if inst._ling_fixed_weapon ~= nil then
        if inst._ling_fixed_weapon:IsValid() then inst._ling_fixed_weapon:Remove() end
        inst._ling_fixed_weapon = nil
    end
    if form == FORM.XIAOYAO then
        inst.components.combat:SetRange(inst._ling_ranged_range or 15)
        local w = CreateFixedRangedWeapon(inst)
        inst._ling_fixed_weapon = w
    else
        -- 清平：无默认武器
        inst.components.combat:SetRange(inst._ling_melee_range or 4)
    end
end

-- 通用：睡眠回血配置（夜晚，血量<50%）
local function SetupSleepHeal(inst)
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = 5

    local function StandardSleepChecks(inst)
        return not (inst.components.homeseeker ~= nil and inst.components.homeseeker.home ~= nil and inst.components.homeseeker.home:IsValid() and inst:IsNear(inst.components.homeseeker.home, 40))
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

    inst.components.sleeper.sleeptestfn = function(inst)
        if inst.components.health and inst.components.health.currenthealth < 50 then
            return StandardSleepChecks(inst) and TheWorld.state.isnight
        end
        return false
    end

    inst.components.sleeper.waketestfn = function(inst)
        if StandardWakeChecks(inst) then return true end
        if inst.components.health then
            local health_recovered = inst.components.health.currenthealth >= inst.components.health.maxhealth * 0.8
            local is_day = not TheWorld.state.isnight
            return health_recovered or is_day
        end
        return not TheWorld.state.isnight
    end

    inst:ListenForEvent("gotosleep", function(inst)
        if inst.sleep_heal_task then inst.sleep_heal_task:Cancel() end
        inst.sleep_heal_task = inst:DoPeriodicTask(1, function()
            if inst.components.health and not inst.components.health:IsDead()
               and inst.components.sleeper and inst.components.sleeper:IsAsleep() then
                local max_health = inst.components.health.maxhealth
                local current_health = inst.components.health.currenthealth
                if current_health < max_health then
                    inst.components.health:DoDelta(max_health * 0.02)
                end
            end
        end)
    end)

    inst:ListenForEvent("onwakeup", function(inst)
        if inst.sleep_heal_task then inst.sleep_heal_task:Cancel(); inst.sleep_heal_task = nil end
    end)
end

local function onDespawn(inst)
    ArkLogger:Debug("ling_guard:onDespawn", inst)
    local fx = SpawnPrefab("spawn_fx_medium")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.components.colourtweener:StartTween({ 0, 0, 0, 1 }, 13 * FRAMES, inst.Remove)
end
----------------------------
-- 普通守卫（ling_guard_basic）
----------------------------
local function ling_guard_basic_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:SetCanSleep(false)

    inst.MiniMapEntity:SetIcon("ling.tex")

    inst.AnimState:SetBank("loong_0")
    inst.AnimState:SetBuild("loong_0")
    inst.AnimState:PlayAnimation("idle", true)

    inst.Transform:SetFourFaced()
    inst.DynamicShadow:SetSize(1.5, 0.75)

    inst:AddTag("ling_guard_basic")
    inst:AddTag("companion")
    inst:AddTag("ling_summon")

    MakeCharacterPhysics(inst, 50, 0.5)

    inst.entity:SetPristine()

    inst:AddComponent("healthsyncer")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("named")
    -- TODO: 设置正确的名称
    inst.components.named.possiblenames = STRINGS.PIGNAMES
    inst.components.named:PickNewName()

    inst:AddComponent("health")
    inst.components.health.save_maxhealth = true


    inst:AddComponent("combat")
    inst.components.combat:SetRange(0.1)
    inst.components.combat:SetRetargetFunction(1, NormalRetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetAttackPeriod(1)
    -- 守卫行为管理
    inst:AddComponent("ling_guard")
    inst.components.ling_guard:SetLevel(1)
    inst.components.ling_guard:SetForm(FORM.QINGPING)

    inst:AddComponent("locomotor")

    inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true


    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst:AddComponent("knownlocations")
    inst:AddComponent("talker")

    -- 容器 + 溢出至容器
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ling_guard_basic")
    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = 0
    inst.components.inventory.GetOverflowContainer = function(inv)
        if inv.ignoreoverflow then return nil end
        return inv.inst.components.container
    end

    -- 睡眠回血
    SetupSleepHeal(inst)

    inst:AddComponent("timer")
    inst:AddComponent("ling_guard_plant")
    inst:AddComponent("ling_guard_skill")

    inst:AddComponent("colourtweener")

    -- 光照
    inst.Light:SetRadius(0.5)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(0.8, 0.8, 1.0)
    inst.Light:Enable(true)

    -- 大脑与状态机
    inst:SetBrain(brain)
    inst:SetStateGraph("SGling_guards")

    -- 形态：默认清平（由 ling_guard 组件管理）
    inst:ListenForEvent("ling_form_changed", function(inst, data)
        SetupBasicForm(inst, data and data.form or FORM.QINGPING)
    end)

    -- 附属容器保存/加载/清理（共用）
    inst.OnSave = OnSave_Common
    inst.OnPreLoad = OnPreLoad_Common
    inst.OnRemoveEntity = OnRemoveEntity_Common
    inst:ListenForEvent("despawn", onDespawn)
    inst:DoTaskInTime(0, CreateFogRevealerIcon)
    return inst
end

----------------------------
-- 高级守卫（ling_guard_elite）
----------------------------
local function ling_guard_elite_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:SetCanSleep(false)
    inst.MiniMapEntity:SetIcon("ling.tex")

    inst.AnimState:SetBank("loong_1")
    inst.AnimState:SetBuild("loong_1")
    inst.AnimState:SetScale(0.54, 0.54, 0.54)
    inst.AnimState:PlayAnimation("idle", true)

    inst.Transform:SetFourFaced()
    inst.DynamicShadow:SetSize(1.5, 0.75)

    inst:AddTag("ling_guard_elite")
    inst:AddTag("ling_summon")

    MakeCharacterPhysics(inst, 50, 0.5)

    inst.entity:SetPristine()

    inst:AddComponent("healthsyncer")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("named")
    -- TODO: 设置正确的名称
    inst.components.named.possiblenames = STRINGS.PIGNAMES
    inst.components.named:PickNewName()

    inst:AddComponent("health")
    inst.components.health.save_maxhealth = true

    inst:AddComponent("combat")
    inst.components.combat:SetRange(3)
    inst.components.combat:SetRetargetFunction(1, NormalRetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetAttackPeriod(1)

    inst:AddComponent("ling_guard")
    inst.components.ling_guard:SetLevel(3)

    inst:AddComponent("locomotor")

    inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst:AddComponent("talker")

    inst:AddComponent("timer")
    inst:AddComponent("ling_guard_plant")
    inst:AddComponent("ling_guard_skill")

    inst:AddComponent("colourtweener")

    inst.Light:SetRadius(1.5)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(0.8, 0.8, 1.0)
    inst.Light:Enable(true)

    inst:SetBrain(brain)
    inst:SetStateGraph("SGling_guards")

    inst:ListenForEvent("onhitother", function(inst, data)
        if data and data.target and data.target.prefab == "ling_guard_elite" then
            inst.components.combat:PauseAttacks(1)
        end
    end)
    -- 附属容器保存/加载/清理（共用）
    inst.OnSave = OnSave_Common
    inst.OnPreLoad = OnPreLoad_Common
    inst.OnRemoveEntity = OnRemoveEntity_Common
    inst:ListenForEvent("despawn", onDespawn)
    inst:DoTaskInTime(0, CreateFogRevealerIcon)
    return inst
end

return Prefab("ling_guard_basic", ling_guard_basic_fn, assets),
       Prefab("ling_guard_elite", ling_guard_elite_fn, assets)

