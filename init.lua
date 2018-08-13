
wifi.setmode(wifi.STATION)
wifi.sta.config("BLUEZONE","")

dofile("postToSlack.lua")
