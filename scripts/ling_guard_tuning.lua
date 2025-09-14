local CONSTANTS = require("ark_constants_ling")
local FORM = CONSTANTS.GUARD_FORM

-- 令的守卫数值与消耗配置（从 summon_guard.lua 迁移并适配“基础守卫(清平/逍遥)”与“高级守卫(弦惊)”结构）
local T = {}

-- 基础守卫（ling_guard_basic）：按等级区分，并在同一等级下区分清平/逍遥形态
T.BASIC = {
    LEVELS = {
        [1] = {
            [FORM.QINGPING] = {
                HEALTH = 300,
                DAMAGE = 30,
                DAMAGE_REDUCTION = 0.1,
                ATTACK_RANGE = 4,
                WALK_SPEED = 2.5,
                RUN_SPEED = 5,
                ATTACK_PERIOD = 4,
                SUMMON_COST = 10,
            },
            -- 逍遥在精一后解锁，此处不提供 1 级
        },
        [2] = {
            [FORM.QINGPING] = {
                HEALTH = 500,
                DAMAGE = 50,
                DAMAGE_REDUCTION = 0.2,
                ATTACK_RANGE = 4,
                WALK_SPEED = 3,
                RUN_SPEED = 6,
                ATTACK_PERIOD = 3,
                SUMMON_COST = 9,
            },
            [FORM.XIAOYAO] = {
                HEALTH = 100,
                DAMAGE = 70,
                DAMAGE_REDUCTION = 0.05,
                ATTACK_RANGE = 15,
                WALK_SPEED = 3,
                RUN_SPEED = 7,
                ATTACK_PERIOD = 5,
                SUMMON_COST = 9,
            },
        },
        [3] = {
            [FORM.QINGPING] = {
                HEALTH = 700,
                DAMAGE = 80,
                DAMAGE_REDUCTION = 0.4,
                ATTACK_RANGE = 4,
                WALK_SPEED = 3.5,
                RUN_SPEED = 7,
                ATTACK_PERIOD = 2,
                SUMMON_COST = 8,
            },
            [FORM.XIAOYAO] = {
                HEALTH = 200,
                DAMAGE = 100,
                DAMAGE_REDUCTION = 0.1,
                ATTACK_RANGE = 15,
                WALK_SPEED = 3.5,
                RUN_SPEED = 8,
                ATTACK_PERIOD = 5,
                SUMMON_COST = 8,
            },
        },
    }
}

-- 高级守卫（ling_guard_elite / 弦惊）
T.ELITE = {
    LEVELS = {
        [3] = {
            HEALTH = 2100,
            DAMAGE = 220,
            DAMAGE_REDUCTION = 0.7,
            ATTACK_RANGE = 4,
            WALK_SPEED = 5,
            RUN_SPEED = 5,
            ATTACK_PERIOD = 3,
            SUMMON_COST = 16,
        }
    }
}

-- 守卫种植系统（与等级相关）
T.PLANT = {
    {
        MAX_CROP = 40,
        TIME_PER_CROP = 8, -- 若需与游戏分钟对齐，改为 8 * 60
    },
    {
        MAX_CROP = 60,
        TIME_PER_CROP = 6 * 60,
    },
    {
        MAX_CROP = 80,
        TIME_PER_CROP = 4 * 60,
    },
}

-- 便捷获取
function T.GetBasicFormLevel(level, form)
    local lv = T.BASIC.LEVELS[level]
    return lv and form and lv[form] or nil
end

function T.GetBasicBothForms(level)
    local lv = T.BASIC.LEVELS[level]
    return lv and lv[FORM.QINGPING], lv and lv[FORM.XIAOYAO]
end

function T.GetEliteLevel(level)
    return T.ELITE.LEVELS[level]
end

-- 计算召唤消耗（用于召唤管理器）
-- kind: "basic"|"elite"; form: FORM 常量（basic 时必传）
function T.GetSummonCost(kind, level, form)
    if kind == "elite" then
        local cfg = T.GetEliteLevel(level)
        return cfg and cfg.SUMMON_COST or nil
    else
        local cfg = T.GetBasicFormLevel(level, form)
        return cfg and cfg.SUMMON_COST or nil
    end
end

return T

