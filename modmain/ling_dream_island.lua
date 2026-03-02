-- 为 Ling 的梦境岛屿添加迷雾
AddPrefabPostInit("world", function(inst)
    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, function()
            for i, id in ipairs(TheWorld.topology.ids) do
                if id == "StaticLayoutIsland:LingDreamIsland" then
                    local node = TheWorld.topology.nodes[i]
                    local x, z = node.cent[1], node.cent[2]

                    local mist = SpawnPrefab("mist")
                    mist.Transform:SetPosition(x, 0, z)
                    local ext = ResetextentsForPoly(node.poly)
                    mist.components.emitter.area_emitter = CreateCircleEmitter(ext.radius + 4)
                    mist.entity:SetAABB(ext.radius + 4, 2)
                    mist.components.emitter.density_factor = 0.3
                    mist.components.emitter:Emit()
                    break
                end
            end
        end)
    end
end)