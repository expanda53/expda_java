require 'model/Luafunc'
local params = {...}
ui = params[1]
cikod = params[2]:gsub(':','')
cikk = params[3]:gsub(':','')
hkod = params[4]:gsub(':',''):gsub('%%20',' ')
elojel = params[5]:gsub(':','')
kezelo = params[6]:gsub(':','')
hivszam ='.'
cegazon = 0
mibiz = "hkod_elrak_" .. kezelo;
subdir = 'tasklist'
klt = 0
-- ter01 keszletfilebol megkeressuk az adott cikk keszletet
filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\bevet_hkodklt.txt'
kltfile = io.open (filename , "r")
if (kltfile~=nil) then
  source = kltfile:read("*a")
  kltfile:close()
  terklt = luafunc.strtotable(source)
  for i, row in ipairs(terklt) do 
    if row['CIKK']==cikod then 
	  klt = row['DRB'] 
	end
  end
end	

--beolvasas tablaba, ha letezo bizonylatot folytat
filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\'..mibiz..'.txt'
file = io.open (filename , "r")
if (file~=nil) then
  source = file:read("*a")
  file:close()
  t = luafunc.strtotable(source)
else
  t={}
end	

local ujsor = true
  

  count = 0
  drb=0
  for i, row in ipairs(t) do 
    count = count + 1 
	-- megnezzuk, hogy van-e mar ilyen sor, ha van, kiolvassuk a darabot
	if row['LEIR']==cikk and row['ELOJEL']==elojel and row['HKOD']==hkod then 
	  drb = row['DRB'] 
	  if (elojel=="-") then 
	    drb=drb - 1 
	  else
        drb = drb + 1 
	  end
	  t[i]['DRB'] = drb
	  t[i]['CIKK'] = cikod
	  ujsor=false
	end
	
  end
  
  local mehet = true
  if (elojel=="+") then 
	    if ((drb > klt or klt==0) and kltfile~=nil) then
		  ui:showMessage('Nincs ennyi elpakolható készlet! ('..klt..' db)')
		  mehet = false
		end
  end  
  if (mehet == true) then 
	  sorsz = count + 1
	  if ujsor then
		t[sorsz]={}
		if (elojel=="-") then drb=drb - 1 else drb = drb + 1 end
		t[sorsz]['DRB'] = drb
		t[sorsz]['CIKK'] = cikod
		t[sorsz]['CIKKNEV'] = ui:findObject('LCIKK'):getText()
		t[sorsz]['SORSZ'] = sorsz
		t[sorsz]['HKOD'] = hkod
		t[sorsz]['LEIR'] = cikk
		t[sorsz]['ELOJEL'] = elojel
	  end

	  
		filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '.txt'
		file = io.open (filename , "w")
		for i, row in ipairs(t) do
		  sor = '[[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']][[ELOJEL=' ..row['ELOJEL']..']]\n'
		  file:write (sor) 
		end    
		file:close()

		
		filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
		file = io.open (filename , "a")
		
		if (elojel=='+') then
		  elojel = 'P'
		else
		  elojel = 'M'  
		end 
		sor = 'HKOD_MENTES2 ' ..cikod .. ' ' ..cikk .. ' ' .. hkod:gsub(' ', '%%20') .. ' ' .. elojel .. ' ' .. kezelo .. ' ' .. drb .. ' ' ..  hivszam .. ' ' ..cegazon .. ' 1\n'
		file:write (sor) 

		file:close()

	ui:executeCommand('setbgcolor','lcikklabel','green')
	ui:executeCommand('valueto','lstatus','Mentés rendben. Cikk lövés')
  else -- mehet=false
	ui:executeCommand('setbgcolor','lcikklabel','red')
	ui:executeCommand('valueto','lstatus','Készlethiba! Cikk lövés')
	
  end
  ui:executeCommand('valueto','lcikkc','')
  ui:executeCommand('valueto','ldrb','db: ' .. drb)
  ui:executeCommand('setfocus','lcikkc','')
  ui:executeCommand('scanneron','','')  
  
