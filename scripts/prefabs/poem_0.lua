local assets =
{
    Asset("ANIM", "anim/poem.zip"),
    Asset("ATLAS", "images/inventoryimages/poem.xml"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("poem")
    inst.AnimState:SetBuild("poem")
    inst.AnimState:PlayAnimation("poem_0")
    inst:AddTag("poem")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "poem_0"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/poem.xml"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.POEM
    inst.components.repairer.finiteusesrepairvalue = 2

    inst:AddComponent("poem_useable")
    inst.components.poem_useable:SetOnUseFn(function(inst, doer)
        if doer == nil or doer.components == nil or doer.components.sanity == nil then return false end
        -- +5 理智
        doer.components.sanity:DoDelta(5)
        inst.components.stackable:Get():Remove()
        return true
    end)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("poem_0", fn, assets)