require 'model/Luafunc'
local params = {...}
ui = params[1]
kezelo = params[2]:gsub(':','')
subdir = 'tasklist'
mehet = ui:showDialog("Biztos zárható?")
if mehet then

	mibiz = 'leltar_' .. kezelo
	filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz .. '.txt'
	file = io.open (filename , "r")
	lezaras_mehet = true
	if file~=nil then
			sor = 'LELTAR_CLOSE_UPD ' .. kezelo .. '\n'
			filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
			fileupd = io.open (filename , "a")
			fileupd:write (sor)
			fileupd:close()
			ui:executeCommand('close','','')
			file:close()
	else
		lezaras_mehet=false
		ui:showMessage(mibiz .. ".txt adatfile nem elérhető." )
	end
 
end


