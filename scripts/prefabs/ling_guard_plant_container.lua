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

    -- 默认先处于loading态，避免读档回填容器物品时被itemtestfn拒绝
    inst.loading = true

    inst.OnPreLoad = function(inst)
        inst.loading = true
        print("ling guard plant container pre load")
    end
    inst.OnLoad = function(inst)
        -- 延迟到下一帧再关闭loading，确保容器反序列化/回填流程完成
        inst:DoTaskInTime(0, function(inst)
            if inst and inst:IsValid() then
                inst.loading = false
            end
        end)
        print("ling guard plant container load")
    end

    -- 新召唤出来（非读档）的容器也在下一帧关闭loading
    inst:DoTaskInTime(0, function(inst)
        if inst and inst:IsValid() and inst.loading then
            inst.loading = false
        end
    end)
    -- 不保存数据
    inst.persists = false
    return inst
end

return Prefab("ling_guard_plant_container", fn)