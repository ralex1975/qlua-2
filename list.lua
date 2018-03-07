local List = {}

function List.new(size)
  assert(type(size) == "number", "List expects size as a number")
  assert(size > 0, "List expects non zero size")
  return {first = 0, last = -1, max_size = size}
end

function List.isfull(list)
  return (list.last + 1 - list.first) == list.max_size
end

function List.pushright (list, value)
  local last = list.last + 1
  if last == list.max_size then
     List.popleft(list)
     last = last - 1
     list.first = list.first - 1
  end
  list.last = last
  list[last] = value

end   

function List.popleft (list)
   local first = list.first
   if first > list.last then error("list is empty") end
   local value = list[first]
   list[first] = nil        -- to allow garbage collection
   list.first = first + 1
   return value
end

function List.mean(list)
  local sum = 0
  local count = 0
  for k, v in pairs(list) do
    if type(k) == 'number' then
      sum = sum + v
      count = count + 1
    end
  end
  if count == 0 then count = count + 1 end
  return (sum / count)
end

function List.dump(list)
  for k, v in pairs(list) do
    print(k.." "..v)
  end
end

return List