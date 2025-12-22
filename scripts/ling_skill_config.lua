local ARK_CONSTANTS = require "ark_constants"

local skillConfig = {{
  id = 'skill1',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING["1"],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING["1"],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_1.tex",
  hotkey = KEY_Z,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.MANUAL,
  levels = {{
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["1"]["1"],
    activationEnergy = 60,
    buffDuration = 25,
    config = {
      attackSpeed = 1.2,
      damageMultiplier = 1.2,
      trueDamage = true,
      affectGuards = true -- 技能1影响守卫
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["1"]["2"],
    activationEnergy = 50,
    buffDuration = 25,
    config = {
      attackSpeed = 1.38,
      damageMultiplier = 1.38,
      trueDamage = true,
      affectGuards = true -- 技能1影响守卫
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["1"]["3"],
    activationEnergy = 40,
    buffDuration = 25,
    config = {
      attackSpeed = 1.5,
      damageMultiplier = 1.5,
      trueDamage = true,
      affectGuards = true -- 技能1影响守卫
    }
  }}
}, {
  id = 'skill2',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING["2"],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING["2"],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_2.tex",
  hotkey = KEY_X,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.AUTO,
  levels = {{
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["2"]["1"],
    activationEnergy = 15,
    maxActivationStacks = 1,
    config = {
      damageMultiplier = 2.5,
      AOEarc = 3,
      shackleTime = 1.5,
      affectGuards = false -- 技能2不影响守卫
    }
  }, {
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["2"]["2"],
    activationEnergy = 10,
    maxActivationStacks = 2,
    config = {
      damageMultiplier = 3.7,
      AOEarc = 3,
      shackleTime = 2.5,
      affectGuards = false -- 技能2不影响守卫
    }
  }}
}, {
  id = 'skill3',
  name = STRINGS.UI.ARK_SKILL.NAMES.LING["3"],
  lockedDesc = STRINGS.UI.ARK_SKILL.LOCKED_DESC.LING["3"],
  atlas = "images/ling_skill.xml",
  image = "skill_icon_skchr_ling_3.tex",
  hotkey = KEY_C,
  energyRecoveryMode = ARK_CONSTANTS.ENERGY_RECOVERY_MODE.AUTO,
  activationMode = ARK_CONSTANTS.ACTIVATION_MODE.MANUAL,
  levels = {{
    desc = STRINGS.UI.ARK_SKILL.LEVEL_DESC.LING["3"]["1"],
    activationEnergy = 30,
    buffDuration = 30,
    config = {
      damageMultiplier = 1.4,
      damageAbsorption = 0.6,
      affectGuards = true -- 技能3影响守卫
    }
  }}
}}

return skillConfig
