local containers = require "containers"

local params = containers.params

RegisterInventoryItemAtlas("images/inventoryimages/ling_bookshelf.xml", "ling_bookshelf.tex")

--------------------------------------------------------------------------
--[[ ling_bookshelf ]]
--------------------------------------------------------------------------

params.ling_bookshelf =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_bookstation_4x5",
        animbuild = "ui_bookstation_4x5",
        pos = Vector3(0, 280, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 0, 4 do
    table.insert(params.ling_bookshelf.widget.slotpos, Vector3(-114      , (-77 * y) + 37 - (y * 2), 0))
    table.insert(params.ling_bookshelf.widget.slotpos, Vector3(-114 + 75 , (-77 * y) + 37 - (y * 2), 0))
    table.insert(params.ling_bookshelf.widget.slotpos, Vector3(-114 + 150, (-77 * y) + 37 - (y * 2), 0))
    table.insert(params.ling_bookshelf.widget.slotpos, Vector3(-114 + 225, (-77 * y) + 37 - (y * 2), 0))
end

function params.ling_bookshelf.itemtestfn(container, item, slot)
    return item:HasTag("poem")
end
-- 配方: 木板3个, 精英化二解锁
AddRecipe2("ling_bookshelf", { Ingredient("boards", 3) }, TECH.ARK_ELITE_TWO, {
  builder_tag = "ling",
  placer = "ling_bookshelf_placer",
  force_hint = true,
}, { "CHARACTER", "MODS", "STRUCTURES" })

local function IsEntityInDreamIsland(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local node_index = TheWorld.Map:GetNodeIdAtPoint(x, y, z)
    local node = TheWorld.topology.nodes[node_index]
    return node ~= nil and node.tags ~= nil and table.contains(node.tags, "ling_dream_island")
end

local trackEntityKey = "ling_bookshelf_transfer_target"
AddAction("DREAM_ISLAND_TELEPORT", STRINGS.ACTIONS.DREAM_ISLAND_TELEPORT, function(act)
    if not act.target or not act.target:HasTag("dream_island_teleporter") then return false end
    local cachedTarget = act.target.components.entitytracker and act.target.components.entitytracker:GetEntity(trackEntityKey) or nil
    if cachedTarget then
        act.target.components.teleporter:Target(cachedTarget)
        act.target.components.teleporter:Activate(act.doer)
        act.target.components.teleporter:Target(nil)
        return true
    end
    local is_island = IsEntityInDreamIsland(act.target)
    local target = nil
    local last_target = nil
    for _, v in pairs(Ents) do
        if v.prefab == "ling_bookshelf" and v ~= act.target then
            if IsEntityInDreamIsland(v) ~= is_island then
                target = v
                break
            end
            last_target = v
        end
    end
    target = target or last_target
    if target then
        act.target.components.teleporter:Target(target)
        act.target.components.teleporter:Activate(act.doer)
        act.target.components.teleporter:Target(nil)
        if target.components.entitytracker then
            target.components.entitytracker:TrackEntity(trackEntityKey, act.target)
        end
        return true
    end
    if act.doer.components.talker ~= nil then
        act.doer.components.talker:Say(GetString(act.doer, "ANNOUNCE_DREAM_ISLAND_TELEPORT_FAILED"))
        return true
    end
    return false
end)
ACTIONS.DREAM_ISLAND_TELEPORT.distance = 2

AddComponentAction("SCENE", "teleporter", function(inst, doer, actions, right)
    if right and inst:HasTag("dream_island_teleporter") then
        table.insert(actions, ACTIONS.DREAM_ISLAND_TELEPORT)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.DREAM_ISLAND_TELEPORT, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.DREAM_ISLAND_TELEPORT, "give"))
