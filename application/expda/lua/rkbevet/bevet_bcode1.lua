require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
kezelo = params[3]:gsub(':','')
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
local drb=0

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
    ui:showMessage('Cikk nem található!')
end
 
 
ui:executeCommand('valueto','lcikk',cikknev)
ui:executeCommand('setbgcolor','lcikklabel','lightgray')
ui:executeCommand('showobj','ldrblabel','')
if (cikk_found == false) then
	  ui:executeCommand('setbgcolor','lcikk','orange')
	  ui:executeCommand('valueto','lstatus','Cikk ellenőrizendő')
	  ui:executeCommand('uzenet','Nincs ilyen kódú cikk a törzsben. Ellenőrizni kell!','')

	  ui:executeCommand('showobj','pcikkval','')
	  ui:executeCommand('hideobj','panel1','')
	  ui:executeCommand('valueto','lfilter','')
	  ui:executeCommand('setfocus','lfilter','')
	  
else
	  ui:executeCommand('STARTLUA','rkbevet/bevet_mentes.lua '..cikod..' ' .. cikk .. ' ' .. kezelo,'')
end

ui:executeCommand('scanneron','','')
   