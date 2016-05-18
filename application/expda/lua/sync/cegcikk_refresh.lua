require 'model/Luafunc'
local luadir = luafunc.ini('luadir'):gsub('%/','%.'):gsub("\\",".")
exClass = require (luadir .. '.common.func')
subdir = "common"
exportdir = luafunc.ini('exportdir') .. '\\' .. subdir ..'\\'

function writeOneTask(mibiz)
  --print (mibiz)
  local list = luafunc.query('TASK_REFRESH ' ..mibiz.. ' [lkezelo]',false)
  filename = exportdir ..mibiz.. '.txt'
  file = io.open (filename , "w")
  for i, v in ipairs(list) do
    file:write (v..'\n')
  end
  file:close()   
end 

function writeTask(source)
  for i, v in ipairs(source) do
    local mibiz= v
    mibiz = mibiz:gsub('MIBIZ=','')
    mibiz = mibiz:gsub('%[','')
    mibiz = mibiz:gsub('%]','')
    mibiz = mibiz:gsub(' ','')
    local s = luafunc.findFiles(mibiz .. '_update',subdir)
    if (s==nil or s=="") then writeOneTask(mibiz) end 
  end
end



function sendFiles(ui,files)
  t = exClass.split(files,",")
  if (t~=nil) then 
    for i, v in ipairs(t) do
      aktfile = v 
      filename = exportdir..aktfile
      file = io.open (filename , "r")
      local rename_mehet = true
      if (file~=nil) then
        while true do
          local line = file:read("*l")
          if line == nil then break end
          ui:executeCommand('tcpuzenet',line)
          local lupdate = ui:findObject('lupdate')
          if (lupdate~=nil) then
            local updatestat = lupdate:getText()
            if updatestat ~= "OK" then
              ui:showMessage(updatestat) 
              rename_mehet = false
              break 
            end 
          end
        end    
  
        file:close()
        if (rename_mehet) then 
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


local params = {...}
local ui = params[1]
local lstatus = ui:findObject('lluastat')


exClass.luastat(ui,lstatus,"...Kezelő frissités...","red")
-- kezelők lekerdezese
local list = luafunc.query('login_kezelolist',false)
filename = exportdir .. 'login.txt'
file = io.open (filename , "w")
if (list~=nil) then
  for i, v in ipairs(list) do
    file:write (v .. '\n')
  end
end
file:close()


exClass.luastat(ui,lstatus,"...Cég frissités...","red")
-- bevet cegek lekerdezese
local list = luafunc.query('CEGVAL_LIST',false)
filename = exportdir .. 'bevet_ceglist.txt'
file = io.open (filename , "w")
if (list~=nil) then
  for i, v in ipairs(list) do
    file:write (v .. '\n')
  end
end
file:close()

exClass.luastat(ui,lstatus,"...Cikk frissités/törlés...","red")

local files = luafunc.findFiles('cikklist',subdir)
  local t = exClass.split(files,",")
  if (t~=nil) then 
    for i, aktfile in ipairs(t) do
		ui:executeCommand("valueto","lluastat",aktfile)
		filename = exportdir .. '\\'..aktfile
		os.remove(filename)
	  end
  end


i=0
while (i<6) do
	ui:executeCommand("valueto","lluastat","...Cikk frissités EAN/" ..i.. "...")
	--exClass.luastat(ui,lstatus,"...Cikk frissités EAN/" ..i.. "...","red")
	local list = luafunc.query_assoc('CIKKVAL_LIST * '..i..' VKOD',false)
	filename=""
    firstchar = ""
	file=nil
	if (list~=nil) then
	  for j, v in ipairs(list) do
		f = v['VKOD']
		if (f==nil or f=="") then f=" " end
		fc = string.sub(f,1,9)
		if (firstchar ~= fc) then
		  firstchar=fc;
		  if (filename~="") then file:close() end
		  filename = exportdir .. 'cikklist_' .. firstchar ..'.txt'
		  file = io.open (filename , "a")
		end
		file:write ('[[NEV=' ..v['NEV'] .. ']][[KOD=' .. v['KOD'] ..']][[VKOD=' .. v['VKOD'] ..']][[CSOPNEV=' .. v['CSOPNEV'] ..']]\n')
	  end
	end
	if (file~=nil) then file:close() end
	i=i+1
