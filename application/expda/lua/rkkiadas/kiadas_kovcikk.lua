require 'model/Luafunc'
local params = {...}
ui = params[1]
local mibiz = params[2]:gsub(':','')
local sorsz = params[3]:gsub(':','')
local hkod = params[4]:gsub(':','')
local taskdir = 'tasklist'
--beolvasas tablaba
filename = luafunc.ini('exportdir') .. '\\' .. taskdir .. '\\' .. mibiz..'.txt'
file = io.open (filename , "r")
source = file:read("*a")
file:close()
local update_mehet = false
local t = luafunc.strtotable(source)
volt = false
kovsorsz= 0
ui:executeCommand('setbgcolor','lcikkc','orange')
--aktualis sor kikeresese sorsz alapjan
for i, v in ipairs(t) do
  row = v
  rowsorsz = tonumber(row['SORSZ'])
  sorsz = tonumber(sorsz)
  local drb = row['DRB'];
  if (drb=='' or drb==nil) then drb=0 end
  drb = tonumber(drb)
  local drb2 = row['DRB2'];
  if (drb2=='' or drb2==nil) then drb2=0 end
  drb2 = tonumber(drb2)
  if (rowsorsz>sorsz) and (hkod==row['HKOD']) and (drb>drb2) and not(volt)  then
    volt = true
    kovsorsz = row['SORSZ']
    kovcikk = row['CIKKNEV']
    kovdrb = drb
    kovdrb2 = drb2
  end
end

if volt then
    ui:executeCommand('valueto','lcikk',kovcikk)
    ui:executeCommand('valueto','lcikkc','')
    ui:executeCommand('valueto','ldrbossz',kovdrb)
    ui:executeCommand('valueto','edrbkint',kovdrb2)
    ui:executeCommand('valueto','lsorsz',kovsorsz)
    ui:executeCommand('setfocus','lcikkc','')
    ui:executeCommand('scanneron','','')
else
    ui:executeCommand('uzenet','Nincs több kiszedhető cikk a helykódon!','')
    local luafile = luafunc.ini('luadir'):gsub('%/','%.'):gsub("\\",".") .. '.kiadas.kiadas_kovhkod_func'
    require (luafile)
    kovhkod(ui, mibiz, sorsz, hkod)                                                                                   
end
