local CONSTANTS = require("ark_constants_ling")
local getGuardConfig = require("ling_guard_config").getGuardConfig

local MUST_TAGS = {"_combat"}
local EXCLUDE_TAGS = {"playerghost", "INLIMBO", "player", "companion", "wall", "ling_summon"}

-- 领主附近扫描缓存（减少多守卫重复扫描）
local LEADER_SCAN_CACHE = {}
local CACHE_TTL = 0.25 -- 秒，足够短以保证新鲜度

local function find_ents_near_leader_cached(leader, radius)
  if leader == nil or not leader:IsValid() or radius == nil or radius <= 0 then
    return {}
  end

  local now = GetTime and GetTime() or os.clock()
  local guid = leader.GUID
  local entry = LEADER_SCAN_CACHE[guid]
  if entry == nil then
    entry = {
      radii = {},
      listener_added = false
    }
    LEADER_SCAN_CACHE[guid] = entry
  end

  if not entry.listener_added then
    leader:ListenForEvent("onremove", function()
      LEADER_SCAN_CACHE[guid] = nil
    end)
    entry.listener_added = true
  end

  local rec = entry.radii[radius]
  if rec == nil or (now - rec.time) > CACHE_TTL then
    local pos = leader:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, radius, MUST_TAGS, EXCLUDE_TAGS)
    rec = {
      time = now,
      pos = pos,
      ents = ents
    }
    entry.radii[radius] = rec
  end

  -- 取用时过滤：剔除失效、进出虚空、以及已不在范围内的实体
  local filtered = {}
  local r2 = radius * radius
  for i = 1, #rec.ents do
    local e = rec.ents[i]
    if e ~= nil and e:IsValid() and not e:IsInLimbo() then
      -- 使用当前 leader 位置做实时半径校验，避免过期位置导致误差
      if leader:GetDistanceSqToInst(e) <= r2 then
        table.insert(filtered, e)
      end
    end
  end
  return filtered
end

-- 友军判定：守卫本体、同阵营召唤物、同主人的随从、自己的随从
local function IsFriendlyToGuard(inst, guy)
  if guy == nil or not guy:IsValid() then
    return true
  end
  if guy == inst then
    return true
  end
  if guy:HasTag("ling_summon") then
    return true
  end

  local leader = inst.components.follower and inst.components.follower.leader or nil
  if leader ~= nil then
    if guy == leader then
      return true
    end
    if guy.components and guy.components.follower and guy.components.follower.leader == leader then
      return true
    end
  end
  if guy.components and guy.components.follower and guy.components.follower.leader == inst then
    return true
  end
  return false
end

-- 是否为威胁：有效、可见、未死亡、可被攻击、且满足仇恨或怪物类标签
local function IsThreatToGuard(inst, guy)
  if not (guy and guy:IsValid()) then
    return false
  end
  if guy.entity and not guy.entity:IsVisible() then
    return false
  end
  if guy.components.health and guy.components.health:IsDead() then
    return false
  end
  if not (inst.components.combat and inst.components.combat:CanTarget(guy)) then
    return false
  end
  if IsFriendlyToGuard(inst, guy) then
    return false
  end

  if guy:HasTag("player") then
    return false
  end
  if guy:HasTag("companion") then
    return false
  end
  if guy:HasTag("wall") then
    return false
  end

  local leader = inst.components.follower and inst.components.follower.leader or nil
  if guy.components and guy.components.combat then
    if guy.components.combat:TargetIs(inst) then
      return true
    end
    if leader and guy.components.combat:TargetIs(leader) then
      return true
    end
  end

  if guy:HasTag("monster") or guy:HasTag("pirate") or guy:HasTag("merm") or guy:HasTag("wonkey") then
    return true
  end
  return false
end

local function list_to_set(list)
  local t = {}
  for _, v in ipairs(list) do
    t[v] = true
  end
  return t
end

local function intersect_lists(a, b)
  local setb = list_to_set(b)
  local res = {}
  for _, v in ipairs(a) do
    if setb[v] then
      table.insert(res, v)
    end
  end
  return res
end

local function union_lists(a, b)
  local set = {}
  local res = {}
  for _, v in ipairs(a) do
    if not set[v] then
      set[v] = true;
      table.insert(res, v)
    end
  end
  for _, v in ipairs(b) do
    if not set[v] then
      set[v] = true;
      table.insert(res, v)
    end
  end
  return res
end

local function find_ents_at(pos, radius)
  if not pos or not radius or radius <= 0 then
    return {}
  end
  return TheSim:FindEntities(pos.x, pos.y, pos.z, radius, MUST_TAGS, EXCLUDE_TAGS)
end

-- 依据规则选取目标：不同模式下按“多个范围的交集”过滤
local function SelectTarget(inst)
  if inst == nil or inst:IsInLimbo() then
    return nil
  end
  local guardConfig = getGuardConfig(inst)
  local leader = inst.components.follower and inst.components.follower.leader or nil

  local leader_def = guardConfig.LEADER_DEFENSE_DIST
  local candidates = nil
  local mode = inst.components.ling_guard:GetBehaviorMode()
  if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
    local guard_range = guardConfig.GUARD_RANGE
    local guard_pos = inst.components.ling_guard.guard_pos

    local list_self = find_ents_at(inst:GetPosition(), guardConfig.DEFENSE_DIST)
    candidates = list_self
    -- 守模式：候选 = 自己的防御范围 ∪ 守卫范围 ∪（若主人位于守卫范围内，则再 ∪ 主人周围的威胁半径）
    local list_guard = find_ents_at(guard_pos, guard_range)
    candidates = union_lists(candidates, list_guard)
    if leader and leader:GetDistanceSqToPoint(guard_pos:Get()) <= (guard_range * guard_range) then
      local list_leader = find_ents_near_leader_cached(leader, leader_def)
      candidates = union_lists(candidates, list_leader)
    end
  else
    -- 慎/攻：自己的防御距离 ∪ 主人的防御距离
    local list_self = find_ents_at(inst:GetPosition(), guardConfig.DEFENSE_DIST)
    local list_leader = leader and find_ents_near_leader_cached(leader, leader_def) or {}
    candidates = union_lists(list_self, list_leader)
  end

  -- 过滤威胁并选择最佳目标
  local best, best_score, best_d2 = nil, math.huge, math.huge
  for _, guy in ipairs(candidates) do
    if IsThreatToGuard(inst, guy) then
      -- 打分：优先正在打主人/自己，其次离主人近；无主则离自己近
      local pri = 2
      if guy.components and guy.components.combat then
        if guy.components.combat:TargetIs(inst) then
          pri = 0
        elseif leader and guy.components.combat:TargetIs(leader) then
          pri = 0
        end
      end
      local d2 = leader and leader:GetDistanceSqToInst(guy) or inst:GetDistanceSqToInst(guy)
      local score = pri * 10000 + d2
      if score < best_score then
        best, best_score, best_d2 = guy, score, d2
      end
    end
  end
  return best
end

return {
  IsThreatToGuard = IsThreatToGuard,
  IsFriendlyToGuard = IsFriendlyToGuard,
  SelectTarget = SelectTarget
}

