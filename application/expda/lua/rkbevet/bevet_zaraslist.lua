local params = {...}
require 'model/Luafunc'
kezelo = params[2]:gsub(':','')
mibiz = 'rkbevet_' .. kezelo
function readTask(source)
  source = source:gsub('%[%[%[','%[%[')
  source = source:gsub('%]%]%]','%]%]')
  luafunc.refreshtable_fromstring('seltablezar',source)
end

-- bizonylat
filename = luafunc.ini('exportdir') ..'\\tasklist\\' .. mibiz .. '.txt'
file = io.open (filename , "r")
if (file~=nil) then
  t = file:read("*a")
  file:close()
  readTask(t)
end
