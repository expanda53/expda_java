require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
cikod = params[3]:gsub(':','')
nev = params[4]:gsub(':',''):gsub('%%20',' ')
kezelo = params[5]:gsub(':','')

subdir = 'tasklist'
mibiz = 'rkbevet_' .. kezelo
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
    sor = '[[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[DRB2=' .. row['DRB2'] .. ']][[VKOD=' ..row['VKOD'].. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']][[MOZGAS=' ..row['MOZGAS']..']]\n'
    file:write (sor) 
end    
file:close()

filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\' .. mibiz.. '_update.txt'
file = io.open (filename , "a")
sor = 'RKBEVET_CIKKMENT_UPD ' .. cikk .. ' ' .. cikod .. ' ' .. kezelo ..'\n'
file:write (sor) 
file:close()
  
ui:executeCommand('valueto','lstatus','Cikk mentés kész. Következő cikk lövés')
ui:executeCommand('valueto','lcikk',nev)
ui:executeCommand('hideobj','pcikkval','')
ui:executeCommand('showobj','panel1','')




   