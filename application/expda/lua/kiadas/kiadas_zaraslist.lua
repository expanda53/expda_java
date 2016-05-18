local params = {...}
require 'model/Luafunc'
local mibiz = params[2]:gsub(':','')
function readTask(source)
  source = source:gsub('%[%[%[','%[%[')
  source = source:gsub('%]%]%]','%]%]')
  luafunc.refreshtable_fromstring('seltablezar',source)
end

-- bizonylat
filename = luafunc.ini('exportdir') .. '\\tasklist\\' .. mibiz .. '.txt'
file = io.open (filename , "r")
t = file:read("*a")
file:close()
readTask(t)
