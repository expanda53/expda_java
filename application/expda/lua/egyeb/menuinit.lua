require 'model/Luafunc'
local params = {...}
ui = params[1]
local menuitem = params[2]:gsub(':','')
local kezelo = params[3]:gsub(':','')
if (menuitem~='EXIT') then
  ui:executeCommand('openxml',menuitem,kezelo)
else
  ui:executeCommand('close','','')
end


