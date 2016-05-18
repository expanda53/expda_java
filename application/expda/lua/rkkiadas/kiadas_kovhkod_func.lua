


function kovhkod(ui,mibiz, sorsz, hkod)
  require 'model/Luafunc'
  --beolvasas tablaba
  filename = luafunc.ini('exportdir') .. '\\tasklist\\'..mibiz..'.txt'
  file = io.open (filename , "r")
  source = file:read("*a")
  file:close()
  local update_mehet = false
  local t = luafunc.strtotable(source)
  volt = false
  kovsorsz= 0
  --aktualis sor kikeresese sorsz alapjan
  for i, row in ipairs(t) do
    rowsorsz = tonumber(row['SORSZ'])
    sorsz = tonumber(sorsz)
    local drb = row['DRB'];
    if (drb=='') then drb=0 end
    drb = tonumber(drb)
    local drb2 = row['DRB2'];
    if (drb2=='') then drb2=0 end
    drb2 = tonumber(drb2)
    if (rowsorsz>sorsz) and (hkod~=row['HKOD']) and (drb>drb2) and not(volt)  then
      volt = true
      kovsorsz = row['SORSZ']
      kovhkod = row['HKOD']
	  kovhkodleir = row['HKODLEIR']
    end
  end
  
  if volt then
      ui:executeCommand('valueto','lcikkc','')
      ui:executeCommand('valueto','lhkoc','')
	  ui:executeCommand('valueto','lhkodleir',kovhkodleir)
      ui:executeCommand('setbgcolor','lhkoc','orange')
      ui:executeCommand('hideobj','LCIKK;LDRBOSSZ;EDRBKINT;BKOVCIKK;LCIKKC','')
      ui:executeCommand('valueto','lhkod',kovhkod)
      ui:executeCommand('valueto','lsorsz',kovsorsz)
      ui:executeCommand('aktbcodeobj','bcode1','')
      ui:executeCommand('setfocus','lhkoc','')
      ui:executeCommand('scanneron','','')
  else
      ui:executeCommand('hideobj','BKOVHKOD;BKOVCIKK','')
      ui:executeCommand('uzenet','Nincs több helykód!','')
  end
end

