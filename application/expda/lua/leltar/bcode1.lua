require 'model/Luafunc'
local params = {...}
ui=params[1]
hkodc = params[2]:gsub(':','')
if (hkodc:len()>10) then
  ui:showMessage('helykód hossza nem lehet több, mint 10 karakter!')
  ui:executeCommand('valueto','lhkoc','')
  ui:executeCommand('setfocus','lhkoc','')
else 
	ui:executeCommand('setbgcolor','lhklabel','lightgray')
	ui:executeCommand('setbgcolor','lcikklabel','green')
	ui:executeCommand('valueto','lcikkc','')
	ui:executeCommand('showobj','lcikklabel;bujhkod','')
	ui:executeCommand('setfocus','lcikkc','')
	ui:executeCommand('valueto','lstatus','Cikk lövés')
	ui:executeCommand('aktbcodeobj','bcode2','')
	ui:executeCommand('scanneron','','')
end