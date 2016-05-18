require 'model/Luafunc'
local params = {...}
ui = params[1]
local mibiz = params[2]:gsub(':','')
local kezelo = params[3]:gsub(':','')
local mehet = ui:showDialog("Biztos zárható?")
local taskdir = 'tasklist'
if mehet then
  local sor = 'kiadas_close_upd :'..mibiz ..  ' :' .. kezelo .. '\n'
  filename = luafunc.ini('exportdir') .. '\\' .. taskdir .. '\\' .. mibiz.. '_update.txt'
  file = io.open (filename , "a")
  file:write (sor)
  file:close()
  ui:executeCommand('close','','')
end


