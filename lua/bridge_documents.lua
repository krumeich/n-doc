bridge_documents={}

documents = require "documents"

function bridge_documents.getDocumentVersion(key, tex)
   tex.sprint(documents.getDocumentVersion(key))
end

function bridge_documents.gitCommitId(key, tex)
    local docversion = documents.getDocumentVersion(key)
    if string.find(docversion, "-SNAPSHOT") then
       tex.sprint("\\\\\\textsmaller{[Commit~\\gitAbbrevHash{}~/~\\gitBranch{}]}")
    end
end

function bridge_documents.getDocumentDate(key, tex)
   tex.sprint(documents.getDocumentDate(key))
end

function bridge_documents.version_number_for_reflist(key)
    local docdata = documents.get_version_for_reflist(key)
    return docdata and docdata[1] or ''
end

return bridge_documents
