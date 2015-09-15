world = require "world"
domain = require "domain"
lm = require "locmath"

local compass_api = {}
  
--local compass = { x = 0, y = 0, angle = 0., image = IMAGE_COMPASS, level = DRAW_GUI_LAYER}

local radar_center = {x = IMAGE_COMPASS:getWidth() / 2, y = IMAGE_COMPASS:getWidth() / 2}

local function draw_radar()
    local hwidth = IMAGE_RADAR:getWidth() / 2
    local hheight = IMAGE_RADAR:getHeight() / 2
    local rx = ORIGIN_WINDOW_WIDTH - radar_center.x
    local ry = ORIGIN_WINDOW_HEIGHT - radar_center.y
    love.graphics.draw(IMAGE_RADAR, rx, ry,
      0, 1, 1, hwidth, hheight)
    
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(0, 0, 255)
    love.graphics.circle("fill", rx, ry, 2, 5)
    love.graphics.setColor(r, g, b, a)

    domain.domain_map_curr_rect(
      function(_, dmn)
        for _, obj in pairs(dmn.objects) do
          if obj.objtype == OBJ_TYPE_BOT then
            local dir = lm.vecsub(obj, world.camera)
            local coeff = lm.vecmod(dir) / (domain.radius() / 2)
            if coeff <= 1. then
              local length = coeff * IMAGE_RADAR:getWidth() / 2
              local findir = lm.vecmulc(lm.vecnorm(dir), length)
              local nx = findir.x * math.cos(world.camera.angle) - findir.y * math.sin(world.camera.angle)
              local ny = findir.x * math.sin(world.camera.angle) + findir.y * math.cos(world.camera.angle)
              local pnt = lm.vecadd({x = nx, y = ny}, {x = rx, y = ry})
              love.graphics.setColor(255, 0, 0)
              love.graphics.circle("fill", pnt.x, pnt.y, 2, 5)
              love.graphics.setColor(r, g, b, a)
            end
          end
        end
      end
    )
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