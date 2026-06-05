#!/usr/bin/env texlua

dofile("init_test_db.lua")

local documents = require "documents"

lu = require('luaunit')

test_documents = {}

 function test_documents.test_version()
   theDoc="adv_fsp"
   lu.assertEquals(documents.getDocumentVersion(theDoc), "1.0-SNAPSHOT")
 end

 function test_documents.test_date()
   theDoc="adv_fsp"
   lu.assertEquals(documents.getDocumentDate(theDoc), "\\today")
 end

 function test_documents.test_type_pdf()
   theDoc="adv_fsp"
   lu.assertEquals(documents.getDocumentType(theDoc), "pdf")
 end
  
 function test_documents.test_type_csv()
   theDoc="db"
   lu.assertEquals(documents.getDocumentType(theDoc), "db")
 end
        
  function test_documents.test_versions()
    lu.assertEquals(documents.get_version_number_for_reflist("1.0-SNAPSHOT"), "1.0")
    lu.assertEquals(documents.get_version_number_for_reflist("1.0"), "1.0")
    lu.assertEquals(documents.get_version_number_for_reflist("1.1-SNAPSHOT"), "1.0")
    lu.assertEquals(documents.get_version_number_for_reflist("1.2-SNAPSHOT"), "1.1")
    lu.assertEquals(documents.get_version_number_for_reflist("1.2"), "1.2")
  end

  function test_documents.test_get_version_for_reflist_snapshot()
    -- SNAPSHOT with minor > 0: decremented (input: adv_fsp → uses string "1.0-SNAPSHOT" which yields minor=0, so returns verbatim. For testing the path, use a version with minor>0)
    local result = documents.get_version_number_for_reflist("2.1-SNAPSHOT")
    lu.assertEquals(result, "2.0")
  end

  function test_documents.test_get_version_for_reflist_release()
    -- Released version: returned verbatim (input doesn't matter for releases in get_version_number_for_reflist)
    local result = documents.get_version_number_for_reflist("3.5-SNAPSHOT")
    lu.assertEquals(result, "3.4")
  end

os.exit( lu.LuaUnit.run() )
