
GLOBAL.setmetatable(env, {
  __index = function(t, k)
    return GLOBAL.rawget(GLOBAL, k)
  end
})
local common = require("ark_common_ling")

function GLOBAL.lprint(...)
  local args = {...}
  print(unpack(args))
end

if LOC.GetLocaleCode() == "zh" then
  STRINGS.CHARACTERS.LING = require("languages/speech_ling")
end
-- 加载语言文件
common.LoadPOFile("scripts/languages/ling_chinese_s.po", "zh")

PrefabFiles = {'ling_lantern', 'ling', 'ling_lantern_smoke', 'ling_guards', 'ling_guard_basic_start_fx', 'ling_guard_basic_fusion_fx', 'ling_aoe_attack_fx', 'ling_guard_elite_attack_hit_fx', 'ling_guard_skill_halo_fx', 'ling_guard_plant_container', 'ling_guard_plant_club', 'poem_0', 'poem_1', 'poem_2', 'poem_3', 'ling_desk', 'ling_jars', 'ling_cloud_pavilion_exit_door', 'ling_interior_texture_packages', 'ling_wall_tigerpond', 'so_is_writ_an_ode_to_wine_buff'}

Assets = {
  Asset('ATLAS', 'images/saveslot_portraits/ling.xml'),
  Asset('ATLAS', 'images/selectscreen_portraits/ling.xml'),
  Asset('ATLAS', 'images/map_icons/ling.xml'),
  Asset('ATLAS', 'images/map_icons/ling_desk.xml'),
  Asset('ATLAS', 'images/avatars/avatar_ling.xml'),
  Asset('ATLAS', 'images/avatars/avatar_ghost_ling.xml'),
  Asset('ATLAS', 'images/avatars/self_inspect_ling.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_lantern.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_elite.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_poetry.xml'),
  Asset('ATLAS', 'images/inventoryimages/poem.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_desk.xml'),
  Asset('ATLAS', 'bigportraits/ling.xml'),
  Asset('ATLAS', 'images/names_ling.xml'),
  Asset('ATLAS', 'images/ark_skill.xml'),
  Asset('ATLAS', 'images/ling_skill.xml'),
  Asset('ATLAS', 'images/ui_ling_guard_panel.xml'),
  Asset('ATLAS', 'images/ui_ling_guard_panel_call.xml'),
  Asset('ATLAS', 'images/ling_container_slot.xml'),
  Asset('ATLAS', 'images/ui_ling_guard_plant_slot.xml'),
  Asset('ATLAS', 'images/ling_desk_prototyper.xml'),
  Asset('IMAGE', 'fx/lantern_fx.tex'),
  Asset('ANIM', 'anim/ui_ling_guard_container.zip'),
  Asset('ANIM', 'anim/ui_ling_guard_plant_container.zip'),
  Asset('ANIM', 'anim/ui_ling_guard_plant_club.zip'),
  Asset('ANIM', 'anim/ling_poetry.zip'),
  Asset('ANIM', 'anim/ling_cloud_pavilion_mist.zip'),
}
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.LING = {"ling_lantern", "ark_backpack"}
TUNING.GAMEMODE_STARTING_ITEMS.LAVAARENA.LING = {"ling_lantern", "ark_backpack"}
TUNING.GAMEMODE_STARTING_ITEMS.QUAGMIRE.LING = {"ling_lantern", "ark_backpack"}

AddMinimapAtlas('images/map_icons/ling.xml')
AddModCharacter("ling", "FEMALE")
AddReplicableComponent("ling_poetry")
AddReplicableComponent("ling_summon_manager")
AddReplicableComponent("ling_guard")
AddReplicableComponent("ling_guard_plant")

TUNING.ARK_SKILL = TUNING.ARK_SKILL or {}

ArkLogger:DeclareLogger('TRACE', 'ling')
-- 常量配置
TUNING.LING = {}

modimport("lingmain/ling_elite")
modimport("lingmain/summon_guard")
modimport("lingmain/ling_guard_containers")
modimport("lingmain/ling_jars")
modimport("lingmain/ling_poetry")
modimport("lingmain/ling_desk")
modimport("lingmain/poem")
modimport("lingmain/ling_cloud_pavilion")


DefineNetState('ling_guard', {
  behavior_mode = "tinybyte:classified",
  work_mode = "tinybyte:classified",
  guard_pos_x = "float:classified",
  guard_pos_y = "float:classified",
  guard_pos_z = "float:classified",
  level = "tinybyte:classified",
  form = "tinybyte:classified",
  current_health = "ushortint:classified",
  max_health = "ushortint:classified",
})

DefineNetState('ling_poetry', {
  current_poetry = "float:classified",
  max_poetry = "byte:classified",
})

DefineNetState('ling_summon_manager', (function()
    local state = {
        max_slots = "tinybyte:classified"
    }
    for i = 1, TUNING.LING.MAX_GUARDS do
        state["inst_" .. i] = "entity:classified"
        state["form_" .. i] = "tinybyte:classified"
        state["level_" .. i] = "tinybyte:classified"
        state["status_" .. i] = "tinybyte:classified"
        state["world" .. i] = "tinybyte:classified"
    end
    return state
end)())
-- 6*木板 2*活木 1*蝴蝶翅膀 10*噩梦燃料
AddRecipe2('ling_lantern', {Ingredient("boards", 6), Ingredient("livinglog", 2), Ingredient("butterflywings", 1), Ingredient("nightmarefuel", 10)}, TECH.MAGIC_THREE, nil, {
  "MAGIC",
  "CHARACTER",
  "MODS",
})
RegisterInventoryItemAtlas("images/inventoryimages/ling_lantern.xml", "ling_lantern.tex")
