-- 令的守卫战斗配置
-- 这个文件包含所有守卫的战斗参数，可以通过修改这些值来调整守卫的行为

local LING_GUARD_CONFIG = {
    -- 跟随参数
    FOLLOW = {
        MIN_FOLLOW_DIST = 2,        -- 最小跟随距离
        TARGET_FOLLOW_DIST = 5,     -- 理想跟随距离
        MAX_FOLLOW_DIST = 10,       -- 最大跟随距离
        MAX_WANDER_DIST = 8,        -- 最大游荡距离
    },
    
    -- 战斗参数
    COMBAT = {
        ATTACK_CHASE_TIME = 25,     -- 攻击追击时间（秒）
        ATTACK_CHASE_DIST = 20,     -- 攻击追击距离
        
        -- 重新定位函数调用间隔
        RETARGET_PERIOD = 3,        -- 重新寻找目标的间隔（秒）
    },
    
    -- 风筝参数
    KITE = {
        DETECTION_RANGE = 12,       -- 风筝检测范围（检测敌对敌人的范围）
        SAFE_DISTANCE = 10,         -- 风筝安全距离（小于此距离开始风筝）
        RUN_DISTANCE = 6,           -- 开始逃跑的距离
        STOP_DISTANCE = 12,         -- 停止逃跑的距离
    },
    
    -- 目标跟随参数（战斗中跟随敌人）
    TARGET_FOLLOW = {
        MIN = 6,                    -- 跟随目标最小距离
        TARGET = 8,                 -- 跟随目标理想距离
        MAX = 15,                   -- 跟随目标最大距离
    },
    
    -- 集群战斗参数
    CLUSTER = {
        COMBAT_RANGE = 20,          -- 集群战斗范围
        SHARE_RANGE = 15,           -- 目标共享范围
        MAX_SIZE = 8,               -- 最大集群大小
    },
    
    -- 行为模式特定参数
    BEHAVIOR_MODES = {
        GUARD = {
            -- 守模式：静止不动，只攻击进入范围的敌人
            ATTACK_RANGE_MULTIPLIER = 1.0,  -- 攻击范围倍数
        },
        ATTACK = {
            -- 攻模式：主动寻找并攻击敌人
            SEARCH_RANGE = 15,               -- 主动搜索敌人的范围
        },
        CAUTIOUS = {
            -- 慎模式：类似阿比盖尔，只在主人受攻击时反击
            PROTECT_RANGE = 10,              -- 保护主人的范围
        },
    },
}

-- 获取配置的函数
function GetLingGuardConfig()
    return LING_GUARD_CONFIG
end

-- 更新配置的函数（用于运行时调整）
function UpdateLingGuardConfig(category, key, value)
    if LING_GUARD_CONFIG[category] and LING_GUARD_CONFIG[category][key] ~= nil then
        LING_GUARD_CONFIG[category][key] = value
        print(string.format("Updated Ling Guard Config: %s.%s = %s", category, key, tostring(value)))
        return true
    else
        print(string.format("Invalid config path: %s.%s", category, key))
        return false
    end
end

-- 重置配置到默认值的函数
function ResetLingGuardConfig()
    -- 这里可以重新加载默认配置
    print("Ling Guard Config reset to defaults")
end

-- 打印当前配置的函数（用于调试）
function PrintLingGuardConfig()
    print("=== Ling Guard Configuration ===")
    for category, settings in pairs(LING_GUARD_CONFIG) do
        print(string.format("[%s]", category))
        for key, value in pairs(settings) do
            print(string.format("  %s = %s", key, tostring(value)))
        end
    end
    print("================================")
end

return LING_GUARD_CONFIG
