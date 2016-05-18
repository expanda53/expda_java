require 'model/Luafunc'
local params = {...}
ui=params[1]
local okbiz = params[2]:gsub(':','')
local cegazon = params[3]:gsub(':','')
local kezelo = params[4]:gsub(':','')
mibiz = ''
subdir = 'tasklist'
function getMibiz(okbiz,cegazon)
  filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\bevet_mibizlist.txt'
  file = io.open (filename , "r")
  aktmibiz = ''
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
  return aktmibiz
end

mibiz = getMibiz(okbiz,cegazon)
if (mibiz=="") then mibiz='bevet_' .. okbiz .. '_' .. cegazon end
ui:executeCommand('valueto','lhivat','Hivatkozás:' .. okbiz)
ui:executeCommand('setwidth','lhivat','300')
ui:executeCommand('valueto','ltitle','Bevét:' .. mibiz)
ui:executeCommand('hideobj','ehivat','')
ui:executeCommand('showobj','lcikklabel','')
ui:executeCommand('valueto','lcikkc','')
ui:executeCommand('valueto','lstatus','cikk lövés')
ui:executeCommand('setbgcolor','lcikkc','orange')
ui:executeCommand('aktbcodeobj','bcode1','')
ui:executeCommand('scanneron','','')
ui:executeCommand('setfocus','lcikkc','')