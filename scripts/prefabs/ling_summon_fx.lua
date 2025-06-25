-- 令召唤特效预制体
local assets =
{
    Asset("ANIM", "anim/cave_exit_lightsource.zip"),
}

local function OnEffectTimer(inst)
    -- 特效结束后生成召唤物
    if inst._spawn_callback then
        inst._spawn_callback()
    end
    -- 延迟移除特效
    inst:DoTaskInTime(0.5, inst.Remove)
end

local function SetSpawnCallback(inst, callback)
    inst._spawn_callback = callback
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("cavelight")
    inst.AnimState:SetBuild("cave_exit_lightsource")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetLightOverride(1)

    -- 缩小版地穴光照，0.6倍大小
    inst.Transform:SetScale(0.6, 0.6, 0.6)

    -- 淡蓝色光效，与召唤物光照颜色一致
    inst.AnimState:SetMultColour(0.8, 0.8, 1.0, 1.0)

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    -- 光照设置 - 简单常驻光源
    inst.Light:SetRadius(1.5)
    inst.Light:SetIntensity(0.95)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(0.8, 0.8, 1.0) -- 淡蓝色光
    inst.Light:Enable(true)
    inst.Light:EnableClientModulation(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- 播放召唤音效
    inst.SoundEmitter:PlaySound("dontstarve/common/staff_star_create")

    -- 设置回调函数
    inst.SetSpawnCallback = SetSpawnCallback

    -- 2秒后触发召唤回调并移除特效
    inst:DoTaskInTime(2, OnEffectTimer)

    return inst
end

return Prefab("ling_summon_fx", fn, assets)
