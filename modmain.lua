GLOBAL.setmetatable(env, {
  __index = function(t, k)
    return GLOBAL.rawget(GLOBAL, k)
  end
})
local common = require("ark_common_ling")

-- 加载语言文件
common.LoadPOFile("scripts/languages/ling_chinese_s.po", "zh")

PrefabFiles = {'ling', 'ling_lantern', 'ling_lantern_smoke', 'ling_guards', 'ling_summon_fx', 'ling_aoe_attack_fx', 'ling_guard_containers'}
Assets = {
  Asset('ATLAS', 'images/saveslot_portraits/ling.xml'),
  Asset('ATLAS', 'images/selectscreen_portraits/ling.xml'),
  Asset('ATLAS', 'images/map_icons/ling.xml'),
  Asset('ATLAS', 'images/avatars/avatar_ling.xml'),
  Asset('ATLAS', 'images/avatars/avatar_ghost_ling.xml'),
  Asset('ATLAS', 'images/avatars/self_inspect_ling.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_lantern.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_elite.xml'),
  Asset('ATLAS', 'bigportraits/ling.xml'),
  Asset('ATLAS', 'images/names_ling.xml'),
  Asset('ATLAS', 'images/ark_skill.xml'),
  Asset('ATLAS', 'images/ling_skill.xml'),
  Asset('ATLAS', 'images/ling_guard_ui.xml'),
  Asset('IMAGE', 'fx/lantern_fx.tex'),
  Asset('ANIM', 'anim/ling_poetry.zip'),
  Asset('ANIM', 'anim/ling_lantern.zip'),
  Asset('ANIM', 'anim/swap_ling_lantern_stick.zip'),
}

AddMinimapAtlas('images/map_icons/ling.xml')
AddModCharacter("ling", "FEMALE")
AddReplicableComponent("ling_poetry")

TUNING.ARK_SKILL = TUNING.ARK_SKILL or {}

-- 常量配置
TUNING.LING = {}


-- 调试开关
TUNING.LING_DEBUG = true  -- 设置为true启用守卫调试日志

modimport("lingmain/ark_skill")
modimport("lingmain/ling_ui")
modimport("lingmain/ling_elite")
modimport("lingmain/summon_guard")
modimport("lingmain/true_damage")
modimport("lingmain/attack_speed")
modimport("lingmain/ling_skill2_attack")
modimport("lingmain/ling_guard_containers")