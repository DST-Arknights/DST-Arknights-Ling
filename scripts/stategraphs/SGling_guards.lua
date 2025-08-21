require("stategraphs/commonstates")

local actionhandlers = {
    ActionHandler(ACTIONS.CHOP,   "work_attack0"),
    ActionHandler(ACTIONS.MINE,   "work_attack0"),
    ActionHandler(ACTIONS.DIG,    "work_attack0"),
    ActionHandler(ACTIONS.HAMMER, "work_attack0"),
    ActionHandler(ACTIONS.PICKUP, "pick"),
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
}

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
            local spawn_anim = "start"
            if inst.guard_type == "xianjing" then
                spawn_anim = "start"
            end
            inst.AnimState:PlayAnimation(spawn_anim)
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
            if inst.guard_type == "xiaoyao" then
                attack_anim = "attack_1"
            elseif inst.guard_type == "xianjing" then
                attack_anim = "attack"
            end
            inst.AnimState:PlayAnimation(attack_anim)
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/attack")
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
        name = "work_attack0",
        tags = { "busy" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack_0")
        end,
        timeline = {
            TimeEvent(15*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
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
            TimeEvent(6*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
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
            if inst.components.talker then
                inst.components.talker:Say("等级提升！")
            end
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
CommonStates.AddSimpleWalkStates(states, "run")
CommonStates.AddSimpleRunStates(states, "run")
CommonStates.AddSleepStates(states, {
    sleeptimeline = {
        TimeEvent(1*FRAMES, function(inst) end),
    },
})

return StateGraph("SGling_guards", states, events, "spawn", actionhandlers)
