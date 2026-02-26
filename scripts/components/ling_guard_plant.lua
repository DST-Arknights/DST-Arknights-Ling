local LING_TUNING = require("ling_guard_tuning")
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local function onlevel(self, level)


  self.inst.replica.ling_guard_plant:SetLevel(level)
  self._enabledSlots = self.inst.replica.ling_guard_plant:GetEnabledSlotsByLevel(level)
end

local function onplanting(self, planting)
    self.inst.replica.ling_guard_plant:SetPlanting(planting)
end

local LingGuardPlant = Class(function(self, inst)
    self.inst = inst
    self._enabledSlots = {}
    self.planting = false
    self.level = 1
    self.seed_item = nil -- 当前种植的种子
    self.product_prefab = nil -- 种子对应的产物
    self.completed_tasks = 0 -- 已完成的任务次数

    -- 监听定时器完成事件
    self.inst:ListenForEvent("timerdone", function(inst, data)
        if data and data.name == "plant_crop" then
            self:OnPlantTimerDone()
        end
    end)
end, nil, {
  level = onlevel,
  planting = onplanting,
})

-- 判断某个索引是否有效
function LingGuardPlant:IsValidIndex(index)
    local enabledSlots = self:GetEnabledSlots()
    for _, enabledIdx in ipairs(enabledSlots) do
        if index == enabledIdx then
            return true
        end
    end
    return false
end

function LingGuardPlant:GetEnabledSlots()
    return self._enabledSlots
end

function LingGuardPlant:SetLevel(level)
    local old_level = self.level
    self.level = level
    -- 如果等级发生变化且正在种植，触发等级变更逻辑
    if old_level ~= level and self.planting then
        self:HarvestCrops()
        self:SetupPlantingTimer()
    end
end

function LingGuardPlant:GetLevel()
    return self.level
end

-- 获取种子对应的产物
function LingGuardPlant:GetProductFromSeed(seed_item)
    if not seed_item then
        return nil
    end

    local product = nil

    -- 如果是随机种子，需要确定具体的作物类型
    if seed_item.prefab == "seeds" then
        -- 使用随机种子的pickproduct逻辑
        product = self:PickRandomProduct()
        return product
    end

    -- 优先检查deployable组件（新的种植系统）
    if seed_item.components.deployable then
        -- 对于deployable种子，需要查看farmplantable组件
        if seed_item.components.farmplantable and seed_item.components.farmplantable.plant then
            -- 从farm_plant_xxx获取对应的作物名称
            local plant_name = FunctionOrValue(seed_item.components.farmplantable.plant, seed_item)
            product = plant_name:gsub("farm_plant_", "") -- 移除前缀获取作物名
        elseif seed_item.components.plantable then
            -- 兼容旧的plantable组件
            product = FunctionOrValue(seed_item.components.plantable.product, seed_item)
        end
    elseif seed_item.components.plantable then
        -- 兼容旧的plantable组件
        product = FunctionOrValue(seed_item.components.plantable.product, seed_item)
    end

    return product
end

-- 随机选择作物产物（参考farm_plants.lua中的pickfarmplant函数，移除杂草）
function LingGuardPlant:PickRandomProduct()
    -- 获取当前季节
    local season = TheWorld.state.season
    local weights = {}
    local season_mod = TUNING.SEED_WEIGHT_SEASON_MOD or 2

    -- 计算每个蔬菜的权重（考虑季节加成）
    for k, v in pairs(VEGGIES) do
        if v.seed_weight and v.seed_weight > 0 then
            local plant_def = PLANT_DEFS and PLANT_DEFS[k]
            local is_good_season = plant_def and plant_def.good_seasons and plant_def.good_seasons[season]
            weights[k] = v.seed_weight * (is_good_season and season_mod or 1)
        end
    end

    -- 使用weighted_random_choice选择
    return weighted_random_choice(weights) or "carrot"
end

