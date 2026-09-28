bridge = require "bridge_common"
bridge.init("../common/test_db/")

lu = require('luaunit')

tex={}
function tex.print(texoutput)
   lu.assertEquals(texoutput, tex.expectedresult)
   tex.expected(nil)
end
tex.sprint=tex.print
function tex.expected(expectedresult)
   tex.expectedresult=expectedresult
   return tex
end
