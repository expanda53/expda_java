require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
vkod = params[3]:gsub(':','')
hkod = params[4]:gsub(':','')
aktdrb = params[5]:gsub(':','')
kezelo = params[6]:gsub(':','')
hivszam ='.'
cegazon = 0
mibiz = 'hkod_elrak_' .. kezelo
mehet = true
subdir = 'tasklist'
if (cikk=="-") then
  ui:showMessage('Válasszon cikket!') 
  mehet=false
end
if (hkod=="") then
  ui:showMessage('Válasszon helykódot!') 
  mehet=false
end
if (mehet and tonumber(aktdrb)==0) then 
  ui:showMessage('A teljes mennyiség javítva lett!') 
  mehet=false
else
  if mehet then 
     elojel = 'P'
     if (tonumber(aktdrb)>0) then 
	   drb = aktdrb - 1
	   elojel='P'
	 end
  end
	 
end
if (mehet) then
    seltabsum = ui:findObject('seltablesum')
	selrowsum = seltabsum:getSelectionIndex()
	
    seltabdet = ui:findObject('seltabledetails')
	selrowdet = seltabdet:getSelectionIndex()

	filename = luafunc.ini('exportdir') ..'\\' .. subdir .. '\\'..mibiz..'.txt'
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
		  if (r['CIKK'] == cikk and r['LEIR']==vkod and r['HKOD']==ahkod) then 
			t[i]['DRB']= drb 
			row_found = true
		  end
		  if row_found then break end
	end  
	if (row_found) then
		file = io.open (filename , "w")
		for i, row in ipairs(t) do
		  adrb = row['DRB']
		  if tonumber(adrb)~=0 then
		    sor = '[[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']][[ELOJEL=' ..row['ELOJEL']..']]\n'
		    file:write (sor) 
		  else
		    selrow=nil
		  end
		end    
		file:close()

		
		filenameu = luafunc.ini('exportdir') ..'\\' .. subdir .. '\\' .. mibiz.. '_update.txt'
		file = io.open (filenameu , "a")
		sor = 'HKOD_MENTES2 ' ..cikk .. ' ' ..vkod .. ' ' .. hkod:gsub(' ', '%%20') .. ' ' .. elojel .. ' ' .. kezelo .. ' ' .. drb .. ' ' .. hivszam .. ' '..cegazon ..' 1\n'
		file:write (sor) 

		file:close()
	end
	
	
	ui:executeCommand("refresh","seltablesum","")
	ui:executeCommand("valuetohidden","selcikk",vkod)
	ui:executeCommand("valuetohidden","selcikod",cikk)

	if (selrowsum~=nil) then 
	  seltabsum:setSelection(selrowsum)
	end	
    
	ui:executeCommand("refresh","seltabledetails","")
	
	if (selrowdet~=nil) then 
	  --seltabdet:setSelection(selrowdet) 
	end

	ui:executeCommand('valuetohidden','seldrb',drb)
	ui:executeCommand('setfocus','seltabledetails','')
	
end