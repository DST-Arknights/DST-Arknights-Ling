require("stategraphs/commonstates")

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
            -- 弦惊使用start动画，其他使用默认start
            local spawn_anim = "start"
            if inst.guard_type == "xianjing" then
                spawn_anim = "start"  -- 弦惊有专门的start动画
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

            -- 根据守卫类型选择攻击动画
            local attack_anim = "attack_0"  -- 清平默认使用attack_0
            if inst.guard_type == "xiaoyao" then
                attack_anim = "attack_1"  -- 逍遥使用attack_1
            elseif inst.guard_type == "xianjing" then
                attack_anim = "attack"    -- 弦惊使用attack
            end
            inst.AnimState:PlayAnimation(attack_anim)
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                -- 播放攻击音效
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

    State{
        name = "level_up",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("level_up")
            -- 播放升级音效和特效
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
            -- 播放融合音效
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    -- 融合level_up动画播放完毕后，保持在这个状态等待被移除
                    -- 不转换到idle状态，因为守卫即将被移除
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

-- 添加移动状态，使用合适的动画
-- 走路状态使用 run 动画（因为清平可能没有专门的walk动画）
CommonStates.AddSimpleWalkStates(states, "run")

-- 跑步状态使用 run 动画
CommonStates.AddSimpleRunStates(states, "run")

-- 使用官方标准睡眠状态，动画名称为: sleep_pre, sleep_loop, sleep_pst
CommonStates.AddSleepStates(states, {
    sleeptimeline = {
        TimeEvent(1*FRAMES, function(inst)
            -- 清平进入睡眠状态
        end),
    },
})

return StateGraph("SGling_guards", states, events, "spawn")
