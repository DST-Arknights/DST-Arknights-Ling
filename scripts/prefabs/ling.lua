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

  -- 添加组件
  inst:AddComponent("ark_elite")
  inst:AddComponent("ling_poetry")
  inst:AddComponent("sleeper")
  inst:AddComponent("planarentity")
  inst:AddComponent("reader")
  inst:AddComponent("ling_summon_manager")
  inst:AddComponent("fader")
  inst:AddComponent("ling_cloud_pavilion_transfer")
  inst:AddComponent("ling_skill")
  inst.components.sanity.dapperness = TUNING.DAPPERNESS_MED

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
end

return MakePlayerCharacter("ling", prefabs, assets, common_post_init, master_post_init, start_inv)