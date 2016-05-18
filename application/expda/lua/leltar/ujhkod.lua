local params = {...}
ui = params[1]
ui:executeCommand("hideobj","LCIKKLABEL;LCIKKC;BBEVESZ;BUJHKOD;LCIKKLABEL;LCIKK","")
ui:executeCommand("setbgcolor","lhklabel","green")
ui:executeCommand("valueto","lhkoc","")
ui:executeCommand("setfocus","lhkoc","")
ui:executeCommand("aktbcodeobj","bcode1","")
ui:executeCommand("scanneron","","")
ui:executeCommand("valueto","lstatus","Helykód lövés")
