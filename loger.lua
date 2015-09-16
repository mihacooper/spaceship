local MSG_QUEUE_SIZE = 10
local loger = 
{
  messages = {}
}

function loger.send(msg, lev)
  if lev <= LOG_LEVEL then
    table.insert(loger.messages, msg)
    if #loger.messages > MSG_QUEUE_SIZE then
      table.remove(loger.messages, 1)
    end
  end
end

function loger.draw(lev)
  if lev == DRAW_LAYER_GUI then
    local count = #loger.messages
    for i = 1, count do
      local m = loger.messages[i]
      love.graphics.print("> " .. tostring(m), 10,  ORIGIN_WINDOW_HEIGHT - (count - i) * 15 - 20)
    end
  end
end

return loger
