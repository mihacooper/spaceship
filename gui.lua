world = require "world"

local compass_api = {}
  
--local compass = { x = 0, y = 0, angle = 0., image = IMAGE_COMPASS, level = DRAW_GUI_LAYER}

local radar_center = {x = IMAGE_COMPASS:getWidth() / 2, y = IMAGE_COMPASS:getWidth() / 2}

local function draw_radar()
    local hwidth = IMAGE_RADAR:getWidth() / 2
    local hheight = IMAGE_RADAR:getHeight() / 2
    local x = ORIGIN_WINDOW_WIDTH - radar_center.x
    local y = ORIGIN_WINDOW_HEIGHT - radar_center.y
    love.graphics.draw(IMAGE_RADAR, x, y,
      0, 1, 1, hwidth, hheight)
end

local function draw_compass()
    local hwidth = IMAGE_COMPASS:getWidth() / 2
    local hheight = IMAGE_COMPASS:getHeight() / 2
    local x = ORIGIN_WINDOW_WIDTH - radar_center.x
    local y = ORIGIN_WINDOW_HEIGHT - radar_center.y
    love.graphics.draw(IMAGE_COMPASS, x, y,
      world.camera.angle, 1, 1, hwidth, hheight)
end

local function draw_info()
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.print("POS: "
        ..tostring(math.floor(world.camera.x / world.cell_width)).."x"
        ..tostring(math.floor(world.camera.y / world.cell_height)), 10, 25)
end

function compass_api.postdraw(lev)
  if lev == DRAW_LAYER_GUI then
    draw_radar()
    draw_compass()
    draw_info()
  end
end

return compass_api