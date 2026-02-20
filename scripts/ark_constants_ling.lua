return {
  GUARD_LOCATION = {
    NONE= 0,
    CURRENT_WORLD = 1,
    OTHER_WORLD = 2,
  },
  GUARD_SLOT_STATUS = {
    NONE = 0,
    EMPTY = 1,
    SUMMONING = 2,
    OCCUPIED = 3,
    DISABLED = 4,
  },
  -- 形态常量（用于普通守卫的清平/逍遥切换
  GUARD_FORM = {
    NONE = 0,
    QINGPING = 1,
    XIAOYAO = 2,
    XIANJING = 3,
  },
  GUARD_BEHAVIOR_MODE = {
    NONE = 0,
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
  LING_GUARD_PANEL_POSITION = Vector3(-300, 100, 0),
  LING_GUARD_PANEL_OPEN_CONTAINER_POSITION = Vector3(-63, -11, 0),
  LING_GUARD_PANEL_CONTAINER_POSITION = Vector3(-63, -11, 0),
  -- LING_GUARD_PANEL_CLOSE_CONTAINER_POSITION = {54, 111, 0},
  LING_GUARD_PANEL_CLOSE_CONTAINER_POSITION = Vector3(64, 121, 0),
  LING_GUARD_PANEL_PLANT_CONTAINER_POSITION = Vector3(-184, -361, 0),
  LING_GUARD_PANEL_PLANT_CONTAINER_CLOSED_POSITION = Vector3(-184, -181, 0),
  LING_GUARD_PANEL_SCALE = 0.6,
  LING_TRANSFER_FADE_TIME = 1.5,
  -- 室内空间 Z 轴阈值（z >= 此值时视为室内区域）
  INTERIOR_Z_THRESHOLD = 950,
}