local CONSTANTS = require "ark_constants_ling"
local maxContainer = CONSTANTS.MAX_GUARDS_CONTAINER
local containers = require "containers"

for i = 1, maxContainer do
  -- 3*3
  containers.params["ling_guard_container_" .. i] = {
    widget = {
      slotpos = {},
      slotbg  = {},
      animbank = "ui_guard_container",
      animbuild = "ui_guard_container",
      pos = Vector3(0, 200, 0),
      side_align_tip = 160,
    },
    type = "ling_guard_container",
  }
  for y = 2, 0, -1 do
    for x = 0, 2 do
      table.insert(containers.params["ling_guard_container_" .. i].widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
      table.insert(containers.params["ling_guard_container_" .. i].widget.slotbg, { image = "ling_container_slot.tex", atlas = "images/ling_container_slot.xml" })
    end
  end
end