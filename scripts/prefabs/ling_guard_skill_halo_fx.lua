local function PlaySound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

-- 硬编码的单一特效：ling_guard_skill_halo_fx
local BANK  = "deer_fire_charge"
local BUILD = "deer_fire_charge"
local ANIM  = "blast"
local SOUND = "wickerbottom_rework/book_spells/light_upgrade"

local function startfx(proxy)
    local inst = CreateEntity("ling_guard_skill_halo_fx")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    proxy._fx = inst
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
    inst.AnimState:PlayAnimation(ANIM, true)  -- 循环播放
    inst.AnimState:SetMultColour(1, 1, 1, 0.6)

    -- 设置渲染层级：在角色脚下
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)  -- 较低的排序值，显示在下层

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetScale(1.5, 1.5, 1.5)

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

        -- 监听父实体移除事件，父实体移除时自动清理特效
        inst:ListenForEvent("onremove", function()
            if inst._fx and inst._fx:IsValid() then
                inst._fx:Remove()
            end
        end)
    end

    inst.Transform:SetFourFaced()

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local assets = {
    Asset("ANIM", "anim/"..BUILD..".zip"),
}




return Prefab("ling_guard_skill_halo_fx", fn, assets)
