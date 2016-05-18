require 'model/Luafunc'
local params = {...}
ui = params[1]
ui:executeCommand("showobj","panel1;pfooter","")
local kezelo = ui:findObject('lkezelo'):getText():gsub(':','')

mibiz='rkbevet_' .. kezelo
ui:executeCommand('valueto','ltitle','Raktárközi bevét hkód nélkül: ' .. mibiz)
ui:executeCommand('showobj','lcikklabel','')
ui:executeCommand('valueto','lcikkc','')
ui:executeCommand('valueto','lstatus','cikk lövés')
ui:executeCommand('setbgcolor','lcikkc','orange')
ui:executeCommand('aktbcodeobj','bcode1','')
ui:executeCommand('scanneron','','')
ui:executeCommand('setfocus','lcikkc','')


ui:executeCommand('STARTLUA','rkbevet/utonklt_refresh.lua','')