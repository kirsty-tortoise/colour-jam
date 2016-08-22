function copy(obj, seen)
  -- From http://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function tableToLua(object)
  if type(object) == "table" then
    local result = "{"
    for k,v in pairs(object) do
      if type(k) == "string" then
        result = result .. k
      elseif type(k) == "number" then
        result = result .. "[" .. k .. "]"
      end
      result = result .. " = " .. tableToLua(v) .. ", "
    end
    result = result .. "}"
    return result
  elseif type(object) == "string" then
    return "\""..object.."\""
  elseif type(object) == "number" then
    return tostring(object)
  elseif type(object) == "boolean" then
    if object then
      return "true"
    else
      return "false"
    end
  end
end
