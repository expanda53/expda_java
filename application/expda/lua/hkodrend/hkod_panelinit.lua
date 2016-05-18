local params = {...}
ui = params[1]
ui:executeCommand("showobj","panel1;pfooter;bkiad;bbevesz","")
ui:executeCommand("valueto","lstatus","Bevét vagy kiadás")
ui:executeCommand('setbgcolor','lcikkc','orange')
ui:executeCommand('aktbcodeobj','bcode1','')
ui:executeCommand('scanneron','','')
ui:executeCommand('setfocus','lcikkc','')

