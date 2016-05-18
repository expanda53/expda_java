require 'model/Luafunc'
local params = {...}
ui = params[1]
kezelo = params[2]:gsub(':','')
mibiz = 'rkbevet_' .. kezelo
subdir = 'tasklist'
mehet = ui:showDialog("Biztos zárható?")
if mehet then
  local sor = 'rkbevet_close_upd ' .. kezelo .. '\n'
  filename = luafunc.ini('exportdir') ..'\\' .. subdir .. '\\' .. mibiz.. '_update.txt'
  file = io.open (filename , "a")
  file:write (sor)
  file:close()
  ui:executeCommand('close','','')
end


