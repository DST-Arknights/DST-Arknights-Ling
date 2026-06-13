local fxs = { {
  name = "ling_aoe_attack_fx",
  bank = "fx_skill_2",
  build = "fx_skill_2",
  anim = "fx_hit",
  sound = "dontstarve/creatures/together/stalker/shield",
  nofaced = true,
  fn = function(inst)
    -- 缩放
    inst.AnimState:SetScale(0.6, 0.6, 0.6)
    -- 动画减慢
    inst.AnimState:SetDeltaTimeMultiplier(0.6)
  end,
}, {
  name = "ling_guard_elite_attack_hit_fx",
  bank = "loong_1_attack_hit_fx",
  build = "loong_1_attack_hit_fx",
  anim = "attack",
  fn = function(inst)
    inst.AnimState:SetScale(0.8, 0.8, 0.8)
  end,
}, {
  name = "ling_guard_skill_halo_fx",
  bank = "bearger_ring_fx",
  build = "bearger_ring_fx",
  anim = "idle",
  sound = "dontstarve/common/deathpoof",
  tint = Vector3(1, 1, 1, 0.6),
  fn = function(inst)
    -- 设置渲染层级：在角色脚下
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetScale(1.5, 1.5, 1.5)
  end,
} }

local results = {}
for _, fx in ipairs(fxs) do
  table.insert(results, ArkMakeFx(fx))
end
return unpack(results)
