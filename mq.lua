-- file : application.lua
local module = {}  
m = nil

-- Sends a simple ping to the broker
local function send_ping()
    m:publish(config.ENDPOINT .. config.ID .. "/heartbeat","id=" .. config.MQID,0,0)
    module.post_status()
end

-- Sends my id to the broker for registration
local function register_myself()

print("Attempting to Register " .. config.MQID)

m:subscribe(config.ENDPOINT .. config.ID .. "/set",0, function(client) 
print("Successfully subscribed to " .. config.MQID) end)

end

local function mqtt_connect()
    -- Connect to broker
    m:connect(config.MQHOST, config.MQPORT, config.MQTLS, function(client) 
        print("mqtt_connect()")
        register_myself()
        m:publish(config.ENDPOINT .. config.ID .. "/connect","id=" .. config.MQID,0,0)
        tmr.stop(6)
        tmr.alarm(6, 60000, 1, send_ping)
    end,function(client,reason)
        print("mqtt connection failed due to " .. reason)
        tmr.stop(6)
        tmr.alarm(6, 10000, 1, mqtt_connect)
    end)
    m:on("offline", function(client) 
        print ("mqtt went offline, reconnecting " .. config.ID) 
        tmr.stop(6)
        tmr.alarm(6, 10000, 1, mqtt_connect)
    end)
end

local function mqtt_start()  
    m = mqtt.Client(config.MQID, 120, config.MQUSR, config.MQPW)
    -- register message callback beforehand

    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        value = tonumber(data)
        if value ~= nil then
          if (value == 0) then
            rollerblind.up()
          end
          if (value == 100) then
            rollerblind.down()
          end
          if (value > 0 and value < 100) then
            percent_go_to(value,config.step_ms)
          end
        end      
      end
    end)
    mqtt_connect()
end

function module.start()  
  mqtt_start()
end

function module.post_status()
  perc = 100 - (cur_step*100/tot_steps)
  print(config.POST .. ": " .. perc)
  m:publish(config.POST,perc,0,0)
end

return module
