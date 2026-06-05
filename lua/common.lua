common = {}

-- Singleton error sentinel — stored on common so all modules share one object identity without importing db_core
common._ERROR_SENTINEL = {err=true}

-- Centralized error detection – callers check result[1] against this single object
function common.has_error(result)
   return type(result[1]) == "table" and result[1].err == true
end

function common.insert_error(result)
   if (#result == 0) then
       table.insert(result, common._ERROR_SENTINEL)
   end
   return result
end

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
   local result = _G.db_core.read_from_db(querykey, {theKey})
   return common.check_for_errors(result, key)
end

function common.get_relations_by_query_key(querykey, keymap, error_mapper)
   local keys = keymap or {}
   local e = error_mapper or function (e) return e end;
   local dbresult = _G.db_core.read_from_db(querykey, keys, e)
   return dbresult
end

function common.check_for_errors(result, key)
    if _G.db_core.has_error(result) then
        local escaped_key = string.gsub(key, "_", "\\_")
        return "\\textcolor{red}{" .. escaped_key .. " is undefined}"
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

return common
