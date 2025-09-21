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
    inst.AnimState:PlayAnimation("poem_2")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "poem_2"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/poem.xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(22)
    inst.components.finiteuses:SetUses(22)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = MATERIALS.POEM
    inst.components.repairable:SetFiniteUsesRepairable(true)

    inst:AddComponent("rechargeable")

    inst:AddComponent("book")
    inst.components.book:SetOnRead(function(inst, reader)
        if reader.components.ling_poetry then
            reader.components.ling_poetry:Dirty(25)
            if reader.components.sanity ~= nil then reader.components.sanity:DoDelta(40) end
        else
            if reader.components.sanity ~= nil then reader.components.sanity:DoDelta(20) end
        end
        -- if inst.components.finiteuses ~= nil then inst.components.finiteuses:Use(1) end
        inst.components.rechargeable:Discharge(30)
        return true
    end)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 45
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)


    return inst
end

return Prefab("poem_2", fn, assets)