require 'model/Luafunc'
local params = {...}
ui = params[1]
cikod = params[2]:gsub(':','')
cikk = params[3]:gsub(':','')
kezelo = params[4]:gsub(':','')
cikknev = ui:findObject('LCIKK'):getText() 


mibiz = 'rkbevet_' .. kezelo
subdir = 'tasklist'
subdir_common = 'common'

--beolvasas tablaba, ha letezo bizonylatot folytat
filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\'..mibiz..'.txt'
file = io.open (filename , "r")
if (file~=nil) then
  source = file:read("*a")
  file:close()
  t = luafunc.strtotable(source)
else
  t={}
end	

local update_mehet = false
local cikk_found = false
local ujsor = false


local ujsor = true
  
count = 0
drb=0
osszdrb = 0;
for i, row in ipairs(t) do 
    count = count + 1 
    -- megnezzuk, hogy van-e mar ilyen sor, ha van, kiolvassuk a darabot
    if row['LEIR']==cikk then
      osszdrb = osszdrb + row['DRB'] 
      drb = row['DRB'] 
      drb = drb + 1
      t[i]['DRB'] = drb
      t[i]['CIKK'] = cikod
      ujsor=false
    end

end
sorsz = count + 1

if ujsor then
    t[sorsz]={}
    drb = drb + 1
    t[sorsz]['DRB'] = drb
    t[sorsz]['CIKK'] = cikod
    t[sorsz]['CIKKNEV'] = cikknev
    t[sorsz]['SORSZ'] = sorsz
    t[sorsz]['LEIR'] = cikk
    t[sorsz]['DRB2'] = 0
    t[sorsz]['VKOD'] = ""
    t[sorsz]['HKOD'] = "TER01"
    t[sorsz]['MOZGAS'] = "UTHN"
end

klt = 0
-- uton keszletfilebol megkeressuk az adott cikk keszletet
filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\rkbevet_utonklt.txt'
kltfile = io.open (filename , "r")
if (kltfile~=nil) then
  source = kltfile:read("*a")
  kltfile:close()
  terklt = luafunc.strtotable(source)
  for i, row in ipairs(terklt) do 
    if row['CIKK']==cikod then 
	  klt = row['DRB'] 
	end
  end
end	
 
ui:executeCommand('valueto','lcikk',cikknev)
ui:executeCommand('setbgcolor','lcikklabel','lightgray')
ui:executeCommand('showobj','ldrblabel','')
mehet = true
if ((tonumber(osszdrb+1) > tonumber(klt) or tonumber(klt)==0) and kltfile~=nil) then
	ui:showMessage('Nincs ennyi útonlévő készlet! (készlet: '..klt..' db)')
	mehet = false
end

if (mehet) then
	ui:executeCommand('valueto','ldrb',drb)


	if cikk_found then
	  ui:executeCommand('setbgcolor','lcikk','green')
	  ui:executeCommand('valueto','lstatus','Mentés kész. Következő cikk lövés')
	end

    filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '.txt'
    file = io.open (filename , "w")
    for i, row in ipairs(t) do
      sor = '[[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[DRB2=' .. row['DRB2'] .. ']][[VKOD=' ..row['VKOD'].. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']][[MOZGAS=' ..row['MOZGAS']..']]\n'
      file:write (sor) 
    end    
    file:close()

    
    filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
    file = io.open (filename , "a")
    
    sor = 'RKBEVET_BCODE1_UPD ' ..cikod .. ' ' .. cikk .. ' ' .. kezelo ..' ' .. drb .. '\n'
    file:write (sor) 

    file:close()
else
	ui:executeCommand('valueto','lstatus','Készlet hiba! Cikk lövés')
end	
ui:executeCommand('scanneron','','')




   