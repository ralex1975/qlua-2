
p_classcode="TQBR" --Код класса

p_seccode="SBER" --Код инструмента

is_run=true


LAST_ASK = 0
LAST_BID = 0
SCALE = 100

local d = os.date("%d_%m_%y")
local fname = "DATA_"..p_seccode..d..".txt"
local fpath = "C:\\tmp\\qlua\\data\\"

--------------------------------
--  MAIN
--------------------------------

function main()
      while is_run do
            sleep(2000)
      end
end

function OnStop(stop_flag)
	  message("Stop ", 1)
      is_run=false

end

function OnQuote(class_code, sec_code)
	if is_run == false then
		return
	end
    if class_code == p_classcode and sec_code == p_seccode then		
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
		if LAST_BID == max_bid and LAST_ASK == min_ask then
			return
		end
		LAST_BID = max_bid
		LAST_ASK = min_ask
		l_file=io.open(fpath..fname, "a")
		l_file:write(os.date("%c ")..
					 tostring(LAST_BID).." "..
					 tostring(LAST_ASK).."\n")
		l_file:close()	
	end
end