
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

local BitField = {}

--- 创建位域处理器
-- @param specs 位域配置表 {字段名 = {bits=位宽, signed=是否带符号, default=默认值}}
-- @param max_bits 最大位数，默认32位
-- @return 包含 pack 和 unpack 方法的表
function BitField.create(specs, max_bits)
    -- 设置最大位数，默认32位
    max_bits = max_bits or 32
    assert(max_bits > 0 and max_bits <= 32, "最大位数必须在1-32之间")

    -- 收集字段信息并计算偏移量
    local fields = {}
    local field_order = {}
    local total_bits = 0

    -- 按照字母顺序处理字段（确保一致性）
    local keys = {}
    for name in pairs(specs) do
        table.insert(keys, name)
    end
    table.sort(keys)

    for _, name in ipairs(keys) do
        local config = specs[name]
        local bits = config.bits
        local signed = config.signed or false
        local default = config.default or 0

        assert(bits > 0 and bits <= max_bits, string.format("字段 '%s' 位宽必须在1-%d之间", name, max_bits))
        assert(total_bits + bits <= max_bits, string.format("总位宽超过%d位，字段 '%s' 无法添加", max_bits, name))

        -- 计算掩码
        local mask = bit.lshift(1, bits) - 1

        -- 计算范围
        local min_val, max_val
        if signed then
            local half = bit.lshift(1, bits - 1)
            min_val = -half
            max_val = half - 1
        else
            min_val = 0
            max_val = mask
        end

        fields[name] = {
            bits = bits,
            signed = signed,
            default = default,
            offset = total_bits,
            mask = mask,
            min_val = min_val,
            max_val = max_val
        }

        table.insert(field_order, name)
        total_bits = total_bits + bits
    end

    -- 打包函数
    local function pack(values)
        local result = 0

        for _, name in ipairs(field_order) do
            local field = fields[name]
            local value = values[name]

            -- 使用默认值
            if value == nil then
                value = field.default
            end

            -- 范围检查
            if value < field.min_val or value > field.max_val then
                error(string.format("字段 '%s' 值 %d 超出范围 [%d, %d]",
                    name, value, field.min_val, field.max_val))
            end

            -- 有符号数转换为无符号表示
            if field.signed and value < 0 then
                value = value + bit.lshift(1, field.bits)
            end

            -- 移位并合并到结果中
            result = bit.bor(result, bit.lshift(bit.band(value, field.mask), field.offset))
        end

        return result
    end

    -- 解包函数
    local function unpack(packed)
        local result = {}

        for _, name in ipairs(field_order) do
            local field = fields[name]

            -- 提取字段值
            local value = bit.band(bit.rshift(packed, field.offset), field.mask)

            -- 有符号数转换
            if field.signed then
                local sign_bit = bit.lshift(1, field.bits - 1)
                if bit.band(value, sign_bit) ~= 0 then
                    value = value - bit.lshift(1, field.bits)
                end
            end

            result[name] = value
        end

        return result
    end

    -- 返回接口
    return {
        pack = pack,
        unpack = unpack,
        fields = field_order,  -- 字段顺序，用于调试
        total_bits = total_bits,  -- 总位数，用于验证
        max_bits = max_bits  -- 最大位数，用于调试
    }
end


return {
  utf8_sub = utf8_sub,
  utf8_len = utf8_len,
  mergeTable = mergeTable,
  cloneTable = cloneTable,
  BitField = BitField,
}