-- 检查蔬菜是否有对应的种子
function LingGuardPlant:HasSeeds(veggie_name)
    -- 检查SEEDLESS表，如果在其中则没有种子
    local SEEDLESS = {
        berries = true,
        cave_banana = true,
        cactus_meat = true,
        berries_juicy = true,
        fig = true,
        kelp = true,
    }

    return not SEEDLESS[veggie_name]
end

-- 定时器完成回调
function LingGuardPlant:OnPlantTimerDone()
    self:ProduceCrop()

    local config = LING_TUNING[self.level] and LING_TUNING[self.level].PLANT
    if not config or self.completed_tasks >= config.MAX_CROP then
        self:StopPlanting()
        return
    end

    -- 重新启动定时器
    self:SetupPlantingTimer()
end

-- 设置种植定时器
function LingGuardPlant:SetupPlantingTimer()
    -- 停止现有定时器
    if self.inst.components.timer and self.inst.components.timer:TimerExists("plant_crop") then
        self.inst.components.timer:StopTimer("plant_crop")
    end

    local config = LING_TUNING[self.level] and LING_TUNING[self.level].PLANT
    if not config then
        return
    end

    -- 启动新的定时器
    if self.inst.components.timer then
        print("[LingGuardPlant] SetupPlantingTimer:", config.TIME_PER_CROP)
        self.inst.components.timer:StartTimer("plant_crop", config.TIME_PER_CROP)
    end
end

-- 生产作物
function LingGuardPlant:ProduceCrop()
    if not self.planting or not self.product_prefab then
        print("[LingGuardPlant] ProduceCrop: Not planting or no product")
        return
    end

    local plant_container = self.inst.plant_container
    if not plant_container or not plant_container.components.container then
        print("[LingGuardPlant] ProduceCrop: No plant container")
        return
    end

    -- 根据等级决定放入哪个格子和产物类型
    local enabled_slots = self:GetEnabledSlots()
    for _, slot_index in ipairs(enabled_slots) do
        ArkLogger:Debug("LingGuardPlant:ProduceCrop", slot_index)
        local item_prefab = nil
        local quantity = 1
        local should_create = true

        if slot_index == 1 then
            -- 第一个格子：作物本身
            item_prefab = self.product_prefab
            quantity = 1
        elseif slot_index == 2 then
            -- 第二个格子：作物种子（如果有的话）
            if self:HasSeeds(self.product_prefab) then
                item_prefab = self.product_prefab .. "_seeds"
                quantity = 1
            else
                should_create = false -- 没有种子，跳过这个格子
            end
        elseif slot_index == 3 then
            -- 第三个格子：3个作物
            item_prefab = self.product_prefab
            quantity = 3
        end

            -- 创建新物品并直接放入容器
        if should_create and item_prefab then
            local item = SpawnPrefab(item_prefab)
            if item then
                print("[LingGuardPlant] ProduceCrop:", item.prefab)
                -- 添加守卫作物标签
                item:AddTag("ling_guard_crop")

                -- 设置堆叠数量
                if item.components.stackable and quantity > 1 then
                    item.components.stackable:SetStackSize(quantity)
                end

                -- 直接使用GiveItem，容器会自动处理堆叠
                plant_container.components.container:GiveItem(item, slot_index)
            end
        end
    end

    -- 增加完成任务次数
    self.completed_tasks = self.completed_tasks + 1
end

-- 清空产物容器，将物品转移给玩家
function LingGuardPlant:ClearProductContainer()
    local plant_container = self.inst.plant_container
    local leader = self.inst.components.follower.leader

    if not plant_container or not leader then
        return
    end

    -- 使用ling_guard组件中的转移逻辑
    if leader.components.inventory then
        local container = plant_container.components.container
        -- 使用源码中的 MoveItemFromAllOfSlot 方法转移所有物品
        for i = 1, container.numslots do
            if container:GetItemInSlot(i) then
                container:MoveItemFromAllOfSlot(i, leader, leader)
            end
        end
    else
        -- 如果没有主人或主人没有背包，就丢弃物品
        plant_container.components.container:DropEverything()
    end
