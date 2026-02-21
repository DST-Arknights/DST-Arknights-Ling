local BASE_OFF = 1000
local ROOM_SIZE = 60
local ROW_COUNT = BASE_OFF / ROOM_SIZE * 2

---这里选择和哈姆雷特的组件同名，不过代码不一样，除了count外也许更像一个工具函数集合
local InteriorSpawner = Class(function(self, inst)
    self.inst = inst

    self.count = 0 --主机数据
    self.globalInstance = nil
end)

function InteriorSpawner:GetDis()
    return 12 --半径
end

-- 房间边界
function InteriorSpawner:getSpawnOrigin()
    return {
        dx = { -6.5, 5.5 }, --上下
        dz = { -9, 8 }      --左右
    }
end

function InteriorSpawner:GetGlobalInstance()
    if self.globalInstance then
        return self.globalInstance
    end
    local pos = self:GetPos()
    local door = self:SpawnHouseDoorInteriorPrefabs(pos.x, pos.z)
    self.globalInstance = door
    return door
end

--- 当房屋被摧毁时把屋内的掉落物扔出来
--- 如果是remove就移除屋内道具，如果是敲毁就返还材料，只包括lootdropper和inventoryitem
function InteriorSpawner:OnHouseDestroy(house, destroyer, isRemove)
    local centerPos = house.components.hamletdoor and house.components.hamletdoor.centerPos
    if not centerPos then return end

    local dis = self:GetDis()
    local hx, hy, hz = house.Transform:GetWorldPosition()
    if not isRemove then
        --摧毁室内建筑，生成掉落物
        for _, v in ipairs(TheSim:FindEntities(centerPos.x, centerPos.y, centerPos.z, dis)) do
            if not v:HasTag("ling_cloud_pavilion_floor") and v ~= house then  --地板下面再删除
                if v.components.workable then
                    v.components.workable:Destroy(destroyer or floor) --包括其他的房间
                elseif v.components.health and not v.components.health:IsDead() and not v.components.locomotor
                    and v.components.lootdropper then
                    v.components.lootdropper:DropLoot() --一般是在死亡的sg中生成，我杀死直接移除不会生成额外的掉落物
                    v.components.health:Kill()
                end
            end
        end
    end

    --传送掉落物，移除地板
    for _, v in ipairs(TheSim:FindEntities(centerPos.x, centerPos.y, centerPos.z, dis)) do
        if not isRemove and v.components.inventoryitem then
            house.components.lootdropper:FlingItem(v) --借用lootdropper组件抛出物品
        elseif v.components.health and v.components.locomotor then
            if v:HasTag("player") then
                -- 玩家落水处理
                v.sg:GoToState("sink_fast")
            else
                v.Transform:SetPosition(hx, hy, hz)
            end
        else
            v:Remove()
        end
    end
end

---从地图左上角开始，从左到右，从上到下累积
function InteriorSpawner:GetPos()
    local x = (self.count % ROW_COUNT) * ROOM_SIZE - BASE_OFF
    local z = BASE_OFF + math.ceil(self.count / ROW_COUNT) * ROOM_SIZE
    self.count = self.count + 1
    return Vector3(x, 0, z)
end

--- 不可见墙，里侧阻挡玩家移动，外侧限制建造和摆放位置
function InteriorSpawner:SpawnWall(x, z)
    local origin = self:getSpawnOrigin()
    local STEP = 1

    local function placeWall(wx, wz)
        local part = SpawnPrefab("ling_wall_tigerpond")
        part:AddTag("NOBLOCK")
        part.Transform:SetPosition(wx, 0, wz)
    end

    -- 上下两条边（沿 z 轴）
    for dz = origin.dz[1], origin.dz[2], STEP do
        placeWall(x + origin.dx[1] + 0.5, z + dz + 0.5)
        placeWall(x + origin.dx[2] + 0.5, z + dz + 0.5)
    end

    -- 左右两条边（沿 x 轴，跳过已放置的角）
    for dx = origin.dx[1] + STEP, origin.dx[2], STEP do
        placeWall(x + dx + 0.5, z + origin.dz[1] + 0.5)
        placeWall(x + dx + 0.5, z + origin.dz[2] + 0.5)
    end
