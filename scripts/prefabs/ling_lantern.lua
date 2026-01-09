local assets = {
    Asset("ATLAS", "images/inventoryimages/ling_lantern.xml"),
    Asset("ANIM", "anim/swap_ling_lantern_stick.zip"),
    Asset("ANIM", "anim/ling_lantern.zip"),
}

-- ========== 常量配置 ==========
local LING_LANTERN_CONFIG = {
    -- 燃料相关（稍微延长持续时间，降低加成）
    FUEL_MAX = TUNING.TOTAL_DAY_TIME * 8,                    -- 8天
    FUEL_BONUS_MULT = 0.5,           -- 燃料加成倍数（略微降低以平衡）

    -- 光照相关
    -- 光照相关（提高最大可视范围与亮度，使用平滑曲线计算）
    LIGHT_RADIUS_MIN = 2,
    LIGHT_RADIUS_MAX = 10,
    LIGHT_FALLOFF = 0.8,
    LIGHT_INTENSITY_MIN = 0.75,
    LIGHT_INTENSITY_MAX = 0.75,
    LIGHT_COLOR = {255/255, 211/255, 151/255},

    -- 攻击相关
    ATTACK_DAMAGE = 22,
    ATTACK_RANGE = 6,

    -- 烟雾跟随位置
    SMOKE_OFFSET = {0, 185, 0},

    -- 灯体跟随位置
    BODY_OFFSET = {68, -130, 0},
}

-- ========== 状态管理 ==========
local LANTERN_STATE = {
    EQUIPPED = 1,
    INVENTORY = 2,
    GROUND = 3
}

-- 获取灯笼当前状态
local function GetLanternState(inst)
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        return LANTERN_STATE.EQUIPPED
    elseif inst.components.inventoryitem and inst.components.inventoryitem:IsHeld() then
        return LANTERN_STATE.INVENTORY
    else
        return LANTERN_STATE.GROUND
    end
end

-- 获取燃料百分比（缓存优化）
local function GetFuelPercent(inst)
    return inst.components.fueled:GetPercent() or 0
end

-- ========== 清理函数 ==========
local function OnRemoveSmoke(smoke)
    if smoke._lantern then
        smoke._lantern._smoke = nil
    end
end

local function OnRemoveBody(body)
    if body._lantern then
        body._lantern._body = nil
    end
end

local function GetLight(inst)
    if inst._body then
        return inst._body.Light
    else
        return inst.Light
    end
end

local function EvalRadius(t)
    if t <= 0 then return LING_LANTERN_CONFIG.LIGHT_RADIUS_MIN end
    -- 从最小值到最大值的平滑过渡
    local scaled = 0.35 + 0.65 * (t ^ 0.7)
    return LING_LANTERN_CONFIG.LIGHT_RADIUS_MIN + (LING_LANTERN_CONFIG.LIGHT_RADIUS_MAX - LING_LANTERN_CONFIG.LIGHT_RADIUS_MIN) * scaled
end

local function EvalIntensity(t)
    if t <= 0 then return LING_LANTERN_CONFIG.LIGHT_INTENSITY_MIN end
    -- 从最小值到最大值的平滑过渡
    local scaled = t ^ 0.9
    return LING_LANTERN_CONFIG.LIGHT_INTENSITY_MIN + (LING_LANTERN_CONFIG.LIGHT_INTENSITY_MAX - LING_LANTERN_CONFIG.LIGHT_INTENSITY_MIN) * scaled
end

-- 统一的光照更新函数
local function UpdateLightSystem(inst)
    
    local fuel_percent = GetFuelPercent(inst)

    local radius = EvalRadius(fuel_percent)
    local intensity = EvalIntensity(fuel_percent)

    -- 颜色随燃料略微变暗（低燃料时偏冷/暗）
    local c1, c2, c3 = unpack(LING_LANTERN_CONFIG.LIGHT_COLOR)
    local color_scale = 0.6 + 0.4 * fuel_percent
    local r, g, b = c1 * color_scale, c2 * color_scale, c3 * color_scale
    local light = GetLight(inst)
    light:SetRadius(radius)
    light:SetIntensity(intensity)
    light:SetFalloff(LING_LANTERN_CONFIG.LIGHT_FALLOFF)
    light:SetColour(r, g, b)
