local SpDamageUtil = GLOBAL.require("components/spdamageutil")

SpDamageUtil.DefineSpType("true_damage", {
    -- 真实伤害不考虑防御，所以总是返回0
    GetDefense = function(ent)
        return 0
    end,
})


AddComponentPostInit("combat", function(self)
  function self:EnableTrueDamage(enable)
    if enable == nil then
      enable = true
    end
    self.true_damage_enabled = enable
  end

  function self:DisableTrueDamage()
    self.true_damage_enabled = false
  end

  local _GetAttacked = self.GetAttacked
  function self:GetAttacked(attacker, damage, weapon, stimuli, spdamage)
    -- 作为被攻击者, 如果攻击者启用了真实伤害，则将伤害转换为真实伤害
    if attacker and attacker.components.combat and attacker.components.combat.true_damage_enabled then
      print('GetAttacked', 'true damage', damage, spdamage)
      if spdamage == nil then
        spdamage = {}
      end
      spdamage.true_damage = damage
      damage = 0
      print('GetAttacked', spdamage)
      return _GetAttacked(self, attacker, damage, weapon, stimuli, spdamage)
    end
    return _GetAttacked(self, attacker, damage, weapon, stimuli, spdamage)
  end
end)
