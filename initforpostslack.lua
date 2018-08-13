print(wifi.sta.getip())
--nil
print("Atempting to connect to Bluezone")
wifi.setmode(wifi.STATION)
wifi.sta.config("BLUEZONE","")
print(wifi.sta.getip())
