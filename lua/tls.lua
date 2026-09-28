local tls = {}

function tls.init(basepath)
   if tls.initialized then return end
   local connections = {}
   local parser = require "ftcsv"
   local parsedTable = parser.parse(basepath .. "tls_definitions.csv", ";")
   for k,v in ipairs(parsedTable) do
      local tableentry = {key=v.key, logicalintf=v.logicalintf, role=v.role, peer=v.peer, protocol=v.protocol, port=v.port, idtoe=v.idtoe, idpeer=v.idpeer, authpeer=v.authpeer}
      tableentry.tdslink = v.submod == "NN" and "NN" or "\\tdslink[fq]{"  .. v.submod .. "}"
      tableentry.tds     = v.submod == "NN" and "NN" or "\\tds[fq]{"  .. v.submod .. "}"
      tableentry.submod  = v.submod == "NN" and "NN" or v.submod
      connections[v.key] = tableentry
   end
   tls.connections = connections
   tls.initialized = true
end

function tls.printTlsConnectionTable()
   local result = {}
   for tlsid in pairs(tls.connections) do
      table.insert(result, tls.getTlsConnectionTableRow(tlsid))
   end
   return table.concat(result, "\n")
end


function tls.getTlsConnectionTableRow(key)
   local tlsconn = tls.connections[key]
   local result = {}
   table.insert(result, tlsconn.logicalintf  .. "&")
   table.insert(result, tlsconn.role  .. "&")
   table.insert(result, tlsconn.peer  .. "&")
   table.insert(result, tlsconn.tdslink   .. "&")
   table.insert(result, tlsconn.port  .. "&")
   table.insert(result, tlsconn.idtoe  .. "&")
   table.insert(result, tlsconn.idpeer  .. "&")
   table.insert(result, tlsconn.authpeer)
   return table.concat(result)
end

function tls.printTlsParametersForModule(key)
   local tlsconn = tls.connections[key]
   local result = {}
   table.insert(result, "  TLS ID & \\secitemformat{\\ref{" .. key .. "}}\\\\")
   table.insert(result, "  Schnittstelle  & " .. tlsconn.logicalintf .. "\\\\")
   table.insert(result, "  Rolle des TOE  & " .. tlsconn.role .. "\\\\")
   table.insert(result, "  Peer  & " .. tlsconn.peer .. "\\\\")
   table.insert(result, "  Protokoll  & " .. tlsconn.protocol .. "\\\\")
   table.insert(result, "  Port  & " .. tlsconn.port .. "\\\\")
   table.insert(result, "  Identität des TOE  & " .. tlsconn.idtoe .. "\\\\")
   table.insert(result, "  Identität des Peer  & " .. tlsconn.idpeer .. "\\\\")
   table.insert(result, "  Authentifizierung des Peer durch  & " .. tlsconn.authpeer .. "\\\\")
   return table.concat(result)
end



return tls