end

-- ========== 烟雾效果管理 ==========
local function CreateSmoke(inst)
    if inst._create_smoke_task then
        inst._create_smoke_task:Cancel()
        inst._create_smoke_task = nil
    end
    inst._create_smoke_task = inst:DoTaskInTime(0, function()
        inst._create_smoke_task = nil
        if inst._smoke then
            return -- 已存在，无需重复创建
        end

        inst._smoke = SpawnPrefab("ling_lantern_smoke")
        inst._smoke.entity:AddFollower()
        inst._smoke._lantern = inst
        inst:ListenForEvent("onremove", OnRemoveSmoke, inst._smoke)
        -- 设置烟雾跟随位置
        local offset = LING_LANTERN_CONFIG.SMOKE_OFFSET
        local state = GetLanternState(inst)
        if state == LANTERN_STATE.EQUIPPED and inst._body then
            inst._smoke.Follower:FollowSymbol(inst._body.GUID, "lantern_swing",
                                                offset[1], offset[2], offset[3])
        elseif state == LANTERN_STATE.GROUND then
            inst._smoke.Follower:FollowSymbol(inst.GUID, "lantern_swing",
                                                offset[1], offset[2], offset[3])
        end
    end)
end

local function RemoveSmoke(inst)
    if inst._create_smoke_task then
        inst._create_smoke_task:Cancel()
        inst._create_smoke_task = nil
    end
    if inst and inst._smoke then
        inst._smoke:Remove()
        inst._smoke = nil
    end
end

-- ========== 开关控制 ==========

local autoCloseSymbol = Symbol("AutoClose")

local function TurnOff(inst)
    inst[autoCloseSymbol] = true
    inst.components.machine:TurnOff()
    inst[autoCloseSymbol] = nil
end

local function MachineTurnOffCallback(inst)
    if not inst[autoCloseSymbol] and GetLanternState(inst) == LANTERN_STATE.GROUND and TheWorld.state.isnight then
        inst._auto_turnon_at_night = false
    end
    -- 移除烟雾效果
    RemoveSmoke(inst)
    inst.components.fueled:StopConsuming()
    local light = GetLight(inst)
    light:Enable(false)
end

local function TurnOn(inst)
    inst.components.machine:TurnOn()
end

local function MachineTurnOnCallback(inst)
    inst._auto_turnon_at_night = true
    -- 检查是否是在地面打开的
    if GetLanternState(inst) == LANTERN_STATE.GROUND then
        inst._auto_turnon_at_night = true
    end
    CreateSmoke(inst)
    -- 开始消耗燃料
    inst.components.fueled:StartConsuming()
    local light = GetLight(inst)
    light:Enable(true)
    -- 更新光照系统
    UpdateLightSystem(inst)
end

-- ========== 灯体管理 ==========
local function CreateLanternBody(inst, owner)
    if inst._body then
        inst._body:Remove()
    end

    inst._body = SpawnPrefab("ling_lanternbody")
    inst._body._lantern = inst
    inst:ListenForEvent("onremove", OnRemoveBody, inst._body)

    -- 设置跟随
    inst._body.entity:SetParent(owner.entity)
    inst._body.entity:AddFollower()
    local offset = LING_LANTERN_CONFIG.BODY_OFFSET
    inst._body.Follower:FollowSymbol(owner.GUID, "swap_object", offset[1], offset[2], offset[3])
end

local function RemoveLanternBody(inst)
    if inst._body then
        inst._body:Remove()
        inst._body = nil
    end
end

local function UpdateOwnerAnimation(inst, owner, equipping)
    if equipping then
        -- 装备时的动画设置
        owner.AnimState:OverrideSymbol("swap_object", "swap_ling_lantern_stick", "swap_ling_lantern_stick")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    else
        -- 卸下时的动画设置
        if inst._body and inst._body.entity:IsVisible() then
            owner.AnimState:OverrideSymbol("swap_object", "swap_ling_lantern", "swap_ling_lantern")
        end
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end
end

