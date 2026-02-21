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
