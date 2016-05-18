require 'model/Luafunc'
local params = {...}
ui = params[1]
mibiz = params[2]:gsub('Bevét:',''):gsub(':','')
okbiz = params[3]:gsub(':','')
cegazon = params[4]:gsub(':','')
kezelo = params[5]:gsub(':','')
if (okbiz == '') then
  okbiz ='.'
end  
subdir = 'tasklist'
mehet = ui:showDialog("Biztos zárható?")
if mehet then
  local sor = 'bevet_close_upd ' .. mibiz ..  ' ' .. okbiz .. ' ' .. cegazon .. ' ' .. kezelo .. '\n'
  filename = luafunc.ini('exportdir') ..'\\' .. subdir .. '\\' .. mibiz.. '_update.txt'
  file = io.open (filename , "a")
  file:write (sor)
  file:close()
  ui:executeCommand('close','','')
end


