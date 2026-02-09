local TechTree = require('techtree')


RegisterInventoryItemAtlas("images/inventoryimages/ling_desk.xml", "ling_desk.tex")

------------
table.insert(TechTree.AVAILABLE_TECH, 'POETRY_TECH')

TECH.NONE.POETRY_TECH = 0
TECH.POETRY_ONE = { POETRY_TECH = 1, CARTOGRAPHY = 2 }

for k,v in pairs(TUNING.PROTOTYPER_TREES) do
  v.POETRY_TECH = 0
end

TUNING.PROTOTYPER_TREES.POETRY_ONE = TechTree.Create({
  POETRY_TECH = 1,
  CARTOGRAPHY = 2,
})

for i, v in pairs(AllRecipes) do
	v.level.POETRY_TECH = v.level.POETRY_TECH or 0
end

------------
table.insert(TechTree.AVAILABLE_TECH, 'LING_DESK_TECH')

TECH.NONE.LING_DESK_TECH = 0
TECH.LING_DESK_ONE = { LING_DESK_TECH = 1 }

for k,v in pairs(TUNING.PROTOTYPER_TREES) do
  v.LING_DESK_TECH = 0
end

TUNING.PROTOTYPER_TREES.LING_DESK_ONE = TechTree.Create({
  LING_DESK_TECH = 1,
})

for i, v in pairs(AllRecipes) do
	v.level.LING_DESK_TECH = v.level.LING_DESK_TECH or 0
end

AddPrototyperDef('ling_desk', {
  icon_atlas = "images/ling_desk_prototyper.xml",
  icon_image = "ling_desk_prototyper.tex",
  is_crafting_station = true,
  action_str = 'LING_DESK',
  filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.LING_DESK
})

-- AddRecipeFilter({
--   name = "LING_DESK",
--   image = "ling_desk_prototyper.tex",
--   atlas = "images/ling_desk_prototyper.xml",
-- })

AddRecipe2("ling_desk", {Ingredient("boards", 3), Ingredient("featherpencil", 1), Ingredient("papyrus", 1)}, TECH.LING_DESK_ONE, {
  builder_tag = "ling",
  placer = "ling_desk_placer",
  atlas = "images/inventoryimages/ling_desk.xml",
  image = "ling_desk.tex",
  force_hint = true,
}, { "CHARACTER", "MODS", "PROTOTYPERS", "STRUCTURES" })
