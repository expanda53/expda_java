require 'model/Luafunc'
local luadir = luafunc.ini('luadir'):gsub('%/','%.'):gsub("\\",".")
exClass = require (luadir .. '.common.func')
params = {...}
ui = params[1]
taskdir = 'tasklist';


function delFiles(files)
  local t = exClass.split(files,",")
  if (t~=nil) then 
    for i, aktfile in ipairs(t) do
		filename = luafunc.ini('exportdir') .. '\\'.. taskdir..'\\'..aktfile
		os.remove(filename)
	end
  end
end


if (luafunc.getWifiStrength()>0) then
	shortFilename = "rkbevet_utonklt.txt";
    delFiles(shortFilename) 

	-- ter01 hkodklt lekerdezese
	--exClass.luastat(ui,lstatus,"...Kiadási feladatok...","red")
	local list = luafunc.query_assoc('GET_UTON_KLT x [lkezelo]',false)
	filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\'..shortFilename
	file = io.open (filename , "w")
	if (list~=nil) then
	  for i, v in ipairs(list) do
	    local aktcikk = v['CIKK']
		if (aktcikk ~= "") then
		  file:write ('[[CIKK=' .. v['CIKK'] .. ']][[VKOD=' .. v['VKOD'] .. ']][[DRB=' .. v['DRB'] .. ']]\n')
		end
	  end
	end
	file:close()
else 
  ui:showMessage("Wifi nem elérhető!Útonlévő készlet letöltése nem sikerült.")
end





