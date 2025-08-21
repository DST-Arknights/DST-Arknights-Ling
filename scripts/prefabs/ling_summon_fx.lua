local function PlaySound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

-- 硬编码的单一特效：ling_summon_fx
local LING_BANK  = "fx_book_light_upgraded"
local LING_BUILD = "fx_book_light_upgraded"
local LING_ANIM  = "play_fx"
local LING_SOUND = "wickerbottom_rework/book_spells/light_upgrade"

local function startfx(proxy)
    local inst = CreateEntity("ling_summon_fx")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    local parent = proxy.entity:GetParent()
    if parent ~= nil then
        inst.entity:SetParent(parent.entity)
    end

    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.entity:AddSoundEmitter()
    inst:DoTaskInTime(0, PlaySound, LING_SOUND)

    inst.AnimState:SetBank(LING_BANK)
    inst.AnimState:SetBuild(LING_BUILD)
    inst.AnimState:PlayAnimation(LING_ANIM)
    inst.AnimState:SetFinalOffset(3)

    inst:ListenForEvent("animover", inst.Remove)
    if TheWorld then
        TheWorld:PushEvent("fx_spawned", inst)
    end
end

local function ling_fx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, startfx, inst)
    end

    inst.Transform:SetFourFaced()

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)

    return inst
end

local ling_assets = {
    Asset("ANIM", "anim/"..LING_BUILD..".zip"),
}




return Prefab("ling_summon_fx", ling_fx_fn, ling_assets)
