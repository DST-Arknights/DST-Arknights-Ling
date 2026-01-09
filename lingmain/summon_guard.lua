local ImageButton = require "widgets/imagebutton"
local CONSTANTS = require "ark_constants_ling"
local LingGuardPanel = require "widgets/ling_guard_panel"
local LingCloseContainer = require "widgets/ling_close_container"
local LingPoetryBadge = require "widgets/ling_poetry"

local FORM = CONSTANTS.GUARD_FORM
-- 守卫数值与消耗配置已迁移至 scripts/ling_guard_tuning.lua（通过 require("ling_guard_tuning") 使用）
local LING_TUNING = require("ling_guard_tuning")



-- 自定义动作：守卫挖地皮（无需工具）
local LING_TERRAFORM = AddAction("LING_TERRAFORM", "Terraform", function(act)
    if act.doer == nil then return false end
    local pt = act:GetActionPoint()
    if pt == nil then return false end

    local world = TheWorld
    local map = world and world.Map or nil
    if map == nil then return false end

    local px, py, pz = pt:Get()
    if not map:CanTerraformAtPoint(px, py, pz) then
        return false
    end

    local original_tile_type = map:GetTileAtPoint(px, py, pz)
    local tx, ty = map:GetTileCoordsAtPoint(px, py, pz)
    local undertile = TheWorld.components.undertile and TheWorld.components.undertile:GetTileUnderneath(tx, ty) or WORLD_TILES.DIRT

    map:SetTile(tx, ty, undertile)

    -- 触发地皮挖掘后的掉落与效果
    if HandleDugGround ~= nil then
        HandleDugGround(original_tile_type, px, py, pz)
    end


    return true
end)

-- 自定义动作：回收守卫（由守卫自身执行，交给状态图处理）
local LING_GUARD_RECALL = AddAction("LING_GUARD_RECALL", "Recall", function(act)
    return true
end)

-- 诗意值ui
AddClassPostConstruct("widgets/controls", function(self)
  self.guard_panels = {}
  if not self.owner or self.owner.prefab ~= "ling" then
    return
  end
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
  local _SetGhostMode = self.SetGhostMode
  function self:SetGhostMode(ghost_mode, ...)
    _SetGhostMode(self, ghost_mode, ...)
    self.ling_poetry:SetGhostMode(ghost_mode)
  end

end)

