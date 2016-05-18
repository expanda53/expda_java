local params = {...}
require 'model/Luafunc'

function readTask(source)
  source = source:gsub('%[%[%[','%[%[')
  source = source:gsub('%]%]%]','%]%]')
  luafunc.refreshtable_fromstring('selcegtable',source)
end

-- cegek beolvasasa
filename = luafunc.ini('exportdir') .. '\\common\\bevet_ceglist.txt'
file = io.open (filename , "r")
t = file:read("*a")
file:close()
readTask(t)
