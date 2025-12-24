local CONSTANTS = require("ark_constants_ling")
local FORM = CONSTANTS.GUARD_FORM

-- 令的守卫数值与消耗配置
local T = {
    {
        GUARD = {
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
        },
        PLANT = {
            MAX_CROP = 40,
            TIME_PER_CROP = 8, -- 若需与游戏分钟对齐，改为 8 * 60
        }
    },
    {
        GUARD = {
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
        PLANT = {
            MAX_CROP = 60,
            TIME_PER_CROP = 6 * 60,
        }
    },
    {
        GUARD = {
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
            [FORM.XIANJING] = {
                HEALTH = 2100,
                DAMAGE = 220,
                DAMAGE_REDUCTION = 0.7,
                ATTACK_RANGE = 4,
                WALK_SPEED = 5,
                RUN_SPEED = 5,
                ATTACK_PERIOD = 3,
                SUMMON_COST = 16,
            },
                
        },
        PLANT = {
            MAX_CROP = 80,
            TIME_PER_CROP = 4 * 60,
        }
    }
}

function T.GetLevelConfig(form, level)
    return T[level] and T[level].GUARD[form] or nil
end

-- 计算召唤消耗
function T.GetSummonCost(form, level)
    local cfg = T.GetLevelConfig(form, level)
    return cfg and cfg.SUMMON_COST or nil
end

return T

