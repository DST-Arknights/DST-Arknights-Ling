return {
  SKILL_STATUS = {
    LOCKED = "locked",
    ENERGY_RECOVERING = "energy_recovering",
    BUFFING = "buffing",
    BULLETING = "bulleting",
  },
  ENERGY_RECOVERY_MODE = {
    NONE = "none",
    AUTO = "auto",
    ATTACK = "attack",
    DEFENSIVE = "defensive",
  },
  ACTIVATION_MODE = {
    PASSIVE = "passive",
    MANUAL = "manual",
    AUTO = "auto",
  },
  MAX_SKILL_LIMIT = 6,
  MAX_SKILL_LEVEL = 10,
  GUARD_SLOT_STATUS = {
    EMPTY = 0,
    SUMMONING = 1,
    OCCUPIED = 2,
    DISABLED = 3,
    OTHER_WORLD = 4,
  },
  -- 槽位类型（仅基础/高级，用于网络槽位与召唤链路）
  GUARD_SLOT_TYPE = {
    BASIC = 1,
    ELITE = 2,
  },
  -- 形态常量（用于普通守卫的清平/逍遥切换）
  GUARD_FORM = {
    QINGPING = "qingping",
    XIAOYAO = "xiaoyao",
  },
  GUARD_BEHAVIOR_MODE = {
    CAUTIOUS = 1, -- 慎：类似阿比盖尔的行为
    GUARD = 2,    -- 守：静止不动，攻击进入范围的敌人
    ATTACK = 3,   -- 攻：锁定目标跟随攻击
  },
  GUARD_WORK_MODE = {
    NONE = 0,
    CHOP = 1, -- 伐木
    DIG = 2,  -- 挖掘
    DIG_LAND = 3, -- 挖地
    HAMMER = 4, -- 锤炼
    MINE = 5, -- 采矿
    PLANT = 6, -- 种植
  },
  LING_GUARD_PANEL_POSITION = { -300, 100, 0},
  LING_GUARD_PANEL_OPEN_CONTAINER_POSITION = {-63, -11, 0},
  LING_GUARD_PANEL_CONTAINER_POSITION = {-63, -11, 0},
  -- LING_GUARD_PANEL_CLOSE_CONTAINER_POSITION = {54, 111, 0},
  LING_GUARD_PANEL_CLOSE_CONTAINER_POSITION = {64, 121, 0},
  LING_GUARD_PANEL_PLANT_CONTAINER_POSITION = {-184, -361, 0},
  LING_GUARD_PANEL_PLANT_CONTAINER_CLOSED_POSITION = {-184, -181, 0},
  LING_GUARD_PANEL_SCALE = 0.6,
  LING_TRANSFER_FADE_TIME = 1.5,
}