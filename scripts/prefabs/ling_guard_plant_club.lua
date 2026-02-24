local CONSTANTS = require("ark_constants_ling")

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()
    inst:AddTag("ling_guard_plant_club")
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ling_guard_plant_club")
    inst.components.container.skipautoclose = true
    inst:ListenForEvent("itemget", function(inst, data)
        local parent = inst.entity:GetParent()
        if parent and parent.components.ling_guard:GetWorkMode() == CONSTANTS.GUARD_WORK_MODE.PLANT then
            parent.components.ling_guard_plant:StartPlanting()
        end
    end)
    -- 不保存数据
    inst.persists = false
    return inst
end

return Prefab("ling_guard_plant_club", fn)
