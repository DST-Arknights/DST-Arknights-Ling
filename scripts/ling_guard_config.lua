-- 令的守卫配置（重构版）
-- 结构：COMMON 通用参数 + MODE.{GUARD,CAUTIOUS,ATTACK} 按形态覆盖的参数
-- 说明：
--  1) 若 MODE 内未覆盖字段，则回落到 COMMON
--  2) GUARD_RANGE 同时用作“守形态的工作半径”

local CONFIG = {
    COMMON = {
        FOLLOW = {
            MIN = 0,          -- 最小跟随距离
            TARGET = 5,       -- 理想跟随距离
            MAX = 10,         -- 最大跟随距离
            WANDER_DIST = 8,  -- 跟随点附近游荡距离
        },
        KITE = {              -- 风筝/规避
            DETECTION_RANGE = 12,
            SAFE_DISTANCE   = 10,
            RUN_DISTANCE    = 8,
            STOP_DISTANCE   = 12,
        },
        LEADER_DEFENSE_DIST = 8,
    },

    MODE = {
        GUARD = {
            GUARD_RANGE = 16, -- 守点/工作半径
            CHASE_RANGE = 24, -- 守形态最大追击半径（> GUARD_RANGE）
            ATTACK = {
                CHASE_TIME = 25,
                CHASE_DIST = 8,
            },
            WORK = {
                SAFE_RADIUS = 10, -- 安全范围（你要求：用配置）
                ACTIONS = { CHOP=true, MINE=true, DIG=true, HAMMER=true },
                PICKUP = {
                    GROUP_MODE = "around_last_work", -- 先拾最近工作点一组，再空闲清理
                    SEARCH_ALL_IN_GUARD_RANGE = true, -- 空闲时清理守卫范围内其他掉落组
                },
            },
        },

        CAUTIOUS = {
            ATTACK = {
                CHASE_TIME = 20,
                CHASE_DIST = 10,
            },
            FOLLOW = { MIN = 0, TARGET = 5, MAX = 10, WANDER_DIST = 8 },
        },

        ATTACK = {
            -- 仅行为更激进，不改属性
            ATTACK = {
                CHASE_TIME = 30,
                CHASE_DIST = 16,
            },
            FOLLOW = { MIN = 0, TARGET = 6, MAX = 12, WANDER_DIST = 10 },
        },
    },
}

-- 简单的获取函数，保留旧名兼容
function GetLingGuardConfig()
    return CONFIG
end

-- 兼容旧的 Update 接口（仅支持一级键或两级键）
function UpdateLingGuardConfig(category, key, value)
    local t = CONFIG[category]
    if t ~= nil and t[key] ~= nil then
        t[key] = value
        print(string.format("Updated Ling Guard Config: %s.%s = %s", category, key, tostring(value)))
        return true
    end
    print(string.format("Invalid config path: %s.%s", tostring(category), tostring(key)))
    return false
end

function ResetLingGuardConfig()
    print("Ling Guard Config reset to defaults (restart mod to fully reload)")
end

function PrintLingGuardConfig()
    local function print_table(prefix, tbl)
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                print(prefix .. tostring(k) .. ": {")
                print_table(prefix .. "  ", v)
                print(prefix .. "}")
            else
                print(prefix .. tostring(k) .. " = " .. tostring(v))
            end
        end
    end
    print("=== Ling Guard Configuration (reworked) ===")
    print_table("", CONFIG)
    print("===========================================")
end

return CONFIG
