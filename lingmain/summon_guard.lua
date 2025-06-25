-- 令的守卫召唤物配置
TUNING.LING_GUARDS = {
  -- 清平配置
  QINGPING = {
    LEVELS = {
      -- 无精英化 (elite_level = 0)
      [0] = {
        HEALTH = 300,
        DAMAGE = 30,
        DAMAGE_REDUCTION = 0.1, -- 10%免伤
        ATTACK_RANGE = 4,
        WALK_SPEED = 2.5,
        RUN_SPEED = 5,
        ATTACK_PERIOD = 4,
        SUMMON_COST = 10, -- 召唤消耗诗意
      },
      -- 精英化一 (elite_level = 1)
      [1] = {
        HEALTH = 500,
        DAMAGE = 50,
        DAMAGE_REDUCTION = 0.2, -- 20%免伤
        ATTACK_RANGE = 4,
        WALK_SPEED = 3,
        RUN_SPEED = 6,
        ATTACK_PERIOD = 3,
        SUMMON_COST = 9,
      },
      -- 精英化二 (elite_level = 2)
      [2] = {
        HEALTH = 700,
        DAMAGE = 80,
        DAMAGE_REDUCTION = 0.4, -- 40%免伤
        ATTACK_RANGE = 4,
        WALK_SPEED = 3.5,
        RUN_SPEED = 7,
        ATTACK_PERIOD = 2,
        SUMMON_COST = 8,
      },
    }
  },

  -- 逍遥配置（精一后解锁）
  XIAOYAO = {
    LEVELS = {
      -- 精英化一 (elite_level = 1)
      [1] = {
        HEALTH = 100,
        DAMAGE = 70,
        DAMAGE_REDUCTION = 0.05, -- 5%免伤
        ATTACK_RANGE = 15,
        WALK_SPEED = 3,
        RUN_SPEED = 7,
        ATTACK_PERIOD = 5,
        SUMMON_COST = 9,
      },
      -- 精英化二 (elite_level = 2)
      [2] = {
        HEALTH = 200,
        DAMAGE = 100,
        DAMAGE_REDUCTION = 0.1, -- 10%免伤
        ATTACK_RANGE = 15,
        WALK_SPEED = 3.5,
        RUN_SPEED = 8,
        ATTACK_PERIOD = 5,
        SUMMON_COST = 8,
      },
    }
  },

  -- 弦惊配置（精二后解锁）
  XIANJING = {
    LEVELS = {
      -- 精英化二 (elite_level = 2)
      [2] = {
        HEALTH = 2100,
        DAMAGE = 220,
        DAMAGE_REDUCTION = 0.7, -- 70%免伤
        ATTACK_RANGE = 4,
        WALK_SPEED = 5,
        RUN_SPEED = 5,
        ATTACK_PERIOD = 3,
        SUMMON_COST = 16, -- 相当于两个召唤物
      },
    }
  }
}

-- 添加召唤系统的RPC通信
AddModRPCHandler("ling_summon", "summon_guard", function(player, guard_type, level)
  if not player or player.prefab ~= "ling" then
    return
  end

  -- 直接调用ling的召唤方法，让它们处理诗意检查和扣除
  if guard_type == "qingping" then
    player:SummonQingping(level)
  elseif guard_type == "xiaoyao" then
    player:SummonXiaoyao(level)
  elseif guard_type == "xianjing" then
    player:SummonXianjing(level)
  end
end)

-- 添加命令系统的RPC通信
AddModRPCHandler("ling_summon", "command_guards", function(player, command_type)
  if not player or player.prefab ~= "ling" then
    return
  end

  local x, y, z = player.Transform:GetWorldPosition()
  local guards = TheSim:FindEntities(x, y, z, 30, {"ling_summon"})

  for _, guard in ipairs(guards) do
    if guard.components.follower and guard.components.follower.leader == player then
      if command_type == "guard" or command_type == "attack" or command_type == "cautious" then
        guard:SetBehaviorMode(command_type)
      end
    end
  end
end)

