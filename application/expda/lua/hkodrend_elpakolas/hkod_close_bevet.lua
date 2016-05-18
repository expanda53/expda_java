require 'model/Luafunc'
local params = {...}
ui = params[1]
kezelo = params[2]:gsub(':','')
subdir = 'tasklist'
hivszam ='.'
cegazon = 0

mehet = ui:showDialog("Biztos zárható?")
if mehet then

	mibiz = 'hkod_elrak_' .. kezelo
	filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz .. '.txt'
	file = io.open (filename , "r")
	lezaras_mehet = true
	if file~=nil then
		source = file:read("*a")
		file:close()
		t =luafunc.strtotable(source)
		for i, row in ipairs(t) do
			local drb = 0
			drb = drb + row['DRB']
			if drb < 0 then 
				lezaras_mehet = false
				break 
			end
		end
		if lezaras_mehet==false then
			ui:showMessage("Negatív tétel a listában. Nem zárható, amíg nincs javítva!")
		else
			sor = 'HKOD_CLOSE_UPD ' .. kezelo .. ' ' ..  hivszam .. ' ' ..cegazon ..  ' 1\n'
			filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
			file = io.open (filename , "a")
			file:write (sor)
			file:close()
			ui:executeCommand('close','','')
		end
	  
	else
		lezaras_mehet=false
		ui:showMessage(mibiz .. ".txt adatfile nem elérhető." )
	end
	


  
end


