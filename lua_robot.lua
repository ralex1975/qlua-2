
local Q = require "quikutil"





p_classcode="TQBR" --Код класса

p_seccode="SBER" --Код инструмента

is_run=true

k_TO_BUY = false
k_TO_SELL = false
p_LAST_BUY = 0
LAST_BID = 0
LAST_ASK = 0
MAX_BID_GAP = 0
MAX_ASK_GAP = 0
p_INCOME = 0

ON_QUOTE_NUM = 0
SKIP_QUOTE_NUM = 0

ASK_LIST = List.new()
BID_LIST = List.new()

BID_LIST_COUNTER = 0
ASK_LIST_COUNTER = 0

LIST_MAX_SIZE = 3

BROKER_FEE=0.25
LOT=10

MY_MARGIN = BROKER_FEE * 2 + 1.89
--------------------------------
--  MAIN
--------------------------------

function main()
      message("  Started ",1)
      while is_run do

            sleep(2000)

      end

end

function OnStop(stop_flag)
	  message("Stop with income "..tostring(p_INCOME).."  Quotes: "..tostring(ON_QUOTE_NUM).." Skipped: "..tostring(SKIP_QUOTE_NUM), 1)
      is_run=false

end

function OnTrade(trade)
	message("Trade", 1)
end

function OnAllTrade(alltrade)
	message("Trade SEC: "..alltrade.sec_code
		     " PRICE: "..alltrade.price, 1)
end


function OnQuote(class_code, sec_code)
	if is_run == false then
		return
	end

    if class_code == p_classcode and sec_code == p_seccode then
		

		if LAST_BID == max_bid and LAST_ASK == min_ask then
			--message(class_code.."   "..sec_code.."  SKIP ",1)
			SKIP_QUOTE_NUM = SKIP_QUOTE_NUM + 1
			return
		end
		if LAST_BID ~= max_bid then
			List.pushright(BID_LIST, max_bid)
			BID_LIST_COUNTER = BID_LIST_COUNTER + 1
			if BID_LIST_COUNTER > LIST_MAX_SIZE then
				List.popleft(BID_LIST)
				BID_LIST_COUNTER = BID_LIST_COUNTER - 1
			end
			if LAST_BID > max_bid then
				local g = math.max(MAX_BID_GAP, LAST_BID - max_bid)
				if g ~= MAX_BID_GAP then
					message(class_code.."   "..sec_code.."  MAX BID GAP "..g,1)
					MAX_BID_GAP = g
				end
			end
			LAST_BID = max_bid
		end
		if LAST_ASK ~= min_ask then
			List.pushright(ASK_LIST, min_ask)
			ASK_LIST_COUNTER = ASK_LIST_COUNTER + 1
			if ASK_LIST_COUNTER > LIST_MAX_SIZE then
				List.popleft(ASK_LIST)
				ASK_LIST_COUNTER = ASK_LIST_COUNTER - 1
			end
			if LAST_ASK > min_ask then
				local g = math.max(MAX_ASK_GAP, LAST_ASK - min_ask)
				if g ~= MAX_ASK_GAP then
					message(class_code.."   "..sec_code.."  MAX ASK GAP "..g,1)
					MAX_ASK_GAP = g
				end
			end
			LAST_ASK = min_ask
		end
		--message(class_code.."   "..sec_code.."  NEW QUOTE ",1)
		ON_QUOTE_NUM = ON_QUOTE_NUM + 1
		l_file=io.open("C:\\tmp\\sber_13.txt", "a")
		local mean = stats.mean(ASK_LIST)
		local smean = stats.mean(BID_LIST)
		l_file:write(os.date("%c ")..
					 tostring(max_bid)..";  "..
					 string.format("%03.2f", smean)  ..";  "..
					 tostring(min_ask)..";  "..
					 string.format("%03.2f", mean) ..";  "..
					 tostring(p_LAST_BUY)..";  "..
                     tostring(p_LAST_BID)   .."\n")
		l_file:close()
		
		local cur_price = min_ask		
		

		if ASK_LIST_COUNTER == LIST_MAX_SIZE then			
			--message(class_code.."   "..sec_code.."  cur_bid: "..tostring(cur_price).."  mean "..tostring(mean),1)
			if k_TO_BUY == true and k_TO_SELL == false then
			    --message(class_code.."   "..sec_code.." check buy: "..tostring(cur_price).."  mean "..tostring(mean),1)
				if cur_price > mean then
					--if p_LAST_BUY ~= 0 and cur_price > p_LAST_BUY then
					--if cur_price > mean then
					--	return
					--end
				    message(class_code.."   "..sec_code.." buy: "..tostring(cur_price), 1)
					p_LAST_BUY = cur_price
					p_LAST_BID = 0
					k_TO_SELL = true
				end
			elseif k_TO_BUY == false and cur_price < mean then
				k_TO_BUY = true
				message(class_code.."   "..sec_code.." prepare to buy: "..tostring(cur_price).."  mean "..tostring(mean),1)
			elseif k_TO_SELL == true then
				if (max_bid - p_LAST_BUY) * LOT > MY_MARGIN then					
					--message(class_code.."   "..sec_code.." may sell: "..tostring(max_bid).." smean="..tostring(smean), 1)
					if max_bid < smean then
						k_TO_SELL = false
						k_TO_BUY  = false
						p_INCOME = p_INCOME + ((max_bid - p_LAST_BUY) - BROKER_FEE * 2) * LOT
						message(class_code.."   "..sec_code.." sell: "..tostring(max_bid).." INCOME="..tostring(p_INCOME), 1)
						--ASK_LIST_COUNTER = 0
						--BID_LIST_COUNTER = 0
						--ASK_LIST = List.new()
						--BID_LIST = List.new()
						p_LAST_BID = max_bid
					end
				end
			end
		end

            --message(class_code.."   "..sec_code.."  bid: "..cur_price.."  i want "..tostring(p_my_newprice),1)
		-- if tonumber(cur_price) >= p_my_newprice then
			-- t = {
					-- ["CLASSCODE"]   = p_classcode,
					-- ["SECCODE"]	    = p_seccode,
					-- ["ACTION"]      = "NEW_ORDER",
					-- ["ACCOUNT"]     = "L01-00000F00",
					-- ["CLIENT_CODE"] = "346204",
					-- ["TYPE"]        = "L",
					-- ["OPERATION"]   = "S",
					-- ["QUANTITY"]    = "1",
					-- ["PRICE"]       = cur_price,
					-- ["TRANS_ID"]    = "1"
				-- }
				-- res = sendTransaction(t)
				-- message(res, 1)
				-- is_run = false
		-- end

	end

end