end

function InteriorSpawner:OnSave()
    local data = {
        count = self.count,
    }
    local ents = {}
    if self.globalInstance then
        data.globalInstance = self.globalInstance.GUID
        table.insert(ents, self.globalInstance.GUID)
    end
    return data, ents
end

function InteriorSpawner:OnLoad(data)
    if not data then return end
    self.count = data.count or self.count
end

function InteriorSpawner:LoadPostPass(newents, data)
    if data and data.globalInstance then
        self.globalInstance = newents[data.globalInstance].entity
    end
    if data.count then
        self.count = data.count
    end
end

---根据格式初始化室内装饰，并保存初始化数据
function InteriorSpawner:InitHouseInteriorPrefab(p, data)
    if data.children then
        p.tempChildrens = data.children
    end
    if data.rotation then
        p.Transform:SetRotation(data.rotation)
    end
    if data.animdata then
        if data.animdata.flip then
            p.AnimState:SetScale(-1, 1)
        end
        if data.animdata.bank then
            p.AnimState:SetBank(data.animdata.bank)
        end
        if data.animdata.build then
            p.AnimState:SetBuild(data.animdata.build)
        end
        if data.animdata.anim then
            p.AnimState:PlayAnimation(data.animdata.anim)
        end
        if data.animdata.background then
            p.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
            -- p.AnimState:SetOrientation(ANIM_ORIENTATION.RotatingBillboard)
            p.AnimState:SetSortOrder(3)
        end
    end

    if data.addtags then
        for _, tag in ipairs(data.addtags) do
            p:AddTag(tag)
        end
    end
end

-- 清理目标区域的空间
-- 虽然房子坐标是累增的，但是防止一些特殊情况，比如mod中途移除再添加导致count重新计数，或者其他mod也有小房子，房子生成位置冲突
function InteriorSpawner:ClearSpace(x, z)
    for _, ent in ipairs(TheSim:FindEntities(x, 0, z, self:GetDis())) do
        ent:Remove()
    end
end

---根据格式初始化室内装饰
function InteriorSpawner:SpawnHouseDoorInteriorPrefabs(x, z)
    self:ClearSpace(x, z)

    self:SpawnWall(x, z)
    
    local ling_cloud_pavilion_props = {
        {
            name = "ling_cloud_pavilion_exit_door",
            x_offset = 4.7,
            animdata = { bank = "pig_shop_doormats", build = "pig_shop_doormats", anim = "idle_old", background = true },
        },
        { name = "ling_wallinteriorplayerhouse", x_offset = -2.8, },
        { name = "ling_cloud_pavilion_interior_floor",   x_offset = -2.4 }
    }
    local door = nil
    for _, data in ipairs(ling_cloud_pavilion_props) do
        data = shallowcopy(data)

        local p = SpawnPrefab(data.name)

        if x and z and (data.x_offset or data.z_offset) then
            p.Transform:SetPosition(x + (data.x_offset or 0), data.y_offset or 0, z + (data.z_offset or 0))
            data.x_offset = nil
            data.y_offset = nil
            data.z_offset = nil
        end

        self:InitHouseInteriorPrefab(p, data)
        p.initData = data
        if data.name == "ling_cloud_pavilion_exit_door" then
            door = p
        end
    end
    return door
end

---传入hamletdoor组件对象，递归检测内部是否存在玩家
local TNTERIOR_ONE_OF_TAGS = { "player", "hamlet_door" }
function InteriorSpawner:InterioHasPlayer(door)
    local centerPos = door.components.hamletdoor and door.components.hamletdoor.centerPos

    if not centerPos then return false end

    local doors = {}
    for _, v in ipairs(TheSim:FindEntities(centerPos.x, 0, centerPos.z, self:GetDis(), nil, nil, TNTERIOR_ONE_OF_TAGS)) do
        if v:HasTag("player") then
            return true
        else
            table.insert(door, v)
        end
    end

    for _, d in ipairs(doors) do
        if self:InterioHasPlayer(d) then
            return true
        end
    end

    return false
end

return InteriorSpawner
