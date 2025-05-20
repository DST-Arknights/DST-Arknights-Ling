local MakePlayerCharacter = require "prefabs/player_common"
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

local function common_post_init(inst)
  inst:AddTag("ling")
end

local function DeclareFunction(inst)
  function inst:SetElite(level)
    print("设置 elite", level)
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
  end

  function inst:InDream() return false end
end

local function master_post_init(inst)
  inst.elite_level = 0
  DeclareFunction(inst)
	inst:AddComponent("ling_poetry")
  inst:SetElite(1)
  inst.OnSave = function(inst, data)
    data.elite_level = inst.elite_level
  end
  inst.OnLoad = function(inst, data)
    if data and data.elite_level then
      inst:SetElite(data.elite_level)
    end
  end
end

return MakePlayerCharacter("ling", prefabs, assets, common_post_init, master_post_init, start_inv)