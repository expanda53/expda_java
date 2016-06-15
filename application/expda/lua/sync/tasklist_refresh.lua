require 'model/Luafunc'
local luadir = luafunc.ini('luadir'):gsub('%/','%.'):gsub("\\",".")
exClass = require (luadir .. '.common.func')
 params = {...}
 ui = params[1]
 lstatus = ui:findObject('lluastat')
 taskdir = 'tasklist';

function writeOneTask(mibiz)
  --print (mibiz)
  local list = luafunc.query('TASK_REFRESH ' ..mibiz.. ' [lkezelo]',false)
  filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\'..mibiz.. '.txt'
  local file = io.open (filename , "w")
  for i, v in ipairs(list) do
    file:write (v..'\n')
  end
  file:close()  
end 

function writeOneTaskHKOD(fnev, mibiz)
  --print (mibiz)
  local list = luafunc.query('TASK_REFRESH ' ..mibiz.. ' [lkezelo]',false)
  filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\'..fnev.. '.txt'
  local file = io.open (filename , "a")
  for i, v in ipairs(list) do
    file:write (v..'\n')
  end
  file:close()  
end 

function writeTask_kiadas(source)
  if (source~=nil) then
	  for i, v in ipairs(source) do
		local mibiz= v['MIBIZ']
		mibiz = mibiz:gsub('MIBIZ=','')
		mibiz = mibiz:gsub('%[','')
		mibiz = mibiz:gsub('%]','')
		mibiz = mibiz:gsub(' ','')
		local s = luafunc.findFiles(mibiz .. '_update.txt',taskdir)
		if (s==nil or s=="") then writeOneTask(mibiz) end 
	  end
  end
end

function writeTask_bevet(source)
  if (source~=nil) then
	  for i, v in ipairs(source) do
		local mibiz= v['MIBIZ']
		mibiz = mibiz:gsub('MIBIZ=','')
		mibiz = mibiz:gsub('%[','')
		mibiz = mibiz:gsub('%]','')
		mibiz = mibiz:gsub(' ','')
		local s = luafunc.findFiles(mibiz .. '_update.txt',taskdir)
		if (s==nil or s=="") then writeOneTask(mibiz) end 
	  end
	end
end

function writeTask_bevethkod(source)
  if (source~=nil) then
	  for i, v in ipairs(source) do
		local mibiz= v['MIBIZ']
		mibiz = mibiz:gsub('MIBIZ=','')
		mibiz = mibiz:gsub('%[','')
		mibiz = mibiz:gsub('%]','')
		mibiz = mibiz:gsub(' ','')
		local s = luafunc.findFiles(mibiz .. '_update.txt',taskdir)
		if (s==nil or s=="") then writeOneTask(mibiz) end 
	  end
	end
end

function writeTask_hkodrend(source,kezelo,tip)
  if (source~=nil) then
	  fnev = "hkodrend.tmp"
	  for i, v in ipairs(source) do
		local mibiz= v['MIBIZ']
		if (mibiz~="") then
			mibiz = mibiz:gsub('MIBIZ=','')
			mibiz = mibiz:gsub('%[','')
			mibiz = mibiz:gsub('%]','')
			mibiz = mibiz:gsub(' ','')
			writeOneTaskHKOD(fnev,mibiz) 
		end
	  end
	  local filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\' ..fnev.. '.txt'
	  local newfilename = "";
	  local s2 = nil
	  if (tip==0) then 
		newfilename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\hkod_' ..kezelo.. '.txt'  
		s2 = luafunc.findFiles('hkod_' ..kezelo.. '.txt',taskdir)	  
	  elseif (tip==1) then 
		newfilename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\hkod_elrak_' ..kezelo.. '.txt'
		s2 = luafunc.findFiles('hkod_elrak_' ..kezelo.. '.txt',taskdir)
	  elseif (tip==2) then 
		newfilename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\rkbevet_' ..kezelo.. '.txt'
		s2 = luafunc.findFiles('rkbevet_' ..kezelo.. '.txt',taskdir)
	  elseif (tip==3) then 
		newfilename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\rkbevethkod_' ..kezelo.. '.txt'
		s2 = luafunc.findFiles('rkbevethkod_' ..kezelo.. '.txt',taskdir)
	  elseif (tip==4) then 
		newfilename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\rkkiaduj_' ..kezelo.. '.txt'
		s2 = luafunc.findFiles('rkkiaduj_' ..kezelo.. '.txt',taskdir)
	  end
	  
      --ha letezik mar ilyen file, toroljuk
	  if (s2~=nil and s2~="") then 
		local res = os.remove(newfilename)
	  end
      --modositjuk a temp nevet a veglegesre
	  local res = os.rename(filename,newfilename)
  end
		
end

