world = require "world" 
hero = require "hero"
domain = require "domain"

local event_handlers = 
{
  loading = {hero.load, nil},
  subprocess = 
  {
    {function() return true  end, 
      { 
        {world.update, {}},
        {hero.update, {}},
        {domain.update, {}}
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
    {function() return love.keyboard.isDown("escape") end,
      {
        {love.event.quit, {}}
      }
    },
  }
}

return event_handlers
