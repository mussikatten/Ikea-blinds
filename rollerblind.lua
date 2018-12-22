--rollerblind.lua
local module = {}
--local tmr_delay = 2

function module.up()
  print("UP!")
  percent_go_to(0,config.step_ms)
  state = 0
end

function module.down()
  print("DOWN!")
  percent_go_to(100,config.step_ms)
  state = 2
end

return module
