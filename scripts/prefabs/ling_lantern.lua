local assets = {
    Asset("ATLAS", "images/inventoryimages/ling_lantern.xml"),
    Asset("ANIM", "anim/ling_lantern.zip"),
}

-- ========== 常量配置 ==========
local LING_LANTERN_CONFIG = {
    -- 燃料相关
    FUEL_MAX = 480,                    -- 8分钟 = 480秒
    FUEL_REFILL_AMOUNT = 0.1,         -- 每个噩梦燃料补充10%
    FUEL_BONUS_MULT = 0.25,           -- 燃料加成倍数

    -- 光照相关
    LIGHT_RADIUS_MAX = 3,
    LIGHT_FALLOFF = 1,
    LIGHT_INTENSITY_MAX = 0.5,
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
    EQUIPPED = "equipped",
    INVENTORY = "inventory",
    GROUND = "ground"
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

-- 检查是否应该有光照
local function ShouldHaveLight(inst)
    local fuel_percent = GetFuelPercent(inst)
    local machine_on = inst.components.machine:IsOn()
    return fuel_percent > 0 and machine_on
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

-- ========== 光照系统 ==========
-- 统一的光照更新函数 - 修复了燃料为0时的亮度bug
local function UpdateLightSystem(inst)
    local state = GetLanternState(inst)
    local fuel_percent = GetFuelPercent(inst)
    local should_have_light = ShouldHaveLight(inst)

    -- 计算光照属性
    local radius = should_have_light and (LING_LANTERN_CONFIG.LIGHT_RADIUS_MAX * fuel_percent) or 0
    local intensity = should_have_light and (LING_LANTERN_CONFIG.LIGHT_INTENSITY_MAX * fuel_percent) or 0

    if state == LANTERN_STATE.EQUIPPED and inst._body then
        print("ling_lantern: UpdateLightSystem - equipped")
        -- 装备状态：使用灯体光照
        inst._body.Light:SetRadius(radius)
        inst._body.Light:SetIntensity(intensity)
        inst._body.Light:Enable(should_have_light)
        -- 关闭本体光照
        inst.Light:Enable(false)
    else
        print("ling_lantern: UpdateLightSystem - ground/inventory")
        -- 地面或库存状态：使用本体光照
        inst.Light:SetRadius(radius)
        inst.Light:SetIntensity(intensity)
        inst.Light:Enable(should_have_light)
        -- 关闭灯体光照（如果存在）
        if inst._body then
            inst._body.Light:Enable(false)
        end
    end
end

-- ========== 烟雾效果管理 ==========
local function CreateSmoke(inst)
    if inst._smoke then
        return -- 已存在，无需重复创建
    end

    inst._smoke = SpawnPrefab("ling_lantern_smoke")
    if inst._smoke then
        inst._smoke.entity:AddFollower()
        inst._smoke._lantern = inst
        inst:ListenForEvent("onremove", OnRemoveSmoke, inst._smoke)
    end
end

local function UpdateSmokePosition(inst)
    if not inst._smoke then
        return
    end

    local state = GetLanternState(inst)
    local offset = LING_LANTERN_CONFIG.SMOKE_OFFSET

    if state == LANTERN_STATE.EQUIPPED and inst._body then
        -- 装备状态：跟随灯体
        if not inst.currentSmokeFollow or inst.currentSmokeFollow ~= "body" then
            inst._smoke.Follower:FollowSymbol(inst._body.GUID, "lantern_swing",
                                             offset[1], offset[2], offset[3])
            inst.currentSmokeFollow = "body"
        end
    elseif state == LANTERN_STATE.GROUND then
        -- 地面状态：跟随灯笼本体
        if not inst.currentSmokeFollow or inst.currentSmokeFollow ~= "ground" then
            inst._smoke.Follower:FollowSymbol(inst.GUID, "lantern_swing",
                                             offset[1], offset[2], offset[3])
            inst.currentSmokeFollow = "ground"
        end
    end
end

local function RemoveSmoke(inst)
    if inst and inst._smoke then
        inst._smoke:Remove()
        inst._smoke = nil
    end
end

-- ========== 开关控制 ==========

local function MachineTurnOffCallback(inst)
    -- 移除烟雾效果
    RemoveSmoke(inst)
    inst.components.fueled:StopConsuming()
    -- 更新光照系统（会关闭所有光照）
    UpdateLightSystem(inst)
end

local function TurnOff(inst)
    inst.components.machine:TurnOff()
end

local function MachineTurnOnCallback(inst)
    if not inst.components.fueled or inst.components.fueled:IsEmpty() then
        TurnOff(inst)
        return
    end
    CreateSmoke(inst)
    UpdateSmokePosition(inst)
    -- 开始消耗燃料
    inst.components.fueled:StartConsuming()
    -- 更新光照系统
    UpdateLightSystem(inst)
end

local function TurnOn(inst)
    inst.components.machine:TurnOn()
end

-- ========== 灯体管理 ==========
local function CreateLanternBody(inst, owner)
    if inst._body then
        inst._body:Remove()
    end

    inst._body = SpawnPrefab("ling_lanternbody")
    if not inst._body then
        return false
    end

    inst._body._lantern = inst
    inst:ListenForEvent("onremove", OnRemoveBody, inst._body)

    -- 设置跟随
    inst._body.entity:SetParent(owner.entity)
    inst._body.entity:AddFollower()
    local offset = LING_LANTERN_CONFIG.BODY_OFFSET
    inst._body.Follower:FollowSymbol(owner.GUID, "swap_object", offset[1], offset[2], offset[3])

    return true
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

-- ========== 伤害计算系统 ==========
-- 计算武器基础伤害：（22+持有者当前诗意最大上限）*目前的燃料百分比
local function CalculateWeaponDamage(inst)
    local fuel_percent = GetFuelPercent(inst)

    -- 燃料为0时伤害为0
    if fuel_percent <= 0 then
        return 0
    end

    -- 获取持有者的诗意最大上限
    local poetry_max = 0
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner and owner.components.ling_poetry then
            poetry_max = owner.components.ling_poetry:GetMax()
        end
    end

    -- 计算伤害：（22+诗意最大上限）*燃料百分比
    local base_damage = LING_LANTERN_CONFIG.ATTACK_DAMAGE + poetry_max
    local final_damage = base_damage * fuel_percent

    return final_damage
end

-- 更新武器可用状态
local function UpdateWeaponEnabled(inst)
    local damage = CalculateWeaponDamage(inst)
    inst.components.weapon:SetDamage(damage)
    if damage <= 0 then
        inst.components.combat.canattack = false
    end
end



-- ========== 事件回调 ==========
local function OnRemove(inst)
    RemoveSmoke(inst)
    RemoveLanternBody(inst)
end

local function OnDropped(inst)
    RemoveLanternBody(inst)
    UpdateWeaponEnabled(inst)
    TurnOn(inst)
end

local function OnEquip(inst, owner)
    UpdateOwnerAnimation(inst, owner, true)

    -- 创建灯体
    if CreateLanternBody(inst, owner) then
        -- 监听状态变化以更新动画
        inst._body:ListenForEvent("newstate", function(owner, data)
            UpdateOwnerAnimation(inst, owner, true)
            if inst._body then
                inst._body:Show()
            end
            UpdateSmokePosition(inst)
        end, owner)

        -- 显示灯体
        if inst._body then
            inst._body:Show()
        end
    end

    -- 更新武器状态（装备时重新计算，因为现在有持有者的诗意信息）
    UpdateWeaponEnabled(inst)
    -- 装备时尝试开启
    print("ling_lantern: OnEquip")
    TurnOn(inst)
end

local function OnUnequip(inst, owner)
    UpdateOwnerAnimation(inst, owner, false)

    -- 更新武器状态（卸下时重新计算，诗意信息不再可用）
    UpdateWeaponEnabled(inst)
    -- 卸下武器一定恢复可攻击状态
    inst.components.combat.canattack = true
    RemoveLanternBody(inst)
    TurnOff(inst)
end

local function OnEquipToModel(inst, owner, from_ground)
    -- 装备到模型时关闭
    TurnOff(inst)
end

local function OnFuelEmpty(inst)
    -- 通知装备者火把燃尽
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner then
            owner:PushEvent("torchranout", {torch = inst})
        end
    end

    -- 更新武器状态
    UpdateWeaponEnabled(inst)

    TurnOff(inst)
end

local function OnFuelUpdate(inst)
    UpdateLightSystem(inst)
    UpdateWeaponEnabled(inst)
end

local function OnRefueled(inst, fuel_value)
    UpdateLightSystem(inst)
    UpdateWeaponEnabled(inst)
    -- 无论在什么状态，只要有燃料就尝试开启
    TurnOn(inst)
end

-- ========== 其他回调 ==========
local function OnAttack(inst, attacker, target)
    -- 攻击回调函数，可以在这里添加特殊攻击效果
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
    inst.components.fueled:InitializeFuelLevel(LING_LANTERN_CONFIG.FUEL_MAX)
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled.secondaryfueltype = "NIGHTMARE"
    inst.components.fueled.accepting = true
    inst.components.fueled.bonusmult = LING_LANTERN_CONFIG.FUEL_BONUS_MULT
    inst.components.fueled:SetDepletedFn(OnFuelEmpty)
    inst.components.fueled:SetUpdateFn(OnFuelUpdate)
    inst.components.fueled:SetTakeFuelFn(OnRefueled)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled:SetSections(10)
    inst.components.fueled:SetSectionCallback(function(section)
        UpdateLightSystem(inst)
    end)

    -- 武器组件
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(LING_LANTERN_CONFIG.ATTACK_DAMAGE) -- 初始伤害，会在装备时重新计算
    inst.components.weapon:SetRange(LING_LANTERN_CONFIG.ATTACK_RANGE)
    inst.components.weapon:SetOnAttack(OnAttack)

    -- 战斗组件（需要用于武器攻击）
    inst:AddComponent("combat")

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

    -- 事件处理
    inst.OnRemoveEntity = OnRemove

    -- 保存加载处理
    inst.OnLoad = function(inst, data)
        -- 延迟更新确保所有组件都已加载
        inst:DoTaskInTime(0, function()
            UpdateWeaponEnabled(inst)
            TurnOn(inst) -- 尝试开启（如果有燃料）
        end)
    end

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

    -- 光照设置（修复bug：初始关闭，由UpdateLightSystem控制）
    inst.Light:Enable(false)
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
       Prefab("ling_lanternbody", CreateLanternBody)
