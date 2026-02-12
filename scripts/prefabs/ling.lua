local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset( "ANIM", "anim/ling.zip" ),
}
local prefabs = {
  "ling_lantern",
  "ark_backpack",
	-- "silence_glass",
	-- "silence_coat",
	-- "silence_remote_control",
}
local start_inv = {
  "ark_backpack",
  "ling_lantern"
}


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

local function OnApplyElite(inst, elite, level)
  ArkLogger:Debug("OnApplyElite", elite, level)
  if inst.components.ling_poetry and elite then
    inst.components.ling_poetry:SetElite(elite)
  end
  if inst.components.ark_skill then
    if elite == 1 then
      inst.components.ark_skill:GetSkill("skill1"):Unlock()
      inst.components.ark_skill:GetSkill("skill1"):SetLevel(1)
    end
    if elite == 2 then
      if inst.components.builder then
        inst.components.builder:AddRecipe("ling_desk")
        -- inst.components.builder:AddRecipe("ling_jars")
      end
      inst.components.ark_skill:GetSkill("skill1"):SetLevel(2)
      inst.components.ark_skill:GetSkill("skill2"):Unlock()
      inst.components.ark_skill:GetSkill("skill2"):SetLevel(1)
    elseif elite == 3 then
      inst.components.ark_skill:GetSkill("skill1"):SetLevel(3)
      inst.components.ark_skill:GetSkill("skill2"):SetLevel(2)
      inst.components.ark_skill:GetSkill("skill3"):Unlock()
      inst.components.ark_skill:GetSkill("skill3"):SetLevel(1)
    end
  end
  local data = TUNING.LING.ELITE[elite]
  if not data then
      return
  end
  -- 更新基础属性
  inst.components.health:SetMaxHealth(data.MAX_HEALTH)
  inst.components.hunger:SetMax(data.MAX_HUNGER)
  inst.components.sanity:SetMax(data.MAX_SANITY)
  -- 应用移动速度
  inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ling_elite_speed", data.SPEED_MULTIPLIER)
  inst.components.combat.externaldamagemultipliers:SetModifier(inst, data.DAMAGE_MULTIPLIER, "ling_elite_damage")
  -- 应用睡眠抗性
	local mult = TUNING.CHANNELCAST_SPEED_MOD * data.SPEED_MULTIPLIER
	inst.components.grogginess:SetSpeedModMultiplier(1 / math.max(TUNING.MAX_GROGGY_SPEED_MOD, mult))
  -- 应用召唤管理器槽位
  if inst.components.ling_summon_manager then
    ArkLogger:Debug("SetMaxSlots", data.MAX_GUARDS)
    inst.components.ling_summon_manager:SetMaxSlots(data.MAX_GUARDS)
  end
  -- 解锁书桌
  if elite == 2 and inst.components.builder then
    inst.components.builder:UnlockRecipe("ling_desk")
  end
  -- 所有召唤兽同步等级
  if inst.components.ling_summon_manager then
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard then
        guard.components.ling_guard:SetLevel(elite)
      end
    end)
  end
end

local function OnReroll(inst)
  -- 移除所有的召唤物
  if inst.components.ling_summon_manager then
    inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
      if guard.components.ling_guard then
        guard.components.ling_guard:Recall()
      end
    end)
  end
end

local function OnPoetryChanged(inst, data)
  if inst.components.ark_elite then
    -- 取绝对值
    local exp = math.abs(data.diff)
    inst.components.ark_elite:AddExp(exp * 5)
  end
end

local function AddTimeExp(inst)
  if inst.components.ark_elite then
    inst.components.ark_elite:AddExp(2)
  end
end

local function common_post_init(inst)
  inst:AddTag("ling")
  inst:AddTag("reader")
end

local function master_post_init(inst)
  inst.MiniMapEntity:SetIcon("ling.tex")

  -- 添加组件
  inst:AddComponent("ark_currency")
  inst:AddComponent("ling_poetry")
  inst:AddComponent("planarentity")
  inst:AddComponent("reader")
  inst:AddComponent("ling_summon_manager")
  inst:AddComponent("fader")
  inst:AddComponent("ling_cloud_pavilion_transfer")
  inst:AddComponent("ling_skill")
  inst:AddComponent("ark_elite")
  inst:ListenForEvent("ling_poetry_changed", OnPoetryChanged)
  inst.components.ark_elite:SetRarity(6)
  inst.components.ark_elite:OnApplyElite(OnApplyElite)
  inst.components.sanity.dapperness = 0.33

  -- 设置leader组件的回调函数
  inst.components.leader.onfolloweradded = function(leader, follower)
    inst:DoTaskInTime(0, function()
      if inst.components.ling_summon_manager then
        inst.components.ling_summon_manager:OnFollowerAdded(follower)
      end
    end)
  end

  inst.components.leader.onremovefollower = function(leader, follower)
    if inst.components.ling_summon_manager then
      inst.components.ling_summon_manager:OnFollowerLost(follower)
    end
  end

  -- 保存和加载由组件自动处理

  -- 添加催眠抗性
  inst.components.grogginess:SetResistance(10) -- 设置催眠抗性为10
  inst:ListenForEvent("attacked", OnAttacked)
  inst:ListenForEvent("newcombattarget", OnNewTarget)

  inst.OnDespawn = function(inst, migrationdata)
    if migrationdata ~= nil then
      -- 准备迁移
      inst.components.ling_summon_manager:PrepareForMigration()
    end
  end
  inst:ListenForEvent("ms_playerreroll", OnReroll)
  inst:DoPeriodicTask(2, AddTimeExp)
end

return MakePlayerCharacter("ling", prefabs, assets, common_post_init, master_post_init, start_inv)