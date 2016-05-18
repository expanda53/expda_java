local params = {...}
ui = params[1]
ui:executeCommand("hideobj","LCIKKLABEL;LCIKKC;BUJHKOD;LCIKKLABEL;LCIKK;LDRB","")
ui:executeCommand("setbgcolor","lhklabel","green")
ui:executeCommand("valueto","lhkoc","")
ui:executeCommand("setfocus","lhkoc","")
ui:executeCommand("aktbcodeobj","bcode1","")
ui:executeCommand("scanneron","","")
elojel = ui:findObject('lelojel'):getText()
if (elojel == "+") then
  ui:executeCommand('setbgcolor','lhkoc','orange')
else
  ui:executeCommand('setbgcolor','lhkoc','yellow')
end
ui:executeCommand("valueto","lstatus","Helykód lövés (" .. elojel .. ")" )