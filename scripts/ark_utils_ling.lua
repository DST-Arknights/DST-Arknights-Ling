
local function utf8_sub(str, start, len)
  local chars = {}
  for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
      table.insert(chars, uchar)
  end
  -- 如果没有传入 len，则截取到末尾
  len = len or (#chars - start + 1)
  -- 确保 len 不超过剩余字符数
  len = math.min(len, #chars - start + 1)
  return table.concat(chars, "", start, start + len - 1)
end

local function utf8_len(str)
  local count = 0
  for _ in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
    count = count + 1
  end
  return count
end

local function mergeTable(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == 'table' then
      if not t1[k] then
        t1[k] = {}
      end
      mergeTable(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

local function cloneTable(t)
  local newTable = {}
  for k, v in pairs(t) do
    if type(v) == 'table' then
      newTable[k] = cloneTable(v)
    else
      newTable[k] = v
    end
  end
  return newTable
end

return {
  utf8_sub = utf8_sub,
  utf8_len = utf8_len,
  mergeTable = mergeTable,
  cloneTable = cloneTable,
}