local LingCloudPavilionExit = Class(function(self, inst)
    self.inst = inst
end)

function LingCloudPavilionExit:CanExitCloudPavilion()
  return true
end

function LingCloudPavilionExit:ExitCloudPavilion(doer)
    if not self:CanExitCloudPavilion() then
        return
    end
    if not doer.components.ling_cloud_pavilion_transfer then
        return
    end
    doer.components.ling_cloud_pavilion_transfer:ExitCloudPavilion()
end

return LingCloudPavilionExit