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
    inst.AnimState:PlayAnimation("poem_3")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "poem_3"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/poem.xml"

    inst:AddComponent("rechargeable")

    inst:AddComponent("book")
    inst.components.book:SetOnRead(function(inst, reader)
        if reader.components.ling_poetry then
            reader.components.ling_poetry:Dirty(30)
            if reader.components.sanity ~= nil then reader.components.sanity:DoDelta(50) end
        else
            if reader.components.sanity then
                if reader.components.reader then
                    reader.components.sanity:DoDelta(50)
                else
                    reader.components.sanity:DoDelta(20)
                end
            end
        end
        inst.components.rechargeable:Discharge(60)
        return true
    end)


    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 180
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)


    return inst
end

return Prefab("poem_3", fn, assets)