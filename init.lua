print("set up wifi mode")
wifi.setmode(wifi.STATION)
--please config ssid and password according to settings of your wireless router.
wifi.sta.config("microsekasus","qwertyuiop")
wifi.sta.connect()
cnt = 0
tmr.alarm(1, 3000, 1, function() 
    if (wifi.sta.getip() == nil) and (cnt < 20) then 
        print("IP unavaiable, Waiting...")
        cnt = cnt + 1 
    else 
        tmr.stop(1)
        if (cnt < 20) then print("Config done, IP is "..wifi.sta.getip())
        --dofile("script.lua")
        else print("Wifi setup time more than 20s, Please verify wifi.sta.config() function. Then re-download the file.")
        end
    end 
end)

port=9876
dthpin = 4
function receiveData(conn, data)
  --i,j=string.find(data, "cmd2", 1)
  pingreenled=2
  pinredled=1
  cmd=data
  print(data)
    gpio.mode(pingreenled,gpio.OUTPUT)
    gpio.mode(pinredled,gpio.OUTPUT)
    dht=require("dht")
    status,temp,humi,temp_decimial,humi_decimial = dht.read(dthpin)
    if (cmd=="cmd2") then-- on green led
        gpio.write(pingreenled,gpio.HIGH)
        conn:send("ok")
    elseif(cmd=="cmd3") then -- on red led
        gpio.write(pinredled,gpio.HIGH)
        conn:send("ok")
    elseif(cmd=="cmd4") then -- on red and green led
        gpio.write(pingreenled,gpio.HIGH)
        gpio.write(pinredled,gpio.HIGH)
        conn:send("ok")
    elseif(cmd=="cmd5") then ---- off green led
        gpio.write(pingreenled,gpio.LOW)
        conn:send("ok")
    elseif(cmd=="cmd6") then ---- off red led
        gpio.write(pinredled,gpio.LOW)
        conn:send("ok")
    elseif(cmd=="cmd7") then -- off red and green led
        gpio.write(pingreenled,gpio.LOW)
        gpio.write(pinredled,gpio.LOW)
        conn:send("ok")
    elseif(cmd=="cmd1") then -- off red and green led
        print(temp)
        conn:send(temp)
    elseif(cmd=="cmd8") then -- off red and green led
        print(humi)
        conn:send(humi)
    end
 
   
  --conn:send(device.measure())
end

srv=net.createServer(net.TCP, 28800) 
srv:listen(port,function(conn)
    print("Microsek ESP connected")
     
    conn:on("receive",receiveData)
   
    conn:on("disconnection",function(c) 
        print("Microsek ESP disconnected")
    end)
    
end)

    