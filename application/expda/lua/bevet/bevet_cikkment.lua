require 'model/Luafunc'
local params = {...}
ui = params[1]
mibiz = params[2]:gsub('Bevét:',''):gsub(':','')
cikk = params[3]:gsub(':','')
cikod = params[4]:gsub(':','')
nev = params[5]:gsub(':',''):gsub('%%20',' ')
cegazon = params[6]:gsub(':','')
kezelo = params[7]:gsub(':','')
okbiz = ui:findObject('lhivat'):getText():gsub('Hivatkozás:','')
if (okbiz == '') then
  okbiz ='.'
end  
subdir = 'tasklist'
--kivalasztott cikk felirasa
filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\'..mibiz..'.txt'
file = io.open (filename , "r")
source = file:read("*a")
file:close()
t = luafunc.strtotable(source)


local cikk_found = false
-- sor kikeresese
ui:showWaitbox('Cikk felírás...')
if (cikk_found==false and t~=nil) then
  -- elobb megnezzuk a bizonylaton, az a gyorsabb
    for i, r in ipairs(t) do
      if r['LEIR'] == cikk and r['CIKK']=="NINCSEAN" then 
        -- ui:showMessage(r['CIKKNEV'] .. ' = ' .. r['CIKK'] .. ' = ' .. r['SORSZ'])
        t[i]['CIKK'] = cikod  
        t[i]['CIKKNEV'] = nev
        cikk_found = true
        break
      end
      if cikk_found then break end
    end  
end
ui:hideWaitbox()

filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '.txt'
file = io.open (filename , "w")
for i, row in ipairs(t) do
    sor = '[[CEGNEV=' .. row['CEGNEV'] .. ']][[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[DRB2=' .. row['DRB2'] .. ']][[VKOD=' ..row['VKOD'].. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']][[MOZGAS=' ..row['MOZGAS']..']][[OKBIZ=' ..row['OKBIZ']..']]\n'
    file:write (sor) 
end    
file:close()

filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
file = io.open (filename , "a")
sor = 'BEVET_CIKKMENT_UPD ' .. cikk .. ' ' .. cikod .. ' ' .. okbiz .. ' ' ..cegazon .. ' ' .. kezelo ..'\n'
file:write (sor) 
file:close()
  
ui:executeCommand('valueto','lstatus','Cikk mentés kész. Következő cikk lövés')
ui:executeCommand('valueto','lcikk',nev)
ui:executeCommand('hideobj','pcikkval','')
ui:executeCommand('showobj','panel1','')




   