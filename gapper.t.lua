
local gapper = require "gapper"

local DATA_FILE = "./data/DATA_SBER27_02_18.txt"
--local DATA_FILE = "./data/DATA_SBER16_02_18.txt"
local lines = {}
local lines = {}

print("hello")


-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function run(gap, margin, lines)
   gapper.reset()
   gapper.setMargin(margin)
   gapper.setMaxGap(gap)
   gapper.setBrokerFee(25)

   for key,value in pairs(lines) do
       a,b,c,d = string.match(value, '(.*) (.*) (%d+) (%d+)')
       bid = tonumber(c)
       ask = tonumber(d)
       --print(bid..ask.."\n")
       if bid ~= nil and ask ~= nil and bid < ask then
          rc = gapper.addQuote(bid, ask)
          if rc ~= 0 then
            --print("quote: "..key.." "..value.." op: "..rc)
          end
       end
   end
   income = gapper.getTotalIncome()
   if income > 0 then
      print("Gap: "..gap.." Margin:"..margin.." Total income: "..income)
   end
end
-- for line in io.lines() do
--    table.insert(lines, line)
-- end
lines = lines_from(DATA_FILE)

if next(lines) == nil then
   print("no data")
else
   print("read lines: "..#lines)
end

for g=20,30 do
   for m=10,20 do
      run(g, m/10, lines)
   end
end

