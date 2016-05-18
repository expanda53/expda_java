require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
kezelo = params[3]:gsub(':','')
mibiz = "leltar_" .. kezelo;
local cikk_found = false
subdir = 'tasklist'
subdir_common = 'common'
  filename = luafunc.ini('exportdir') ..'\\' .. subdir .. '\\'..mibiz..'.txt'
  file = io.open (filename , "r")
  if (file~=nil) then
    source = file:read("*a")
    file:close()
    t = luafunc.strtotable(source)
  else
    t={}
  end	

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
  -- megnezzuk a cikktorzsben
  fc = string.sub(cikk,1,9)
  filename = luafunc.ini('exportdir') ..'\\' .. subdir_common.. '\\cikklist_' .. fc ..'.txt'
  cikkfile = io.open (filename , "r")
  local stop = false
  if (cikkfile~=nil) then
    while true do
      local line = cikkfile:read("*l")
      if line == nil then break end
      local aktcikk = luafunc.strtotable(line)
      for i, r in ipairs(aktcikk) do
		aktvkod = r['VKOD']
		if (aktvkod==cikk) then
			cikod = r['KOD']
			cikknev = r['NEV']
			cikk_found = true
		else 
			--cikk.tipus (vkod) sorrendben van a cikklist.txt
			if aktvkod > cikk or aktvkod=="" then
				stop = true
			end
		end  
      end
      if cikk_found or stop then break end    
    end    
    cikkfile:close()
  else
	  --ui:showMessage('cikklist.txt nem található! Futtassa a törzsadat frissítést.')
    
  end  
end  

ui:hideWaitbox()
if (cikk_found==false) then
    cikod = 'NINCSEAN'
    cikknev = cikk
end

ui:executeCommand('setbgcolor','lcikklabel','lightgray')  
ui:executeCommand('valueto','lcikk',cikknev)
ui:executeCommand('valuetohidden','lcikod',cikod)
if (cikk_found == false) then
  ui:executeCommand('setbgcolor','lcikk','orange')
  ui:executeCommand('valueto','lstatus','Cikk ellenőrizendő')
  ui:executeCommand('uzenet','Nincs ilyen kódú cikk a törzsben. Ellenőrizni kell!','')

  ui:executeCommand('showobj','pcikkval','')
  ui:executeCommand('hideobj','panel1','')
  ui:executeCommand('valueto','lfilter','')
  ui:executeCommand('setfocus','lfilter','')
  ui:executeCommand('showobj','bbevesz','')
--ui:executeCommand('setfocus','bbevesz','')  
else
  ui:executeCommand('STARTLUA','leltar/mentes.lua '..cikod..' ' .. cikk .. ' + ' .. kezelo,'')
  ui:executeCommand('setfocus','lcikkc','')
end
--ui:executeCommand('showobj','bbevesz','')
--ui:executeCommand('setfocus','bbevesz','')
ui:executeCommand('scanneron','','')
