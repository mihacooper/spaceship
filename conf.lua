function love.conf(t)
  local minor = 8
  if love.getVersion ~= nil then
    _, minor, _, _ = love.getVersion()
  end
  if minor > 8 then
    t.window.width = 0 
    t.window.height = 0 
    t.window.fullscreen = true        -- Enable fullscreen (boolean)
   -- t.screen.fullscreentype = "desktop" -- Standard fullscreen or desktop fullscreen mode (string)
    t.window.vsync = false
  else
    t.screen.width = 0 
    t.screen.height = 0 
    t.screen.fullscreen = true        -- Enable fullscreen (boolean)
   -- t.screen.fullscreentype = "desktop" -- Standard fullscreen or desktop fullscreen mode (string)
    t.screen.vsync = false
  end
end
