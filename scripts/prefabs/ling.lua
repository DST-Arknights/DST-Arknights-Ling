local ling_voice = require "languages/ling_voice"
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
  Asset("ANIM", "anim/ling.zip"),
  Asset("ATLAS", "images/map_icons/ling.xml"),
  Asset("SOUNDPACKAGE", "sound/ling.fev"),
  Asset("FILE", "sound/ling.fsb"),
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
  if target == nil or target:HasTag("ling_summon") then
    ArkLogger:Debug("OnNewTarget: target is ling_summon", target)
    return
  end
  inst.components.combat:ShareTarget(target, 30, function(dude)
    return dude:HasTag("ling_summon") and dude.components.follower and dude.components.follower.leader == inst
  end, 10)
end

local function OnApplyElite(inst, elite, level)
  if inst.components.ling_poetry and elite then
    inst.components.ling_poetry:SetElite(elite)
  end
  if inst.components.ark_skill then
    if elite == 1 then
      inst.components.ark_skill:GetSkill("skill1"):Unlock()
      inst.components.ark_skill:GetSkill("skill1"):SetLevel(1)
    end
    if elite == 2 then
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
  local currentHealth = inst.components.health.currenthealth
  inst.components.health:SetMaxHealth(data.MAX_HEALTH)
  inst.components.health:SetCurrentHealth(currentHealth)
  local currentHunger = inst.components.hunger.current
  inst.components.hunger:SetMax(data.MAX_HUNGER)
  inst.components.hunger:SetCurrent(currentHunger)
  local currentSanity = inst.components.sanity.current
  inst.components.sanity:SetMax(data.MAX_SANITY)
  inst.components.sanity.current = currentSanity
  -- 应用移动速度
  inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ling_elite_speed", data.SPEED_MULTIPLIER)
  inst.components.combat.externaldamagemultipliers:SetModifier(inst, data.DAMAGE_MULTIPLIER, "ling_elite_damage")
  -- 应用睡眠抗性 (组件死亡会删除)
  if inst.components.grogginess then
    local mult = TUNING.CHANNELCAST_SPEED_MOD * data.SPEED_MULTIPLIER
    inst.components.grogginess:SetSpeedModMultiplier(1 / math.max(TUNING.MAX_GROGGY_SPEED_MOD, mult))
  end
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
    inst.components.ark_elite:AddExp(1)
  end
end

-- ========== 养成类经验获取 ==========

-- 进食经验: 饱食度 ÷ 2
local function OnEat(inst, data)
  if inst.components.ark_elite and data.food and data.food.components.edible then
    local hunger_value = data.food.components.edible.hungervalue or 0
    local exp = math.floor(hunger_value / 2)
    if exp > 0 then
      inst.components.ark_elite:AddExp(exp)
    end
  end
end

-- 采摘经验: 固定10
local function OnPickSomething(inst, data)
  if inst.components.ark_elite then
    inst.components.ark_elite:AddExp(10)
  end
end

-- 完成劳动经验: 固定20 (砍树/挖矿/铲除等)
local function OnFinishedWork(inst, data)
  if inst.components.ark_elite then
    inst.components.ark_elite:AddExp(20)
  end
end

-- 烹饪经验: 固定50 (收获锅中食物时触发)
local function OnHarvestCooking(inst, data)
  if inst.components.ark_elite then
    inst.components.ark_elite:AddExp(50)
  end
end

-- 制作物品经验: 固定30
local function OnBuildItem(inst, data)
  if inst.components.ark_elite then
    inst.components.ark_elite:AddExp(30)
  end
end

-- 建造建筑经验: 固定50
local function OnBuildStructure(inst, data)
  if inst.components.ark_elite then
    inst.components.ark_elite:AddExp(50)
  end
end

-- ========================================

local function OnChangeArea(inst, area)
  local on_ling_island = area ~= nil and area.tags and table.contains(area.tags, "ling_dream_island")
  if on_ling_island then
    inst:AddDebuff("ling_dream_island_buff", "ling_dream_island_buff")
    if not inst._visited_dream_island then
      inst._visited_dream_island = true
      inst:DoTaskInTime(7, function()
        SayAndVoice(inst, "ANNOUNCE_ENTER_DREAM_ISLAND")
      end)
    end
  else
    inst:RemoveDebuff("ling_dream_island_buff")
  end
end

local function IsIdleBasicGuardForNerd(guard)
  if guard == nil or not guard:IsValid() then
    return false
  end
  if guard.prefab ~= "ling_guard_basic" then
    return false
  end
  if guard.components == nil or guard.components.health == nil or guard.components.health:IsDead() then
    return false
  end
  if guard.components.combat ~= nil and guard.components.combat.target ~= nil then
    return false
  end
  if guard.sg:HasStateTag("busy") or guard.sg:HasStateTag("sleeping") then
    return false
  end
  return guard.sg:HasStateTag("idle")