-- 添加令的召唤状态图
AddStategraphState("wilson", State{
    name = "ling_summon",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst, data)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("staff")

        -- 播放唤星者魔杖的施法音效
        inst.SoundEmitter:PlaySound("dontstarve/common/staffteleport")

        -- 令的提灯渐变发光效果
        local lantern = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if lantern and lantern.prefab == "ling_lantern" then
            -- 创建提灯发光特效
            if lantern._body and lantern._body.Light then
                -- 保存原始光照设置
                inst.sg.statemem.original_light_radius = lantern._body.Light:GetRadius()
                inst.sg.statemem.original_light_intensity = lantern._body.Light:GetIntensity()
                inst.sg.statemem.original_light_falloff = lantern._body.Light:GetFalloff()

                -- 创建施法光照特效
                local casting_light = SpawnPrefab("staff_castinglight")
                if casting_light then
                    casting_light.entity:SetParent(lantern._body.entity)
                    casting_light.Transform:SetPosition(0, 0, 0)
                    casting_light:SetUp({223/255, 208/255, 69/255}, 2, 0) -- 唤星者魔杖的颜色，2秒持续时间
                    inst.sg.statemem.casting_light = casting_light
                end

                -- 增强提灯本身的光照
                lantern._body.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
                lantern._body.AnimState:SetLightOverride(1)
            end
        end

        -- 保存召唤数据
        inst.sg.statemem.summon_data = data
        -- 标记召唤未完成
        inst.sg.statemem.summon_completed = false
        -- 设置2秒超时
        inst.sg:SetTimeout(2.1) -- 稍微长一点确保时间轴完成
    end,

    timeline =
    {
        -- 0.5秒：施法开始，扣除诗意
        TimeEvent(0.5, function(inst)
            local data = inst.sg.statemem.summon_data
            if data then
                -- 扣除诗意
                local poetry_component = inst.components.ling_poetry
                if poetry_component then
                    poetry_component:Dirty(-data.cost)
                end

                -- 播放施法进行音效
                inst.SoundEmitter:PlaySound("dontstarve/common/staff_star_create")
            end
        end),

        -- 1.5秒：确定召唤位置，创建特效
        TimeEvent(1.5, function(inst)
            local data = inst.sg.statemem.summon_data
            if data then
                -- 确定召唤位置
                local x, y, z = inst.Transform:GetWorldPosition()
                local offset = FindWalkableOffset(Vector3(x, y, z), math.random() * 2 * PI, 3, 8)
                local spawn_x, spawn_z
                if offset then
                    spawn_x = x + offset.x
                    spawn_z = z + offset.z
                else
                    spawn_x = x + 2
                    spawn_z = z
                end

                -- 保存召唤位置
                inst.sg.statemem.spawn_x = spawn_x
                inst.sg.statemem.spawn_y = y
                inst.sg.statemem.spawn_z = spawn_z

                -- 创建召唤特效（除了弦惊）
                if data.guard_type ~= "xianjing" then
                    local fx = SpawnPrefab("ling_summon_fx")
                    if fx then
                        fx.Transform:SetPosition(spawn_x, y, spawn_z)
                        inst.sg.statemem.summon_fx = fx
                    end
                end
            end
        end),

        -- 2.0秒：施法完成，执行召唤
        TimeEvent(2.0, function(inst)
            local data = inst.sg.statemem.summon_data
            if data and not inst.sg.statemem.summon_completed then
                inst.sg.statemem.summon_completed = true

                -- 保存召唤位置到局部变量，避免状态图退出后访问失败
                local spawn_x = inst.sg.statemem.spawn_x
                local spawn_z = inst.sg.statemem.spawn_z

                -- 如果有特效，设置召唤回调
                if inst.sg.statemem.summon_fx and inst.sg.statemem.summon_fx:IsValid() then
                    inst.sg.statemem.summon_fx:SetSpawnCallback(function()
                        inst:SpawnGuardAtPosition(data.guard_type, data.elite_level, spawn_x, spawn_z)
                    end)
                else
                    -- 直接召唤（弦惊或特效创建失败）
                    inst:SpawnGuardAtPosition(data.guard_type, data.elite_level, spawn_x, spawn_z)
                end
            end
        end),
    },

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                -- 动画结束但还没到2秒，继续等待
                inst.AnimState:PlayAnimation("staff", true)
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:GoToState("idle")
    end,

    onexit = function(inst)
        -- 恢复提灯光照效果
        local lantern = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if lantern and lantern.prefab == "ling_lantern" and lantern._body then
            -- 移除施法光照特效
            if inst.sg.statemem.casting_light and inst.sg.statemem.casting_light:IsValid() then
                inst.sg.statemem.casting_light:Remove()
            end

            -- 恢复原始光照设置
            if inst.sg.statemem.original_light_radius and inst.sg.statemem.original_light_intensity then
                lantern._body.Light:SetRadius(inst.sg.statemem.original_light_radius)
                lantern._body.Light:SetIntensity(inst.sg.statemem.original_light_intensity)
            end
            if inst.sg.statemem.original_light_falloff then
                lantern._body.Light:SetFalloff(inst.sg.statemem.original_light_falloff)
            end

            -- 清除视觉效果
            lantern._body.AnimState:ClearBloomEffectHandle()
            lantern._body.AnimState:SetLightOverride(0)
        end

        -- 如果召唤被打断，清理特效
        if inst.sg.statemem.summon_fx and inst.sg.statemem.summon_fx:IsValid() and
           not inst.sg.statemem.summon_completed then
            inst.sg.statemem.summon_fx:Remove()
        end

        -- 清理召唤数据
        inst.sg.statemem.summon_data = nil
        inst.sg.statemem.summon_fx = nil
        inst.sg.statemem.summon_completed = nil
        inst.sg.statemem.spawn_x = nil
        inst.sg.statemem.spawn_y = nil
        inst.sg.statemem.spawn_z = nil
    end,
})

AddStategraphState("wilson_client", State{
    name = "ling_summon",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("staff")
        inst.SoundEmitter:PlaySound("dontstarve/common/staffteleport")
        -- 设置2秒超时
        inst.sg:SetTimeout(2.1) -- 稍微长一点确保时间轴完成
    end,

    timeline =
    {
        -- 0.5秒：播放施法进行音效
        TimeEvent(0.5, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/common/staff_star_create")
        end),

        -- 2.0秒：施法完成，准备结束
        TimeEvent(2.0, function(inst)
            -- 客户端不需要执行召唤逻辑，只需要同步动画和音效
        end),
    },

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                -- 动画结束但还没到2秒，继续等待
                inst.AnimState:PlayAnimation("staff", true)
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:GoToState("idle")
    end,
})
