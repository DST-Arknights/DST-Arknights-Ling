-- 束缚目标5秒
local function ShackleTarget(target, duration)
  if target.components.locomotor then
    if not target:IsValid() then
      return
    end
    local effectiveName = "ling_skill2_shackle"
    -- 设置移动速度为0（完全束缚）
    target.components.locomotor:SetExternalSpeedMultiplier(target, effectiveName, 0)
    
    -- 创建束缚特效
    -- TODO: 替换为真实特效
    local fx = SpawnPrefab("spat_splat_fx")
    fx.entity:SetParent(target.entity)
    fx.Transform:SetPosition(0, 0, 0)
    
    -- 定时解除束缚
    target:DoTaskInTime(duration, function()
      if target:IsValid() then
        target.components.locomotor:RemoveExternalSpeedMultiplier(target, effectiveName)
        if fx and fx:IsValid() then
            fx:Remove()
        end
      end
    end)
  end
end

local _attackFn = ACTIONS.ATTACK.fn
local AREAATTACK_EXCLUDETAGS = { "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost", "ling_summon" }
ACTIONS.ATTACK.fn = function(act)
  local weapon = act.doer.components.combat:GetWeapon()
  if weapon and weapon.prefab == "ling_lantern" and act.doer.components.ark_skill_ling and act.doer.components.ark_skill_ling:GetActivationStacks(2) > 0 then
    local x, y, z = act.target.Transform:GetWorldPosition()
    local AOEarc = act.doer.components.ark_skill_ling:GetLevelConfig(2).AOEarc
    -- 排查所有友好目标
    local fx = SpawnPrefab("ling_guard_skill_halo_fx")
    fx.Transform:SetPosition(x, 1, z)
    act.doer.components.ark_skill_ling:ActivateSkill(2)
    -- 束缚目标
    local shackleTime = act.doer.components.ark_skill_ling:GetLevelConfig(2).shackleTime
    local targets = TheSim:FindEntities(x, y, z, AOEarc, { "_combat" }, AREAATTACK_EXCLUDETAGS)
    for _, target in ipairs(targets) do
      -- TODO: 更多的过滤条件
      if target ~= act.doer then
        ShackleTarget(target, shackleTime)
      end
    end
    ShackleTarget(act.target, shackleTime)
    act.doer.components.combat:DoAreaAttack(act.target, AOEarc, weapon, nil, nil, nil)
    -- 束缚目标
  end
  return _attackFn(act)
end
