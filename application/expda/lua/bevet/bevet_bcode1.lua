require 'model/Luafunc'
local params = {...}
ui = params[1]
mibiz = params[2]:gsub('Bevét:',''):gsub(':','')
cikk = params[3]:gsub(':','')
cegazon = params[4]:gsub(':','')
kezelo = params[5]:gsub(':','')
okbiz = ui:findObject('lhivat'):getText():gsub('Hivatkozás:','')
if (okbiz == '') then
  okbiz ='.'
end  
subdir = 'tasklist'
subdir_common = 'common'
--beolvasas tablaba, ha letezo bizonylatot folytat
if (mibiz~="Új") then
  filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\'..mibiz..'.txt'
  file = io.open (filename , "r")
  if (file~=nil) then
    source = file:read("*a")
    file:close()
    t = luafunc.strtotable(source)
  else
    t={}
  end	
else
  t={}
end

local update_mehet = false
local cikk_found = false
local ujsor = false
-- cikk kikeresese
ui:showWaitbox('Cikk keresés...')

if (cikk_found==false and t~=nil) then
  -- elobb megnezzuk a bizonylaton, az a gyorsabb
    for i, r in ipairs(t) do
      if r['LEIR'] == cikk then --and r['CIKK']~="NINCSEAN" 
        --ui:showMessage(r['CIKKNEV'] .. ' = ' .. r['CIKK'] .. ' = ' .. r['SORSZ'])
        cikod = r['CIKK']
        cikknev = r['CIKKNEV']
        drb = r['DRB']
        sorsz = r['SORSZ']
        t[i]['DRB'] = drb + 1 
        cikk_found = true
      end
      if cikk_found then break end
    end  
end

if (cikk_found==false) then
  -- bizonylaton nem talalhato, megnezzuk a cikktorzsben, vkod szerint
  fc = string.sub(cikk,1,9)
  filename = luafunc.ini('exportdir') ..'\\' .. subdir_common.. '\\cikklist_'.. fc ..'.txt'
  cikkfile = io.open (filename , "r")
  local stop = false
  if (cikkfile~=nil) then
    while true do
      local line = cikkfile:read("*l")
      if line == nil then break end
      local aktcikk = luafunc.strtotable(line)
      for i, r in ipairs(aktcikk) do
        if (r['VKOD']==cikk) then
          -- ui:showMessage(r['NEV'] .. ' = ' .. r['KOD'])
          cikod = r['KOD']
          cikknev = r['NEV']
          drb = 0
          sorsz = 0 
          cikk_found = true
		  ujsor=true --uj sorkent fel kell vinni, mert a bizonylaton meg nincs rajta
  	    else
	        --cikk.tipus (vkod) sorrendben van a cikklist.txt
			if r['VKOD'] > cikk or r['VKOD']=="" then
				stop = true
			end
        end  
      end
      if cikk_found or stop then break end    
    end    
    cikkfile:close()
  end  
end  

ui:hideWaitbox()
if (cikk_found==false) then
    cikod = 'NINCSEAN'
    cikknev = cikk
    drb = 0
    sorsz = 0 
    --ui:showMessage('Cikk nem található!')
end
  
ui:executeCommand('valueto','lcikk',cikknev)
ui:executeCommand('setbgcolor','lcikklabel','lightgray')
ui:executeCommand('showobj','ldrblabel','')
drb = drb + 1
ui:executeCommand('valueto','ldrb',drb)

if (cikk_found==false or ujsor) then
  count=0
  for i, r in ipairs(t) do count = count + 1 end
  sorsz = count + 1
  t[sorsz]={}
  t[sorsz]['DRB'] = drb
  t[sorsz]['DRB2'] = 0
  t[sorsz]['CIKK'] = cikod
  t[sorsz]['CIKKNEV'] = cikknev
  t[sorsz]['CEGNEV'] = ""
  t[sorsz]['SORSZ'] = sorsz
  t[sorsz]['VKOD'] = ""
  t[sorsz]['HKOD'] = "TER01"
  t[sorsz]['OKBIZ'] = okbiz
  t[sorsz]['MOZGAS'] = "BITT"
  t[sorsz]['LEIR'] = cikk
end

if cikk_found then
  ui:executeCommand('setbgcolor','lcikk','green')
  ui:executeCommand('valueto','lstatus','Mentés kész. Következő cikk lövés')
end

    filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '.txt'
    file = io.open (filename , "w")
    for i, row in ipairs(t) do
      sor = '[[CEGNEV=' .. row['CEGNEV'] .. ']][[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[DRB2=' .. row['DRB2'] .. ']][[VKOD=' ..row['VKOD'].. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']][[MOZGAS=' ..row['MOZGAS']..']][[OKBIZ=' ..row['OKBIZ']..']]\n'
      file:write (sor) 
    end    
    file:close()

	
    filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
    file = io.open (filename , "a")
	
    sor = 'BEVET_BCODE1_UPD ' .. mibiz .. ' ' .. cikk .. ' ' .. okbiz .. ' ' .. cegazon .. ' ' .. kezelo ..' ' .. drb .. '\n'
    file:write (sor) 

    file:close()

	if (cikk_found == false) then
  ui:executeCommand('setbgcolor','lcikk','orange')
  ui:executeCommand('valueto','lstatus','Cikk ellenőrizendő. Mentés kész. Következő cikk lövés')
  ui:executeCommand('uzenet','Mentés megtörtént, de nincs ilyen kódú cikk a törzsben. Ellenőrizni kell!','')
  ui:executeCommand('showobj','pcikkval','')
  ui:executeCommand('hideobj','panel1','')
  ui:executeCommand('valueto','lfilter','')
  ui:executeCommand('setfocus','lfilter','')
end
	
ui:executeCommand('scanneron','','')




   