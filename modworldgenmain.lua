-- Dream Butterfly Island World Generation (梦蝶岛世界生成)
-- 使用 Static Layout 系统在海洋中生成固定形状的蝴蝶岛

GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

local LAYOUTS = require("map/layouts").Layouts
local STATIC_LAYOUTS = require("map/static_layout")
-----------------------------------
-- 注册 Static Layout
-----------------------------------

LAYOUTS["LingDreamIsland"] = STATIC_LAYOUTS.Get("map/static_layouts/ling_dream_island", {
	start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.RANDOM,
	disable_transform = true,
    add_topology = {
        room_id = "StaticLayoutIsland:LingDreamIsland",
        tags = {"RoadPoison", "nohunt", "nohasslers", "not_mainland", "ling_dream_island"},
    },
})

AddTaskSetPreInit("default", function(taskset)
    if taskset.ocean_prefill_setpieces == nil then
        taskset.ocean_prefill_setpieces = {}
    end
    taskset.ocean_prefill_setpieces["LingDreamIsland"] = {count = 1}
end)

AddTaskSetPreInit("classic", function(taskset)
    if taskset.ocean_prefill_setpieces == nil then
        taskset.ocean_prefill_setpieces = {}
    end
    taskset.ocean_prefill_setpieces["LingDreamIsland"] = {count = 1}
end)
