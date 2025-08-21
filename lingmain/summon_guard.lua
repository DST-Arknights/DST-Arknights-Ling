local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"
local GUARD_TYPE = CONSTANTS.GUARD_TYPE

-- 令的守卫召唤物配置
TUNING.LING_GUARDS = {
  -- 清平配置
  [GUARD_TYPE.QINGPING] = {
    LEVELS = {
      -- 无精英化 (elite_level = 1)
      [1] = {
        HEALTH = 300,
        DAMAGE = 30,
        DAMAGE_REDUCTION = 0.1, -- 10%免伤
        ATTACK_RANGE = 4,
        WALK_SPEED = 2.5,
        RUN_SPEED = 5,
        ATTACK_PERIOD = 4,
        SUMMON_COST = 10, -- 召唤消耗诗意
      },
      -- 精英化一 (elite_level = 2)
      [2] = {
        HEALTH = 500,
        DAMAGE = 50,
        DAMAGE_REDUCTION = 0.2, -- 20%免伤
        ATTACK_RANGE = 4,
        WALK_SPEED = 3,
        RUN_SPEED = 6,
        ATTACK_PERIOD = 3,
        SUMMON_COST = 9,
      },
      -- 精英化二 (elite_level = 3)
      [3] = {
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
  [GUARD_TYPE.XIAOYAO] = {
    LEVELS = {
      -- 精英化一 (elite_level = 2)
      [2] = {
        HEALTH = 100,
        DAMAGE = 70,
        DAMAGE_REDUCTION = 0.05, -- 5%免伤
        ATTACK_RANGE = 15,
        WALK_SPEED = 3,
        RUN_SPEED = 7,
        ATTACK_PERIOD = 5,
        SUMMON_COST = 9,
      },
      -- 精英化二 (elite_level = 3)
      [3] = {
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
  [GUARD_TYPE.XIANJING] = {
    LEVELS = {
      -- 精英化二 (elite_level = 3)
      [3] = {
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

TUNING.LING_GUARD_PLANT = {
  {
    MAX_CROP = 40,
    TIME_PER_CROP = 8, -- * 60,
  },
  {
    MAX_CROP = 60,
    TIME_PER_CROP = 6 * 60,
  },
  {
    MAX_CROP = 80,
    TIME_PER_CROP = 4 * 60,
  },
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
        self.parent.ling_poetry:CloseCallPanel()
        self.ling_guard_panel:RequestClose()
        self.parent.ling_poetry:Hide()
      else
        self.parent.ling_poetry:Show()
      end
    end
  end

  local PANEL_SCALE = CONSTANTS.LING_GUARD_PANEL_SCALE
  local LingGuardPanel = require "widgets/ling_guard_panel"
  self.containerroot.ling_guard_panel = self.containerroot:AddChild(LingGuardPanel(self.owner))
  self.ling_guard_panel = self.containerroot.ling_guard_panel
  self.ling_guard_panel:SetPosition(unpack(CONSTANTS.LING_GUARD_PANEL_POSITION))
  self.ling_guard_panel:SetScale(PANEL_SCALE, PANEL_SCALE, PANEL_SCALE)

  -- 关闭按钮无法单独调整图层, 需要与面板本身分开,以把容器夹在中间
  local LingCloseContainer = require "widgets/ling_close_container"
  self.containerroot.ling_close_container = self.containerroot:AddChild(LingCloseContainer(self.owner))
  self.ling_close_container = self.containerroot.ling_close_container
  local pos = Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_POSITION)) + Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_CLOSE_CONTAINER_POSITION)) * PANEL_SCALE
  print("pos", pos.x, pos.y, pos.z)
  self.ling_close_container:SetPosition(pos.x, pos.y, pos.z)
  self.ling_close_container:SetScale(PANEL_SCALE, PANEL_SCALE, PANEL_SCALE)
  self.ling_close_container:Hide()
end)

AddClassPostConstruct("screens/playerhud", function(self)
  local _OpenContainer = self.OpenContainer
  function self:OpenContainer(container, side)
    _OpenContainer(self, container, side)
    local containerReplica = container.replica.container
    print("OpenContainer", containerReplica.type)
    if containerReplica.type == "ling_guard_container" then
      local owned = ThePlayer.replica.ling_summon_manager and ThePlayer.replica.ling_summon_manager:GetGuardSlotIndex(container)
      if owned and self.controls.ling_guard_panel then
        self.controls.ling_guard_panel:MoveToBack()
        self.controls.ling_guard_panel.container_open:Hide()
        self.controls.ling_close_container:Open()
        self.controls.ling_close_container:MoveToFront()
        for con, _ in pairs(self.controls.containers) do
          if con.replica and con.replica.container.type == "ling_guard_plant_club" then
            self.controls.containers[con]:MoveToBack()
          end
        end
        for con, _ in pairs(self.controls.containers) do
          if con.replica and con.replica.container.type == "ling_guard_plant_container" then
            self.controls.containers[con]:MoveToBack()
          end
        end
      end
    elseif containerReplica.type == "ling_guard_plant_container" then
      -- 关闭plant_bg
      self.controls.ling_guard_panel.plant_bg:Hide()
      local pos = containerReplica.widget.pos
      local openPos = containerReplica.widget.openPos
      self.controls.containers[container]:MoveTo(pos, openPos, 0.5)
      -- 根据等级关闭多余的插槽
      local parent = container.entity:GetParent()
      local enabledSlots = parent and parent.replica.ling_guard_plant and parent.replica.ling_guard_plant:GetEnabledSlots() or nil
      if enabledSlots then
        for idx, inv in pairs(self.controls.containers[container].inv) do
          local show = false
          for _, enabledIdx in ipairs(enabledSlots) do
            if idx == enabledIdx then
              show = true
              break
            end
          end
          if not show then
            inv:Hide()
            inv:Disable()
          end
        end
      end
      local level = parent and parent.replica.ling_guard_plant and parent.replica.ling_guard_plant:GetLevel() or 1
      if level == 2 then
        self.controls.containers[container].bganim:GetAnimState():PlayAnimation("open_1")
      elseif level == 3 then
        self.controls.containers[container].bganim:GetAnimState():PlayAnimation("open_2")
      end
    elseif containerReplica.type == "ling_guard_plant_club" then
      for con, _ in pairs(self.controls.containers) do
        if con.replica and con.replica.container.type == "ling_guard_plant_container" then
          self.controls.containers[con]:MoveToBack()
        end
      end
    end
  end
  local _CloseContainer = self.CloseContainer
  function self:CloseContainer(container, side)
    local containerReplica = container.replica.container
    if containerReplica.type == "ling_guard_container" then
      local owned = ThePlayer.replica.ling_summon_manager and ThePlayer.replica.ling_summon_manager:GetGuardSlotIndex(container)
      if owned and self.controls.ling_guard_panel then
        self.controls.ling_guard_panel.container_open:Show()
        self.controls.ling_close_container:Hide()
      end
    elseif containerReplica.type == "ling_guard_plant_container" then
      local pos = containerReplica.widget.pos
      local openPos = containerReplica.widget.openPos
      local containerWidget = self.controls.containers[container]
      self.controls.containers[container] = nil
      -- 期间禁用所有的插槽交互
      for idx, inv in pairs(containerWidget.inv) do
        inv:Disable()
      end
      containerWidget:MoveTo(openPos, pos, 0.1, function()
        self.controls.ling_guard_panel.plant_bg:Show()
        self.controls.ling_guard_panel:RefreshPlanting()
        containerWidget:Close()
      end)
      return
    end
    _CloseContainer(self, container, side)
  end
end)

AddComponentPostInit("container", function(self)
  local _Open = self.Open
  function self:Open(doer)
    if not doer.components.ling_summon_manager then
      return _Open(self, doer)
    end
    local owned = doer.components.ling_summon_manager:GetGuardSlotIndex(self.inst)
    if owned then
      doer.components.ling_summon_manager.openedContainerInst = self.inst
      doer.components.ling_summon_manager:RequestOpenGuardPanel(self.inst)
    elseif self.inst:HasTag("ling_summon") then
      doer.components.ling_summon_manager:RequestCloseGuardPanel()
    end
    return _Open(self, doer)
  end

  local _Close = self.Close
  function self:Close(doer)
    local keepOpen = doer and doer.components.ling_summon_manager and doer.components.ling_summon_manager.openedContainerInst == self.inst
    if keepOpen then
      return
    end
    print("container closed with out keep open")
    return _Close(self, doer)
  end
end)

-- 添加召唤系统的RPC通信
AddModRPCHandler("ling_summon", "summon_guard", function(player, guard_type, slot_index)
  print("summon_guard", guard_type, slot_index)
  if not player or player.prefab ~= "ling" then
    return
  end
  if not player.components.ling_summon_manager then
    return
  end

  -- 直接调用召唤管理器组件的方法，让它们处理诗意检查和扣除
  if guard_type == GUARD_TYPE.QINGPING then
    player.components.ling_summon_manager:SummonQingping(slot_index)
  elseif guard_type == GUARD_TYPE.XIAOYAO then
    player.components.ling_summon_manager:SummonXiaoyao(slot_index)
  elseif guard_type == GUARD_TYPE.XIANJING then
    player.components.ling_summon_manager:SummonXianjing(slot_index)
  end
end)

-- 移除了 command_guards RPC 处理器，功能将在组件中重构



AddModRPCHandler("ling_summon", "request_open_guard_panel", function(player, guard_inst)
  if player.components.ling_summon_manager then
    player.components.ling_summon_manager:RequestOpenGuardPanel(guard_inst)
  end
end)

AddClientModRPCHandler("ling_summon", "open_guard_panel", function(guard_inst)
  if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_guard_panel then
    print("open_guard_panel", guard_inst and guard_inst.prefab or "nil")
    ThePlayer.HUD.controls.ling_guard_panel:Open(guard_inst)
  end
end)

AddModRPCHandler("ling_summon", "request_close_guard_panel", function(player, guard_inst)
  print("request_close_guard_panel", guard_inst and guard_inst.prefab or "nil")
  if player.components.ling_summon_manager then
    player.components.ling_summon_manager:RequestCloseGuardPanel(guard_inst)
  end
end)

AddClientModRPCHandler("ling_summon", "close_guard_panel", function()
  print("close_guard_panel")
  if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.ling_guard_panel then
    ThePlayer.HUD.controls.ling_guard_panel:Close()
  end
end)

AddModRPCHandler("ling_summon", "request_open_container", function(player, guard_inst)
  if player.components.ling_summon_manager then
    player.components.ling_summon_manager:RequestOpenContainer(guard_inst)
  end
end)

AddModRPCHandler("ling_summon", "request_close_container", function(player)
  if player.components.ling_summon_manager then
    player.components.ling_summon_manager:RequestCloseContainer()
  end
end)

AddModRPCHandler("ling_summon", "change_guard_behavior", function(player, guard_inst, mode)
  if not player or player.prefab ~= "ling" then
    return
  end

  if not guard_inst or not guard_inst:IsValid() then
    return
  end

  -- 验证这个守卫是否属于这个玩家
  if player.components.ling_summon_manager then
    local is_owned = player.components.ling_summon_manager:IsGuardOwnedByPlayer(guard_inst)
    if is_owned and guard_inst.components.ling_guard then
      guard_inst.components.ling_guard:SetBehaviorMode(mode)
    end
  end
end)

AddModRPCHandler("ling_summon", "change_guard_work", function(player, guard_inst, mode)
  if not player or player.prefab ~= "ling" then
    return
  end

  if not guard_inst or not guard_inst:IsValid() then
    return
  end

  -- 验证这个守卫是否属于这个玩家
  if player.components.ling_summon_manager then
    local is_owned = player.components.ling_summon_manager:IsGuardOwnedByPlayer(guard_inst)
    if is_owned and guard_inst.components.ling_guard then
      guard_inst.components.ling_guard:SetWorkMode(mode)
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
        -- 设置2秒超时（对齐动画帧）
        inst.sg:SetTimeout(60*FRAMES)
    end,

    timeline =
    {
        -- 15帧：施法开始，扣除诗意
        TimeEvent(15 * FRAMES, function(inst)
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

        -- 30帧：确定召唤位置，创建特效
        TimeEvent(30 * FRAMES, function(inst)
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
                    fx.Transform:SetPosition(spawn_x, y, spawn_z)
                    inst.sg.statemem.summon_fx = fx
                end
            end
        end),

        -- 45帧：施法完成，执行召唤
        TimeEvent(45 * FRAMES, function(inst)
            local data = inst.sg.statemem.summon_data
            if data and not inst.sg.statemem.summon_completed then
                inst.sg.statemem.summon_completed = true

                -- 保存召唤位置到局部变量，避免状态图退出后访问失败
                local spawn_x = inst.sg.statemem.spawn_x
                local spawn_z = inst.sg.statemem.spawn_z

                -- 在时间线上直接执行生成，不依赖特效回调
                if inst.components.ling_summon_manager then
                    inst.components.ling_summon_manager:SpawnGuardAtPosition(data.type, data.level, spawn_x, spawn_z, data.slots)
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

        -- 如果召唤未完成，回滚槽位状态
        if not inst.sg.statemem.summon_completed then
            local data = inst.sg.statemem.summon_data
            if data and data.slots and inst.components.ling_summon_manager then
                inst.components.ling_summon_manager:CancelSummon(data.slots)
            end
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
        -- 设置2秒超时（对齐动画帧）
        inst.sg:SetTimeout(60 * FRAMES)
    end,

    timeline =
    {
        -- 15帧：播放施法进行音效
        TimeEvent(15 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/common/staff_star_create")
        end),

        -- 45帧：客户端结束占位
        TimeEvent(45 * FRAMES, function(inst)
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
