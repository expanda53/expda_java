require 'model/Luafunc'
local params = {...}
ui = params[1]
cikod = params[2]:gsub(':','')
cikk = params[3]:gsub(':','')
hkod = params[4]:gsub(':',''):gsub('%%20',' ')
kezelo = params[5]:gsub(':','')
hivszam = ui:findObject('lhivat'):getText():gsub('Hivatkozás:',''):gsub(' ', '%%20')

cegazon = ui:findObject('lcegazon'):getText()
--mibiz = "bevethkod_" .. cegazon .."_"..hivszam
mibiz = ui:findObject('ltitle'):getText():gsub('Bevét:',''):gsub(' ', '%%20')
if (hivszam == '') then
  hivszam ='.'
end  
subdir = 'tasklist'
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

local ujsor = true
  
  count = 0
  drb=0
  for i, row in ipairs(t) do 
    count = count + 1 
	-- megnezzuk, hogy van-e mar ilyen sor, ha van, kiolvassuk a darabot
	if row['LEIR']==cikk and row['HKOD']==hkod then 
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
    t[sorsz]['CIKKNEV'] = ui:findObject('LCIKK'):getText()
    t[sorsz]['SORSZ'] = sorsz
    t[sorsz]['HKOD'] = hkod
    t[sorsz]['LEIR'] = cikk
  end

  
    filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '.txt'
    file = io.open (filename , "w")
    for i, row in ipairs(t) do
      sor = '[[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']]\n'
      file:write (sor) 
    end    
    file:close()

	
    filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
    file = io.open (filename , "a")
	
    sor = 'BEVETHKOD_MENTES ' ..cikod .. ' ' ..cikk .. ' ' .. hkod:gsub(' ', '%%20') .. ' ' .. kezelo .. ' ' .. drb .. ' ' ..  hivszam .. ' ' ..cegazon .. '\n'
    file:write (sor) 

    file:close()

ui:executeCommand('setbgcolor','lcikklabel','green')
ui:executeCommand('valueto','lcikkc','')
ui:executeCommand('valueto','ldrb','db: ' .. drb)
--ui:executeCommand('hideobj','lcikk','')
ui:executeCommand('setfocus','lcikkc','')
ui:executeCommand('valueto','lstatus','Mentés rendben. Cikk lövés')
ui:executeCommand('scanneron','','')
