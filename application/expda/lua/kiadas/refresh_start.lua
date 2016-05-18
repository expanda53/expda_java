require 'model/Luafunc'
local luadir = luafunc.ini('luadir'):gsub('%/','%.'):gsub("\\",".")
exClass = require (luadir .. '.common.func')
params = {...}
ui = params[1]
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


function writeTask_kiadas(source)
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


function sendFiles(ui,files)
  local t = exClass.split(files,",")
  if (t~=nil) then 
    for i, aktfile in ipairs(t) do
	  --ui:executeCommand("valueto","lluastat",aktfile)
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
         for i,line in ipairs(rows) do
          if line == nil then break end
          ui:executeCommand('tcpuzenet',line)
          local lupdate = ui:findObject('lupdate')
          if (lupdate~=nil) then
            local updatestat = lupdate:getText()
            if updatestat ~= "OK" then
              ui:showMessage(updatestat) 
              rename_mehet = false
              break 
			else 
			  rename_mehet = true
			  lineout = lineout + 1
            end 
          end
        end    
  
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
	  --ui:executeCommand("valueto","lluastat",aktfile)
		filename = luafunc.ini('exportdir') .. '\\'.. taskdir..'\\'..aktfile
		local s = luafunc.findFiles('_update.txt',taskdir)
		if (s==nil or s=="") then os.remove(filename) end
	  end
	end
  end
end


if (luafunc.getWifiStrength()>0) then
	-- kiadas feladatok modositasainak visszakuldese
	filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\kiadas_mibizlist.txt'
	file = io.open (filename , "r")
	local mibizlist_upd = ""
	local mibizlist_all = ""
	if (file~=nil) then
		  aktsorsz = 0
		  source = file:read("*a")
		  file:close()

		  source = source:gsub('%[%[%[','%[%[')
		  source = source:gsub('%]%]%]','%]%]')
		  t = luafunc.strtotable(source)
		  
		  
		  for i, row in ipairs(t) do
			local aktmibiz = row['MIBIZ']
			mibizlist_all = mibizlist_all .. aktmibiz .. '.txt' .. ','
			local aktfile = luafunc.findFiles(aktmibiz .. '_update.txt',taskdir)
			if (aktfile~=nil and aktfile ~= "") then mibizlist_upd = mibizlist_upd .. aktfile .. ',' end
		  end
	end

	if (mibizlist_upd~=nil and mibizlist_upd~="") then sendFiles (ui,mibizlist_upd) end
	--regi fileok torlese
	--exClass.luastat(ui,lstatus,"...Törlés...","red") 
	if (mibizlist_all~=nil and mibizlist_all~="") then delFiles(mibizlist_all) end

	-- kiadas feladatok lekerdezese
	--exClass.luastat(ui,lstatus,"...Kiadási feladatok...","red")
	local list = luafunc.query_assoc('KIADAS_MIBIZLIST [lkezelo]',false)
	filename = luafunc.ini('exportdir') .. '\\' .. taskdir..'\\kiadas_mibizlist.txt'
	file = io.open (filename , "w")
	if (list~=nil) then
	  for i, v in ipairs(list) do
		file:write ('[[MIBIZ=' .. v['MIBIZ'] .. ']][[CEGNEV=' .. v['CEGNEV'] .. ']][[FIZMOD=' .. v['FIZMOD'] .. ']]\n')
	  end
	end
	file:close()
	writeTask_kiadas(list)
else 
  ui:showMessage("Wifi nem elérhető!Feladatok letöltése nem sikerült.")
end



ui:executeCommand("refresh","seltable","")
ui:executeCommand("setfocus","seltable","")
ui:executeCommand("aktbcodeobj","bcodebiz","")
ui:executeCommand("scanneron","","")


