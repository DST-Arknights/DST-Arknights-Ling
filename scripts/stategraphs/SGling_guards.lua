require("stategraphs/commonstates")
local CONSTANTS = require("ark_constants_ling")


local actionhandlers = {
    ActionHandler(ACTIONS.CHOP,   "chop"),
    ActionHandler(ACTIONS.MINE,   "mine"),
    ActionHandler(ACTIONS.DIG,    "dig"),
    ActionHandler(ACTIONS.HAMMER, "hammer"),
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
                -- 弦惊特效
                if inst.components.ling_guard.form == CONSTANTS.GUARD_FORM.XIANJING then
                    local target = inst.sg.statemem.target
                    local x, y, z = target.Transform:GetWorldPosition()
                    local fx = SpawnPrefab("ling_guard_elite_attack_hit_fx")
                    lprint("elite attack hit fx spawned at", x, y, z)
                    fx.Transform:SetPosition(x, y, z)
                end
            end),
            TimeEvent(8*FRAMES, function(inst)
                local weapon = nil
                local is_xiaoyao = (inst.replica and inst.replica.ling_guard and inst.replica.ling_guard.IsXiaoyao and inst.replica.ling_guard:IsXiaoyao())
                if is_xiaoyao and inst._ling_fixed_weapon and inst._ling_fixed_weapon:IsValid() then
                    weapon = inst._ling_fixed_weapon
                end
                inst.components.combat:DoAttack(inst.sg.statemem.target, weapon)
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
        tags = { "mining" },
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
            TimeEvent(30*FRAMES, function(inst)
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

    -- 回收：先爆背包再播放死亡动画并删除
    State{
        name = "recall",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("die")
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
CommonStates.AddSimpleWalkStates(states, "run")
CommonStates.AddSimpleRunStates(states, "run")
CommonStates.AddSleepStates(states, {
    sleeptimeline = {
        TimeEvent(1*FRAMES, function(inst) end),
    },
})
CommonStates.AddSimpleActionState(states, "unpin", "pick", 21 * FRAMES, { "busy" })

return StateGraph("SGling_guards", states, events, "spawn", actionhandlers)
