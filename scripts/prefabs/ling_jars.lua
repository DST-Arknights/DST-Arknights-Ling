require "prefabutil"



local assets =
{
    Asset("ANIM", "anim/ling_jars.zip"),
}

local prefabs =
{
}

local function onhammered(inst, worker)
    if inst.components.stewer.product ~= nil and inst.components.stewer:IsDone() then
        inst.components.stewer:Harvest()
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if inst.components.stewer:IsCooking() then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("working", true)
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    else
        if inst.components.container ~= nil and inst.components.container:IsOpen() then
            inst.components.container:Close()
            --onclose will trigger sfx already
        else
            inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
        end
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end

--anim and sound callbacks

local function startcookfn(inst)
    inst.AnimState:PlayAnimation("working", true)
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
    if not inst.components.stewer:IsCooking() then
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("idle", false)
        inst.SoundEmitter:KillSound("snd")
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end



local function spoilfn(inst)
    inst.components.stewer.product = inst.components.stewer.spoiledproduct
end



local function donecookfn(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
end

local function continuedonefn(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function continuecookfn(inst)
    inst.AnimState:PlayAnimation("working", true)
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function harvestfn(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function getstatus(inst)
    return (inst.components.stewer:IsDone() and "DONE")
        or (not inst.components.stewer:IsCooking() and "EMPTY")
        or (inst.components.stewer:GetTimeToCook() > 15 and "COOKING_LONG")
        or "COOKING_SHORT"
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end





local function onloadpostpass(inst, newents, data)
    if data and data.additems and inst.components.container then
        for i, itemname in ipairs(data.additems)do
            local ent = SpawnPrefab(itemname)
            inst.components.container:GiveItem( ent )
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    -- inst.entity:AddMiniMapEntity()

    inst.entity:AddNetwork()

    inst:SetDeploySmartRadius(1) --recipe min_spacing/2
    MakeObstaclePhysics(inst, .5)



    inst:AddTag("structure")
    inst:AddTag("stewer")

    -- Common initialization
    inst.AnimState:SetBank("ling_jars")
    inst.AnimState:SetBuild("ling_jars")
    inst.AnimState:PlayAnimation("idle")
    inst.scrapbook_anim = "idle"
    -- inst.MiniMapEntity:SetIcon("ling_jars.tex")

    MakeSnowCoveredPristine(inst)

    inst.scrapbook_specialinfo = "CROCKPOT"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- Master initialization
    inst:AddComponent("stewer")
    inst.components.stewer.onstartcooking = startcookfn
    inst.components.stewer.oncontinuecooking = continuecookfn
    inst.components.stewer.oncontinuedone = continuedonefn
    inst.components.stewer.ondonecooking = donecookfn
    inst.components.stewer.onharvest = harvestfn
    inst.components.stewer.onspoil = spoilfn

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ling_jars")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuilt)



    inst.OnLoadPostPass = onloadpostpass

    return inst
end
return Prefab("ling_jars", fn, assets, prefabs),
MakePlacer("ling_jars_placer", "ling_jars", "ling_jars", "idle")