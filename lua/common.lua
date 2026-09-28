local common = {}

local dbcore = require "db_core"

function common.split(key, sep)
   local sep, fields = sep or ".", {}
   local pattern = string.format("([^%s]+)", sep)
   string.gsub(key, pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function common.split_at_dot(key)
   local label = common.split(key, ".")
   return label[1], label[2], label[3], label[4]
end

function common.replaceUnderscore(key)
   local result = string.gsub(key, "_", "\\_")
   return result
end

function common.remove_smart_hyphen(key)
   local result = string.gsub(key, '\\%-', '') -- I have no idea why this works.
   return result
end

function common.get_by_query_key(querykey, key)
   local theKey = string.lower(key)
   local result = dbcore.read_from_db(querykey, {theKey})
   return common.check_for_errors(result, key)
end

function common.get_relations_by_query_key(querykey, keymap)
   local keys = keymap or {}
   return dbcore.read_from_db(querykey, keys)
end

function common.undefined_error(key)
   return "\\textcolor{red}{" .. key .. " is undefined}"
end

function common.check_for_errors(result, key)
   if #result == 0 then
      local escaped_key = string.gsub(key, "_", "\\_")
      return common.undefined_error(escaped_key)
   end
   return result[1]
end

function common.generate_label_list(thelabel)
    local labels = common.get_relations_by_query_key(thelabel .."_all_labels")
    return labels
end

function common.count_labels(thelabel)
    local labels = common.get_relations_by_query_key(thelabel .."_all_labels")
    return #labels
end

function common.getError(key)
    return common.get_by_query_key("error", key)
 end

function common.labels(labeltype)
   local labels = common.generate_label_list(labeltype)
   local i = 0
   return function ()
      i = i + 1
      if i <= #labels then return labels[i] end
   end
end

function common.iterator(data, fields)
   local i = 0
   local n = #data
   if fields then
      return function()
         i = i + 1
         if i <= n then
            local entry = data[i]
            local values = {}
            for j, f in ipairs(fields) do
               values[j] = entry[f]
            end
            return table.unpack(values, 1, #fields)
         end
      end
   else
      return function()
         i = i + 1
         if i <= n then return data[i] end
      end
   end
end

return common