end

local function OnEmote(inst, data)
  if inst.components == nil or inst.components.ling_summon_manager == nil then
    return
  end
  inst.components.ling_summon_manager:OptionalAllGuard(function(guard)
    if IsIdleBasicGuardForNerd(guard) then
      guard:PushEvent("ling_guard_do_nerd", {
        leader = inst,
        emote = data,
      })
    end
  end)
end

local function OnTalk(inst, data)
  -- local idleVoices = { "IDLE1", "IDLE2" }
  -- local voiceIndex = math.random(1, #idleVoices)
  -- SayAndVoice(inst, idleVoices[voiceIndex], { notext = true })
end

local function OnSave(inst, data)
  data._visited_dream_island = inst._visited_dream_island
  data._visited_cloud_pavilion = inst._visited_cloud_pavilion
end

local function OnLoad(inst, data)
  if data._visited_dream_island then
    inst._visited_dream_island = data._visited_dream_island
  end
  if data._visited_cloud_pavilion then
    inst._visited_cloud_pavilion = data._visited_cloud_pavilion
  end
end

local function common_post_init(inst)
  inst:AddTag("ling")
  inst:AddTag("reader")
end

local function master_post_init(inst)
  inst.MiniMapEntity:SetIcon("ling.tex")

  -- 添加组件
  -- inst:AddComponent("ark_currency")
  inst:AddComponent("ling_poetry")
  inst:AddComponent("planarentity")
  inst:AddComponent("reader")
  inst:AddComponent("ling_summon_manager")
  inst:AddComponent("fader")
  inst:AddComponent("ling_cloud_pavilion_transfer")
  inst:AddComponent("ling_skill")
  inst:AddComponent("knownlocations")
  inst:ListenForEvent("ling_poetry_changed", OnPoetryChanged)
  inst:AddComponent("ark_elite")
  inst.components.ark_elite:SetRarity(6)
  inst.components.ark_elite:OnApplyElite(OnApplyElite)
  inst.components.ark_elite:SetMaxHealthBonus(105)
  inst.components.ark_elite:SetMaxDamageBonus(21)
  inst:AddComponent("i18n_talker")
  inst.components.i18n_talker:RegisterVoice(ling_voice)
  inst.components.i18n_talker:SetVoiceLang(TUNING.LING.VOICE_LANG)

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

  -- 移除尸体
  inst.skeleton_prefab = nil

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
  inst:ListenForEvent("changearea", OnChangeArea)
  inst:ListenForEvent("emote", OnEmote)

  inst:ListenForEvent("ontalk", OnTalk)

  -- 养成类经验事件监听
  inst:ListenForEvent("oneat", OnEat)                           -- 进食
  inst:ListenForEvent("picksomething", OnPickSomething)         -- 采摘
  inst:ListenForEvent("finishedwork", OnFinishedWork)           -- 完成劳动
  inst:ListenForEvent("builditem", OnBuildItem)                 -- 制作物品
  inst:ListenForEvent("buildstructure", OnBuildStructure)       -- 建造建筑
  inst:ListenForEvent("learncookbookrecipe", OnHarvestCooking)  -- 烹饪收获

  -- 复活后重新应用睡眠抗性
  inst:ListenForEvent("ms_respawnedfromghost", function()
    if inst.components.grogginess then
      local elite = inst.components.ark_elite and inst.components.ark_elite.elite or 1
      local data = TUNING.LING.ELITE[elite]
      local mult = TUNING.CHANNELCAST_SPEED_MOD * data.SPEED_MULTIPLIER
      inst.components.grogginess:SetSpeedModMultiplier(1 / math.max(TUNING.MAX_GROGGY_SPEED_MOD, mult))
    end
    if IsEntityInDreamIsland(inst) or IsEntityInCloudPavilion(inst) then
      inst:AddDebuff("ling_dream_island_buff", "ling_dream_island_buff")
    end
  end)
  inst:ListenForEvent("death", function()
    if IsEntityInDreamIsland(inst) then
      inst:DoTaskInTime(6, function()
        -- 复活
        if inst:HasTag("playerghost") then
          inst:DoTaskInTime(5, function()
            SayAndVoice(inst, "ANNOUNCE_REVIVE_IN_DREAM_ISLAND")
          end)
          inst:PushEvent("respawnfromghost", { source = inst })
        end
      end)
    end
  end)
  -- inst:DoPeriodicTask(60, AddTimeExp)
  -- 记录是否登陆过梦岛
  inst._visited_dream_island = false
  -- 记录是否登陆过云山亭
  inst._visited_cloud_pavilion = false
  inst.OnSave = OnSave
  inst.OnLoad = OnLoad
end

return MakePlayerCharacter("ling", prefabs, assets, common_post_init, master_post_init, start_inv)