-- ========== 其他回调 ==========
local function OnAttack(inst, attacker, target)
    -- 攻击回调函数，可以在这里添加特殊攻击效果
end

local function AddWeaponComponent(inst)
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(LING_LANTERN_CONFIG.ATTACK_DAMAGE)
    inst.components.weapon:SetRange(LING_LANTERN_CONFIG.ATTACK_RANGE)
    inst.components.weapon:SetOnAttack(OnAttack)
end

-- 更新武器可用状态
local function UpdateWeaponDamage(inst)
    local fuel_percent = GetFuelPercent(inst)
    if fuel_percent <= 0 then
        if inst.components.weapon then
            inst:RemoveComponent("weapon")
        end
        return
    end
    if not inst.components.weapon then
        AddWeaponComponent(inst)
    end
    local poetry_max = 0
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner and owner.components.ling_poetry then
            poetry_max = owner.components.ling_poetry:GetMax()
        end
    end
    local damage = LING_LANTERN_CONFIG.ATTACK_DAMAGE + fuel_percent * poetry_max
    inst.components.weapon:SetDamage(damage)
end



-- ========== 事件回调 ==========
local function OnRemove(inst)
    RemoveSmoke(inst)
    RemoveLanternBody(inst)
end

local function OnDropped(inst)
    RemoveLanternBody(inst)
    UpdateWeaponDamage(inst)
    TurnOff(inst)
    if not inst.turn_on_task then
        inst.turn_on_task = inst:DoTaskInTime(0, function()
            inst.turn_on_task = nil
            if not inst:IsLightGreaterThan(0.5) then
                TurnOn(inst)
            end
        end)
    end
end

local function OnEquip(inst, owner)
    UpdateOwnerAnimation(inst, owner, true)

    -- 创建灯体
    CreateLanternBody(inst, owner)
    -- 监听状态变化以更新动画
    -- inst._body:ListenForEvent("newstate", function(owner, data)
    --     if inst._smoke then
    --         if inst._body then
    --             ArkLogger:Debug("ling_lantern:OnEquip - newstate - follow body")
    --             inst._smoke.Follower:FollowSymbol(inst._body.GUID, "lantern_swing",
    --                                                 LING_LANTERN_CONFIG.SMOKE_OFFSET[1], LING_LANTERN_CONFIG.SMOKE_OFFSET[2], LING_LANTERN_CONFIG.SMOKE_OFFSET[3])
    --         else
    --             ArkLogger:Debug("ling_lantern:OnEquip - newstate - follow owner")
    --             inst._smoke.Follower:FollowSymbol(owner.GUID, "swap_object", LING_LANTERN_CONFIG.SMOKE_OFFSET[1], LING_LANTERN_CONFIG.SMOKE_OFFSET[2], LING_LANTERN_CONFIG.SMOKE_OFFSET[3])
    --         end
    --     end
    -- end, owner)
    -- 更新武器状态
    UpdateWeaponDamage(inst)
    TurnOn(inst)
end

local function OnUnequip(inst, owner)
    UpdateOwnerAnimation(inst, owner, false)

    -- 更新武器状态（卸下时重新计算，诗意信息不再可用）
    RemoveLanternBody(inst)
    UpdateWeaponDamage(inst)
end

local function OnEquipToModel(inst, owner, from_ground)
    -- 装备到模型时关闭
    -- TurnOff(inst)
end

local function OnFuelEmpty(inst)
    inst:RemoveTag("fueldepleted")
    -- 通知装备者火把燃尽
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner then
            owner:PushEvent("torchranout", {torch = inst})
        end
    end

    -- 更新武器状态
    UpdateWeaponDamage(inst)
end

local function OnFuelUpdate(inst)
    UpdateLightSystem(inst)
    UpdateWeaponDamage(inst)
end

local function OnRefueled(inst, fuel_value)
    -- 如果已经打开, 开始燃烧
    if inst.components.machine:IsOn() then
        inst.components.fueled:StartConsuming()
    end
end

local function GetStatus(inst)
    local fuel_percent = GetFuelPercent(inst)
    if fuel_percent <= 0 then
        return "OUT"
    elseif fuel_percent <= 0.2 then
        return "LOWFUEL"
    end
    return "NORMAL"
