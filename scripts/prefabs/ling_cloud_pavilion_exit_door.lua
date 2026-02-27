local assets = {
    Asset("ANIM", "anim/acorn.zip"),
    Asset("ANIM", "anim/ling_cloud_pavilion_exit_door.zip"), --出口地毯
}


local function StartTravelSound(inst, doer)
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
end

local function OnHaunt(inst, haunter)
    inst.components.teleporter:Activate(haunter)
end

local function OnSave(inst, data)
    data.side = inst.side
    data.initData = inst.initData
end

local function OnLoad(inst, data)
    if data == nil then return end

    inst.side = data.side
    if data.initData then
        TheWorld.components.ling_interiorspawner:InitHouseInteriorPrefab(inst, data.initData)
        inst.initData = data.initData
    end
end

local function playerHouseExitDoorFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ling_cloud_pavilion_exit_door")
    inst.AnimState:SetBuild("ling_cloud_pavilion_exit_door")
    inst.AnimState:PlayAnimation("idle_old")
    -- inst.AnimState:SetSortOrder(0)
    -- inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst:AddTag("NOBLOCK")
    
    inst:AddTag("ling_cloud_pavilion_exit_door")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.side = nil --门所在墙边

    inst:AddComponent("ling_cloud_pavilion_exit")

    inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph


    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return
-- 出口门
    Prefab("ling_cloud_pavilion_exit_door", playerHouseExitDoorFn, assets)
-- 出口门anim：
-- idle_antiquities、idle_bank、idle_basic、idle_deli、idle_flag、idle_florist、idle_general、idle_giftshop、idle_hoofspa、idle_old、idle_produce、idle_tinker
