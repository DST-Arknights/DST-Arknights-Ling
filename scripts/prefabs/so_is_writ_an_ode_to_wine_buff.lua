local function ApplyBuffEffect(inst, target, cfg)
  ArkLogger:Debug("so_is_writ_an_ode_to_wine_buff ApplyBuffEffect spawnByLoad=", inst.spawnByLoad, inst, target, cfg)
  if not inst.spawnByLoad then
    local reduceCd = cfg.SO_IS_WRIT_AN_ODE_TO_WINE_BUFF_REDUCE_CD or 0
    local skillComp = target.components.ark_skill
    ArkLogger:Debug("so_is_writ_an_ode_to_wine_buff ApplyBuffEffect", reduceCd, skillComp)
    if skillComp then
      for id, skill in pairs(skillComp.skillsById) do
        skill:AddEnergyProgress(reduceCd)
      end
    end
  end
  -- 攻击力增加
  local targetCombatComp = target.components.combat
  if targetCombatComp then
    local increasePercent = cfg.SO_IS_WRIT_AN_ODE_TO_WINE_BUFF_INCREASE_ATTACK_PERCENT or 1
    targetCombatComp.externaldamagemultipliers:SetModifier(inst, increasePercent, "so_is_writ_an_ode_to_wine_buff")
  end
end
local function OnAttached(inst, target)
  ArkLogger:Debug("so_is_writ_an_ode_to_wine_buff OnAttached", inst, target)
  inst.entity:SetParent(target.entity)
  inst.Transform:SetPosition(0, 0, 0) --in case of loading
  inst:ListenForEvent("death", function()
    inst.components.debuff:Stop()
  end, target)
  local targetElite = target.components.ark_elite.elite
  local cfg = TUNING.LING.ELITE[targetElite] or {}
  local totalTime = cfg.SO_IS_WRIT_AN_ODE_TO_WINE_BUFF_DURATION or 10
  local remainingTime = inst.components.timer:GetTimeLeft("so_is_writ_an_ode_to_wine_buff_duration") or totalTime
  inst.components.timer:StartTimer("so_is_writ_an_ode_to_wine_buff_duration", totalTime)
  inst.components.ark_buff_icon:SetTotalTime(totalTime)
  inst.components.ark_buff_icon:SetRemainingTime(remainingTime)
  inst.components.ark_buff_icon:AttachTo(target)

  -- 应用一次性触发效果
end

local function OnDetached(inst, target)
  ArkLogger:Debug("so_is_writ_an_ode_to_wine_buff OnDetached")
  inst.components.ark_buff_icon:AttachTo(inst)
  inst:Remove()
end

local function OnExtended(inst, target)
  ArkLogger:Debug("so_is_writ_an_ode_to_wine_buff OnExtended")
  inst.components.timer:StopTimer("so_is_writ_an_ode_to_wine_buff_duration")
  local targetElite = target.components.ark_elite.elite
  local cfg = TUNING.LING.ELITE[targetElite] or {}
  local totalTime = cfg.SO_IS_WRIT_AN_ODE_TO_WINE_BUFF_DURATION or 10
  inst.components.timer:StartTimer("so_is_writ_an_ode_to_wine_buff_duration", totalTime)
  inst.components.ark_buff_icon:SetTotalTime(totalTime)
  inst.components.ark_buff_icon:SetRemainingTime(totalTime)
end

local function OnTimerDone(inst, data)
    if data.name == "so_is_writ_an_ode_to_wine_buff_duration" then
        inst.components.debuff:Stop()
    end
end

local function OnLoad(inst, data)
  inst.spawnByLoad = true -- 标记自己是加载回来的, 而不是新创建的, 避免重复触发
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    if not TheWorld.ismastersim then
        -- inst:DoTaskInTime(0, inst.Remove)
        return inst
    end
    inst.entity:Hide()
    inst.persists = false
    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst:AddComponent("ark_buff_icon")
    inst.components.ark_buff_icon:SetTexture("images/ling_skill.xml", "skill_icon_skchr_ling_1.tex")

    inst.OnLoad = OnLoad
    return inst
end
return Prefab("so_is_writ_an_ode_to_wine_buff", fn)