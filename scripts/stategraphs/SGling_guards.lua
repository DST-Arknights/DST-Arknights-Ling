require("stategraphs/commonstates")
local CONSTANTS = require("ark_constants_ling")

-------------------------------------------------------------------
-- 弦惊形态 AOE 岩刺攻击（类似 deerclops 的满地攻击）
-------------------------------------------------------------------
local ROCKSPIKE_RADIUS = 2
local ROCKSPIKE_AOE_ARC = 35  -- 扇形角度
local AREA_EXCLUDE_TAGS = { "DECOR", "FX", "INLIMBO", "NOCLICK", "playerghost", "shadow" }
local AREAATTACK_MUST_TAGS = { "_combat" }

-- 在指定位置执行 AOE 伤害
local function DoRockSpikeAOE(inst, x, z, data)
    if inst.components.combat == nil then return end
    inst.components.combat.ignorehitrange = true
    local ents = TheSim:FindEntities(x, 0, z, ROCKSPIKE_RADIUS + 0.5, AREAATTACK_MUST_TAGS, AREA_EXCLUDE_TAGS)
    for i, v in ipairs(ents) do
        if not data.targets[v] and v:IsValid() and not v:IsInLimbo() and
            not (v.components.health ~= nil and v.components.health:IsDead()) and
            v ~= inst
        then
            local range = ROCKSPIKE_RADIUS + v:GetPhysicsRadius(0)
            if v:GetDistanceSqToPoint(x, 0, z) < range * range and inst.components.combat:CanTarget(v) then
                inst.components.combat:DoAttack(v)
                data.targets[v] = true
            end
        end
    end
    inst.components.combat.ignorehitrange = false
end

-- 在指定位置生成岩刺特效
local function DoSpawnRockSpikeFx(inst, info, data, hitdelay)
    local fx = SpawnPrefab("ling_guard_elite_attack_hit_fx")
    if fx then
        fx.Transform:SetPosition(info.x, 0, info.z)
        fx.Transform:SetRotation(inst.Transform:GetRotation())
    end
    if hitdelay < FRAMES then
        DoRockSpikeAOE(inst, info.x, info.z, data)
    else
        inst:DoTaskInTime(hitdelay, DoRockSpikeAOE, info.x, info.z, data)
    end
end

-- 按距离排序（近到远）
local function SpikeInfoNearToFar(a, b)
    return a.radius < b.radius
end

-- 生成满地岩刺特效（类似 deerclops 的攻击方式）
local function SpawnEliteRockSpikeFx(inst)
    local data = { targets = {} }
    local attack_range = inst.components.combat and inst.components.combat:GetAttackRange() or 4

    local x, _, z = inst.Transform:GetWorldPosition()
    local angle = inst.Transform:GetRotation()
    local spikeinfo = {}

    local theta = angle * DEGREES
    local cos_theta = math.cos(theta)
    local sin_theta = math.sin(theta)

    -- 中心直线上的岩刺
    local num = 3
    for _ = 1, num do
        local radius = attack_range / num * _
        table.insert(spikeinfo,
        {
            x = x + radius * cos_theta,
            z = z - radius * sin_theta,
            radius = radius,
        })
    end

    -- 扇形区域内随机岩刺
    num = math.random(8, 12)
    for _ = 1, num do
        local randtheta = (angle + math.random(ROCKSPIKE_AOE_ARC * 2) - ROCKSPIKE_AOE_ARC) * DEGREES
        local radius = attack_range * math.sqrt(math.random())
        table.insert(spikeinfo,
        {
            x = x + radius * math.cos(randtheta),
            z = z - radius * math.sin(randtheta),
            radius = radius,
        })
    end

    -- 身后少量岩刺
    num = math.random(3, 5)
    local newarc = 180 - ROCKSPIKE_AOE_ARC
    for _ = 1, num do
        local randtheta = (angle - 180 + math.random(newarc * 2) - newarc) * DEGREES
        local radius = 2 * math.random() + 1
        table.insert(spikeinfo,
        {
            x = x + radius * math.cos(randtheta),
            z = z - radius * math.sin(randtheta),
            radius = radius,
        })
    end

    -- 按距离排序，近的先生成
    table.sort(spikeinfo, SpikeInfoNearToFar)

    -- 分批生成岩刺特效，按距离延迟
    for _, info in ipairs(spikeinfo) do
        local delay = info.radius * 0.5 * FRAMES  -- 延迟时间与距离成正比
        inst:DoTaskInTime(delay, DoSpawnRockSpikeFx, info, data, 0)
    end

    return data
