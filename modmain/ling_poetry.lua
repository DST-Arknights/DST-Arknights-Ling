AddCharacterIngredient("ling_poetry", {
  Has = function(inst, amount)
    local replica = inst.replica.ling_poetry
    local current = replica and replica:GetCurrent() or 0
    return current >= amount, current
  end,
  Consume = function(inst, amount)
    if inst.components.ling_poetry then
      inst.components.ling_poetry:Dirty(-amount)
    end
  end,
})

AddComponentPostInit("builder", function(self)
  local _RemoveIngredients = self.RemoveIngredients
  self.RemoveIngredients = function(self, ingredients, recname, ...)
    if self.freebuildmode then
      return
    end
    -- 有buff的情况下, 若诗意值大于70, 免费制作, 40以上, 40%概率消耗40点免费制作.
    if self.inst.components.debuffable then
      local has_island_buff = self.inst.components.debuffable:HasDebuff("ling_dream_island_buff")
      local comp_ling_poetry = self.inst.components.ling_poetry
      if has_island_buff and comp_ling_poetry ~= nil then
        local poetry = comp_ling_poetry:GetCurrent()
        if poetry >= 70 then
          SayAndVoice(self.inst, "POETIC_OBJECTS")
          comp_ling_poetry:Dirty(-70)
          return
        elseif poetry >= 40 and math.random() < 0.4 then
          SayAndVoice(self.inst, "POETIC_OBJECTS")
          comp_ling_poetry:Dirty(-40)
          return
        end
      end
    end

    local recipe = AllRecipes[recname]
    if recipe then
      for k, v in pairs(recipe.ingredients) do
        if v.type == 'ling_poetry' then
          self.inst.components.ling_poetry:Dirty(-v.amount)
        end
      end
    end
    return _RemoveIngredients(self, ingredients, recname, ...)
  end
end)
