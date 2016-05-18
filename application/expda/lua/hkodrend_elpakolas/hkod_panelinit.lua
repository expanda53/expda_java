require 'model/Luafunc'
local params = {...}
ui = params[1]
ui:executeCommand("showobj","panel1;pfooter","")
ui:executeCommand("valueto","lstatus","Bevét")

ui:executeCommand('setbgcolor','lhkoc','orange')
ui:executeCommand('setbgcolor','lcikkc','orange')

ui:executeCommand('showobj','lhklabel','')
ui:executeCommand("valueto","lhkoc","")
ui:executeCommand("setfocus","lhkoc","")
ui:executeCommand("aktbcodeobj","bcode1","")
ui:executeCommand("scanneron","","")
ui:executeCommand("valueto","lstatus","Helykód lövés")
ui:executeCommand('hideobj','lcikklabel;bujhkod;lcikkc;lcikk;ldrb','')

ui:executeCommand('STARTLUA','hkodrend_elpakolas/hkodklt_refresh.lua','')

