RegisterInventoryItemAtlas("images/inventoryimages/ling_poetry.xml", "ling_poetry.tex")
RegisterInventoryItemAtlas("images/inventoryimages/poem.xml", "poem_0.tex")
RegisterInventoryItemAtlas("images/inventoryimages/poem.xml", "poem_1.tex")
RegisterInventoryItemAtlas("images/inventoryimages/poem.xml", "poem_2.tex")
RegisterInventoryItemAtlas("images/inventoryimages/poem.xml", "poem_3.tex")
-- 用于修复
MATERIALS.POEM = "poem"
-- 诗句配方, 只有令可以做
AddRecipe2("poem_0", { Ingredient("ling_poetry", 2) }, TECH.NONE, {
  nounlock = true,
  station_tag = "ling_desk",
  builder_tag = "ling",
}, { "CHARACTER", "MODS" })

AddRecipe2("poem_1", { Ingredient("poem_0", 22), Ingredient("papyrus", 2) }, TECH.POETRY_ONE, {
  nounlock = true,
  builder_tag = "ling",
  station_tag = "ling_desk",
  force_hint = true,
}, { "CHARACTER", "MODS" })

AddRecipe2("poem_2", { Ingredient("poem_1", 222), Ingredient("papyrus", 2), Ingredient("silk", 1) }, TECH.POETRY_ONE, {
  nounlock = true,
  builder_tag = "ling",
  station_tag = "ling_desk",
  force_hint = true,
}, { "CHARACTER", "MODS" })

AddRecipe2("poem_3", { Ingredient("poem_2", 305), Ingredient("silk", 4) }, TECH.POETRY_ONE, {
  nounlock = true,
  builder_tag = "ling",
  station_tag = "ling_desk",
  force_hint = true,
}, { "CHARACTER", "MODS" })

-- 使用诗句
AddAction("USE_POEM", STRINGS.ACTIONS.USE_POEM.GENERIC, function(act)
  local target = act.target or act.invobject
  return target.components.poem_useable ~= nil and target.components.poem_useable:Use(act.doer)
end)

AddComponentAction('INVENTORY', 'poem_useable', function(inst, doer, actions, right)
  table.insert(actions, ACTIONS.USE_POEM)
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.USE_POEM, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.USE_POEM, "doshortaction"))

local _ReadCondition = ACTIONS.READ.condition
ACTIONS.READ.condition = function(inst)
  local action = inst:GetBufferedAction()
  local targe = action.target or action.invobject
  if targe ~= nil and targe.components.poem_useable ~= nil and targe.components.rechargeable ~= nil then
    return targe.components.rechargeable:IsCharged()
  end
  if _ReadCondition ~= nil then
    return _ReadCondition(inst)
  end
  return true
end

-- 如果书未充能完毕, 则不显示阅读选项开关
local removeReadActionIfNotCharged = true
if removeReadActionIfNotCharged then
  local function IsChargedClient(item)
    local inv = item.replica and item.replica.inventoryitem
    local c = inv and inv.classified
    local v = c and c.recharge and c.recharge:value() or 255
    return v == 180 or v == 255 -- 255 当作“无冷却/视为可用”
  end

  local function remove_read(actions)
    for i = #actions, 1, -1 do
      if actions[i] == ACTIONS.READ then
        table.remove(actions, i)
      end
    end
  end


  -- destructive effect: cover source code
  AddComponentAction('INVENTORY', 'book', function(inst, doer, actions, right)
    if doer:HasTag("reader") then
      if TheWorld.ismastersim then
        if inst.components.rechargeable and not inst.components.rechargeable:IsCharged() then
          remove_read(actions)
        end
      else
        if not IsChargedClient(inst) then
          remove_read(actions)
          return
        end
      end
    end
  end)
  AddComponentAction('SCENE', 'book', function(inst, doer, actions, right)
    if doer:HasTag("reader") then
      if TheWorld.ismastersim then
        if inst.components.rechargeable and not inst.components.rechargeable:IsCharged() then
          remove_read(actions)
        end
      else
        if not IsChargedClient(inst) then
          remove_read(actions)
          return
        end
      end
    end
  end)
end
