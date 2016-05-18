local params = {...}
require 'model/Luafunc'
ui = params[1]
kezelo = params[2]:gsub(':','')
subdir = 'tasklist'
function readTask(source)
  source = source:gsub('%[%[%[','%[%[')
  source = source:gsub('%]%]%]','%]%]')
  t =luafunc.strtotable(source)
  table.sort(t, function(a,b) return a['LEIR']<b['LEIR'] end)
  aktrow = {}
  elozodrb = 0
  source = ""
  elso = true
  elsoleir = ""
  rcount = 0
  for i, row in ipairs(t) do
    rcount = rcount + 1
    if elso then 
      aktrow['CIKKNEV'] = row['CIKKNEV']
	  aktrow['LEIR'] = row['LEIR']
	  aktrow['CIKK'] = row['CIKK']
	  elsoleir = row['LEIR']
	  aktrow['DRB']=0
	  elso = false
	end
    if aktrow['LEIR'] ~= row['LEIR'] then
	    if aktrow['DRB']~=0 then aktrow['DRB'] = aktrow['DRB'] .. '@@BGCOLOR:RED' end
		source = source .. '[[CIKKNEV=' ..aktrow['CIKKNEV'] .. ']][[DRB=' .. aktrow['DRB'] .. ']][[LEIR=' .. aktrow['LEIR'] .. ']][[CIKK=' .. aktrow['CIKK'] .. ']]\n'
		aktrow['CIKKNEV'] = row['CIKKNEV']
		aktrow['CIKK'] = row['CIKK']
		aktrow['LEIR'] = row['LEIR']
		aktrow['DRB']=0
	end
	aktrow['DRB']=aktrow['DRB'] + row['DRB']
  end

  if aktrow['DRB']~=0 then aktrow['DRB'] = aktrow['DRB'] .. '@@BGCOLOR:RED' end
  source = source .. '[[CIKKNEV=' ..aktrow['CIKKNEV'] .. ']][[DRB=' .. aktrow['DRB'] .. ']][[LEIR=' .. aktrow['LEIR'] .. ']][[CIKK=' .. aktrow['CIKK'] .. ']]\n'
  luafunc.refreshtable_fromstring('seltablesum',source)
  if (rcount>0) then  
    ui:findObject('seltablesum'):setSelection(0) 
	--ui:executeCommand('STARTLUA','hkodrend/hkod_zaraslist_select.lua','')
	ui:executeCommand("valuetohidden","selcikk",elsoleir)
	ui:executeCommand("refresh","seltabledetails","")
  end
end

-- bizonylat
--hivszam = ui:findObject('lhivat'):getText():gsub('Hivatkozás:',''):gsub(' ', '%%20')
--cegazon = ui:findObject('lcegazon'):getText()
--mibiz = "bevethkod_" .. cegazon .."_"..hivszam
mibiz='rkkiaduj_' .. kezelo

filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz .. '.txt'
file = io.open (filename , "r")
if file~=nil then
  t = file:read("*a")
  file:close()
  if (t~=nil and t~="") then readTask(t) end
else
  ui:showMessage(mibiz .. ".txt adatfile nem elérhető." )
end
