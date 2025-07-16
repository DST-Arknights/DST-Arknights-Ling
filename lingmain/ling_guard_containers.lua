local containers = require "containers"
local CONSTANTS = require "ark_constants_ling"

local pos = Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_POSITION)) + Vector3(unpack(CONSTANTS.LING_GUARD_PANEL_OPEN_CONTAINER_POSITION)) * CONSTANTS.LING_GUARD_PANEL_SCALE

-- 3*3
containers.params.qingping = {
  widget = {
    slotpos = {},
    slotbg  = {},
    animbank = "ui_guard_container",
    animbuild = "ui_guard_container",
    pos = pos,
    side_align_tip = 160,
  },
  type = "ling_guard_container",
}
for y = 2, 0, -1 do
  for x = 0, 2 do
    table.insert(containers.params.qingping.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    table.insert(containers.params.qingping.widget.slotbg, { image = "ling_container_slot.tex", atlas = "images/ling_container_slot.xml" })
  end
end

containers.params.xiaoyao = deepcopy(containers.params.qingping)
