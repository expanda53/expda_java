local params = {...}
ui = params[1]
elojel = params[2]
ui:executeCommand("valueto","lelojel",elojel)
ui:executeCommand('showobj','lhklabel','')
ui:executeCommand("valueto","lhkoc","")
ui:executeCommand("setfocus","lhkoc","")
ui:executeCommand("aktbcodeobj","bcode1","")
ui:executeCommand("scanneron","","")
ui:executeCommand("valueto","lstatus","Helykód lövés (" .. elojel .. ")")
ui:executeCommand('hideobj','lcikklabel;bujhkod;lcikkc;lcikk;ldrb','')
if (elojel == "+") then
  ui:executeCommand('setbgcolor','bkiad','gray')
  ui:executeCommand('setbgcolor','bbevesz','orange')
  ui:executeCommand('setbgcolor','lhkoc','orange')
else
  ui:executeCommand('setbgcolor','bbevesz','gray')  
  ui:executeCommand('setbgcolor','bkiad','yellow')
  ui:executeCommand('setbgcolor','lhkoc','yellow')
end
