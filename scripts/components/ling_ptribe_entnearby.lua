--- 周期性标记附近指定生物，支持根据时间计时或距离计时
--- 双向标记，既能从标记者拿到被标记者，又能从被标记者拿到标记者，
--- 不保存标记数据，每次加载游戏请手动启动和配置
local EntNearby = Class(function(self, inst)
    self.inst = inst

    self.d = {} --多组标记配置
end)

local function MarkNearbyEnt(inst, name)
    local self = inst.components.ling_ptribe_entnearby

    local cur = GetTime()
    local x, y, z = inst.Transform:GetWorldPosition()

    local sets
    if name then
        sets = { name = self.d[name] }
    else
        sets = self.d
    end
    for name, set in pairs(sets) do
        for _, v in ipairs(TheSim:FindEntities(x, y, z, set.radius, set.mustTags, set.cantTags, set.oneOfTags)) do
            if (not set.targetPrefabs or set.targetPrefabs[v.prefab])
                and (not set.testFn or set.testFn(inst, v, name)) then
                v[set.markKey] = v[set.markKey] or {}

                v[set.markKey][inst] = cur
                set.markManage[v] = cur
            end
        end
    end
end

local function MarkManage(inst, name)
    local self = inst.components.ling_ptribe_entnearby

    local cur = GetTime()
    local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
    local sets
    if name then
        sets = { name = self.d[name] }
    else
        sets = self.d
    end
    for name, set in pairs(sets) do
        for k, lastTime in pairs(set.markManage) do
            if k:IsValid() and k[set.markKey] then
                local p2x, p2y, p2z = k.Transform:GetWorldPosition()
                if (set.markDuration and (cur - lastTime > set.markDuration))
                    or (self.maxDisSq and distsq(p1x, p1z, p2x, p2z) > (type(self.maxDisSq) == "number" and self.maxDisSq or self.maxDisSq(inst, k, name))) then
                    k[set.markKey][inst] = nil
                    set.markManage[k] = nil
                end
            else
                set.markManage[k] = nil
            end
        end
    end
end

---暂停标记
---@param name string|nil 标记组名，如果不填则默认暂停所有标记组
function EntNearby:PauseMark(name)
    if name then
        local set = self.d[name]
        if set and set.markTask then
            set.markTask:Cancel()
            set.markTask = nil
            set.clearTask:Cancel()
            set.clearTask = nil
        end
    else
        for _, set in pairs(self.d) do
            if set and set.markTask then
                set.markTask:Cancel()
                set.markTask = nil
                set.clearTask:Cancel()
                set.clearTask = nil
            end
        end
    end
end

---继续标记
---@param name string|nil 标记组名，如果不填则默认继续所有标记组
function EntNearby:ResumeMark(name)
    if name then
        local set = self.d[name]
        if set and not set.markTask then
            set.markTask = self.inst:DoPeriodicTask(set.period, MarkNearbyEnt, 0, name)
            set.clearTask = self.inst:DoPeriodicTask(set.markDuration or set.period, MarkManage,
                set.markDuration or set.period, name)
        end
    else
        for _, set in pairs(self.d) do
            if set and not set.markTask then
                set.markTask = self.inst:DoPeriodicTask(set.period, MarkNearbyEnt, 0, name)
                set.clearTask = self.inst:DoPeriodicTask(set.markDuration or set.period, MarkManage,
                    set.markDuration or set.period, name)
            end
        end
    end
end

---添加标记组
---@param name string|nil 标记组名
---@param data table|nil 配置
---@return table set 配置数据
function EntNearby:AddMark(name, data)
    data = data or {}

    local set = {
        markKey = data.markKey or name,     --标记key，用于从被管理者身上获取标记者，例如 inst[name] = {XXX1 = true,XXX2 = true}，xxx1就是标记者，需要小心和inst已有属性名冲突
        period = data.period or 4,          -- 每次标记间隔
        markDuration = data.markDuration,   --每个标记持续时间
        maxDisSq = data.maxDisSq,           --允许的最大距离平方，可以是值，也可以是函数
        radius = data.radius or 16,         --标记半径
        targetPrefabs = data.targetPrefabs, --指定预制体名称，要求为k-v形式
        testFn = data.testFn,               --对象测试函数，返回true的对象才会被标记
        mustTags = data.mustTags,
        cantTags = data.cantTags,
        oneOfTags = data.oneOfTags,
        markManage = {}, --管理已标记的对象
    }

    set.markTask = self.inst:DoPeriodicTask(set.period, MarkNearbyEnt, 0, name)
    -- print(set.markDuration or set.period, name)
    set.clearTask = self.inst:DoPeriodicTask(set.markDuration or set.period, MarkManage, set.markDuration or set.period,
        name)

    self.d[name] = set

    return set
end

---更新标记状态
---@param name string|nil 标记组名
---@param isClear boolean|nil 是否清除不再范围的标记对象
function EntNearby:RefreshState(name, isClear)
    MarkNearbyEnt(self.inst, name)
    if isClear then
        MarkManage(self.inst, name)
    end
end

function EntNearby:FindEntity(name, fn)
    if not self.d[name] then return end
    for k, time in pairs(self.d[name].markManage) do
        if fn(self.inst, k, time) then
            return k
        end
    end
end

function EntNearby:FindEntitys(name, fn)
    local ents = {}
    if not self.d[name] then return ents end

    for k, time in pairs(self.d[name].markManage) do
        if fn(self.inst, k, time) then
            table.insert(ents, k)
        end
    end
    return ents
end

function EntNearby:FindEntityByPrefab(name, prefab)
    if not self.d[name] then return end
    for k, _ in pairs(self.d[name].markManage) do
        if k.prefab == prefab then
            return k
        end
    end
end

function EntNearby:FindEntitysByPrefab(name, prefab)
    local ents = {}
    if not self.d[name] then return ents end

    for k, _ in pairs(self.d[name].markManage) do
        if k.prefab == prefab then
            table.insert(ents, k)
        end
    end
    return ents
end

return EntNearby
