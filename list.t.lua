
local List = require "list"


local l = List.new(1)

assert(List.mean(l)   == 0,     "Empty List")
assert(List.isfull(l) == false, "Not full")

List.pushright(l, 2)
List.dump(l)

assert(List.mean(l)   == 2,    "Mean 2")
assert(List.isfull(l) == true, "Full List")

List.pushright(l, 3)
List.dump(l)
assert(List.isfull(l) == true, "Full List")
assert(List.mean(l)   == 3,    "Mean 3")

l = List.new(2)
List.pushright(l, 2)
List.pushright(l, 3)

assert(List.isfull(l) == true, "Full List")
assert(List.mean(l)   == 2.5,  "Mean 2.5")

List.pushright(l, 1)
List.pushright(l, 1)
List.dump(l)
print(List.mean(l))
assert(List.mean(l) == 1, "Mean 1")
assert(List.isfull(l) == true, "Full List")

List.popleft(l)

assert(List.isfull(l) == false, "Not full List")