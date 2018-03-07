
local meaner = require "meaner"
local stat   = require "statgainer"

local DATA_FILE = "./data/DATA_MEANER_T.txt"
local LIST_SIZE = 3
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
function main()
  if not file_exists(DATA_FILE) then return {} end
  meaner.reset()
  meaner.init(LIST_SIZE, LIST_SIZE)
  meaner.setMargin(0.1)
  meaner.setBrokerFee(1)
  --lines = {}
  local counter = 0
  for line in io.lines(DATA_FILE) do
    bid, ask = parse_line(line)

    assert(bid ~= nil,    "Valid bid")
    assert(ask ~= nil,    "Valid ask")

    counter = counter + 1
    --lines[#lines + 1] = line
    local rc = meaner.addQuote(bid, ask)
    if     counter <= LIST_SIZE then assert(rc == 0, "skip")
    --elseif counter == 1 then
    end
    --if counter == 5000 then return end

  end
  income = meaner.getTotalIncome()
  assert(income == 1, "Total income")

  --return lines
end

function parse_line(line)
   --for key,value in pairs(lines) do
       a,b,c,d = string.match(line, '(.*) (.*) (%d+) (%d+)')
       local bid = tonumber(c)
       local ask = tonumber(d)
       print(bid.." "..ask.."\n")
       if bid ~= nil and ask ~= nil and bid < ask then
          return bid, ask
          --rc = meaner.addQuote(bid, ask)
          --stat.addQuote(bid, ask)
          -- if rc ~= 0 then
          --   print("quote: "..line.." op: "..rc)
          -- end
       end
   --end

end
-- for line in io.lines() do
--    table.insert(lines, line)
-- end
--lines = lines_from(DATA_FILE)

main()
