require 'model/Luafunc'
local params = {...}
ui = params[1]
kezelo = params[2]:gsub(':','')
hivszam = ui:findObject('lhivat'):getText():gsub('Hivatkozás:',''):gsub(' ', '%%20')
cegazon = ui:findObject('lcegazon'):getText()
--mibiz = "bevethkod_" .. cegazon .."_"..hivszam
mibiz = ui:findObject('ltitle'):getText():gsub('Bevét:',''):gsub(' ', '%%20')
if (hivszam == '') then
  hivszam ='.'
end  

subdir = 'tasklist'
mehet = ui:showDialog("Biztos zárható?")
if mehet then

	filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz .. '.txt'
	file = io.open (filename , "r")
	lezaras_mehet = true
	if file~=nil then
            file:close()
			sor = 'BEVETHKOD_CLOSE_UPD ' .. kezelo  .. ' ' ..  hivszam .. ' ' ..cegazon .. '\n'
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


