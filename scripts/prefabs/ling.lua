local MakePlayerCharacter = require "prefabs/player_common"
local CONSTANTS = require "ark_constants_ling"

local SKILL1_DAMAGE_SOURCE = "ling_skill_1"
local SKILL2_DAMAGE_SOURCE = "ling_skill_2"
local SKILL3_DAMAGE_SOURCE = "ling_skill_3"

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

    for skillIndex = 1, 3 do
      if skill_component:IsSkillActive(skillIndex) then
        local levelConfig = skill_component:GetLevelConfig(skillIndex)
        if levelConfig and levelConfig.trueDamage then
          shouldEnableTrueDamage = true
          break
        end
      end
    end

    -- 更新角色真伤状态
    if shouldEnableTrueDamage then
      inst.components.combat:EnableTrueDamage()
    else
      inst.components.combat:DisableTrueDamage()
    end

    -- 守卫的真伤状态由ling_guard_skill组件管理，不在这里处理
  end

  function inst:InDream() return false end
  -- 技能相关方法
  function inst:StartSkill1()
    local skillLevelConfig = inst.components.ark_skill_ling:GetLevelConfig(1)
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, skillLevelConfig.damageMultiplier, SKILL1_DAMAGE_SOURCE)
    inst.components.combat:SetAttackSpeed(skillLevelConfig.attackSpeed)

    -- 通知所有守卫激活技能1（守卫组件自行决定是否启用）
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:ActivateSkill(1)
      end
    end)

    -- 更新真伤状态
    inst:UpdateTrueDamageState()
  end

  function inst:EndSkill1()
    lprint("EndSkill1")
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL1_DAMAGE_SOURCE)
    inst.components.combat:SetAttackSpeed(1)

    -- 通知所有守卫取消技能1
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:DeactivateSkill(1)
      end
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

    -- 通知所有守卫激活技能3（守卫组件自行决定是否启用）
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:ActivateSkill(3)
      end
    end)
  end

  function inst:EndSkill3()
    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, SKILL3_DAMAGE_SOURCE)
    inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, SKILL3_DAMAGE_SOURCE)

    -- 通知所有守卫取消技能3
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard_skill then
        guard.components.ling_guard_skill:DeactivateSkill(3)
      end
    end)
  end
end

local function OnAttacked(inst, data)
  local attacker = data.attacker
  if attacker == nil then
    return
  end
  inst.components.combat:ShareTarget(attacker, 30, function(dude)
    return dude:HasTag("ling_summon") and dude.components.follower and dude.components.follower.leader == inst
  end, 10)
end

local function OnNewTarget(inst, data)
  local target = data.target
  if target == nil then
    return
  end
  inst.components.combat:ShareTarget(target, 30, function(dude)
    return dude:HasTag("ling_summon") and dude.components.follower and dude.components.follower.leader == inst
  end, 10)
end

local function common_post_init(inst)
  inst:AddTag("ling")
  inst:AddTag("reader")
end

local function master_post_init(inst)
  inst.MiniMapEntity:SetIcon("ling.tex")

  -- 声明所有方法
  DeclareFunction(inst)

  -- 添加组件
  inst:AddComponent("ling_elite")
  inst:AddComponent("ling_poetry")
  inst:AddComponent("ark_skill_ling")
  inst:AddComponent("sleeper")
  inst:AddComponent("planarentity")
  inst:AddComponent("reader")
  inst:AddComponent("ling_summon_manager")
  inst:AddComponent("ling_cloud_pavilion_transfer")
  inst.components.sanity.dapperness = TUNING.DAPPERNESS_MED

  -- 设置leader组件的回调函数
  inst.components.leader.onfolloweradded = function(leader, follower)
    print("[Ling] onfolloweradded: 检测到follower添加", follower)
    inst:DoTaskInTime(0, function()
      if inst.components.ling_summon_manager then
        inst.components.ling_summon_manager:OnFollowerAdded(follower)
      end
    end)
  end

  inst.components.leader.onremovefollower = function(leader, follower)
    print("[Ling] onremovefollower: 检测到follower移除", follower)
    if inst.components.ling_summon_manager then
      inst.components.ling_summon_manager:OnFollowerLost(follower)
    end
  end

  -- 配置技能系统
  inst.components.ark_skill_ling:SetupSkillConfig("ling")

  -- 设置初始等级
  inst.components.ling_elite:SetElite(1)

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


  -- 保存和加载由组件自动处理

  -- 添加催眠抗性
  inst.components.grogginess:SetResistance(10) -- 设置催眠抗性为10
  inst:ListenForEvent("attacked", OnAttacked)
  inst:ListenForEvent("newcombattarget", OnNewTarget)
end

return MakePlayerCharacter("ling", prefabs, assets, common_post_init, master_post_init, start_inv)