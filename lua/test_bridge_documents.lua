#!/usr/bin/env texlua

dofile("init_test_bridge.lua")

test_bridge_documents = {}

bridge = require("bridge_documents")

function test_bridge_documents.test_getDocumentVersion()
   bridge.getDocumentVersion("adv_tds", tex.expected("1.0-SNAPSHOT"))
end

function test_bridge_documents.test_gitCommitId()
   bridge.gitCommitId("adv_tds", tex.expected([[\\\textsmaller{[Commit~\gitAbbrevHash{}~/~\gitBranch{}]}]]))
end

function test_bridge_documents.test_getDocumentDate()
   bridge.getDocumentDate("adv_tds", tex.expected([[\today]]))
end

os.exit( lu.LuaUnit.run() )
