require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
cikod = params[3]:gsub(':','')
nev = params[4]:gsub(':',''):gsub('%%20',' ')
kezelo = params[5]:gsub(':','')

ui:executeCommand('valueto','lcikk',nev)
ui:executeCommand('valuetohidden','lcikod',cikod)
ui:executeCommand('hideobj','pcikkval','')
ui:executeCommand('showobj','panel1','')
ui:executeCommand('STARTLUA','rkbevet/bevet_mentes.lua '..cikod..' ' .. cikk .. ' ' .. kezelo,'')




   