end


i=0
while (i<6) do
	--exClass.luastat(ui,lstatus,"...Cikk frissités NEV/" ..i.. "...","red")
	ui:executeCommand("valueto","lluastat","...Cikk frissités NEV/" ..i.. "...")	
	local list = luafunc.query_assoc('CIKKVAL_LIST * '..i..' NEV',false)
	filename=""
    firstchar = ""
	file=nil
	if (list~=nil) then
	  for j, v in ipairs(list) do
		f = v['NEV']:gsub('/',''):gsub(" ",""):upper():gsub('R',''):gsub('X',''):gsub('ET',''):gsub("%.",'')
		
		if (f==nil or f=="") then f=" " end
		fc = string.sub(f,1,3)
		if (firstchar ~= fc) then
		  firstchar=fc;
		  if (filename~="" and file~=nil) then file:close() end
		  filename = exportdir .. 'cikklist_nev_' .. firstchar ..'.txt'
		  file = io.open (filename , "a")
		end
		if file~=nil then
		  file:write ('[[NEV=' ..v['NEV'] .. ']][[KOD=' .. v['KOD'] ..']][[VKOD=' .. v['VKOD'] ..']][[CSOPNEV=' .. v['CSOPNEV'] ..']]\n')
		end
	  end
	end
	if (file~=nil) then file:close() end
	i=i+1
end


exClass.luastat(ui,lstatus,"...Helykód frissités...","red")
local list = luafunc.query('HKOD_LIST [lkezelo]',false)
filename = exportdir .. 'hkodlist.txt'
file = io.open (filename , "w")
if (list~=nil) then
  for i, v in ipairs(list) do
    file:write (v .. '\n')
  end
end
file:close()

exClass.luastat(ui,lstatus,"...Örzés frissités/törlés...","red")

local files = luafunc.findFiles('orzottlist',subdir)
  local t = exClass.split(files,",")
  if (t~=nil) then 
    for i, aktfile in ipairs(t) do
		ui:executeCommand("valueto","lluastat",aktfile)
		filename = exportdir .. aktfile
		os.remove(filename)
	  end
  end


i=0
while (i<2) do
    ui:executeCommand("valueto","lluastat","...Örzés frissités/" ..i.. "...")	
	local list = luafunc.query_assoc('ORZOTT_LIST '..i..' [lkezelo]',false)
	filename=""
    firstchar = ""
	file=nil
	if (list~=nil) then
	  for j, v in ipairs(list) do
		f = v['RENDSZAM']
		if (f==nil or f=="") then f=" " end
		fc = string.sub(f,1,1)
		if (firstchar ~= fc) then
		  firstchar=fc;
		  if (filename~="") then file:close() end
		  filename = exportdir .. 'orzottlist_' .. firstchar ..'.txt'
		  file = io.open (filename , "a")
		end
		file:write ('[[RENDSZAM=' ..v['RENDSZAM'] .. ']][[CEGNEV=' ..v['CEGNEV'] .. ']][[CIKK_E=' ..v['CIKK_E'] .. ']][[CIKK_H=' ..v['CIKK_H'] .. ']][[CIKK_P=' ..v['CIKK_P'] .. ']][[DRB_E=' ..v['DRB_E'] .. ']][[DRB_H=' ..v['DRB_H'] .. ']][[DRB_P=' ..v['DRB_P'] .. ']]\n')
	  end
	end
	if (file~=nil) then file:close() end
	i=i+1
end



exClass.luastat(ui,lstatus,"Frissites kesz","black")