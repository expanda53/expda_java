require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
hkod = params[3]:gsub(':','')
aktdrb = params[4]:gsub(':','')
kezelo = params[5]:gsub(':','')
mibiz = 'orzleltar_' .. kezelo
subdir = 'tasklist'
mehet = true
 
if (hkod=="") then
  ui:showMessage('Válasszon helykódot!') 
  mehet=false
end
if (mehet and tonumber(aktdrb)<=0) then 
  ui:showMessage('A teljes mennyiség javítva lett!') 
  mehet=false
else
  if mehet then drb = aktdrb - 1 end
end
if (mehet) then
    seltabsum = ui:findObject('seltablesum')
	selrowsum = seltabsum:getSelectionIndex()
	
    seltabdet = ui:findObject('seltabledetails')
	selrowdet = seltabdet:getSelectionIndex()

	filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\'..mibiz..'.txt'
	file = io.open (filename , "r")
	if (file~=nil) then
	  source = file:read("*a")
	  file:close()
	  t = luafunc.strtotable(source)
	else
	  t={}
	end	
	row_found=false
	ahkod = hkod:gsub('%%20',' ')
	for i, r in ipairs(t) do
		  if (r['CIKK'] == cikk and r['HKOD']==ahkod) then 
			t[i]['DRB']= drb 
			row_found = true
		  end
		  if row_found then break end
	end  
	if (row_found) then
		file = io.open (filename , "w")
		for i, row in ipairs(t) do
		  adrb = row['DRB']
		  if tonumber(adrb)>0 then
		    sor = '[[CIKK=' .. row['CIKK'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']]\n'
		    file:write (sor) 
		  else
		    selrow=nil
		  end
		end    
		file:close()

		
		filenameu = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
		file = io.open (filenameu , "a")
		sor = 'ORZLELTAR_MENTES '.. cikk ..' ' .. hkod .. ' ' .. kezelo .. ' ' .. drb .. '\n'
		file:write (sor) 

		file:close()
	end
	
	
	ui:executeCommand("refresh","seltablesum","")
	ui:executeCommand("valuetohidden","selcikk",cikk)

	if (selrowsum~=nil) then 
	  seltabsum:setSelection(selrowsum)
	end	
    
	ui:executeCommand("refresh","seltabledetails","")
	--ui:executeCommand('STARTLUA','leltar/zaraslist_details.lua ' .. vkod .. ' ' .. kezelo,'')
	
	
	if (selrowdet~=nil) then 
	  --seltabdet:setSelection(selrowdet) 
	end

	ui:executeCommand('valuetohidden','seldrb',drb)
	ui:executeCommand('setfocus','seltabledetails','')
	
end