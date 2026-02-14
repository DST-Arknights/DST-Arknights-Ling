local prefabs = {}
local floorAssets =
{
    Asset("ANIM", "anim/ling_cloud_pavilion.zip"), --地板
}

local function OnPlayerNear(inst, doer)
    -- 先赋值锚点（地板实体）
    doer.ling_netvarCameraAnchor:set(inst)
    -- 翻转触发确保客户端一定收到 Dirty 事件
    -- doer:DoTaskInTime(0, function()
    --     doer.ling_netvarCameraAnchor:set(inst)
    -- end)
    doer.ling_inHouse = true
end

local function OnPlayerFar(inst, doer)
    -- 清空锚点，恢复室外相机
    doer.ling_netvarCameraAnchor:set(nil)
    doer.ling_inHouse = false
end

local function OnSave(inst, data)
    data.initData = inst.initData
end


local function OnLoad(inst, data)
    if data == nil then return end

    if data.initData then
        inst.initData = data.initData
        TheWorld.components.ling_interiorspawner:InitHouseInteriorPrefab(inst, inst.initData)
    end
end

local function floorFn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ling_cloud_pavilion")
    inst.AnimState:SetBuild("ling_cloud_pavilion")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(5)
    inst.AnimState:SetScale(4.5, 4.5, 4.5)
    inst.AnimState:PlayAnimation("floor")

    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetRadius(12)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(true)

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("ling_cloud_pavilion_floor")
    inst:AddTag("shadecanopy") --附近不会有月亮雨石头掉下来

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
    local dis = TheWorld.components.ling_interiorspawner:GetDis()
    inst.components.sanityaura.max_distsq = dis * dis

    -- 玩家可能通过其他手段进入和离开房间，我不能通过开关门来判断，只能用这个组件
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)
    inst.components.playerprox:SetDist(dis, dis)
    inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
    inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

----------------------------------------------------------------------------------------------------
local wallAssets = {
    Asset("ANIM", "anim/ling_cloud_pavilion.zip")
}

local function wall_common()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("ling_cloud_pavilion")
    inst.AnimState:SetBuild("ling_cloud_pavilion")
    inst.AnimState:PlayAnimation("wall", true)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetScale(2.8, 2.8, 2.8)

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    -- inst:AddTag("hamlet_housewall")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return
    -- 地板
    Prefab("ling_cloud_pavilion_interior_floor", floorFn, floorAssets, prefabs),
    -- 墙壁
    Prefab("ling_wallinteriorplayerhouse", wall_common, wallAssets, prefabs)
