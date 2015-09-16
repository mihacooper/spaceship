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

function tfind(table, value)
  for k, v in pairs(table) do
    if v == value then
      return k
    end
  end
  return nil
end

function tcombinevec(left, right)
  local res = {}
  for _, v in pairs(left) do
    table.insert(res, v)
  end
  for _, v in pairs(right) do
    table.insert(res, v)
  end
  return res
end

function taddvec(left, right)
  for _, v in pairs(right) do
    table.insert(left, v)
  end
end

function tcombinevecs(vects)
  local res = {}
  for _, vec in pairs(vects) do
    taddvec(res, vec)
  end
  return res
end

