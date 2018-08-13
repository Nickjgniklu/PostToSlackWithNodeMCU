-- this code requires the dev  nodemcu firmware becuase the master branch currently 
--dosent support ssl i suggest building it with the http://nodemcu-build.com/ make sure ssl is enabled 
--when building
--text to send to slack
text="With lots of love ESP8266"

--we make a sceure tcp scocket using this command
-- slack requires secure cinection so 1
sk=net.createConnection(net.TCP, 1)

-- port to connect to and adress of server
--dns is supported so no need for ip adress
sk:connect(443,"hooks.slack.com")
--if the socket recivecs data print it
sk:on("receive", function(scoket, c) print(c)end)
sk:on("disconnection", function(scoket, c) 
                                            print("Disconnected from server")
                                            --reconnect but how?
                                            
                                            end)


--button button pin to input pullup mode
--input pullup invert logic but is more stable
gpio.mode(2,gpio.INPUT,gpio.PULLUP)--button to read
gpio.mode(0,gpio.OUTPUT)--for dispaling button state

--used for change state detection
buttonstate=0
lastbuttonstate=0
   
function checkbutton()
-- read pin number 2 save it intovar
    buttonstate = gpio.read(2)
 
    --change in button state from last press
    if (buttonstate ~= lastbuttonstate) then
        if(buttonstate==0) then
        --button went unpressed to pressed
          --  print("down")
          
            gpio.write(0,0)
            --send message cany only send 1 at a time
            sk:send("POST /services/T03EP9ESA/B0MS5F5LG/KYyJNUOWt1VbBQGGsLxJ5ldy HTTP/1.1\r\n"..
                  "Content-type: application/json\r\n"..
                  "Host: ".."hooks.slack.com".."\r\n"..
                  "Content-Length:"..(string.len(text)+11)..--+11 for the json formatstuff around text
                  "\r\n\r\n"..
                   '{"text":"'..text..'"}'
                   )
            
        else
        --buttonstate change other direction pressed to unpressed
            gpio.write(0,1)
        end
    end
    lastbuttonstate=buttonstate
end

--timer # seconde interval to check 1 for repeat function to call
tmr.alarm(1,100,tmr.ALARM_AUTO, checkbutton)

