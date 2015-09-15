function new_timer(time)
  local timer = { check_time = time, curr_time = 0}
  function timer:age(dt)
    self.curr_time = self.curr_time + dt
    if self.curr_time >= self.check_time then
      self.curr_time = 0
      return true
    end
    return false
  end
  return timer
end

function find(table, value)
  for k, v in pairs(table) do
    if v == value then
      return k
    end
  end
  return nil
end