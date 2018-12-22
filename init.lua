-- file : init.lua

tot_steps = 4000 -- total steps up/down
cur_step = 0
FWD=-1
REV=1

--initiate LED
pin_led=0
gpio.write(pin_led,0)
gpio.mode(pin_led,gpio.OUTPUT)

if file.exists("cfg_tot_steps.lua") then
  dofile("cfg_tot_steps.lua")
  print("Total steps cfg_tot_steps.lua = " .. tot_steps)
end
if file.exists("cfg_cur_step.lua") then
  dofile("cfg_cur_step.lua")
  print("Current step from cfg_cur_step.lua = " .. cur_step)
end

function configure_steps(step_input)
  if file.open("cfg_tot_steps.lua", "w+") then
    file.write("tot_steps=" .. step_input .. '\n')
    print("Wrote new tot_steps value to cfg_tot_steps.lua")
    file.close()
  end
end      

mq          = require("mq")
config      = require("config")  
wifi_setup  = require("wifi_setup")
rollerblind = require("rollerblind")

dofile("stepper.lua")
dofile("button.lua")
pins_disable()
wifi_setup.start()


-- 