AddClassPostConstruct("screens/playerhud", function(self)
  -- 调整container与button的顺序
  local adjustGuardPanelTasks = Symbol("adjustGuardPanelTasks")
  function self:AdjustGuardPanel(guard)
    if not self.controls then return end
    if not self[adjustGuardPanelTasks] then
      self[adjustGuardPanelTasks] = {}
    end
    if self[adjustGuardPanelTasks][guard] then
      return
    end
    self[adjustGuardPanelTasks][guard] = self.owner:DoTaskInTime(0, function()
      self[adjustGuardPanelTasks][guard] = nil
      local panelWidget, containerCloseWidget = self:GetGuardPanel(guard)
      if not panelWidget then return end
      if not guard.replica.container then
        panelWidget.container_open:Hide()
        containerCloseWidget:Hide()
      else
        local containerWidget = self.controls.containers[guard]
        if containerWidget and containerWidget.isopen then
          panelWidget.container_open:Hide()
          containerCloseWidget:Show()
          containerCloseWidget:MoveToBack()
          containerWidget:MoveToBack()
          panelWidget:MoveToBack()
        else
          panelWidget.container_open:Show()
          containerCloseWidget:Hide()
        end
      end
      -- 调整种植相关容器
      local plantClubWidget, plantContainerWidget = nil, nil
      -- 遍历容器
      for container, widget in pairs(self.controls.containers) do
        if widget.isopen then
          if container.replica.container.type == "ling_guard_plant_club" and container.entity:GetParent() == guard then
            plantClubWidget = widget
          end
          if container.replica.container.type == "ling_guard_plant_container" and container.entity:GetParent() == guard then
            plantContainerWidget = widget
          end
        end
      end
      if plantClubWidget then
        plantClubWidget:MoveToBack()
      end
      ArkLogger:Debug("AdjustGuardPanel", "plantContainerWidget", plantContainerWidget, plantContainerWidget and plantContainerWidget.isopen)
      if plantContainerWidget then
        panelWidget.plant_bg:Hide()
        plantContainerWidget:MoveToBack()
      else
        panelWidget.plant_bg:Show()
      end
    end)
  end
  local _OpenContainer = self.OpenContainer
  function self:OpenContainer(container, side)
    _OpenContainer(self, container, side)
    local containerReplica = container.replica.container
    if containerReplica.type == "ling_guard_container" then
      self:AdjustGuardPanel(container)
    elseif containerReplica.type == "ling_guard_plant_container" then
      local pos = containerReplica.widget.pos
      local openPos = containerReplica.widget.openPos
      local containerWidget = self.controls.containers[container]
      containerWidget:MoveTo(pos, openPos, 0.3)
      -- 根据等级关闭多余的插槽
      local parent = container.entity:GetParent()
      if parent then
        local enabledSlots = parent.replica.ling_guard_plant and parent.replica.ling_guard_plant:GetEnabledSlots() or nil
        if enabledSlots then
          for idx, inv in pairs(containerWidget.inv) do
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
        local level = parent.replica.ling_guard_plant and parent.replica.ling_guard_plant:GetLevel() or 1
        if level == 2 then
          containerWidget.bganim:GetAnimState():PlayAnimation("open_1")
        elseif level == 3 then
          containerWidget.bganim:GetAnimState():PlayAnimation("open_2")
        end
        self:AdjustGuardPanel(parent)
      end
    elseif containerReplica.type == "ling_guard_plant_club" then
      local parent = container.entity:GetParent()
      if parent then
        self:AdjustGuardPanel(parent)
      end
    end
  end
  local _CloseContainer = self.CloseContainer
  function self:CloseContainer(container, side)
    local containerReplica = container.replica.container
    if containerReplica.type == "ling_guard_container" then
      _CloseContainer(self, container, side)
      self:AdjustGuardPanel(container)
    elseif containerReplica.type == "ling_guard_plant_container" then
      local pos = containerReplica.widget.pos
      local openPos = containerReplica.widget.openPos
      local containerWidget = self.controls.containers[container]
      -- self.controls.containers[container] = nil
      -- 期间禁用所有的插槽交互
      for idx, inv in pairs(containerWidget.inv) do
        inv:Disable()
      end
      containerWidget:MoveTo(openPos, pos, 0.3)
      _CloseContainer(self, container, side)
      local parent = container.entity:GetParent()
      if parent then
        self:AdjustGuardPanel(parent)
      end
    elseif containerReplica.type == "ling_guard_plant_club" then
      _CloseContainer(self, container, side)
      local parent = container.entity:GetParent()
      if parent then
        self:AdjustGuardPanel(parent)
      end
    else
      _CloseContainer(self, container, side)
    end
  end

  -- 打开守卫面板
  function self:OpenGuardPanel(inst)
    if not self.controls then return end
    if self.controls.guard_panels[inst] then
      return
    end
    local PANEL_SCALE = CONSTANTS.LING_GUARD_PANEL_SCALE
    -- 面板
    local panel = self.controls.containerroot:AddChild(LingGuardPanel(self.owner, inst))
    panel:SetPosition(CONSTANTS.LING_GUARD_PANEL_POSITION)
    panel:SetScale(CONSTANTS.LING_GUARD_PANEL_SCALE, CONSTANTS.LING_GUARD_PANEL_SCALE, CONSTANTS.LING_GUARD_PANEL_SCALE)
    -- 关闭按钮
    -- 关闭按钮无法单独调整图层, 需要与面板本身分开,以把容器夹在中间
    local container_close = self.controls.containerroot:AddChild(LingCloseContainer(self.owner, inst))
    local close_pos = CONSTANTS.LING_GUARD_PANEL_POSITION + CONSTANTS.LING_GUARD_PANEL_CLOSE_CONTAINER_POSITION * PANEL_SCALE
    container_close:SetPosition(close_pos)
    container_close:SetScale(PANEL_SCALE, PANEL_SCALE, PANEL_SCALE)
    -- 检查对应容器是否打开, 如果打开展示关闭按钮, 隐藏容器打开按钮
    self.controls.guard_panels[inst] = { panel = panel, container_close = container_close}
    self:AdjustGuardPanel(inst)
  end

  -- 关闭守卫面板
  function self:CloseGuardPanel(close_inst)
    if not self.controls then return end
    for inst, _ in pairs(self.controls.guard_panels) do
      if close_inst == nil or inst == close_inst then
        self.controls.guard_panels[inst].panel:Kill()
        self.controls.guard_panels[inst].container_close:Kill()
        self.controls.guard_panels[inst] = nil
      end
    end
  end

  -- 获取守卫面板
  function self:GetGuardPanel(inst)
    if not self.controls then return nil, nil end
    for guard_inst, panel in pairs(self.controls.guard_panels) do
      if guard_inst == inst then
        return panel.panel, panel.container_close
      end
    end
    return nil, nil
  end
  -- 获取所有打开的
  function self:GetAllGuardPanels()
    if not self.controls then return {} end
    return self.controls.guard_panels
  end
end)

