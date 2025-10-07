
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

-- 加载语言文件
common.LoadPOFile("scripts/languages/ling_chinese_s.po", "zh")

PrefabFiles = {'ling', 'ling_lantern', 'ling_lantern_smoke', 'ling_guards', 'ling_guard_basic_start_fx', 'ling_guard_basic_fusion_fx', 'ling_aoe_attack_fx', 'ling_guard_elite_attack_hit_fx', 'ling_guard_skill_halo_fx', 'ling_guard_plant_container', 'ling_guard_plant_club', 'poem_0', 'poem_1', 'poem_2', 'poem_3', 'ling_desk', 'ling_jars'}

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
  Asset('ANIM', 'anim/ling_lantern.zip'),
  Asset('ANIM', 'anim/swap_ling_lantern_stick.zip'),
  Asset('ANIM', 'anim/loong_1_attack_hit_fx.zip'),
  Asset('ANIM', 'anim/ling_jars.zip'),
}

AddMinimapAtlas('images/map_icons/ling.xml')
AddModCharacter("ling", "FEMALE")
AddReplicableComponent("ling_poetry")
AddReplicableComponent("ling_summon_manager")
AddReplicableComponent("ling_guard")
AddReplicableComponent("ling_guard_plant")

TUNING.ARK_SKILL = TUNING.ARK_SKILL or {}

-- 常量配置
TUNING.LING = {}


-- 调试开关
TUNING.LING_DEBUG = true  -- 设置为true启用守卫调试日志

modimport("lingmain/widget_extension")
modimport("lingmain/ark_skill")
modimport("lingmain/ling_elite")
modimport("lingmain/summon_guard")
modimport("lingmain/true_damage")
modimport("lingmain/attack_speed")
modimport("lingmain/ling_skill2_attack")
modimport("lingmain/ling_guard_containers")
modimport("lingmain/ling_jars")
modimport("lingmain/ling_poetry")
modimport("lingmain/ling_desk")
modimport("lingmain/poem")

-- 自定义动作：守卫挖地皮（无需工具）
local LING_TERRAFORM = AddAction("LING_TERRAFORM", "Terraform", function(act)
    if act.doer == nil then return false end
    local pt = act:GetActionPoint()
    if pt == nil then return false end

    local world = TheWorld
    local map = world and world.Map or nil
    if map == nil then return false end

    local px, py, pz = pt:Get()
    if not map:CanTerraformAtPoint(px, py, pz) then
        return false
    end

    local original_tile_type = map:GetTileAtPoint(px, py, pz)
    local tx, ty = map:GetTileCoordsAtPoint(px, py, pz)
    local undertile = TheWorld.components.undertile and TheWorld.components.undertile:GetTileUnderneath(tx, ty) or WORLD_TILES.DIRT

    map:SetTile(tx, ty, undertile)

    -- 触发地皮挖掘后的掉落与效果
    if HandleDugGround ~= nil then
        HandleDugGround(original_tile_type, px, py, pz)
    end


    return true
end)

-- 自定义动作：回收守卫（由守卫自身执行，交给状态图处理）
local LING_RECALL_GUARD = AddAction("LING_RECALL_GUARD", "Recall", function(act)
    return true
end)
