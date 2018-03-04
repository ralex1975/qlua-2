
local meaner = require "meaner"

local DATA_FILE = "./data/DATA_SBER27_02_18.txt"
--local DATA_FILE = "./data/DATA_SBER16_02_18.txt"
--local lines = {}


print("hello")


-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function main(file, margin)
  if not file_exists(file) then return {} end
  meaner.reset()
  meaner.init(50, 50)
  meaner.setMargin(margin)
  meaner.setBrokerFee(25)
  --lines = {}
  local counter = 0
  for line in io.lines(file) do 
    counter = counter + 1
    --lines[#lines + 1] = line
    run(margin, line)
    if counter == 5000 then return end

  end
  income = meaner.getTotalIncome()
  if income > 0 then
     print("Gap: "..gap.." Margin:"..margin.." Total income: "..income)
  end
  --return lines
end

function run(margin, line)
   --for key,value in pairs(lines) do
       a,b,c,d = string.match(line, '(.*) (.*) (%d+) (%d+)')
       bid = tonumber(c)
       ask = tonumber(d)
       --print(bid..ask.."\n")
       if bid ~= nil and ask ~= nil and bid < ask then
          rc = meaner.addQuote(bid, ask)
          if rc ~= 0 then
            print("quote: "..line.." op: "..rc)
          end
       end
   --end

end
-- for line in io.lines() do
--    table.insert(lines, line)
-- end
--lines = lines_from(DATA_FILE)



-- for g=20,20 do
--    for m=10,10 do
--       run(g, m/10, lines)
--    end
-- end
main(DATA_FILE, 0.1)