end

function LingGuardPlant:StartPlanting()
    local plant_club = self.inst.plant_club
    local plant_container = self.inst.plant_container
    if not plant_club or not plant_container then
        return
    end

    -- 获取第一个种子作为原产物
    local seed_item = plant_club.components.container:GetItemInSlot(1)
    if not seed_item then
        return
    end

    self.seed_item = seed_item
    self.product_prefab = self:GetProductFromSeed(seed_item)
    print("[LingGuardPlant] StartPlanting:", self.product_prefab)
    if not self.product_prefab then
        return
    end

    -- 清空产物容器，将现有物品转移给玩家
    self:ClearProductContainer()

    self.planting = true
    self.completed_tasks = 0

    -- 设置定时器
    self:SetupPlantingTimer()

    local leader = self.inst.components.follower.leader
    if leader then
        plant_club.components.container:Close(leader)
    end
    -- 移除容器里的第一个种子物品
    plant_club.components.container:RemoveItemBySlot(1)
end

-- 收获所有作物（等级变更时调用）
function LingGuardPlant:HarvestCrops()
    if not self.planting then
        return
    end

    -- 立即生产一次作物，不增加任务计数（这是奖励收获）
    local old_completed_tasks = self.completed_tasks
    self:ProduceCrop()
    self.completed_tasks = old_completed_tasks -- 恢复任务计数
end

function LingGuardPlant:StopPlanting()
    self.planting = false
    self.seed_item = nil
    self.product_prefab = nil
    self.completed_tasks = 0

    -- 停止定时器
    if self.inst.components.timer and self.inst.components.timer:TimerExists("plant_crop") then
        self.inst.components.timer:StopTimer("plant_crop")
    end

    local plant_container = self.inst.plant_container
    local plant_club = self.inst.plant_club
    if not plant_container or not plant_club then
        return
    end
    local leader = self.inst.components.follower.leader
    if leader then
        if plant_container.components.container:IsOpenedBy(leader) then
            plant_club.components.container:Open(leader)
        end
    end
end

function LingGuardPlant:isPlanting()
    return self.planting
end

function LingGuardPlant:SetSeed(item)
    local leader = self.inst.components.follower.leader
    local plant_club = self.inst.plant_club
    if not leader or not plant_club then
        return
    end
    self:StartPlanting()
end

function LingGuardPlant:OnSave()
    return {
        level = self.level,
        planting = self.planting,
        product_prefab = self.product_prefab,
        completed_tasks = self.completed_tasks,
        -- 保存种子信息，用于重新确定产物类型
        seed_prefab = self.seed_item and self.seed_item.prefab or nil
    }
end

function LingGuardPlant:OnLoad(data)
    if data then
        self.level = data.level or 1
        self.planting = data.planting or false
        self.product_prefab = data.product_prefab
        self.completed_tasks = data.completed_tasks or 0

        -- 如果保存的是随机种子但没有确定的产物，重新随机确定
        if data.seed_prefab == "seeds" and not self.product_prefab then
            self.product_prefab = self:PickRandomProduct()
            print("[LingGuardPlant] OnLoad: Re-determined random product:", self.product_prefab)
        end

        -- timer组件会自动恢复定时器，我们只需要确保状态一致
        -- 如果正在种植但没有定时器，重新设置
        if self.planting and self.product_prefab then
            if not (self.inst.components.timer and self.inst.components.timer:TimerExists("plant_crop")) then
                self:SetupPlantingTimer()
            end
        end
    end
end

function LingGuardPlant:OnRemoveFromEntity()
    -- 停止定时器
    if self.inst.components.timer and self.inst.components.timer:TimerExists("plant_crop") then
        self.inst.components.timer:StopTimer("plant_crop")
    end
end

return LingGuardPlant
