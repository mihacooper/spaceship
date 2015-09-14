math = require "math" 
world = require "world" 
resources = require "resources/resources" 
config = require "config" 
events = require "events" 

function update_window_res()
  WINDOW_WIDTH = ORIGIN_WINDOW_WIDTH / world.scale
  WINDOW_HEIGHT = ORIGIN_WINDOW_HEIGHT / world.scale
  world.grid_width = math.floor((WINDOW_WIDTH  + world.cell_width - 1) / world.cell_width)
  world.grid_height = math.floor((WINDOW_HEIGHT + world.cell_height - 1) / world.cell_height)
end

function love.load()
  local window_width = love.graphics.getWidth()
  local window_height = love.graphics.getHeight()
  local minor = 8
  if love.getVersion ~= nil then
    _, minor, _, _ = love.getVersion()
  end
  if minor > 8 then
    love.window.setMode(window_width, window_height, {fullscreen = true})
  else
    love.graphics.setMode(window_width, window_height, true, true, 2)
  end
  if minor > 8 then
    LOVE_VERSION_IS_OLD = false
  else
    LOVE_VERSION_IS_OLD = true
  end  
  for _, func in pairs(events.loading) do
    func()
  end
end


function love.update(dt)
  for _, ev in pairs(events.subprocess) do
    if ev[1]() then
      for _, hand in pairs(ev[2]) do
        local func = hand[1]
        local par = hand[2]
        par.dt = dt
        func(par)
      end
    end
  end
end
 
function offset_x(image)
	return image:getWidth() / 2
end
 
function offset_y(image)
	return image:getHeight() / 2
end

function draw_objects(ct)
  for _, obj in pairs(ct) do
    if obj.image ~= nil then
      local offx = offset_x(obj.image)
      local offy = offset_y(obj.image)
      love.graphics.draw(obj.image, 
        obj.x  - world.camera.x,
        obj.y  - world.camera.y,
        obj.angle + math.pi / 2, 1, 1, offx, offy)
    end
  end
end

function love.mousepressed( x, y, mb )
  if mb == "wu" then
    world.scale = world.scale + 0.05
  elseif mb == "wd" then
    world.scale = world.scale - 0.05
  else
    return
  end
  if world.scale > 1.4 then 
    world.scale = 1.4
  elseif world.scale < 0.5 then 
    world.scale = 0.5
  end
  update_window_res()
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(world.scale)
  for lev = 1, DRAW_LAYERS do
    world.grid_map_curr_rect(
      function(_, cell, _, _, _)
        if cell ~= nil then
          draw_objects(cell)
        end
      end, lev, nil
      )
  end
  love.graphics.pop()
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  love.graphics.print("POS: "
      ..tostring(math.floor(world.center.x / world.cell_width)).."x"
      ..tostring(math.floor(world.center.y / world.cell_height)), 10, 25)
end
