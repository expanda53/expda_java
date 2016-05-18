require 'model/Luafunc'
local params = {...}
ui = params[1]
local mibiz = params[2]:gsub(':','')
local sorsz = params[3]:gsub(':','')
local hkod = params[4]:gsub(':','')
local vkod = params[5]:gsub(':','')
local kezelo = params[6]:gsub(':','')
local taskdir = 'tasklist'
--print (mibiz .. ' ' .. hkod .. ' ' .. sorsz .. ' ' .. vkod )

--beolvasas tablaba
filename = luafunc.ini('exportdir') .. '\\' .. taskdir .. '\\' ..mibiz..'.txt'
file = io.open (filename , "r")
source = file:read("*a")
file:close()
local update_mehet = false
local t = luafunc.strtotable(source)

--aktualis sor kikeresese sorsz alapjan
for i, v in ipairs(t) do
  row = v
  if (row['SORSZ']==sorsz) then
    if (row['VKOD']==vkod) then
      ui:executeCommand('setbgcolor','lcikkc','green')
      local drb = row['DRB'];
      if (drb=='') then drb=0 end
      drb = tonumber(drb)
      local drb2 = row['DRB2'];
      if (drb2=='') then drb2=0 end
      drb2 = tonumber(drb2)
      if (drb2<drb) then
        local sor = 'kiadas_bcode2_upd :'..mibiz .. ' :'..sorsz .. ' :'..hkod .. ' :' .. vkod ..' :' .. kezelo .. '\n'
        filename = luafunc.ini('exportdir') .. '\\' .. taskdir .. '\\' .. mibiz.. '_update.txt'
        file = io.open (filename , "a")
        file:write (sor)
        file:close()
        ui:executeCommand('valueto','edrbkint',drb2 + 1)
        ui:executeCommand('valueto','lstatus','Mentés rendben.')
        t[i]['DRB2']=drb2 + 1
        update_mehet = true
      end
      if (drb2+1>=drb) then
        ui:executeCommand('valueto','lstatus','Cikk kiadva! Köv. cikk vagy helykód')
        ui:executeCommand('uzenet','A teljes mennyiség ki lett adva.','')
      end
      ui:executeCommand('aktbcodeobj','bcode2','')
    else
      --lott vkod nem egyezik
      ui:executeCommand('setbgcolor','lcikkc','red')
      ui:executeCommand('valueto','lstatus','Eltérés! Cikk lövés újra')
      ui:executeCommand('uzenet','Nem egyezik a várt (' .. row['VKOD'] .. ') és a lőtt (' .. vkod .. ') vonalkód!','')
    end
    ui:executeCommand('scanneron','','')
  end
  
end
--visszairas  
if (update_mehet) then
    filename = luafunc.ini('exportdir') .. '\\' .. taskdir .. '\\' .. mibiz.. '.txt'
    file = io.open (filename , "w")
    for i, row in ipairs(t) do
      sor = '[[CEGNEV=' .. row['CEGNEV'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[DRB2=' .. row['DRB2'] .. ']][[VKOD=' ..row['VKOD'].. ']][[HKOD=' ..row['HKOD']..']][[HKODLEIR=' ..row['HKODLEIR']..']]\n'
      file:write (sor) 
    end    
    file:close()
end



