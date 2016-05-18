local params = {...}
ui = params[1]

ui:executeCommand("showobj","pzaras","")
ui:executeCommand("hideobj","panel1;pfooter","")
ui:executeCommand("refresh","seltablesum","")
