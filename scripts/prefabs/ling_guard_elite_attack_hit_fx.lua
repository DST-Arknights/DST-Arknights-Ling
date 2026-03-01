return ArkMakeFx({
  name = "ling_guard_elite_attack_hit_fx",
  bank = "loong_1_attack_hit_fx",
  build = "loong_1_attack_hit_fx",
  anim = "attack",
  fn = function(inst)
    inst.AnimState:SetScale(0.8, 0.8, 0.8)
  end,
})
