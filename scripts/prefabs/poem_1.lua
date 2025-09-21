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
    inst.AnimState:PlayAnimation("poem_1")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "poem_1"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/poem.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_PELLET


    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.POEM
    inst.components.repairer.finiteusesrepairvalue = 22

    inst:AddComponent("poem_useable")
    inst.components.poem_useable:SetOnUseFn(function(inst, doer)
        if doer.components.ling_poetry then
            doer.components.ling_poetry:Dirty(20)
            if doer.components.sanity ~= nil then doer.components.sanity:DoDelta(20) end
        else
            if doer.components.sanity ~= nil then doer.components.sanity:DoDelta(10) end
        end
        inst.components.stackable:Get():Remove()
        return true
    end)
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 15
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)


    return inst
end

return Prefab("poem_1", fn, assets)