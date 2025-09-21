
AddComponentPostInit("inventory", function(self)
  local _Has = self.Has
  self.Has = function(self, item, amount, ...)
    if item == 'ling_poetry' then
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
    if item == 'ling_poetry' then
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
