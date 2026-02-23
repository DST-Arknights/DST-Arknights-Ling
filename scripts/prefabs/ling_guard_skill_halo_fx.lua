return ArkMakeFx({
    name = "ling_guard_skill_halo_fx",
    bank = "deer_fire_charge",
    build = "deer_fire_charge",
    anim = "blast",
    sound = "dontstarve/common/deathpoof",
    tint = Vector3(1, 1, 1, 0.6),
    fn = function(inst)
        -- 设置渲染层级：在角色脚下
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(1)  -- 较低的排序值，显示在下层

        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetScale(1.5, 1.5, 1.5)
    end,
})