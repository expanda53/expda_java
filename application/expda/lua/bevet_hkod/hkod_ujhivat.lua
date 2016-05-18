require 'model/Luafunc'
local params = {...}
ui=params[1]
local okbiz = params[2]:gsub(':','')
local cegazon = params[3]:gsub(':','')
local kezelo = params[4]:gsub(':','')
mibiz = ''
subdir = 'tasklist'
function getMibiz(okbiz,cegazon)
	filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\hkodbevet_mibizlist.txt'
	file = io.open (filename , "r")
	aktmibiz = ''
	if file~=nil then
		local lines = file:read("*a")
		local t = luafunc.strtotable(lines)
		if (t~=nil) then 
			for i, row in ipairs(t) do
				if row['CEGAZON']==cegazon and row['OKBIZ']==okbiz then
					aktmibiz = row['MIBIZ']
					break
				end  
			end
		end
	end
	return aktmibiz
end

mibiz = getMibiz(okbiz,cegazon)
if (mibiz=="") then mibiz='bevethkod_' .. cegazon .. '_' .. okbiz end
ui:executeCommand('valueto','lhivat','Hivatkozás:' .. okbiz)
ui:executeCommand('setwidth','lhivat','300')
ui:executeCommand('valueto','ltitle','Bevét:' .. mibiz)

ui:executeCommand('showobj','lhklabel','')
ui:executeCommand("valueto","lhkoc","")
ui:executeCommand("setfocus","lhkoc","")
ui:executeCommand("aktbcodeobj","bcode1","")
ui:executeCommand("scanneron","","")
ui:executeCommand("valueto","lstatus","Helykód lövés")
ui:executeCommand('hideobj','lcikklabel;bujhkod;lcikkc;lcikk;ldrb','')

ui:executeCommand('setbgcolor','lcikkc','orange')
ui:executeCommand('aktbcodeobj','bcode1','')

