local assets =
{
    Asset("ANIM", "anim/stalker_shield.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    -- 设置动画
    inst.AnimState:SetBank("stalker_shield")
    inst.AnimState:SetBuild("stalker_shield")
    inst.AnimState:PlayAnimation("idle1")
    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    
    -- 设置镜像变换 (对应j=3, i=1的情况)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- 播放音效
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/shield")

    -- 特效不需要保存
    inst.persists = false

    -- 动画结束后移除实体
    inst:ListenForEvent("animover", inst.Remove)
    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + FRAMES, inst.Remove)

    return inst
end

return Prefab("ling_aoe_attack_fx", fn, assets)