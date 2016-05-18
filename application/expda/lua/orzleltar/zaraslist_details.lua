local params = {...}
require 'model/Luafunc'
ui = params[1]
aktcikk = params[2]:gsub(':','')
kezelo = params[3]:gsub(':','')
subdir = 'tasklist'
function readTask(source)
  source = source:gsub('%[%[%[','%[%[')
  source = source:gsub('%]%]%]','%]%]')
  t =luafunc.strtotable(source)
  for i, row in ipairs(t) do
	if row['CIKK']~=aktcikk then 
	  
	end
  end
  
  table.sort(t, function(a,b) return a['HKOD']<b['HKOD'] end)
  aktrow = {}
  source = ""
  elso = true
  for i, row in ipairs(t) do
    if row['LEIR']==aktcikk then 
		if elso then 
		  aktrow['HKOD'] = row['HKOD']
		  aktrow['DRB']=0
		  elso = false
		end
		if aktrow['HKOD'] ~= row['HKOD'] then
			source = source .. '[[HKOD=' ..aktrow['HKOD'] .. ']][[DRB=' .. aktrow['DRB'] .. ']]\n'
			aktrow['HKOD'] = row['HKOD']
			aktrow['DRB']=0
		end
	aktrow['DRB']=aktrow['DRB'] + row['DRB']
	end
  end
  if (aktrow['HKOD']~=nil) then
    source = source .. '[[HKOD=' ..aktrow['HKOD'] .. ']][[DRB=' .. aktrow['DRB'] .. ']]\n'
  end
  luafunc.refreshtable_fromstring('seltabledetails',source)
end

-- bizonylat
mibiz = 'orzleltar_' .. kezelo
filename = luafunc.ini('exportdir') ..'\\' .. subdir .. '\\' .. mibiz .. '.txt'
file = io.open (filename , "r")
if file~=nil then
  t = file:read("*a")
  file:close()
  readTask(t)
else
  ui:showMessage(mibiz .. ".txt adatfile nem elérhető." )
end
