require 'model/Luafunc'
local params = {...}
ui = params[1]
mibiz = params[2]:gsub('Bevét:',''):gsub(':','')
aktsorsz = params[3]:gsub(':','')
aktdrb = params[4]:gsub(':','')
cegazon = params[5]:gsub(':','')
kezelo = params[6]:gsub(':','')
subdir = 'tasklist'
if (tonumber(aktdrb)<=0) then 
  ui:showMessage('A teljes mennyiség javítva lett!') 
  mehet=false
else
  mehet=true
  drb = aktdrb - 1
end
if (mehet) then
    seltab = ui:findObject("seltablezar")
	selrow = seltab:getSelectionIndex()
	
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
	for i, r in ipairs(t) do
		  if r['SORSZ'] == aktsorsz then 
			t[i]['DRB']= drb 
			vkod = r['LEIR']
			okbiz = r['OKBIZ']
			row_found = true
		  end
		  if row_found then break end
	end  
	if (row_found) then
		file = io.open (filename , "w")
		for i, row in ipairs(t) do
		  adrb = row['DRB']
		  if tonumber(adrb)>0 then
		    sor = '[[CEGNEV=' .. row['CEGNEV'] .. ']][[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[DRB2=' .. row['DRB2'] .. ']][[VKOD=' ..row['VKOD'].. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']][[MOZGAS=' ..row['MOZGAS']..']][[OKBIZ=' ..row['OKBIZ']..']]\n'
		    file:write (sor) 
		  else
		    selrow=nil
		  end
		end    
		file:close()

		
		filenameu = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
		file = io.open (filenameu , "a")
		
		sor = 'BEVET_BCODE1_UPD ' .. mibiz .. ' ' .. vkod .. ' ' .. okbiz .. ' ' .. cegazon .. ' ' .. kezelo ..' ' .. drb .. '\n'
		file:write (sor) 

		file:close()
	end
	

	-- bizonylat
	file = io.open (filename , "r")
	if (file~=nil) then
	  source = file:read("*a")
	  file:close()
	  luafunc.refreshtable_fromstring('seltablezar',source)
	  if (selrow~=nil) then 
		 seltab:setSelection(selrow) 
	  end
	end
	ui:executeCommand('valuetohidden','seldrb',drb)
	ui:executeCommand('setfocus','seltablezar','')
	
end