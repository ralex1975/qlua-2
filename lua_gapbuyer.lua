
p_classcode="TQBR" --Код класса

p_seccode="SBER" --Код инструмента


is_run=true

LAST_ASK = 0
LAST_PRICE = 0

BROKER_FEE = 0.25 * 2

INCOME = 0

GAP = 0.05
LOT = 10
MARGIN = 1.005

DIGITS = 2
SHIFT = 10 ^ DIGITS


function main()
    local cntr = 0
    while is_run do
        sleep(2000)
        cntr = cntr + 1
        if cntr % 30 == 0 then
            message("Income " .. INCOME, 1)
        end
    end

end

function Buy(sec_code, price, amount)
    local p = math.floor( price * SHIFT + 0.5 ) / SHIFT
    t = {
					["CLASSCODE"]   = p_classcode,
					["SECCODE"]	    = sec_code,
					["ACTION"]      = "NEW_ORDER",
					["ACCOUNT"]     = "L01-00000F00",
					["CLIENT_CODE"] = "346204",
					["TYPE"]        = "L",
					["OPERATION"]   = "B",
					["QUANTITY"]    = tostring(amount),
					["PRICE"]       = string.format("%0.2f", p),
					["TRANS_ID"]    = "1"
		}
                --message("By for " .. min_ask, 1)
	res = sendTransaction(t)
    return res
end

function Sell(sec_code, price, amount)
    local p = math.floor( price * SHIFT + 0.5 ) / SHIFT
    t = {
					["CLASSCODE"]   = p_classcode,
					["SECCODE"]	    = sec_code,
					["ACTION"]      = "NEW_ORDER",
					["ACCOUNT"]     = "L01-00000F00",
					["CLIENT_CODE"] = "346204",
					["TYPE"]        = "L",
					["OPERATION"]   = "S",
					["QUANTITY"]    = tostring(amount),
					["PRICE"]       = string.format("%0.2f", p),
					["TRANS_ID"]    = "1"
		}
                --message("By for " .. min_ask, 1)
	res = sendTransaction(t)
    LAST_PRICE = 0
    INCOME = INCOME + (price - LAST_PRICE - BROKER_FEE) * LOT
    return res
end

function OnStop(stop_flag)

      is_run=false

end

function OnTrade(trade)
    msg = ""
    for key, value in pairs(trade) do
        --msg = msg..key.."  "..value.."\n"
        msg = msg..key.."\n"
    end
    message("Trade: "..trade.price, 1)
end

function GetBidAsk(class_code, sec_code)
    local tb = getQuoteLevel2(class_code, sec_code)
    local min_ask = math.huge
	for i= 1, tb.offer_count, 1 do
		local p = tonumber(tb.offer[i].price)
		min_ask = math.min( min_ask, p )
	end
    local max_bid = -math.huge
	for i= 1, tb.bid_count, 1 do
		local p = tonumber(tb.bid[i].price)
		max_bid = math.max( max_bid, p )
	end
    return max_bid, min_ask
end

function OnQuote(class_code, sec_code)
	if is_run == false then
		return
	end
    if class_code == p_classcode and sec_code == p_seccode then
        bid, ask = GetBidAsk(class_code, sec_code)
        if LAST_PRICE == 0 then -- Buy here
            if  ask <= (LAST_ASK - 0.05) then
                message("Gap " .. LAST_ASK - ask, 1)
            end
            if  ask <= (LAST_ASK - GAP) and LAST_PRICE == 0 then
                res = Buy(p_seccode, ask, 1)
				message(res, 1)
                LAST_PRICE = ask
            end
            LAST_ASK = ask
        else -- Sell here
            if bid >= (LAST_PRICE * MARGIN) then
                res = Sell(p_seccode, bid, 1)
                message(res, 1)
            end
        
        end
	end

end

