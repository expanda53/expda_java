params = {...}
ui = params[1]
login =  params[2]:gsub(':','')
require 'model/Luafunc' 
subdir = 'common'
filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\login.txt'
file = io.open (filename , "r")
if (file~=nil) then
	source = file:read("*a")
	file:close()
	local t = luafunc.strtotable(source)
	volt = false
	kovsorsz= 0
	--kezelo kikeresese
	for i, row in ipairs(t) do
		bekod = row['BEKOD']
		nev = row['KEZNEV']
		if bekod==login and not(volt)  then
		  volt = true
		end
		if volt then break end
	end
	
	if volt then
	  ui:executeCommand('valueto','lstatus','kezelő:' .. nev)
	end
else
	list = luafunc.query('menu_panelinit :' .. login ,true)
end
