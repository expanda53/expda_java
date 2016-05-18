require 'model/Luafunc'
local params = {...}
ui = params[1]
ui:executeCommand("showobj","panel1;pfooter","")
local kezelo = ui:findObject('lkezelo'):getText():gsub(':','')

mibiz='rkkiaduj_' .. kezelo
ui:executeCommand('valueto','ltitle','Uj raktarkozi kiadas: ' .. mibiz)

ui:executeCommand('showobj','lhklabel','')
ui:executeCommand("valueto","lhkoc","")
ui:executeCommand("setfocus","lhkoc","")
ui:executeCommand("aktbcodeobj","bcode1","")
ui:executeCommand("scanneron","","")
ui:executeCommand("valueto","lstatus","Helykód lövés")
ui:executeCommand('hideobj','lcikklabel;bujhkod;lcikkc;lcikk;ldrb','')



