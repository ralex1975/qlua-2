
local gapper = require "gapper"

local lines = {}


for line in io.lines() do
   table.insert(lines, line)
end

for gap = 40, 40, 1 do
   for margin = 200, 200, 5 do
      gapper.reset()
      gapper.setMargin(margin)
      gapper.setMaxGap(gap)
      gapper.setBrokerFee(25)
      for key,value in pairs(lines) do
	 a,b,c,d = string.match(value, '(.*) (.*) (%d+) (%d+)')
	 bid = tonumber(c)
	 ask = tonumber(d)
	 if bid ~= nil and ask ~= nil and bid < ask then
	    rc = gapper.addQuote(bid, ask)
	    if rc ~= 0 then
	        print("quote: "..key.." "..value.." op: "..rc)
	    end
	 end

      end
      income = gapper.getTotalIncome()
      if income > 0 then
          print("GAP: "..gap.." MARG: "..margin.." Total income: "..income)
      end
   end
end


