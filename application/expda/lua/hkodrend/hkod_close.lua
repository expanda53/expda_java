require 'model/Luafunc'
local params = {...}
ui = params[1]
kezelo = params[2]:gsub(':','')
hivszam ='.'
cegazon = 0

subdir = 'tasklist'
mehet = ui:showDialog("Biztos zárható?")
if mehet then

	mibiz = 'hkod_' .. kezelo
	filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz .. '.txt'
	file = io.open (filename , "r")
	lezaras_mehet = true
    minusz_volt = false
	if file~=nil then
		source = file:read("*a")
		file:close()
		t =luafunc.strtotable(source)
		table.sort(t, function(a,b) return a['LEIR']<b['LEIR'] end)
		aktrow = {}
		source = ""
		elso = true
		for i, row in ipairs(t) do
			if elso then 
				aktrow['LEIR'] = row['LEIR']
				aktrow['DRB']=0
				elso = false
			end
			if aktrow['LEIR'] ~= row['LEIR'] then
			    if aktrow['DRB'] ~= 0 then
				  lezaras_mehet=false
				end
			    if aktrow['DRB'] < 0 then
				  minusz_volt=true
				end
				aktrow['LEIR'] = row['LEIR']
				aktrow['DRB']=0
			end
			aktrow['DRB']=aktrow['DRB'] + row['DRB']
			--if (lezaras_mehet==false) then break end
		end
		if aktrow['DRB'] ~= 0 then lezaras_mehet = false end
        --ha nem volt minuszos sor, akkor futtathato a lezaras. ilyenkor csak bevet van, kiadas generalodik hozza.
        if (minusz_volt==false) then 
          lezaras_mehet=true;
        end
		if lezaras_mehet==false then
			ui:showMessage("Hibás tétel a listában. Nem zárható, amíg nincs javítva!")
		else
            --content file átnevezése, hogy lezaras utan ujat kezdjen a rendszer
            local newfilename = filename
            local nr = 1;
            local nf=filename
                newfilename = nf .. nr
            
            while true do
                local res = os.rename(filename,newfilename)
                if (res==nil) then
                    nr = nr + 1
                    newfilename = nf .. nr
                else
                    break
                end
            end

			sor = 'HKOD_CLOSE_UPD ' .. kezelo  .. ' ' ..  hivszam .. ' ' ..cegazon .. '\n'
			filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
			file = io.open (filename , "a")
			file:write (sor)
			file:close()
			ui:executeCommand('close','','')
            
            --update file átnevezése, hogy lezaras utan ujat kezdjen a rendszer
            local newfilename = filename
            local nr = 1;
            local nf=filename
            newfilename = nf .. nr
            while true do
                local res = os.rename(filename,newfilename)
                if (res==nil) then
                    nr = nr + 1
                    newfilename = nf .. nr
                else
                    break
                end
            end
          
		end
	  
	else
		lezaras_mehet=false
		ui:showMessage(mibiz .. ".txt adatfile nem elérhető." )
	end
	


  
end


