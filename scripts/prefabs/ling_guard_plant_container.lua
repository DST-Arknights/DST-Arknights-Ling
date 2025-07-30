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
    inst.OnLoadPostPass = function(inst)
      local parent = inst.entity:GetParent()
      if parent and parent.components.ling_guard then
        parent.plant_container = inst
      end
    end
    inst:AddComponent("follower")
    return inst
end

return Prefab("ling_guard_plant_container", fn)