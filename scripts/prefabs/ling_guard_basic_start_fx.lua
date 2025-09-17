local function PlaySound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

-- 硬编码的单一特效：ling_guard_basic_start_fx
local BANK  = "fx_book_light_upgraded"
local BUILD = "fx_book_light_upgraded"
local ANIM  = "play_fx"
local SOUND = "wickerbottom_rework/book_spells/light_upgrade"

local function startfx(proxy)
    local inst = CreateEntity("ling_guard_basic_start_fx")

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
    inst:DoTaskInTime(0, PlaySound, SOUND)

    inst.AnimState:SetBank(BANK)
    inst.AnimState:SetBuild(BUILD)
    inst.AnimState:PlayAnimation(ANIM)
    inst.AnimState:SetFinalOffset(3)

    inst:ListenForEvent("animover", inst.Remove)
    if TheWorld then
        TheWorld:PushEvent("fx_spawned", inst)
    end
end

local function fn()
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

local assets = {
    Asset("ANIM", "anim/"..BUILD..".zip"),
}




return Prefab("ling_guard_basic_start_fx", fn, assets)