AddComponentPostInit("container", function(self)
  self.skip_auto_closer = {}
  -- 重新计算是否需要更新
  local function SetUpdatingComponent(self)
    if self.skipautoclose then
      return
    end
    -- openlist 里都是skip_auto_closer的, 不需要再StartUpdatingComponent
    local need_update = false
    for k, v in pairs(self.openlist) do
      if not self.skip_auto_closer[k] then
        need_update = true
        break
      end
    end
    if need_update then
      self.inst:StartUpdatingComponent(self)
    else
      self.inst:StopUpdatingComponent(self)
    end
  end
  local _Open = self.Open
  -- 拥有者打开容器时, 尝试把面板打开
  function self:Open(doer)
    local ownedGuard = doer.components.ling_summon_manager and doer.components.ling_summon_manager:GetGuardSlotIndex(self.inst) or nil
    if ownedGuard then
      self.inst.components.ling_guard:OpenPanel(doer)
    end
    _Open(self, doer)
    SetUpdatingComponent(self)
  end
  

  function self:SkipAutoClose(doer)
    self.skip_auto_closer[doer] = true
    SetUpdatingComponent(self)
  end

  function self:StopSkipAutoClose(doer)
    self.skip_auto_closer[doer] = nil
    SetUpdatingComponent(self)
  end

  local _Close = self.Close
  function self:Close(doer)
    -- 如果保持打开, 则不关闭
    local keepOpen = self.skip_auto_closer[doer]
    if keepOpen then
      return
    end
    return _Close(self, doer)
  end
end)

AddComponentPostInit("follower", function(self)
  local _cached_player_join_fn = self.cached_player_join_fn
  self.cached_player_join_fn = function(world, player) 
    if not self.inst.components.ling_guard then
      return _cached_player_join_fn(world, player)
    end
    if self.cached_player_leader_userid ~= player.userid then
        return
    end
    ArkLogger:Debug("ling_guard:cached_player_join_fn: 检测到玩家加入, 守卫跟随", self.inst, player)
    local current_time = GetTime()
    local cached_player_leader_timeleft = self.cached_player_leader_timeleft
    self:SetLeader(player)

    self.targettime = nil
    if cached_player_leader_timeleft then
        self:AddLoyaltyTime(cached_player_leader_timeleft - current_time)
    end
  end
end)

-- 添加召唤系统的RPC通信
AddModRPCHandler("ling_summon", "summon_basic", function(player, slot_index)
  if not player.components.ling_summon_manager then
    return
  end
  player.components.ling_summon_manager:SummonBasic(slot_index)
end)

AddModRPCHandler("ling_summon", "guard_open_panel", function(player, guard_inst)
  if guard_inst.components.ling_guard then
    ArkLogger:Debug("ling_guard:guard_open_panel", player, guard_inst)
    guard_inst.components.ling_guard:OpenPanel(player)
  end
end)

AddModRPCHandler("ling_summon", "guard_close_panel", function(player, guard_inst)
  if guard_inst.components.ling_guard then
    guard_inst.components.ling_guard:ClosePanel(player)
  end
end)

AddModRPCHandler("ling_summon", "guard_open_container", function(player, guard_inst)
  if guard_inst.components.ling_guard then
    guard_inst.components.ling_guard:OpenContainer(player)
  end
end)

