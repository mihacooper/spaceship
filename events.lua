world = require "world" 
hero = require "hero"
domain = require "domain"
enemy = require "enemy"
gui = require "gui"
background = require "background"
log = require "loger"

local event_handlers = 
{
  loading = {hero.load},
  subprocess = 
  {
    {function() return true  end, 
      { 
        {background.update, {}},
        {hero.update, {}},
        {domain.update, {}},
      }
    },
    {function() return love.keyboard.isDown("w") end,
      {
        {hero.update, {msg = "GoUp"}}
      }
    },
    {function() return love.keyboard.isDown("s") end,
      {
        {hero.update, {msg = "GoDown"}}
      }
    },
    {function() return love.keyboard.isDown("a") end, 
      {
        {hero.update, {msg = "RotateLeft"}}
      }
    },
    {function() return love.keyboard.isDown("d") end,
      {
        {hero.update, {msg = "RotateRight"}}
      }
    },
    {function() return love.keyboard.isDown(" ") end, 
      {
        {hero.update, {msg = "Shoot"}}
      }
    },
    {function() return love.keyboard.isDown("escape") end,
      {
        {love.event.quit, {}}
      }
    },
  },
  domain_creator = { 
    {enemy.domain_init, {}},
  },
  predrawing = {background.predraw},
  postdrawing = {gui.postdraw, log.draw},
}
function event_handlers.perform(event, par)
  if event_handlers[event] == nil then
    return
  end
  for _, hand in pairs(event_handlers[event]) do
    hand(par)
  end
end

return event_handlers