end


local actionhandlers = {
    ActionHandler(ACTIONS.CHOP,   "chop"),
    ActionHandler(ACTIONS.MINE,   "mine"),
    ActionHandler(ACTIONS.DIG,    "dig"),
    ActionHandler(ACTIONS.HAMMER, "hammer"),
    ActionHandler(ACTIONS.INTERACT_WITH, "plant_dance"),
    ActionHandler(ACTIONS.PICKUP, "pick"),
    ActionHandler(ACTIONS.UNPIN, "unpin"),
    ActionHandler(ACTIONS.LING_GUARD_RECALL, "recall"),
    ActionHandler(ACTIONS.LING_TERRAFORM, "work_dig_pick"),
}

local events =
{
    CommonHandlers.OnLocomote(true, false),
    EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end),
    EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("attack", data.target)
        end
    end),
    EventHandler("level_changed", function(inst, data)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("level_up")
        end
    end),
    -- 添加睡眠事件处理
    EventHandler("gotosleep", function(inst)
        if inst.components.health == nil or (inst.components.health ~= nil and not inst.components.health:IsDead()) then
            inst.sg:GoToState(inst.sg:HasStateTag("sleeping") and "sleeping" or "sleep")
        end
    end),
    EventHandler("onwakeup", function(inst)
        if inst.sg:HasStateTag("sleeping") and not inst.sg:HasStateTag("nowake") and
           not (inst.components.health ~= nil and inst.components.health:IsDead()) then
            inst.sg:GoToState("wake")
        end
    end),
    EventHandler("ling_guard_do_nerd", function(inst)
        if inst.components.health ~= nil and inst.components.health:IsDead() then
            return
        end
        if inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("sleeping") then
            return
        end
        if not inst.sg:HasStateTag("idle") then
            return
        end
        inst.sg:GoToState("nerd")
    end),
}

local function goto_idle(inst)
    inst.sg:GoToState("idle")
