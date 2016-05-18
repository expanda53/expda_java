require 'model/Luafunc'
local params = {...}
ui=params[1]
local mibiz = params[2]:gsub(':','')
local sorsz = params[3]:gsub(':','')
local hkod = params[4]:gsub(':',''):gsub('%%20',' ')
local hkodc = params[5]:gsub(':',''):gsub('%%20',' ')
local taskdir = 'tasklist'
--print (mibiz .. ' ' .. hkod .. ' ' .. sorsz .. ' ' .. hkodc )
if (hkod==hkodc) then
  filename = luafunc.ini('exportdir') .. '\\' .. taskdir .. '\\' ..mibiz..'.txt'
  file = io.open (filename , "r")
  source = file:read("*a")
  file:close()
  local t = luafunc.strtotable(source)
  volt = false
  for i, v in ipairs(t) do
    row = v

    if (row['HKOD']==hkod and tonumber(row['DRB']) > tonumber(row['DRB2']) and not volt) then
      volt=true
      ui:executeCommand('setbgcolor','lhklabel','lightgray')
      ui:executeCommand('setbgcolor','lhkoc','green')
      ui:executeCommand('setbgcolor','lcikkc','orange')
      ui:executeCommand('valueto','lcikk',row['CIKKNEV'])
      ui:executeCommand('valueto','ldrbossz',row['DRB'])
      ui:executeCommand('valueto','edrbkint',row['DRB2'])      
      ui:executeCommand('valueto','lcikkc','')
      ui:executeCommand('showobj','bkovcikk','')
      ui:executeCommand('valueto','lstatus','Helykód rendben. Cikk lövés')
      ui:executeCommand('setfocus','lcikkc','')
      ui:executeCommand('aktbcodeobj','bcode2','')
    end
	if volt then break end
  end
  if not volt then
    ui:executeCommand('uzenet','A helykódon nincs kiadható termék.','')
  end
else
  ui:executeCommand('setbgcolor','lhkoc','red')
  ui:executeCommand('valueto','lstatus','Eltérés! Helykód lövés újra')
  ui:executeCommand('uzenet','Nem egyezik a várt (' .. hkod ..') és a lőtt (' .. hkodc ..') helykód!','')
  
end
ui:executeCommand('scanneron','','')
