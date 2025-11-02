local function OnSave(inst, data)
    data.noBlock = inst:HasTag("NOBLOCK") or nil
end

local function OnLoad(inst, data)
    if data and data.noBlock then
        inst:AddTag("NOBLOCK")
    end
end

local function ling_wall_tigerpond()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    -- inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetCollisionGroup(COLLISION.WORLD)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.ITEMS)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.GIANTS)
    phys:CollidesWith(COLLISION.FLYERS)
    phys:SetCapsule(0.5, 50)

    inst:AddTag("NOCLICK")
    inst:AddTag("blocker")
    -- inst:AddTag("NOBLOCK") --根据情况添加，对象会保存记录

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("ling_wall_tigerpond", ling_wall_tigerpond)
