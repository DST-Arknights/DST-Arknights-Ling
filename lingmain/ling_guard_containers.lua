local containers = require "containers"
local CONSTANTS = require "ark_constants_ling"

local slotAtlas = { image = "ling_container_slot.tex", atlas = "images/ling_container_slot.xml" }

-- 种植容器物品测试函数 - 只允许放入守卫生产的作物
local function planitemtestfn(container, item, slot)
  -- 只允许放入带有ling_guard_crop标签的物品
  return container.loading or item:HasTag("ling_guard_crop")
end

-- 种植俱乐部物品测试函数 - 只允许放入种子
local function cubeitemtestfn(container, item, slot)
  -- 预制体名称里是seeds后缀的
  return string.match(item.prefab, "seeds$")
end

-- 3*3
containers.params.ling_guard_basic = {
  widget = {
    slotpos = {},
    slotbg  = {},
    animbank = "ui_ling_guard_container",
    animbuild = "ui_ling_guard_container",
    pos = CONSTANTS.LING_GUARD_PANEL_POSITION + CONSTANTS.LING_GUARD_PANEL_CONTAINER_POSITION * CONSTANTS.LING_GUARD_PANEL_SCALE,
    side_align_tip = 160,
  },
  skipopensnd = true,
  skipclosesnd = true,
  type = "ling_guard_container",
}
for y = 2, 0, -1 do
  for x = 0, 2 do
    table.insert(containers.params.ling_guard_basic.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    table.insert(containers.params.ling_guard_basic.widget.slotbg, shallowcopy(slotAtlas))
  end
end

containers.params.xiaoyao = deepcopy(containers.params.ling_guard_basic)

local function planitemtestfn(container, item, slot)
  return container.loading or item:HasTag("ling_guard_crop")
end

local plantContainerPos = CONSTANTS.LING_GUARD_PANEL_POSITION + CONSTANTS.LING_GUARD_PANEL_PLANT_CONTAINER_CLOSED_POSITION * CONSTANTS.LING_GUARD_PANEL_SCALE
local openPos = CONSTANTS.LING_GUARD_PANEL_POSITION + CONSTANTS.LING_GUARD_PANEL_PLANT_CONTAINER_POSITION * CONSTANTS.LING_GUARD_PANEL_SCALE
containers.params.ling_guard_plant_container = {
  widget = {
    slotpos = {Vector3(-119, -40, 0), Vector3(-119, 40, 0), Vector3(-39, -40, 0)},
    slotbg  = {{
      image = "bg_1.tex",
      atlas = "images/ui_ling_guard_plant_slot.xml",
    }, {
      image = "bg_3.tex",
      atlas = "images/ui_ling_guard_plant_slot.xml",
    }, {
      image = "bg_2.tex",
      atlas = "images/ui_ling_guard_plant_slot.xml",
    }},
    bgimage = nil,
    animbank = "ui_ling_guard_plant_container",
    animbuild = "ui_ling_guard_plant_container",
    pos = plantContainerPos,
    side_align_tip = 120,
    openPos = openPos,
  },
  itemtestfn = planitemtestfn,
  skipopensnd = true,
  skipclosesnd = true,
  type = "ling_guard_plant_container",
}

for x = 1, 4 do
  table.insert(containers.params.ling_guard_plant_container.widget.slotbg, shallowcopy(slotAtlas))
end

containers.params.ling_guard_plant_club = {
  widget = {
    slotpos = {Vector3(0, 60, 0)},
    slotbg  = {{image = "bg_0.tex", atlas = "images/ui_ling_guard_plant_slot.xml"}},
    bgimage = nil,
    animbank = "ui_ling_guard_plant_club",
    animbuild = "ui_ling_guard_plant_club",
    pos = openPos + Vector3(22, -39, 0),
    side_align_tip = 20,
  },
  itemtestfn = cubeitemtestfn,
  skipopensnd = true,
  skipclosesnd = true,
  acceptsstacks = false,
  type = "ling_guard_plant_club",
}
