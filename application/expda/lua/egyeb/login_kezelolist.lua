local params = {...}
local ui = params[1]
require 'model/Luafunc'
subdir = 'common'
filename = luafunc.ini('exportdir') ..'\\' .. subdir.. '\\login.txt'
file = io.open (filename , "r")
if (file~=nil) then
  source = file:read("*a")
  file:close()
  --list = luafunc.strtotable(source)
  -- selkezelo tabla feltoltese
  luafunc.refreshtable_fromstring('selkezelo',source)

else
  -- kezelok lekerdezese
  list = luafunc.query('login_kezelolist',false)
  -- selkezelo tabla feltoltese
  luafunc.refreshtable('selkezelo',list)
  
end

