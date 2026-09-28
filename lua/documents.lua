local documents = {}

local cmn = require "common"

documents.table_definitions = {
   [[CREATE TABLE releases ( `document` TEXT, `version` TEXT, `date` TEXT, `type` TEXT, PRIMARY KEY(`document`) )]],
}

function documents.all_table_definitions()
   return cmn.iterator(documents.table_definitions)
end

documents.populate_info = {
   {st=[[INSERT INTO releases VALUES (:document, :version, :date, :type)]], csv="releases.csv"},
}

function documents.populate()
   return cmn.iterator(documents.populate_info, {"st", "csv"})
end

documents.querysets = {
    {name="docversion", st=[[SELECT version FROM releases WHERE document=?]], resultitem = "version"},
    {name="docdate", st=[[SELECT date FROM releases WHERE document=?]], resultitem = "date"},
    {name="doctype", st=[[SELECT type FROM releases WHERE document=?]], resultitem = "type"}
}

function documents.queries()
   return cmn.iterator(documents.querysets, {"name", "st", "resultitem", "mapper"})
end

function documents.getDocumentDate(key)
   return cmn.get_by_query_key("docdate", key)
end

function documents.getDocumentVersion(key)
   return cmn.get_by_query_key("docversion", key)
end

function documents.getDocumentType(key)
   return cmn.get_by_query_key("doctype", key)
end

function documents.get_version_number_for_reflist(version)
   local nosnap, is_snapshot = string.gsub(version, "-SNAPSHOT", "")
   local major, minor = cmn.split_at_dot(nosnap)
   if is_snapshot > 0 and tonumber(minor) > 0 then
     minor = tonumber(minor)-1
   end
   return major .. "." .. minor
end

return documents
