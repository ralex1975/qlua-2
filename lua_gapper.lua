
p_classcode="TQBR" --Код класса

p_seccode="SBER" --Код инструмента

is_run=true


LAST_ASK = 0
LAST_BID = 0
MAX_ASK_GAP = 0
MAX_BID_GAP = 0
SCALE = 100


--local my = require("lua_gapper")


--------------------------------
--  MAIN
--------------------------------

function main()
	local mymodule = require "my_gapper"
      mymodule.addQuote(1, 2)
      while is_run do
            sleep(2000)
      end
end

function OnStop(stop_flag)
	  message("Stop ", 1)
      is_run=false
end

function IsDup(bid, ask)
	return LAST_BID == bid and LAST_ASK == ask
end

function GetQuotes(class_code, sec_code)
	local tb = getQuoteLevel2(class_code, sec_code)
	local bid_size = tonumber(tb.bid_count)
	local offer_size = tonumber(tb.offer_count)
	local max_bid = -math.huge
	for i= 1, tb.bid_count, 1 do
		local p = tonumber(tb.bid[i].price)
		max_bid = math.max( max_bid, p )
	end
	local min_ask = math.huge
	for i= 1, tb.offer_count, 1 do
		local p = tonumber(tb.offer[i].price)
		min_ask = math.min( min_ask, p )
	end
	max_bid = max_bid * SCALE
	min_ask = min_ask * SCALE
	return max_bid, min_ask
end

function HandleQuotes(bid, ask)
end

function OnQuote(class_code, sec_code)
	if is_run == false then
		return
	end
    if class_code == p_classcode and sec_code == p_seccode then		
		b, a = GetQuotes(class_code, sec_code)
		if IsDup(b, a) == true then
			return
		end
		HandleQuotes(b, a)		
	end
end