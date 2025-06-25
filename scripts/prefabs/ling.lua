local MakePlayerCharacter = require "prefabs/player_common"
local CONSTANTS = require "ark_constants_ling"
local assets = {
    Asset( "ANIM", "anim/ling.zip" ),
}
local prefabs = {
	-- "silence_glass",
	-- "silence_coat",
	-- "silence_remote_control",
}
local start_inv = {
  "ling_lantern",
}

local function isSkillActive(before, now)
  return now.status == CONSTANTS.SKILL_STATUS.BUFFING
end

local function isSkillActiveEnd(before, now)
  return before.status == CONSTANTS.SKILL_STATUS.BUFFING and now.status ~= CONSTANTS.SKILL_STATUS.BUFFING
end

local function common_post_init(inst)
  inst:AddTag("ling")
  inst.AnimState:Show("HAIR_NOHAT")
  inst.AnimState:Show("HAIR")
end

local SKILL1_DAMAGE_SOURCE = "ling_skill_1"
local SKILL2_DAMAGE_SOURCE = "ling_skill_2"
local SKILL3_DAMAGE_SOURCE = "ling_skill_3"

local function DeclareFunction(inst)
  -- 真伤状态管理
  function inst:UpdateTrueDamageState()
    -- 从技能组件实时获取技能状态
    local skill_component = inst.components.ark_skill_ling
    if not skill_component then
      return
    end

    -- 检查哪些技能正在激活且有真伤配置
    local shouldEnableTrueDamage = false
    local shouldEnableGuardTrueDamage = false

    for skillIndex = 1, 3 do
      if skill_component:IsSkillActive(skillIndex) then
        local levelConfig = skill_component:GetLevelConfig(skillIndex)
        if levelConfig and levelConfig.trueDamage then
          shouldEnableTrueDamage = true
          -- 只有技能1的真伤状态影响守卫
          if skillIndex == 1 and levelConfig.affectGuards then
            shouldEnableGuardTrueDamage = true
          end
        end
      end
    end

    -- 更新角色真伤状态
    if shouldEnableTrueDamage then
      inst.components.combat:EnableTrueDamage()
    else
      inst.components.combat:DisableTrueDamage()
    end

    -- 更新守卫真伤状态
    inst:OptionalAllGuard(function(guard)
      if shouldEnableGuardTrueDamage then
        guard.components.combat:EnableTrueDamage()
      else
        guard.components.combat:DisableTrueDamage()
      end
    end)
  end

  -- 基础角色方法
  function inst:SetElite(level)
    inst.elite_level = level
    local data = TUNING.LING.ELITE[level]
    inst.components.health:SetMaxHealth(data.MAX_HEALTH)
    inst.components.hunger:SetMax(data.MAX_HUNGER)
    inst.components.sanity:SetMax(data.MAX_SANITY)
    inst.components.ling_poetry:SetElite(level)
    for i = 1, 3 do
      local tag = "ling_elite_" .. i
      inst:RemoveTag(tag)
    end
    local tag = "ling_elite_" .. level
    inst:AddTag(tag)
    if level == 1 then
      inst.components.ark_skill_ling:UnLock(1)
      inst.components.ark_skill_ling:SetSkillLevel(1, 1)
      inst.components.ark_skill_ling:Lock(2)
      inst.components.ark_skill_ling:Lock(3)
    end
    if level == 2 then
      inst.components.ark_skill_ling:UnLock(1)
      inst.components.ark_skill_ling:SetSkillLevel(1, 2)
      inst.components.ark_skill_ling:UnLock(2)
      inst.components.ark_skill_ling:SetSkillLevel(2, 1)
      inst.components.ark_skill_ling:Lock(3)
    elseif level == 3 then
      inst.components.ark_skill_ling:UnLock(1)
      inst.components.ark_skill_ling:SetSkillLevel(1, 3)
      inst.components.ark_skill_ling:UnLock(2)
      inst.components.ark_skill_ling:SetSkillLevel(2, 2)
      inst.components.ark_skill_ling:UnLock(3)
      inst.components.ark_skill_ling:SetSkillLevel(3, 1)
    end
  end

  function inst:InDream() return false end

  -- 召唤相关方法
  function inst:SummonQingping(level)
    -- 直接使用elite_level作为配置索引
    local elite_level = level or inst.elite_level or 0

    -- 检查诗意消耗
    local poetry_component = inst.components.ling_poetry
    if not poetry_component then
      return false
    end

    local config = TUNING.LING_GUARDS.QINGPING.LEVELS[elite_level]
    local cost = config and config.SUMMON_COST or 10

    -- 检查诗意是否足够
    if not poetry_component:HasEnough(cost) then
      return false
    end

    -- 开始施法动作
    inst:StartSummonCasting("qingping", elite_level, cost)
    return true
  end

  function inst:SummonXiaoyao(level)
    -- 检查等级要求（需要精一，即elite_level >= 1）
    if (inst.elite_level or 0) < 1 then
      return false
    end

    -- 直接使用elite_level作为配置索引，逍遥从精一开始
    local elite_level = level or inst.elite_level or 1

    -- 检查诗意消耗
    local poetry_component = inst.components.ling_poetry
    if not poetry_component then
      return false
    end

    local config = TUNING.LING_GUARDS.XIAOYAO.LEVELS[elite_level]
    local cost = config and config.SUMMON_COST or 12

    -- 检查诗意是否足够
    if not poetry_component:HasEnough(cost) then
      return false
    end

    -- 开始施法动作
    inst:StartSummonCasting("xiaoyao", elite_level, cost)
    return true
  end

  function inst:SummonXianjing(level)
    -- 检查等级要求（需要精二，即elite_level >= 2）
    if (inst.elite_level or 0) < 2 then
      return false
    end

    -- 直接使用elite_level作为配置索引，弦惊从精二开始
    local elite_level = level or inst.elite_level or 2

    -- 检查诗意消耗
    local poetry_component = inst.components.ling_poetry
    if not poetry_component then
      return false
    end

    local config = TUNING.LING_GUARDS.XIANJING.LEVELS[elite_level]
    local cost = config and config.SUMMON_COST or 15

    -- 检查诗意是否足够
    if not poetry_component:HasEnough(cost) then
      return false
    end

    -- 寻找跟随令的清平和逍遥
    local x, y, z = inst.Transform:GetWorldPosition()
    local guards = TheSim:FindEntities(x, y, z, 30, {"ling_summon"}, {"INLIMBO"})

    local fusion_candidates = {}
    for _, guard in ipairs(guards) do
      if guard.components.follower and guard.components.follower.leader == inst
         and (guard.guard_type == "qingping" or guard.guard_type == "xiaoyao")
         and guard.components.health and not guard.components.health:IsDead() then
        table.insert(fusion_candidates, guard)
      end
    end

    -- 需要至少两个守卫进行融合
    if #fusion_candidates < 2 then
      return false
    end

    -- 按血量排序，选择血量最低的两个
    table.sort(fusion_candidates, function(a, b)
      local health_a = a.components.health:GetPercent()
      local health_b = b.components.health:GetPercent()
      return health_a < health_b
    end)

    local guard1 = fusion_candidates[1]
    local guard2 = fusion_candidates[2]

    -- 扣除诗意
    poetry_component:Dirty(-cost)

    -- 开始融合过程
    inst:StartGuardFusion(guard1, guard2, elite_level)

    return true
  end

  -- 施法和生成相关方法
  function inst:StartSummonCasting(guard_type, elite_level, cost)
    -- 检查是否在忙碌状态
    if inst.sg and inst.sg:HasStateTag("busy") then
      return false
    end

    -- 设置召唤数据
    inst.summon_data = {
      guard_type = guard_type,
      elite_level = elite_level,
      cost = cost
    }

    -- 进入召唤状态
    if inst.sg then
      inst.sg:GoToState("ling_summon", inst.summon_data)
    end

    return true
  end

  function inst:SpawnGuardAtPosition(guard_type, elite_level, spawn_x, spawn_z)
    local guard = SpawnPrefab(guard_type)
    if guard then
      guard.Transform:SetPosition(spawn_x, 0, spawn_z)

      -- 设置等级
      guard:SetLevel(elite_level)

      -- 设置跟随
      if guard.components.follower then
        guard.components.follower:SetLeader(inst)
      end

      return true
    end

    return false
  end

  -- 融合相关方法
  function inst:StartGuardFusion(guard1, guard2, elite_level)
    -- 计算融合中心点
    local g1_x, g1_y, g1_z = guard1.Transform:GetWorldPosition()
    local g2_x, g2_y, g2_z = guard2.Transform:GetWorldPosition()
    local center_x = (g1_x + g2_x) / 2
    local center_z = (g1_z + g2_z) / 2

    -- 停止守卫的所有行为
    guard1.components.locomotor:Stop()
    guard2.components.locomotor:Stop()

    -- 设置融合标记，防止被其他系统干扰
    guard1.is_fusing = true
    guard2.is_fusing = true

    -- 设置无敌状态，防止融合过程被打断
    if guard1.components.health then
      guard1.components.health.invulnerable = true
    end
    if guard2.components.health then
      guard2.components.health.invulnerable = true
    end

    -- 让两个守卫互相移动接近
    local function MoveToCenter(guard, target_x, target_z)
      if guard and guard:IsValid() and not guard.components.health:IsDead() then
        guard.components.locomotor:GoToPoint(Vector3(target_x, 0, target_z))
      end
    end

    MoveToCenter(guard1, center_x, center_z)
    MoveToCenter(guard2, center_x, center_z)

    -- 检查融合进度的任务
    local fusion_task
    fusion_task = inst:DoPeriodicTask(0.1, function()
      -- 检查守卫是否还存在且有效
      if not guard1:IsValid() or not guard2:IsValid() or
         guard1.components.health:IsDead() or guard2.components.health:IsDead() then
        if fusion_task then
          fusion_task:Cancel()
        end
        return
      end

      -- 检查距离
      local g1_x, g1_y, g1_z = guard1.Transform:GetWorldPosition()
      local g2_x, g2_y, g2_z = guard2.Transform:GetWorldPosition()
      local distance = math.sqrt((g1_x - g2_x)^2 + (g1_z - g2_z)^2)

      -- 当两个守卫足够接近时开始融合动画
      if distance < 2 then
        fusion_task:Cancel()
        inst:StartFusionAnimation(guard1, guard2, center_x, center_z, elite_level)
      end
    end)

    -- 超时保护，10秒后强制融合
    inst:DoTaskInTime(10, function()
      if fusion_task then
        fusion_task:Cancel()
      end
      if guard1:IsValid() and guard2:IsValid() then
        inst:StartFusionAnimation(guard1, guard2, center_x, center_z, elite_level)
      end
    end)
  end

  function inst:StartFusionAnimation(guard1, guard2, center_x, center_z, elite_level)
    -- 让两个守卫进入融合状态，播放level_up动画
    if guard1.sg then
      guard1.sg:GoToState("fusion_levelup")
    end
    if guard2.sg then
      guard2.sg:GoToState("fusion_levelup")
    end

    -- 等待level_up动画播放完毕（大约0.5秒）
    inst:DoTaskInTime(0.5, function()
      if guard1:IsValid() and guard2:IsValid() then
        inst:CompleteFusion(guard1, guard2, center_x, center_z, elite_level)
      end
    end)
  end

  function inst:CompleteFusion(guard1, guard2, center_x, center_z, elite_level)
    -- 播放融合特效和音效
    local fx = SpawnPrefab("statue_transition_2")
    if fx then
      fx.Transform:SetPosition(center_x, 0, center_z)
    end

    -- 移除两个守卫
    guard1:Remove()
    guard2:Remove()

    -- 立即生成弦惊，播放start动画
    local xianjing = SpawnPrefab("xianjing")
    if xianjing then
      xianjing.Transform:SetPosition(center_x, 0, center_z)

      -- 设置等级
      xianjing:SetLevel(elite_level)

      -- 设置跟随
      if xianjing.components.follower then
        xianjing.components.follower:SetLeader(inst)
      end

      -- 让弦惊播放start动画（spawn状态会自动播放start动画）
      if xianjing.sg then
        xianjing.sg:GoToState("spawn")
      end

      -- 播放生成音效
      xianjing.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")

      -- 显示提示信息
      if inst.components.talker then
        inst.components.talker:Say("弦惊融合完成！")
      end
    end
  end

  -- 行为控制相关方法
  function inst:SwitchQingpingBehaviorMode()
    -- 寻找附近的清平
    local x, y, z = inst.Transform:GetWorldPosition()
    local qingpings = TheSim:FindEntities(x, y, z, 20, {"qingping"})

    local behavior_modes = {"cautious", "guard", "attack"}
    local mode_names = {cautious = "慎", guard = "守", attack = "攻"}

    for _, qingping in ipairs(qingpings) do
      if qingping.components.follower and qingping.components.follower.leader == inst then
        -- 获取当前模式
        local current_mode = qingping.behavior_mode or "cautious"

        -- 切换到下一个模式
        local current_index = 1
        for i, mode in ipairs(behavior_modes) do
          if mode == current_mode then
            current_index = i
            break
          end
        end

        local next_index = (current_index % #behavior_modes) + 1
        local next_mode = behavior_modes[next_index]

        -- 设置新模式
        qingping:SetBehaviorMode(next_mode)

        -- 显示提示信息
        if inst.components.talker then
          inst.components.talker:Say("清平模式: " .. mode_names[next_mode])
        end
      end
    end
  end

    function inst:OptionalAllGuard(fn)
    local followers = inst.components.leader:GetFollowersByTag('ling_guard');
    for _, follower in pairs(followers) do
      fn(follower)
    end
  end

  -- 技能相关方法
  function inst:StartSkill1()
    local skillLevelConfig = inst.components.ark_skill_ling:GetLevelConfig(1)
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, skillLevelConfig.damageMultiplier, SKILL1_DAMAGE_SOURCE)
    inst.components.combat:SetAttackSpeed(skillLevelConfig.attackSpeed)

    -- 为守卫应用技能1效果（如果配置允许）
    if skillLevelConfig.affectGuards then
      self:OptionalAllGuard(function(guard)
        guard.components.combat.externaldamagemultipliers:SetModifier(inst, skillLevelConfig.damageMultiplier, SKILL1_DAMAGE_SOURCE)
        guard.components.combat:SetAttackSpeed(skillLevelConfig.attackSpeed)
      end)
    end

    -- 更新真伤状态
    inst:UpdateTrueDamageState()
  end

  function inst:EndSkill1()
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL1_DAMAGE_SOURCE)
    inst.components.combat:SetAttackSpeed(1)

    -- 移除守卫的技能1效果
    self:OptionalAllGuard(function(guard)
      guard.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL1_DAMAGE_SOURCE)
      guard.components.combat:SetAttackSpeed(1)
    end)

    -- 更新真伤状态
    inst:UpdateTrueDamageState()
  end

  function inst:StartSkill2()
    local skillLevelConfig = inst.components.ark_skill_ling:GetLevelConfig(2)
    -- 修改为250倍伤害
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, 2.5, SKILL2_DAMAGE_SOURCE)

    -- 更新真伤状态
    inst:UpdateTrueDamageState()
  end

  function inst:EndSkill2()
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL2_DAMAGE_SOURCE)

    -- 更新真伤状态
    inst:UpdateTrueDamageState()
  end

  function inst:StartSkill3()
    local skillLevelConfig = inst.components.ark_skill_ling:GetLevelConfig(3)
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, skillLevelConfig.damageMultiplier, SKILL3_DAMAGE_SOURCE)
    inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, skillLevelConfig.damageAbsorption, SKILL3_DAMAGE_SOURCE)

    -- 为守卫应用技能3效果（如果配置允许）
    if skillLevelConfig.affectGuards then
      self:OptionalAllGuard(function(guard)
        guard.components.combat.externaldamagemultipliers:SetModifier(inst, skillLevelConfig.damageMultiplier, SKILL3_DAMAGE_SOURCE)
        guard.components.combat.externaldamagetakenmultipliers:SetModifier(inst, skillLevelConfig.damageAbsorption, SKILL3_DAMAGE_SOURCE)
      end)
    end
  end

  function inst:EndSkill3()
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL3_DAMAGE_SOURCE)
    inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, SKILL3_DAMAGE_SOURCE)

    -- 移除守卫的技能3效果
    self:OptionalAllGuard(function(guard)
      guard.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL3_DAMAGE_SOURCE)
      guard.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, SKILL3_DAMAGE_SOURCE)
    end)
  end
