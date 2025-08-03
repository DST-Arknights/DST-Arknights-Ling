local containers = require "containers"
local CONSTANTS = require "ark_constants_ling"

local slotAtlas = { image = "ling_container_slot.tex", atlas = "images/ling_container_slot.xml" }

-- 3*3
containers.params.qingping = {
  widget = {
    slotpos = {},
    slotbg  = {},
    animbank = "ui_ling_guard_container",
    animbuild = "ui_ling_guard_container",
    pos = Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_POSITION)) + Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_CONTAINER_POSITION)) * CONSTANTS.LING_GUARD_PANEL_SCALE,
    side_align_tip = 160,
  },
  skipopensnd = true,
  skipclosesnd = true,
  type = "ling_guard_container",
}
for y = 2, 0, -1 do
  for x = 0, 2 do
    table.insert(containers.params.qingping.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    table.insert(containers.params.qingping.widget.slotbg, shallowcopy(slotAtlas))
  end
end

local plantContainerPos = Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_POSITION)) + Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_PLANT_CONTAINER_CLOSED_POSITION)) * CONSTANTS.LING_GUARD_PANEL_SCALE
local animPos = Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_POSITION)) + Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_PLANT_CONTAINER_POSITION)) * CONSTANTS.LING_GUARD_PANEL_SCALE
containers.params.ling_guard_plant_container = {
  widget = {
    slotpos = {Vector3(36, -16, 0), Vector3(-119, -40, 0), Vector3(-119, 40, 0), Vector3(-39, -40, 0)},
    slotbg  = {},
    bgimage = nil,
    animbank = "ui_ling_guard_plant_container",
    animbuild = "ui_ling_guard_plant_container",
    pos = plantContainerPos,
    side_align_tip = 120,
    animPos = animPos,
  },
  skipopensnd = true,
  skipclosesnd = true,
  type = "ling_guard_plant_container",
}

for x = 1, 4 do
  table.insert(containers.params.ling_guard_plant_container.widget.slotbg, shallowcopy(slotAtlas))
end

containers.params.xiaoyao = deepcopy(containers.params.qingping)
