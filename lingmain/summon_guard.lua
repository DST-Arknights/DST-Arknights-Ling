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

-- 诗意值ui
AddClassPostConstruct("widgets/controls", function(self)
  if not self.owner or self.owner.prefab ~= "ling" then
    return
  end
  local LingPoetryBadge = require "widgets/ling_poetry"
  -- 将诗意值 UI 直接添加到 topright_root，这样坐标系统更简单
  self.ling_poetry = self.topright_root:AddChild(LingPoetryBadge(self.owner))

  self.owner:DoTaskInTime(.5, function(owner)
    -- 只有在没有保存位置的情况下才设置默认位置
    if not self.ling_poetry.position_loaded then
      -- 获取 statusdisplays 的位置作为参考
      local status_pos = self.status:GetPosition()
      local status_world_pos = self.status:GetWorldPosition()
      local topright_world_pos = self.topright_root:GetWorldPosition()

      -- 计算相对于 topright_root 的位置
      local relative_x = status_world_pos.x - topright_world_pos.x
      local relative_y = status_world_pos.y - topright_world_pos.y

      -- 设置默认位置（在状态显示的右侧）
      self.ling_poetry:SetPosition(relative_x + 80, relative_y, 0)
      self.ling_poetry:SetScale(self.status:GetScale())
    end
  end)

  -- 监听幽灵模式变化
  local _SetGhostMode = self.status.SetGhostMode
  function self.status:SetGhostMode(ghost_mode, ...)
    _SetGhostMode(self, ghost_mode, ...)
    print("SetGhostMode", ghost_mode)
    if self.parent and self.parent.ling_poetry then
      if ghost_mode then
        self.parent.ling_poetry:RequestCloseCallPanel()
        self.ling_guard_panel:RequestClose()
        self.parent.ling_poetry:Hide()
      else
        self.parent.ling_poetry:Show()
      end
    end
  end

  
  local LingGuardPanel = require "widgets/ling_guard_panel"
  self.topright_root.ling_guard_panel = self.topright_root:AddChild(LingGuardPanel(self.owner))
  self.ling_guard_panel = self.topright_root.ling_guard_panel
  self.topright_root.ling_guard_panel:SetPosition(-800, -400, 0)
  self.topright_root.ling_guard_panel:SetScale(0.6, 0.6, 0.6)
end)

-- 添加召唤系统的RPC通信
AddModRPCHandler("ling_summon", "summon_guard", function(player, guard_type, slot_index)
  if not player or player.prefab ~= "ling" then
    return
  end
  if not player.components.ling_summon_manager then
    return
  end

  -- 直接调用召唤管理器组件的方法，让它们处理诗意检查和扣除
  if guard_type == "qingping" then
    player.components.ling_summon_manager:SummonQingping(slot_index)
  elseif guard_type == "xiaoyao" then
    player.components.ling_summon_manager:SummonXiaoyao(slot_index)
  elseif guard_type == "xianjing" then
    player.components.ling_summon_manager:SummonXianjing(slot_index)
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

AddModRPCHandler("ling_summon", "request_open_caller", function(player)
  if player and player.components.ling_summon_manager then
    player.components.ling_summon_manager:RequestOpenCaller()
  end
end)

AddModRPCHandler("ling_summon", "request_close_caller", function(player)
  if player.components.ling_summon_manager then
    player.components.ling_summon_manager:RequestCloseCaller()
  end
end)

AddClientModRPCHandler("ling_summon", "open_caller", function(summaries, max_slots)
  if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_poetry then
    summaries = json.decode(summaries)
    ThePlayer.HUD.controls.ling_poetry:OpenCallPanel(summaries, max_slots)
  end
end)

AddModRPCHandler("ling_summon", "request_open_guard_panel", function(player, slot_index)
  if player.components.ling_summon_manager then
    player.components.ling_summon_manager:RequestOpenGuardPanel(slot_index)
  end
end)

AddModRPCHandler("ling_summon", "request_close_guard_panel", function(player)
  if player.components.ling_summon_manager then
    player.components.ling_summon_manager:RequestCloseGuardPanel()
  end
end)

AddClientModRPCHandler("ling_summon", "open_guard_panel", function(guard)
  if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_guard_panel then
    guard = json.decode(guard)
    ThePlayer.HUD.controls.ling_guard_panel:Open(guard)
  end
end)

-- 引入全局常量
local CONSTANTS = require "ark_constants_ling"
local GUARD_TYPE = CONSTANTS.GUARD_TYPE

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
                if data.type ~= GUARD_TYPE.XIANJING then
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
                        if inst.components.ling_summon_manager then
                            inst.components.ling_summon_manager:SpawnGuardAtPosition(data.type, data.level, spawn_x, spawn_z, data.slots)
                        end
                    end)
                else
                    -- 直接召唤（弦惊或特效创建失败）
                    if inst.components.ling_summon_manager then
                        inst.components.ling_summon_manager:SpawnGuardAtPosition(data.type, data.level, spawn_x, spawn_z, data.slots)
                    end
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
