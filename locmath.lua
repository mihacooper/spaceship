local locmath = {}

function locmath.rand_sign()
  local s = {-1, 1}
  return s[math.random(2)]
end

function locmath.vecsub(l,r)
  return {x = l.x - r.x, y = l.y - r.y}
end

function locmath.vecadd(l,r)
  return {x = l.x + r.x, y = l.y + r.y}
end

function locmath.vecmulc(v,c)
  return {x = v.x * c, y = v.y * c}
end

function locmath.vecnorm(v)
  local mod = locmath.vecmod(v)
  return {x = v.x / mod, y = v.y / mod}
end

function locmath.vecmod(v)
  return math.sqrt(v.x * v.x +  v.y * v.y)
end

function locmath.vecmk(obj)
  return {x = math.cos(obj.angle) * obj.speed,
    y = math.sin(obj.angle) * obj.speed}
end

function locmath.vecscal(l, r)
  return l.x * r.x + l.y * r.y
end

function locmath.vectoang(obj, v)
  local mod = locmath.vecmod(v)
  if mod ~= 0 then
    obj.angle = math.atan2(v.y / mod, v.x / mod)
  end
end


return locmath