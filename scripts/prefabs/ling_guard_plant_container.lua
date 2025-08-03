local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ling_guard_plant_container")
    inst.components.container.skipautoclose = true
    inst:AddComponent("ling_guard_plant")
    return inst
end

return Prefab("ling_guard_plant_container", fn)