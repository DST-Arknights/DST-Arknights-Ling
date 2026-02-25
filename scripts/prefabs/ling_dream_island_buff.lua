local LING_TREASURE_BUFF_BASE_PLANAR_DEFENSE = 5
local GRUE_IMMUNITY = "ling_dream_island_buff"
local REVIVE_DELAY = 3
local REVIVE_TASK_KEY = "_ling_dream_island_revive_task"

local function TryRevive(target)
  if target == nil or not target:IsValid() or target.components.health == nil then
    return
  end

  if not target.components.health:IsDead() then
    return
  end

  if target:HasTag("playerghost") then
    target:PushEvent("respawnfromghost", {source = target})
  elseif target.components.health.Respawn ~= nil then
    target.components.health:Respawn(TUNING.REVIVE_HEALTH)
  end
end

local function ScheduleRevive(target)
  if target == nil or not target:IsValid() or target[REVIVE_TASK_KEY] ~= nil then
    return
  end

  target[REVIVE_TASK_KEY] = target:DoTaskInTime(REVIVE_DELAY, function(owner)
    owner[REVIVE_TASK_KEY] = nil
    TryRevive(owner)
  end)
end

local function temperaturetick(inst, sleeper)
    if sleeper.components.temperature ~= nil then
        if sleeper.components.temperature:GetCurrent() < TUNING.SLEEP_TARGET_TEMP_TENT then
            sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() + TUNING.SLEEP_TEMP_PER_TICK)
        end
    end
end

local function moisturetick(inst, sleeper)
    if sleeper.components.moisture ~= nil then
        sleeper.components.moisture:DoDelta(-5)
    end
end

local function OnTick(inst, target)
  -- 玩家在生命值未满时逐渐消耗饥饿度。
  if target.components.health and not target.components.health:IsDead() and not (target.components.health:GetPercent() >= 1) and target.components.hunger  and not target.components.hunger:IsStarving() then
    target.components.hunger:DoDelta(TUNING.SLEEP_HUNGER_PER_TICK / 2, true, true)
    target.components.health:DoDelta(TUNING.SLEEP_HEALTH_PER_TICK * 2, true, inst.prefab, true)
  end
  -- 恢复理智
  if target.components.sanity and not target.components.sanity:IsInsane() and not (target.components.sanity:GetPercent() >= 1) then
    target.components.sanity:DoDelta(TUNING.SLEEP_SANITY_PER_TICK * 5 / 60, true, inst.prefab, true)
  end
  if not target.ling_inHouse then -- cloud pavilion 有自己的温度管理, 这里跳过
    -- 恢复温度
    temperaturetick(inst, target)
    moisturetick(inst, target)
  end
end

local function OnAttached(inst, target)
  inst.entity:SetParent(target.entity)
  inst.Transform:SetPosition(0, 0, 0)
  inst._ondeath = function()
    ScheduleRevive(target)
    if inst.components.debuff ~= nil then
      inst.components.debuff:Stop()
    end
  end
  inst:ListenForEvent("death", inst._ondeath, target)
  -- 50%减伤, 5点位面防御
  target.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0.5)
  if not target.components.planardefense then
    target:AddComponent("planardefense")
  end
  target.components.planardefense:SetBaseDefense(LING_TREASURE_BUFF_BASE_PLANAR_DEFENSE)
  if not target.components.grue then
    target:AddComponent("grue")
  end
  target.components.grue:AddImmunity(GRUE_IMMUNITY)
  inst._buffTask = inst:DoPeriodicTask(TUNING.SLEEP_TICK_PERIOD, function() OnTick(inst, target) end)
end

local function OnDetached(inst, target)
  if inst._buffTask ~= nil then
    inst._buffTask:Cancel()
    inst._buffTask = nil
  end
  if inst._ondeath ~= nil then
    inst:RemoveEventCallback("death", inst._ondeath, target)
    inst._ondeath = nil
  end
  if target.components.planardefense then
    target.components.planardefense:SetBaseDefense(0)
  end
  if target.components.grue then
    target.components.grue:RemoveImmunity(GRUE_IMMUNITY)
  end
  inst:Remove()
end

local function fn()
  local inst = CreateEntity()
  if not TheWorld.ismastersim then
    return inst
  end
  inst.entity:AddTransform()
  inst.entity:Hide()
  inst.persists = false
  inst:AddTag("CLASSIFIED")

  inst:AddComponent("debuff")
  inst.components.debuff:SetAttachedFn(OnAttached)
  inst.components.debuff:SetDetachedFn(OnDetached)
  inst.components.debuff.keepondespawn = true
  return inst
end

return Prefab("ling_dream_island_buff", fn)