require 'model/Luafunc'
local params = {...}
ui = params[1]
kezelo = params[2]:gsub(':','')
mibiz='rkbevethkod_' .. kezelo


subdir = 'tasklist'
mehet = ui:showDialog("Biztos zárható?")
if mehet then

	filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz .. '.txt'
	file = io.open (filename , "r")
	lezaras_mehet = true
	if file~=nil then
			sor = 'RKBEVETHKOD_CLOSE_UPD ' .. kezelo  .. '\n'
			filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
			file = io.open (filename , "a")
			file:write (sor)
			file:close()
			ui:executeCommand('close','','')
	else
		lezaras_mehet=false
		ui:showMessage(mibiz .. ".txt adatfile nem elérhető." )
	end
	


  
end