end

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle", true)
        end,
    },

    State{
        name = "spawn",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            -- 简化：按标签或默认均使用同一登场动画
            inst.AnimState:PlayAnimation("start")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            local attack_anim = "attack_0"
            if inst.components.ling_guard.form == CONSTANTS.GUARD_FORM.XIANJING then
                attack_anim = "attack"
            elseif inst.components.ling_guard.form == CONSTANTS.GUARD_FORM.XIAOYAO then
                attack_anim = "attack_1"
            elseif inst.components.ling_guard.form == CONSTANTS.GUARD_FORM.QINGPING then
                attack_anim = "attack_0"
            end
            inst.AnimState:PlayAnimation(attack_anim)
        end,

        timeline =
        {
            TimeEvent(7*FRAMES, function(inst)
                -- 弦惊形态：满地岩刺 AOE 攻击（类似 deerclops）
                if inst.components.ling_guard.form == CONSTANTS.GUARD_FORM.XIANJING then
                    inst.sg.statemem.attackdata = SpawnEliteRockSpikeFx(inst)
                end
            end),
            TimeEvent(8*FRAMES, function(inst)
                -- 非弦惊形态：普通攻击
                if inst.components.ling_guard.form ~= CONSTANTS.GUARD_FORM.XIANJING then
                    local weapon = nil
                    local is_xiaoyao = (inst.replica and inst.replica.ling_guard and inst.replica.ling_guard.IsXiaoyao and inst.replica.ling_guard:IsXiaoyao())
                    if is_xiaoyao and inst._ling_fixed_weapon and inst._ling_fixed_weapon:IsValid() then
                        weapon = inst._ling_fixed_weapon
                    end
                    inst.components.combat:DoAttack(inst.sg.statemem.target, weapon)
                end
                -- 弦惊形态的伤害由 SpawnEliteRockSpikeFx 中的 DoRockSpikeAOE 处理
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    -- 统一工作状态：使用 attack_0 动画
    State{
        name = "chop",
        tags = { "chopping" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack_0")
        end,
        timeline = {
            TimeEvent(18*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events = {
            EventHandler("animover", goto_idle),
        },
    },

    -- 采矿：使用 attack_0 动作 + 稿子敲石头音效（不加 busy 标记，保证循环调度顺畅）
    State{
        name = "mine",
        tags = { "mining", "busy" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack_0")
        end,
        timeline = {
            TimeEvent(16*FRAMES, function(inst)
                if inst.SoundEmitter ~= nil then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_pick_rock")
                end
            end),
            TimeEvent(18*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events = {
            EventHandler("animover", goto_idle),
        },
    },

    -- 挖掘：使用 pick 动作 + 铲子音效
    State{
        name = "dig",
        tags = { "busy" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pick")
        end,
        timeline = {
            TimeEvent(14*FRAMES, function(inst)
                if inst.SoundEmitter ~= nil then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
                end
            end),
            TimeEvent(18*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events = {
            EventHandler("animover", goto_idle),
        },
    },

    -- 砸东西：使用 attack_0 动作 + 锤击音效
    State{
        name = "hammer",
        tags = { "busy" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack_0")
        end,
        timeline = {
            TimeEvent(14*FRAMES, function(inst)
                if inst.SoundEmitter ~= nil then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                end
            end),
            TimeEvent(18*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events = {
            EventHandler("animover", goto_idle),
        },
    },


    -- 拾取：使用 pick 动画
    State{
        name = "pick",
        tags = { "busy" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pick")
        end,
        timeline = {
            TimeEvent(14*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events = {
            EventHandler("animover", goto_idle),
        },
    },

    -- 照看作物：使用 pick 动画（不播放音乐）
    State{
        name = "plant_dance",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pick")
        end,

        onexit = function(inst)
            inst:ClearBufferedAction()
        end,

        timeline =
        {
            TimeEvent(14 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animover", goto_idle),
        },
    },

    -- 铲地皮：使用 attack_0 动画（守卫没有草叉，用攻击动作直接铲地皮）
    State{
        name = "work_dig_pick",
        tags = { "busy" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack_0")
        end,
        timeline = {
            TimeEvent(14*FRAMES, function(inst)
                if inst.SoundEmitter ~= nil then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
                end
            end),
            TimeEvent(18*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events = {
            EventHandler("animover", goto_idle),
        },
    },

    State{
        name = "nerd",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("nerd")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },


    State{
        name = "level_up",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("level_up")
            inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "fusion_levelup",
        tags = { "busy", "fusion" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("levelup")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    -- 保持该状态直到外部移除
                end
            end),
        },
    },

    -- 回收：先爆背包再播放死亡动画并删除
    State{
        name = "recall",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("die")
            local guid = inst.GUID
            local leader = inst.components.follower.leader
            local eliteLevel = leader and leader.components.ark_elite and leader.components.ark_elite.elite or 0
            if leader and eliteLevel >= 2 then
                leader:AddDebuff("so_is_writ_an_ode_to_wine_buff" .. guid, "so_is_writ_an_ode_to_wine_buff")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst:Remove()
                end
            end),
        },
    },

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("die")
            inst.components.lootdropper:DropLoot()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst:Remove()
                end
            end),
        },
    },
}

-- 行走/跑步/睡眠
CommonStates.AddSimpleWalkStates(states, "idle")
CommonStates.AddSimpleRunStates(states, "run")
local sleep_health_task_symbol = Symbol("sleep_health_task")
CommonStates.AddSleepStates(states, nil, {
    onsleep = function(inst)
        inst[sleep_health_task_symbol] = inst:DoPeriodicTask(1, function()
            if inst.components.health and not inst.components.health:IsDead() then
                local max_health = inst.components.health.maxhealth
                local current_health = inst.components.health.currenthealth
                if current_health < max_health then
                    inst.components.health:DoDelta(max_health * 0.02)
                end
            end
        end)
    end,
    onwake = function(inst)
        if inst[sleep_health_task_symbol] then inst[sleep_health_task_symbol]:Cancel() end
    end,
})
CommonStates.AddSimpleActionState(states, "unpin", "pick", 21 * FRAMES, { "busy" })

return StateGraph("SGling_guards", states, events, "spawn", actionhandlers)
