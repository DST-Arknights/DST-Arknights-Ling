local assets=
{
  Asset("ATLAS", "images/inventoryimages/ling_lantern.xml"),
  Asset("ANIM", "anim/ling_lantern.zip"),
}

local function onremovesmoke(smoke)
    smoke._lantern._smoke = nil
end

local function turnon(inst)
    if inst._body ~= nil or not inst.components.inventoryitem:IsHeld() then
        if inst._smoke == nil then
            inst._smoke = SpawnPrefab("ling_lantern_smoke")
            inst._smoke.entity:AddFollower()
            inst._smoke._lantern = inst
            inst:ListenForEvent("onremove", onremovesmoke, inst._smoke)
        end
        if inst._body ~= nil and
            not inst._body.entity:IsVisible() and
            inst.components.inventoryitem.owner ~= nil then
            inst._smoke.Follower:FollowSymbol(inst.components.inventoryitem.owner.GUID, "swap_object", 68, -70, 0)
        else
            inst._smoke.Follower:FollowSymbol((inst._body or inst).GUID, "lantern_swing", 0, 185, 0)
        end
    elseif inst._smoke ~= nil then
        inst._smoke:Remove()
    end
end

local function turnoff(inst)
    if inst._smoke ~= nil then
        inst._smoke:Remove()
    end
end


local function OnRemove(inst)
    if inst._smoke ~= nil then
        inst._smoke:Remove()
    end
    if inst._body ~= nil then
        inst._body:Remove()
    end
end

local function ondropped(inst)
    turnoff(inst)
    -- turnon(inst)
end

local function ToggleOverrideSymbols(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_ling_lantern_stick", "swap_ling_lantern_stick")
    inst._body:Show()
    if inst._smoke ~= nil then
        inst._smoke.Follower:FollowSymbol(inst._body.GUID, "lantern_swing", 0, 185, 0)
    end
end

local function onremovebody(body)
    body._lantern._body = nil
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_ling_lantern_stick", "swap_ling_lantern_stick")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst._body ~= nil then
        inst._body:Remove()
    end
    inst._body = SpawnPrefab("ling_lanternbody")
    inst._body._lantern = inst
    inst:ListenForEvent("onremove", onremovebody, inst._body)

    inst._body.entity:SetParent(owner.entity)
    inst._body.entity:AddFollower()
    inst._body.Follower:FollowSymbol(owner.GUID, "swap_object", 68, -130, 0)
    inst._body:ListenForEvent("newstate", function(owner, data)
        ToggleOverrideSymbols(inst, owner)
    end, owner)

    ToggleOverrideSymbols(inst, owner)

    turnon(inst)
end

local function OnUnequip(inst, owner)
    if inst._body ~= nil then
        if inst._body.entity:IsVisible() then
            owner.AnimState:OverrideSymbol("swap_object", "swap_ling_lantern", "swap_ling_lantern")
        end
        inst._body:Remove()
    end

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    turnoff(inst)
end

local function onequiptomodel(inst, owner, from_ground)
    turnoff(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ling_lantern")
    inst.AnimState:SetBuild("ling_lantern")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetFinalOffset(1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)

    inst:AddComponent("inspectable")
    -- inst:AddComponent("ling_lantern")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "ling_lantern"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ling_lantern.xml"
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    inst.OnRemoveEntity = OnRemove

    inst._smoke = nil
    turnon(inst)

    MakeHauntableLaunch(inst)

    return inst
end


local function bodyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.AnimState:SetBank("ling_lantern")
    inst.AnimState:SetBuild("ling_lantern")
    inst.AnimState:PlayAnimation("idle_body_loop", true)
    inst.AnimState:SetFinalOffset(1)

    inst.Light:Enable(true)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(255/255, 211/255, 151/255)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)

    inst.persists = false

    return inst
end

return Prefab("ling_lantern", fn, assets),
       Prefab("ling_lanternbody", bodyfn)