AddModRPCHandler("ling_summon", "guard_close_container", function(player, guard_inst)
  if guard_inst.components.ling_guard then
    guard_inst.components.ling_guard:CloseContainer(player)
  end
end)

AddModRPCHandler("ling_summon", "guard_set_behavior_mode", function(player, guard_inst, mode)
  if guard_inst.components.ling_guard then
    guard_inst.components.ling_guard:SetBehaviorMode(mode)
  end
end)

AddModRPCHandler("ling_summon", "guard_set_work_mode", function(player, guard_inst, mode)
  if guard_inst.components.ling_guard then
    guard_inst.components.ling_guard:SetWorkMode(mode)
  end
end)

AddModRPCHandler("ling_summon", "guard_set_form", function(player, guard_inst, form)
  if guard_inst.components.ling_guard then
    guard_inst.components.ling_guard:SetForm(form)
  end
end)

-- 客户端点击融合（以当前守卫所在槽位为主位）
AddModRPCHandler("ling_summon", "guard_fusion", function(player, guard_inst)
  if player.components.ling_summon_manager then
    player.components.ling_summon_manager:Fusion(guard_inst)
  end
end)

-- 回收守卫：丢出背包物品 -> 播放死亡动画 -> 移除
AddModRPCHandler("ling_summon", "guard_recall", function(player, guard_inst)
  if guard_inst.components.ling_guard then
    guard_inst.components.ling_guard:Recall()
  end
end)

-- 守卫世界管理
local OWNER_SHARD = {}
AddShardModRPCHandler("ling_summon", "LingHere", function(src_shard, userid, enter)
   if TheWorld.ismastershard then
    if enter then
      OWNER_SHARD[userid] = src_shard
    else
      OWNER_SHARD[userid] = nil
    end
  end
end)

AddShardModRPCHandler("ling_summon", "LingGuardStatus", function(src_shard, userid, slot_index, alive)
  local target = OWNER_SHARD[userid]
  if target then
    TheWorld:DoTaskInTime(0, function()
      SendModRPCToShard(GetShardModRPC("ling_summon", "UpdateLingGuardStatus"), target, userid, slot_index, alive)
    end)
  end
end)

AddShardModRPCHandler("ling_summon", "UpdateLingGuardStatus", function(src_shard, userid, slot_index, alive)
  -- TODO: 同步给主人的组件状态
end)

-- 添加令的召唤状态图
AddStategraphState("wilson", State{
    name = "ling_summon",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst, data)
        -- 没有召唤数据直接退出
        if not data then
          inst.sg:GoToState("idle")
          return
        end
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
        TimeEvent(15 * FRAMES, function(inst)
            -- 播放施法进行音效
            inst.SoundEmitter:PlaySound("dontstarve/common/staff_star_create")
        end),

        -- 30帧：确定召唤位置，创建特效
        TimeEvent(30 * FRAMES, function(inst)
            local data = inst.sg.statemem.summon_data
            local pos = data.pos
            -- 创建召唤特效（除了弦惊）
            if data.form ~= FORM.XIANJING then
                local fx = SpawnPrefab("ling_guard_basic_start_fx")
                fx.Transform:SetPosition(pos:Get())
                inst.sg.statemem.summon_fx = fx
            end
        end),

        -- 45帧：施法完成，执行召唤
        TimeEvent(45 * FRAMES, function(inst)
            local data = inst.sg.statemem.summon_data
            inst.sg.statemem.summon_completed = true
            if inst.components.ling_summon_manager then
                inst.components.ling_summon_manager:SpawnGuardAtPosition(data.form, data.level, data.pos, data.slots)
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

        if not inst.sg.statemem.summon_completed then
            -- 如果召唤被打断，立即中断特效
            if inst.sg.statemem.summon_fx then
                inst.sg.statemem.summon_fx:Remove()
            end
            -- 如果召唤未完成，回滚槽位状态
            local data = inst.sg.statemem.summon_data
            if data and data.slots and inst.components.ling_summon_manager then
                for i, slot_index in ipairs(data.slots) do
                    inst.components.ling_summon_manager:EmptySlot(slot_index)
                end
            end
        end

        -- 清理召唤数据
        inst.sg.statemem.summon_data = nil
        inst.sg.statemem.summon_fx = nil
        inst.sg.statemem.summon_completed = nil
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
