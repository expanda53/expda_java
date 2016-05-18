require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
kezelo = params[3]:gsub(':','')
hkod = ui:findObject('LHKOC'):getText()
mibiz = "orzleltar_" .. kezelo;
subdir = 'tasklist'
--ui:executeCommand('uzenet',cikod .. cikk .. hkod ..elojel..kezelo)
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
	if row['CIKK']==cikk and row['HKOD']==hkod then 
	  drb = row['DRB'] 
	  drb = drb + 1
	  t[i]['DRB'] = drb
	  t[i]['CIKK'] = cikk
	  ujsor=false
	end
	
  end
  sorsz = count + 1
  if ujsor then
    t[sorsz]={}
    drb = drb + 1
    t[sorsz]['DRB'] = drb
    t[sorsz]['CIKK'] = cikk
    t[sorsz]['SORSZ'] = sorsz
    t[sorsz]['HKOD'] = hkod
    t[sorsz]['LEIR'] = cikk
  end

  
    filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '.txt'
    file = io.open (filename , "w")
    for i, row in ipairs(t) do
      sor = '[[CIKK=' .. row['CIKK'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']]\n'
      file:write (sor) 
    end    
    file:close()

	
    filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
    file = io.open (filename , "a")
	
    sor = 'ORZLELTAR_MENTES ' ..cikk .. ' ' .. hkod:gsub(' ', '%%20') .. ' '  .. kezelo .. ' ' .. drb .. '\n'
    file:write (sor) 

    file:close()

ui:executeCommand('setbgcolor','lcikklabel','green')
ui:executeCommand('valueto','lcikkc','')
ui:executeCommand('valueto','ldrb','db: ' .. drb)
ui:executeCommand('hideobj','bbevesz','')
ui:executeCommand('setfocus','lcikkc','')
ui:executeCommand('valueto','lstatus','Mentés rendben. Rendszám lövés')
ui:executeCommand('scanneron','','')




   