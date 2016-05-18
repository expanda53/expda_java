local params = {...}
ui = params[1]
cegazon = params[2]:gsub(':','')
cegnev = ui:findObject('selcegnev'):getText()
title = ui:findObject('ltitle'):getText()
if (cegnev~='') then
  ui:executeCommand("valueto","ltitle",title ..':'..cegnev)
end  
ui:executeCommand("valuetohidden","lcegazon",cegazon)
ui:executeCommand("hideobj","pcegval;lcikk","")
ui:executeCommand("showobj","panel1;pfooter","")
ui:executeCommand("aktbcodeobj","bcode0","")
ui:executeCommand("scanneron","","")
ui:executeCommand("setfocus","ehivat","")
