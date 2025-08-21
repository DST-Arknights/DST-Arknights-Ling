
local function LoadPOFile(fname, lang)
  local localeCode = LOC.GetLocaleCode();
  if lang ~= localeCode then
    return
  end
  if IsXB1() then
    -- 检查是不是 data/开头的,如果是就不额外处理了
    if string.sub(fname, 1, 5) ~= 'data/' then
      -- 如果不是,就加上 data/
      fname = 'data/' .. fname
    end
  end
  local loadedLanguages = LanguageTranslator.languages[lang]
  LanguageTranslator:LoadPOFile(fname, lang)
  local newLoadedLanguages = LanguageTranslator.languages[lang]
  newLoadedLanguages = MergeMapsDeep(loadedLanguages, newLoadedLanguages)
  LanguageTranslator.languages[lang] = newLoadedLanguages
  -- Recursively merge translation keys into STRINGS
  for key, value in pairs(newLoadedLanguages) do
    if type(key) == "string" and string.sub(key, 1, 8) == "STRINGS." then
      local path = string.sub(key, 9) -- Remove "STRINGS." prefix
      local parts = {}
      for part in string.gmatch(path, "[^.]+") do
        table.insert(parts, part)
      end

      local current = STRINGS
      for i = 1, #parts - 1 do
        if current[parts[i]] == nil then
          current[parts[i]] = {}
        elseif type(current[parts[i]]) ~= "table" then
          current[parts[i]] = {}
        end
        current = current[parts[i]]
      end
      
      if #parts > 0 then
        current[parts[#parts]] = value
      end
    end
  end
end

local function genArkSkillLevelTag(idx, level)
  return 'ark_skill_level_' .. idx .. '_' .. level
end


local CONSTANTS = require("ark_constants_ling")
local LING_GUARD_CONFIG = require("ling_guard_config")

-- 便捷访问：当前形态配置，未覆盖时回落 COMMON
local function GetModeConfig(inst)
    local mode = inst.components.ling_guard and inst.components.ling_guard:GetBehaviorMode() or CONSTANTS.GUARD_BEHAVIOR_MODE.CAUTIOUS
    local bymode = LING_GUARD_CONFIG.MODE or {}
    local common = LING_GUARD_CONFIG.COMMON or {}
    local cur = (mode == CONSTANTS.GUARD_BEHAVIOR_MODE.GUARD and bymode.GUARD)
            or (mode == CONSTANTS.GUARD_BEHAVIOR_MODE.ATTACK and bymode.ATTACK)
            or bymode.CAUTIOUS
            or {}
    return cur, common, mode
end

return {
  LoadPOFile = LoadPOFile,
  genArkSkillLevelTag = genArkSkillLevelTag,
  GetModeConfig = GetModeConfig,
}