local params = {...}
local ui = params[1]
require 'model/Luafunc'

ui:executeCommand("HIDEOBJ","LSTATUS","")
ui:executeCommand("SETTOP","FLABEL","0")
ui:executeCommand("SETHEIGHT","PFOOTER","40")
ui:executeCommand("SETTOP","PFOOTER","275")
ui:executeCommand("REFRESH","SELKEZELO","")

