
require 'model/Luafunc'
local params = {...}
ui = params[1]
local mibiz = params[2]:gsub(':','')
local sorsz = params[3]:gsub(':','')
local hkod = params[4]:gsub(':','')
local luafile = luafunc.ini('luadir'):gsub('%/','%.'):gsub("\\",".") .. '.kiadas.kiadas_kovhkod_func'
require (luafile)
kovhkod(ui,mibiz, sorsz, hkod)