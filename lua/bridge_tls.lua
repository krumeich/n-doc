local bridge_tls={}

local tls=require("tls")

function bridge_tls.printTlsConnectionTable(tex)
   local conntable = tls.printTlsConnectionTable()
   tex.sprint(conntable)
end

function bridge_tls.getTlsConnectionTableRow(key, _document, tex)
   local conntable = tls.getTlsConnectionTableRow(key)
   tex.sprint(conntable)
end

function bridge_tls.printTlsParametersForModule(key, tex)
   local conntable = tls.printTlsParametersForModule(key)
   tex.sprint(conntable)
end

return bridge_tls
