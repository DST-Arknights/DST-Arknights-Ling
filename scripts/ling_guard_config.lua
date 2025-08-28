local CONSTANTS = require("ark_constants_ling")

local config = {
    MODE = {
        GUARD = {
            LEADER_DEFENSE_DIST = 16,
            GUARD_RANGE = 16, -- 守点/工作半径
            CHASE_RANGE = 32, -- 守形态最大追击半径（> GUARD_RANGE）
            DEFENSE_DIST = 12,
            KITE = { RUN_DISTANCE = 8, STOP_DISTANCE = 12, DETECTION_RANGE = 12, SAFE_DISTANCE = 10 },
            FOLLOW = { MIN = 1, TARGET = 5, MAX = 16, WANDER_DIST = 6 },
        },

        CAUTIOUS = {
            LEADER_DEFENSE_DIST = 16,
            DEFENSE_DIST = 12,
            KITE = { RUN_DISTANCE = 8, STOP_DISTANCE = 12, DETECTION_RANGE = 12, SAFE_DISTANCE = 10 },
            FOLLOW = { MIN = 1, TARGET = 5, MAX = 10, WANDER_DIST = 8 },
        },

        ATTACK = {
            LEADER_DEFENSE_DIST = 24,
            DEFENSE_DIST = 24,
            KITE = { RUN_DISTANCE = 8, STOP_DISTANCE = 12, DETECTION_RANGE = 12, SAFE_DISTANCE = 10 },
            FOLLOW = { MIN = 1, TARGET = 6, MAX = 12, WANDER_DIST = 10 },
        },
    },
}

local function getGuardConfig(inst)
    local mode = inst.components.ling_guard and inst.components.ling_guard:GetBehaviorMode()
    if mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD then
        return config.MODE.GUARD
    elseif mode == CONSTANTS.GUARD_BEHAVIOR_MODE.ATTACK then
        return config.MODE.ATTACK
    else
        return config.MODE.CAUTIOUS
    end
end

return {
    config = config,
    getGuardConfig = getGuardConfig
}
