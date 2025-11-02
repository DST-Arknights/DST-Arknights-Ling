local LingCloudPavilionEnter = Class(function(self, inst)
    self.inst = inst
end)

function LingCloudPavilionEnter:CanEnterCloudPavilion()
  return true
end

function LingCloudPavilionEnter:EnterCloudPavilion(doer)
    if not self:CanEnterCloudPavilion() then
        return
    end
    if not doer.components.ling_cloud_pavilion_transfer then
        return
    end
    doer.components.ling_cloud_pavilion_transfer:EnterCloudPavilion(self.inst)
end

return LingCloudPavilionEnter