function writeTask_leltar(source,kezelo)
  if (source~=nil) then
	  for i, v in ipairs(source) do
		local mibiz= v['MIBIZ']
		if (mibiz~="") then
			mibiz = mibiz:gsub('MIBIZ=','')
			mibiz = mibiz:gsub('%[','')
			mibiz = mibiz:gsub('%]','')
			mibiz = mibiz:gsub(' ','')
			local s = luafunc.findFiles(mibiz .. '_update.txt',taskdir)
			if (s==nil or s=="") then 
			  writeOneTask(mibiz) 
			  local filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\'..mibiz.. '.txt'
			  local newfilename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\leltar_' ..kezelo.. '.txt'
			  local s2 = luafunc.findFiles('leltar_' ..kezelo.. '.txt',taskdir)
			  
			  if (s2~=nil and s2~="") then 
				local res = os.remove(newfilename)
			  end
			  local res = os.rename(filename,newfilename)
			end 
		end
	  end
  end
end

function writeTask_orzleltar(source,kezelo)
  if (source~=nil) then
	  for i, v in ipairs(source) do
		local mibiz= v['MIBIZ']
		if (mibiz~="") then
			mibiz = mibiz:gsub('MIBIZ=','')
			mibiz = mibiz:gsub('%[','')
			mibiz = mibiz:gsub('%]','')
			mibiz = mibiz:gsub(' ','')
			local s = luafunc.findFiles(mibiz .. '_update.txt',taskdir)
			if (s==nil or s=="") then 
			  writeOneTask(mibiz) 
			  local filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\'..mibiz.. '.txt'
			  local newfilename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\orzleltar_' ..kezelo.. '.txt'
			  local s2 = luafunc.findFiles('orzleltar_' ..kezelo.. '.txt',taskdir)
			  
			  if (s2~=nil and s2~="") then 
				local res = os.remove(newfilename)
			  end
			  local res = os.rename(filename,newfilename)
			end 
		end
	  end
  end
end

function sendFiles(ui,files)
  local t = exClass.split(files,",")
  if (t~=nil) then 
    for i, aktfile in ipairs(t) do
	  ui:executeCommand("valueto","lluastat",aktfile)
      local filename = luafunc.ini('exportdir') .. '\\'.. taskdir..'\\'..aktfile
      local file = io.open (filename , "r")
      local rename_mehet = false
	  count = 0
	  lineout = 0
      if (file~=nil) then
	     rows = {}
		 i = 1
	     while true do
		   aktline = file:read("*l")
		   if aktline == nil then break end
		   rows[i]=aktline
		   i=i+1
		 end
		 count = i-1
		 i = 1
		 file:close()
	     rename_mehet = true		 
         for i,line in ipairs(rows) do
          if line == nil then break end
          ui:executeCommand('tcpuzenet',line)
          local lupdate = ui:findObject('lupdate')
          if (lupdate~=nil) then
            local updatestat = lupdate:getText()
            if updatestat~="OK" then
              ui:showMessage(updatestat) 
            end
            local spl = exClass.split(updatestat,"#")
            -- ; nem jo, vsz a php miatt
            updatestat=spl[1]
            n = #(spl)
            local msg= ""
            if n>1 then
                  msg=spl[2]
                  ui:showMessage(msg) 
            end
            if updatestat ~= "OK" then
              ui:showMessage(updatestat) 
              rename_mehet = false
              break 
			else 
			  lineout = lineout + 1
            end 
          end
        end    
        --az _update.txt vegu file-t atnevezi _update.old -nak
        if (rename_mehet and count == lineout and count>0) then 
          local newfilename = filename:gsub('.txt','.old')
          local nf=newfilename
          local nr = 1;
          while true do
            local res = os.rename(filename,newfilename)
            if (res==nil) then
              newfilename = nf .. nr
              nr = nr + 1
            else
              break
            end
          end
        end
      end    
    end
  end
  
end


function delFiles(files)
  local t = exClass.split(files,",")
  if (t~=nil) then 
    for i, aktfile in ipairs(t) do
        
	  if (aktfile:find("cikklist")==nil and aktfile~="bevet_ceglist.txt" and aktfile~="hkodlist.txt" and aktfile~="login.txt" and aktfile:find("orzottlist")==nil) then 
        --ui:showMessage(aktfile) 
        ui:executeCommand("valueto","lluastat",aktfile)
		filename = luafunc.ini('exportdir') .. '\\'.. taskdir..'\\'..aktfile
        --csak akkor torolhetok a fileok (a fentiek kivetelevel), ha nincs a mappaban _update kiegeszitesu modositasokat tartalmazo file. Itt torlodnek a sendFiles altal atnevezett update.old fileok is
		local s = luafunc.findFiles('_update.txt',taskdir)
		if (s==nil or s=="") then os.remove(filename) end
	  end
	end
  end
end