end

local function OnPhaseChanged(inst, phase)
    local status = GetLanternState(inst)
    if not status == LANTERN_STATE.GROUND then
        return
    end
    if phase == "night" and inst._auto_turnon_at_night then
        TurnOn(inst)
    end
    if phase == 'day' then
        TurnOff(inst)
    end
end

local function OnLoad(inst, data)
    if data and data.ground_turnon then
        inst._auto_turnon_at_night = true
    end
end

local function OnSave(inst)
    return {
        ground_turnon = inst._auto_turnon_at_night,
    }
end

-- ========== 主预制体构造函数 ==========
local function CreateLingLantern()
    local inst = CreateEntity()

    -- 添加基础组件
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    -- 设置光照属性（初始关闭，避免bug）
    inst.Light:SetRadius(0)
    inst.Light:SetFalloff(LING_LANTERN_CONFIG.LIGHT_FALLOFF)
    inst.Light:SetIntensity(0)
    inst.Light:SetColour(unpack(LING_LANTERN_CONFIG.LIGHT_COLOR))
    inst.Light:Enable(false)

    -- 物理属性
    MakeInventoryPhysics(inst)

    -- 动画设置
    inst.AnimState:SetBank("ling_lantern")
    inst.AnimState:SetBuild("ling_lantern")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetFinalOffset(1)

    -- 标签
    inst:AddTag("weapon")

    -- inst:AddTag("pillow")
    inst._laglength = 0.2

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- 随机动画帧
    inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)

    -- ========== 组件配置 ==========

    -- 检查组件
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    -- 物品组件
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "ling_lantern"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ling_lantern.xml"
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(TurnOff)

    -- 燃料组件
    inst:AddComponent("fueled")
    inst:DoTaskInTime(1, function() inst:RemoveTag("fueldepleted") end)
    inst.components.fueled:InitializeFuelLevel(LING_LANTERN_CONFIG.FUEL_MAX)
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled.accepting = true
    inst.components.fueled.bonusmult = LING_LANTERN_CONFIG.FUEL_BONUS_MULT
    inst.components.fueled:SetDepletedFn(OnFuelEmpty)
    inst.components.fueled:SetUpdateFn(OnFuelUpdate)
    inst.components.fueled:SetTakeFuelFn(OnRefueled)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled:SetSections(10)
    inst.components.fueled:SetSectionCallback(function () OnFuelUpdate(inst) end)

    -- 武器组件
    AddWeaponComponent(inst)

    -- 机器组件（右键开关）
    inst:AddComponent("machine")
    inst.components.machine.turnonfn = MachineTurnOnCallback
    inst.components.machine.turnofffn = MachineTurnOffCallback
    inst.components.machine.cooldowntime = 0

    -- 装备组件
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:WatchWorldState("phase", OnPhaseChanged)

    -- 事件处理
    inst.OnRemoveEntity = OnRemove

    -- 保存加载处理
    inst.OnLoad = OnLoad
    inst.OnSave = OnSave
    -- 初始化状态
    inst._smoke = nil
    inst._body = nil

    MakeHauntableLaunch(inst)

    return inst
end


-- ========== 灯体预制体构造函数 ==========
local function CreateLanternBody()
    local inst = CreateEntity()

    -- 添加基础组件
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    -- 动画设置
    inst.AnimState:SetBank("ling_lantern")
    inst.AnimState:SetBuild("ling_lantern")
    inst.AnimState:PlayAnimation("idle_body_loop", true)
    inst.AnimState:SetFinalOffset(1)

    inst.Light:Enable(true)
    inst.Light:SetRadius(0)
    inst.Light:SetFalloff(LING_LANTERN_CONFIG.LIGHT_FALLOFF)
    inst.Light:SetIntensity(0)
    inst.Light:SetColour(unpack(LING_LANTERN_CONFIG.LIGHT_COLOR))

    -- 标签
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- 随机动画帧
    inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)

    -- 不保存到存档
    inst.persists = false

    return inst
end

-- ========== 导出预制体 ==========
return Prefab("ling_lantern", CreateLingLantern, assets),
       Prefab("ling_lanternbody", CreateLanternBody, assets)
