
AddComponentPostInit("inventory", function(self)
  local _Has = self.Has
  self.Has = function(self, item, amount, ...)
    if item == 'ling_poetry' and self.inst.components.ling_poetry then
      local left = self.inst.components.ling_poetry:GetCurrent()
      return left >= amount, left
    end
    return _Has(self, item, amount, ...)
  end
end)

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

AddClassPostConstruct('components/inventory_replica', function(self)
  local _Has = self.Has
  self.Has = function(self, item, amount, ...)
    if item == 'ling_poetry' and self.inst.replica.ling_poetry then
      local left = self.inst.replica.ling_poetry:GetCurrent()
      return left >= amount, left
    end
    return _Has(self, item, amount, ...)
  end
end)

-- 修改ui样式, 与精神或体力等一致的样式
local IngredientUI = require "widgets/ingredientui"
local _IngredientUI_ctor = IngredientUI._ctor
function IngredientUI:_ctor(atlas, image, quantity, on_hand, has_enough, name, owner, recipe_type, quant_text_scale, ingredient_recipe)
  _IngredientUI_ctor(self, atlas, image, quantity, on_hand, has_enough, name, owner, recipe_type, quant_text_scale, ingredient_recipe)
  if recipe_type == 'ling_poetry' then
    self.quant:SetString(string.format("-%d", quantity))
  end
end
