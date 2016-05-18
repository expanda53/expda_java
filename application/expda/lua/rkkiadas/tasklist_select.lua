require 'model/Luafunc'
local luadir = luafunc.ini('luadir'):gsub('%/','%.'):gsub("\\",".")
exClass = require (luadir .. '.common.func')
local taskdir = 'tasklist'
local params = {...}
ui = params[1]
local aktmibiz = params[2]:gsub(':','')

function readTask(source)
  source = source:gsub('%[','')
  source = source:gsub('%]%]%]','%]%]')
  row=source
  local spl = exClass.split(row,"%]%]")
  item = spl[1]
  item = item:gsub('CEGNEV=','')
  ui:executeCommand("valueto","sellabel1",item)
  
end

-- kiadas feladatok beolvasasa
filename = luafunc.ini('exportdir') .. '\\' .. taskdir .. '\\' ..aktmibiz..'.txt'
file = io.open (filename , "r")
t = file:read("*l")
file:close()
readTask(t)
