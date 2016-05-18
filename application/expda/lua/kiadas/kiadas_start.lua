require 'model/Luafunc'
local luadir = luafunc.ini('luadir'):gsub('%/','.'):gsub("\\",".")
exClass = require (luadir .. '.common.func')
local taskdir = 'tasklist'

function findHkod()
  local aktsorsz=-1
  local akthkod=""
  local akthkodleir=""
  filename = luafunc.ini('exportdir') .. '\\'.. taskdir .. '\\'..mibiz..'.txt'
  file = io.open (filename , "r")
  if (file~=nil) then
      aktsorsz = 0
	  source = file:read("*a")
	  file:close()

	  source = source:gsub('%[%[%[','%[%[')
	  source = source:gsub('%]%]%]','%]%]')
	  t = luafunc.strtotable(source)
	  
	  
	  for i, row in ipairs(t) do
		drb = row['DRB'];
		if (drb=='') then drb=0 end
		drb = tonumber(drb)
		drb2 = row['DRB2'];
		if (drb2=='') then drb2=0 end
		drb2 = tonumber(drb2)
		if (drb>drb2) and aktsorsz==0  then
		  aktsorsz = tonumber(row['SORSZ'])  
		  akthkod = row['HKOD']  
		  akthkodleir = row['HKODLEIR']  
		end
	end
  end
  res={}
  res["sorsz"]=aktsorsz
  res["hkod"]=akthkod
  res["hkodleir"]=akthkodleir
  return res
end


local params = {...}
ui = params[1]
mibiz = params[2]:gsub(':','')
if (mibiz=="1") then
  ui:showMessage("Válasszon bizonylatot!")
else
  res = findHkod()
  sorsz = res["sorsz"]
  hkod = res["hkod"]
  hkodleir = res["hkodleir"]
  if (sorsz==-1) then
    ui:showMessage("Nem létező bizonylat!")
  else
	  ui:executeCommand("showobj","panel1","")
	  ui:executeCommand("hideobj","pvalasztas;lcikk;ldrbossz;edrbkint;bkovcikk","")
	  ui:executeCommand("valueto","ltitle","Kiadás: " .. mibiz)
	  ui:executeCommand("valueto","lhkod",hkod)
	  ui:executeCommand("valueto","lhkodleir",hkodleir)
	  ui:executeCommand("valueto","lhkoc","")
	  ui:executeCommand("valueto","lsorsz",sorsz)
	  ui:executeCommand("valueto","lstatus","Helykód lövés")
	  ui:executeCommand("setwidth","lstatus","330")
	  ui:executeCommand("aktbcodeobj","bcode1")
	  if sorsz == 0 then
	    ui:showMessage("Nincs kiadható tétel a bizonylaton!")
	  end
	  ui:executeCommand('STARTLUA','kiadas/kiadas_zaras.lua','')
	  ui:setScannerOn()
  end
end

