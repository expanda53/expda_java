local params = {...}
local tipus = params[2]:gsub(':','')
require 'model/Luafunc'

function readTask(source)
  source = source:gsub('%[%[%[','%[%[')
  source = source:gsub('%]%]%]','%]%]')
  luafunc.refreshtable_fromstring('seltable',source)
end

-- kiadas feladatok beolvasasa
filename = luafunc.ini('exportdir') .. '\\tasklist\\kiadas_mibizlist.txt'
file = io.open (filename , "r")
if file~=nil then
  t = file:read("*a")
  file:close()
  readTask(t)
end
