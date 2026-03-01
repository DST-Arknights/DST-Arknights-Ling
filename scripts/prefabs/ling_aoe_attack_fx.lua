return ArkMakeFx({
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
})
