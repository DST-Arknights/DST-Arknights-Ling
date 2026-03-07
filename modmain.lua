GLOBAL.setmetatable(env, {
  __index = function(t, k)
    return GLOBAL.rawget(GLOBAL, k)
  end
})

-- 加载语言文件
if LOC.GetLocaleCode() == "zh" then
  STRINGS.CHARACTERS.LING = require("languages/speech_ling")
end
MergePOFile("scripts/languages/ling_chinese_s.po", "zh", true)

PrefabFiles = {'ling_lantern', 'ling', 'ling_none', 'ling_lantern_smoke', 'ling_guards', 'ling_guard_basic_start_fx', 'ling_guard_basic_fusion_fx', 'ling_aoe_attack_fx', 'ling_guard_elite_attack_hit_fx', 'ling_guard_skill_halo_fx', 'ling_guard_plant_container', 'ling_guard_plant_club', 'poem_0', 'poem_1', 'poem_2', 'poem_3', 'ling_desk', 'ling_jars', 'ling_cloud_pavilion_exit_door', 'ling_interior_texture_packages', 'ling_wall_tigerpond', 'so_is_writ_an_ode_to_wine_buff', 'ling_dream_island_buff', 'ling_bookshelf'}

Assets = {
  Asset('ATLAS', 'images/saveslot_portraits/ling.xml'),
  Asset('ATLAS', 'images/selectscreen_portraits/ling.xml'),
  Asset('ATLAS', 'images/avatars/avatar_ling.xml'),
  Asset('ATLAS', 'images/avatars/avatar_ghost_ling.xml'),
  Asset('ATLAS', 'images/avatars/self_inspect_ling.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_lantern.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_elite.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_poetry.xml'),
  Asset('ATLAS', 'images/inventoryimages/poem.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_desk.xml'),
  Asset('ATLAS', 'images/inventoryimages/ling_bookshelf.xml'),
  Asset('ATLAS', 'bigportraits/ling.xml'),
  Asset('ATLAS', 'images/names_ling.xml'),
  Asset('ATLAS', 'images/ling_skill.xml'),
  Asset('ATLAS', 'images/ui_ling_guard_panel.xml'),
  Asset('ATLAS', 'images/ui_ling_guard_panel_call.xml'),
  Asset('ATLAS', 'images/ling_container_slot.xml'),
  Asset('ATLAS', 'images/ui_ling_guard_plant_slot.xml'),
  Asset('ATLAS', 'images/ling_desk_prototyper.xml'),
  Asset('ATLAS', 'images/ling_cloud_pavilion_mist.xml'),
  Asset('IMAGE', 'fx/lantern_fx.tex'),
  Asset('ANIM', 'anim/ui_ling_guard_container.zip'),
  Asset('ANIM', 'anim/ui_ling_guard_plant_container.zip'),
  Asset('ANIM', 'anim/ui_ling_guard_plant_club.zip'),
  Asset('ANIM', 'anim/ling_poetry.zip'),
}
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.LING = {"ling_lantern", "ark_backpack"}
TUNING.GAMEMODE_STARTING_ITEMS.LAVAARENA.LING = {"ling_lantern", "ark_backpack"}
TUNING.GAMEMODE_STARTING_ITEMS.QUAGMIRE.LING = {"ling_lantern", "ark_backpack"}

TUNING.LING_HEALTH = 50
TUNING.LING_HUNGER = 150
TUNING.LING_SANITY = 250

AddMinimapAtlas('images/map_icons/ling.xml')
AddMinimapAtlas('images/map_icons/ling_desk.xml')
AddMinimapAtlas('images/map_icons/ling_guard_basic.xml')
AddMinimapAtlas('images/map_icons/ling_guard_elite.xml')
AddModCharacter("ling", "FEMALE")
AddReplicableComponent("ling_poetry")
AddReplicableComponent("ling_summon_manager")
AddReplicableComponent("ling_guard")
AddReplicableComponent("ling_guard_plant")

ArkLogger:DeclareLogger('TRACE', 'ling')
-- 常量配置
TUNING.LING = {}

modimport("modmain/ling_elite")
modimport("modmain/summon_guard")
modimport("modmain/ling_guard_containers")
modimport("modmain/ling_jars")
modimport("modmain/ling_poetry")
modimport("modmain/ling_desk")
modimport("modmain/ling_bookshelf")
modimport("modmain/poem")
modimport("modmain/ling_cloud_pavilion")
modimport("modmain/ling_dream_island")

RegisterInventoryItemAtlas("images/inventoryimages/ling_lantern.xml", "ling_lantern.tex")
-- 6*木板 2*活木 1*蝴蝶翅膀 10*噩梦燃料
AddRecipe2('ling_lantern', {Ingredient("boards", 6), Ingredient("livinglog", 2), Ingredient("butterflywings", 1), Ingredient("nightmarefuel", 10)}, TECH.MAGIC_THREE, {
  force_hint = true,
}, {
  "MAGIC",
  "LIGHT",
  "CHARACTER",
  "MODS",
})
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
        state["world_id" .. i] = "ushortint:classified"
        state["role_" .. i] = "tinybyte:classified"
        state["primary_slot_" .. i] = "tinybyte:classified"
        state["slot_count_" .. i] = "tinybyte:classified"
    end
    return state
end)())


local voice_cfg = GetModConfigData("voice_language")
local voice_lang = voice_cfg == "auto" and LOC.GetLocaleCode(LOC.GetLanguage()) or voice_cfg
TUNING.LING.VOICE_LANG = voice_lang

function GLOBAL.IsEntityInDreamIsland(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local node_index = TheWorld.Map:GetNodeIdAtPoint(x, y, z)
    local node = TheWorld.topology.nodes[node_index]
    return node ~= nil and node.tags ~= nil and table.contains(node.tags, "ling_dream_island")
end

function GLOBAL.IsEntityInCloudPavilion(inst)
  return inst.ling_netvarCameraAnchor ~= nil and inst.ling_netvarCameraAnchor:value() ~= nil
end