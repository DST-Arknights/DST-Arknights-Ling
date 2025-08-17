local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()
    inst:AddTag("ling_guard_plant_container")
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ling_guard_plant_container")
    inst.components.container.skipautoclose = true
    inst.components.container:EnableInfiniteStackSize(true)

    inst.OnPreLoad = function(inst)
        inst.loading = true
        print("ling guard plant container pre load")
    end
    inst.OnLoad = function(inst)
        inst.loading = false
        print("ling guard plant container load")
    end
    return inst
end

return Prefab("ling_guard_plant_container", fn)