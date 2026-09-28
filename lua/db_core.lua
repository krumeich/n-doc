local dbcore = {}

dbcore.resultmappers={}
dbcore.insert_statements={}
dbcore.queries={}

local read_configs, populate_db, create_tables, populate_tables, prepare_queries, singleresult

function dbcore.init(db_path)
   dbcore.dbpath = db_path
   print("DB Path:", dbcore.dbpath)
   local sqlite3 = require("lsqlite3")
   dbcore.db = sqlite3.open_memory()
   read_configs()
   populate_db()
end

read_configs = function()
   local configfile = dbcore.dbpath .. "config"
   dbcore.configs = {}
   for i in io.lines(configfile) do
      table.insert(dbcore.configs, i)
   end
end

populate_db = function()
   for _,mod in pairs(dbcore.configs) do
      local mod_config = require(mod)
      create_tables(mod_config.all_table_definitions)
      populate_tables(mod_config.populate)
      prepare_queries(mod_config.queries)
   end
end

create_tables = function(table_definitions)
   for table_definition in table_definitions() do
      assert( dbcore.db:exec(table_definition))
   end
end

populate_tables = function(populate)
   local parser = require("ftcsv")
   for stmt, csv in populate() do
      local st = dbcore.db:prepare(stmt)
      -- print ("Initialisiere Tabelle aus " .. csv)
      local parsedTable = parser.parse(dbcore.dbpath .. csv, ";")
      if texio then
	 local log_out = {}
	 table.insert(log_out, "\n(")
	 table.insert(log_out, dbcore.dbpath)
	 table.insert(log_out, csv)
	 table.insert(log_out, ") ")
	 texio.write("log", table.concat(log_out))
      end
      for k,v in pairs(parsedTable) do
	 st:bind_names(v)
	 st:step()
	 st:reset()
      end
   end
end

prepare_queries = function(queries)
   for querykey, st, resultitem, mapper in queries() do
      dbcore.queries[querykey] = {
	 querystmt = assert(dbcore.db:prepare(st)),
	 resultitem = resultitem,
	 mapper = mapper
      }
   end
end

singleresult = function(v, querykey)
   local resultitem_name = dbcore.queries[querykey].resultitem;
   local result = v[resultitem_name]
   return result
end;

function dbcore.read_from_db(querykey, values)
   local result = {}
   local mapper = dbcore.queries[querykey].mapper or singleresult
   local stmt = dbcore.queries[querykey].querystmt
   stmt:bind_names(values)
   for row in stmt:nrows() do
      table.insert(result, mapper(row, querykey))
   end
   stmt:reset()
   return result
end

return dbcore
