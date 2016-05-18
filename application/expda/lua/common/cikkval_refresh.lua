local params = {...}
ui = params[1]
require 'model/Luafunc'
findstr = params[2]:gsub(':',''):gsub('/',''):gsub("%%20", ""):upper():gsub('R',''):gsub('X',''):gsub('ET',''):gsub('%.','')

if (findstr == "") then
  ui:showMessage("Üres névre nem lehet keresni!")
end


-- cikkek beolvasasa
if findstr:len()<3 then 
  ui:showMessage('Legalább 3 karaktert meg kell adni! Keresett szöveg:' .. findstr)
else
	fs = string.sub(findstr,1,3)
	filename = luafunc.ini('exportdir') .. '\\common\\cikklist_nev_' .. fs ..'.txt'
	file = io.open (filename , "r")
	count = 0
	cikkfound = "";
	hossz = findstr:len()
	if file~=nil then
	  ui:showWaitbox('cikk keresés:"' .. findstr .. '"...')
	  while true do
		line = file:read("*l")
		if line == nil then break end
		t = luafunc.strtotable(line)
		for i, row in ipairs(t) do
		   source = row['NEV']:gsub('/',''):gsub(" ",""):upper():gsub('R',''):gsub('X',''):gsub('ET',''):gsub('%.','')
		   fc = string.sub(source,1,hossz)
		   fs = string.sub(findstr,1,hossz)
		   if (fc>fs) then 
			 break
		   else 
			 if source:find(findstr)~=nil then
			   count = count + 1
			   cikkfound = cikkfound .. line .. '\n' 
			 end
		   end
		end
		if (count==50) then break end
	  end
	  file:close()
	  luafunc.refreshtable_fromstring('pcikkval_table',cikkfound) 
	  ui:hideWaitbox()  
	else
	  ui:showMessage('Cikklist_nev*.txt nem található. Futtassa a törzsadat frissítést!')  
	end
end
