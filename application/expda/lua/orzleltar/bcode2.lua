require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
kezelo = params[3]:gsub(':','')
local cikk_found = false
subdir = 'common'

-- rsz kikeresese
ui:showWaitbox('Rendszám keresés...')



if (cikk_found==false) then
  -- megnezzuk az orzott torzsben
  fc = string.sub(cikk,1,1)
  filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\orzottlist_' .. fc ..'.txt'
  cikkfile = io.open (filename , "r")
  local stop = false
  if (cikkfile~=nil) then
    while true do
      local line = cikkfile:read("*l")
      if line == nil then break end
      local aktcikk = luafunc.strtotable(line)
      for i, r in ipairs(aktcikk) do
		aktrsz = r['RENDSZAM']
		if (aktrsz==cikk) then
		
			cikk_e = r['CIKK_E']
			drb_e = r['DRB_E']
			cikk_h = r['CIKK_H']
			drb_h = r['DRB_H']
			cikk_p = r['CIKK_P']
			drb_p = r['DRB_P']
			
			cegnev = r['CEGNEV']
			cikk_found = true
		else 
			--cikk.tipus (vkod) sorrendben van a cikklist.txt
			if aktrsz > cikk or aktrsz=="" then
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

    cegnev = ''
	cikk_e='-'
	cikk_h='-'
	cikk_p='-'
	drb_e='-'
	drb_h='-'
	drb_p='-'
end

ui:executeCommand('setbgcolor','lcikklabel','lightgray')  
ui:executeCommand('valueto','lcikke',cikk_e)
ui:executeCommand('valueto','lcikkp',cikk_p)
ui:executeCommand('valueto','lcikkh',cikk_h)
ui:executeCommand('valueto','ldrbe',drb_e)
ui:executeCommand('valueto','ldrbh',drb_h)
ui:executeCommand('valueto','ldrbp',drb_p)
ui:executeCommand('valueto','lcegnev',cegnev)
if (cikk_found == false) then
  ui:executeCommand('setbgcolor','lcikk','orange')
  ui:executeCommand('valueto','ldrb','db: 0')
  ui:executeCommand('valueto','lstatus','Rendszám ellenőrizendő')
  ui:executeCommand('uzenet','Nincs ilyen rendszám a törzsben. Ellenőrizni kell!','')
else
  ui:executeCommand('STARTLUA','orzleltar/mentes.lua ' .. cikk .. ' ' .. kezelo,'')
  ui:executeCommand('setfocus','lcikkc','')
end
--ui:executeCommand('showobj','bbevesz','')
--ui:executeCommand('setfocus','bbevesz','')
ui:executeCommand('scanneron','','')
