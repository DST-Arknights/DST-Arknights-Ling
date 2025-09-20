local function PlaySound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

-- 硬编码的单一特效：ling_guard_basic_start_fx
local BANK  = "loong_1_attack_hit_fx"
local BUILD = "loong_1_attack_hit_fx"
local ANIM  = "attack_fx_up"
-- local SOUND = "wickerbottom_rework/book_spells/light_upgrade"

local function startfx(proxy)
    local inst = CreateEntity("ling_guard_elite_attack_hit_fx")

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

    -- inst.entity:AddSoundEmitter()
    -- inst:DoTaskInTime(0, PlaySound, LING_SOUND)

    inst.AnimState:SetBank(BANK)
    inst.AnimState:SetBuild(BUILD)
    inst.AnimState:PlayAnimation(ANIM)
    inst.AnimState:SetFinalOffset(3)
    -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    -- inst.AnimState:SetLayer(LAYER_BACKGROUND)
    lprint("elite attack hit fx playing animation", ANIM)
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




return Prefab("ling_guard_elite_attack_hit_fx", fn, assets)
