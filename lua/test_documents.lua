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

function test_documents.test_versions()
   lu.assertEquals(documents.get_version_number_for_refliste("1.0"), "1.0")
   lu.assertEquals(documents.get_version_number_for_refliste("1.1-SNAPSHOT"), "1.0")
   lu.assertEquals(documents.get_version_number_for_refliste("1.2-SNAPSHOT"), "1.1")
   lu.assertEquals(documents.get_version_number_for_refliste("1.2"), "1.2")
 end

os.exit( lu.LuaUnit.run() )