if (luafunc.getWifiStrength()>0) then
	exClass.luastat(ui,lstatus,"...Visszaküldés...","red")
	-- modositasok visszakuldese
	local s = luafunc.findFiles('_update.txt',taskdir)
	if (s~=nil and s~="") then sendFiles (ui,s) end
	--regi fileok torlese
	exClass.luastat(ui,lstatus,"...Törlés...","red") 
	local s = luafunc.findFilesByDate(0,taskdir)
	if (s~=nil and s~="") then delFiles(s) end

	-- kiadas feladatok lekerdezese
	-- nem kell, feladatvalasztoba belepesnel frissul.
	--exClass.luastat(ui,lstatus,"...Kiadási feladatok...","red")
	--local list = luafunc.query_assoc('KIADAS_MIBIZLIST [lkezelo]',false)
	--filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\kiadas_mibizlist.txt'
	--file = io.open (filename , "w")
	--if (list~=nil) then
	--  for i, v in ipairs(list) do
	--    file:write ('[[MIBIZ=' .. v['MIBIZ'] .. ']][[CEGNEV=' .. v['CEGNEV'] .. ']][[FIZMOD=' .. v['FIZMOD'] .. ']]\n')
	--  end
	--end
	--file:close()
	--writeTask_kiadas(list)

	-- bevet feladatok lekerdezese
	exClass.luastat(ui,lstatus,"...Bevét feladatok...","red")
	local list = luafunc.query_assoc('BEVET_MIBIZLIST [lkezelo]',false)
	filename = luafunc.ini('exportdir') .. '\\'.. taskdir..'\\bevet_mibizlist.txt'
	file = io.open (filename , "w")
	if (list~=nil) then
	  for i, v in ipairs(list) do
		file:write ('[[MIBIZ=' .. v['MIBIZ'] .. ']][[CEGAZON=' .. v['CEGAZON'] .. ']][[OKBIZ=' .. v['OKBIZ'] .. ']]\n')
	  end
	end
	file:close()
	writeTask_bevet(list)

	-- helykódos bevet feladatok lekerdezese
	exClass.luastat(ui,lstatus,"...Helykódos bevét feladatok...","red")
	local list = luafunc.query_assoc('BEVETHKOD_MIBIZLIST [lkezelo]',false)
	filename = luafunc.ini('exportdir') .. '\\'.. taskdir..'\\hkodbevet_mibizlist.txt'
	file = io.open (filename , "w")
	if (list~=nil) then
	  for i, v in ipairs(list) do
		file:write ('[[MIBIZ=' .. v['MIBIZ'] .. ']][[CEGAZON=' .. v['CEGAZON'] .. ']][[OKBIZ=' .. v['OKBIZ'] .. ']]\n')
	  end
	end
	file:close()
	writeTask_bevethkod(list)

	
	
	-- nyitott helykódrendezés feladat lekerdezese
	exClass.luastat(ui,lstatus,"...Hkód rendezés...","red")
	local list = luafunc.query_assoc('HKODREND_MIBIZLIST [lkezelo]',false)
	writeTask_hkodrend(list, ui:findObject('lkezelo'):getText(),0 )

	-- nyitott bevét elpakolás feladat lekerdezese
	exClass.luastat(ui,lstatus,"...Bevét helyrepakolás...","red")
	local list = luafunc.query_assoc('HKODREND_ELPAKOLAS_MIBIZLIST [lkezelo]',false)
	writeTask_hkodrend(list, ui:findObject('lkezelo'):getText(),1)

	-- nyitott raktarkozi bevet feladatok lekerdezese
	exClass.luastat(ui,lstatus,"... rközi bevét...","red")
	local list = luafunc.query_assoc('RKBEVET_MIBIZLIST [lkezelo]',false)
	writeTask_hkodrend(list, ui:findObject('lkezelo'):getText(),2 )	

	-- nyitott raktarkozi hkodos bevet feladatok lekerdezese
	exClass.luastat(ui,lstatus,"... rközi hkodos bevét...","red")
	local list = luafunc.query_assoc('RKBEVETHKOD_MIBIZLIST [lkezelo]',false)
	writeTask_hkodrend(list, ui:findObject('lkezelo'):getText(),3 )	

	-- nyitott raktarkozi kiadas (bizonylatletrehozos) feladatok lekerdezese
	exClass.luastat(ui,lstatus,"... rközi kiadás újbiz...","red")
	local list = luafunc.query_assoc('RKKIADAS_MIBIZLIST [lkezelo] RKVK',false)
	writeTask_hkodrend(list, ui:findObject('lkezelo'):getText(),4 )	

	-- nyitott leltár feladat lekerdezese
	exClass.luastat(ui,lstatus,"...Leltár...","red")
	local list = luafunc.query_assoc('LELTAR_MIBIZLIST [lkezelo]',false)
	writeTask_leltar(list, ui:findObject('lkezelo'):getText())

	-- nyitott örzött leltár feladat lekerdezese
	exClass.luastat(ui,lstatus,"...Örzött leltár...","red")
	local list = luafunc.query_assoc('ORZLELTAR_MIBIZLIST [lkezelo]',false)
	writeTask_orzleltar(list, ui:findObject('lkezelo'):getText())

	exClass.luastat(ui,lstatus,"Frissites kesz","black")
else
  ui:showMessage("Wifi nem elérhető!")
  exClass.luastat(ui,lstatus,"Frissitesi hiba","black")
end