end

local function master_post_init(inst)
  -- 初始化基础属性
  inst.elite_level = 0

  -- 声明所有方法
  DeclareFunction(inst)

  -- 添加组件
  inst:AddComponent("ling_poetry")
  inst:AddComponent("ark_skill_ling")

  -- 配置技能系统
  inst.components.ark_skill_ling:SetupSkillConfig("ling")

  -- 设置初始等级
  inst:SetElite(1)

  -- 技能激活回调
  inst.components.ark_skill_ling.onSkillStatusChange = function(skillIndex, data, latestData)
    -- 技能1 触发
    if skillIndex == 1 and isSkillActive(latestData, data) then
      inst:StartSkill1()
    end
    -- 技能1 结束
    if skillIndex == 1 and isSkillActiveEnd(latestData, data) then
      inst:EndSkill1()
    end

    -- 技能2 触发
    if skillIndex == 2 and isSkillActive(latestData, data) then
      inst:StartSkill2()
    end
    -- 技能2 结束
    if skillIndex == 2 and isSkillActiveEnd(latestData, data) then
      inst:EndSkill2()
    end

    -- 技能3 触发
    if skillIndex == 3 and isSkillActive(latestData, data) then
      inst:StartSkill3()
    end
    -- 技能3 结束
    if skillIndex == 3 and isSkillActiveEnd(latestData, data) then
      inst:EndSkill3()
    end
  end


  -- 保存和加载相关方法
  inst.OnSave = function(inst, data)
    data.elite_level = inst.elite_level
  end

  inst.OnLoad = function(inst, data)
    if data and data.elite_level then
      inst:SetElite(data.elite_level)
    end
  end

  -- 添加催眠抗性
  inst.components.grogginess:SetResistance(10) -- 设置催眠抗性为10
end

return MakePlayerCharacter("ling", prefabs, assets, common_post_init, master_post_init, start_inv)