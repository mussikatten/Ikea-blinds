-- file: setup.lua
-- borrows code from http://www.esp8266.com/viewtopic.php?f=24&t=14433

local module = {}
attempts = 0
local function wifi_monitor()  
  if wifi.sta.getip()== nil then
    print("IP unavailable, Waiting...")
    attempts = attempts + 1
    if attempts > 15 then
        node.restart()
    end
  else
    tmr.stop(1)
--    tmr.alarm(1, 10000, 1, wifi_monitor)
    gpio.write(pin_led,1) --off
    print("\n================== ==================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is "..wifi.sta.getip())
    print("====================================")
    mq.start()
  end
end

function module.start()  
  print("Configuring Wifi ...")
  --if not wifi.getmode() == wifi.STATION then
    wifi.setmode(wifi.STATION)
  --end
  wifi.sta.config(config)
  tmr.alarm(1, 2500, 1, wifi_monitor)
  
end

return module
