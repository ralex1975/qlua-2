local Q = require "quikutil"


p_classcode="TQBR" --Код класса

p_seccode="SBER" --Код инструмента


is_run=true

LAST_ASK = 0

LAST_PRICE = 281.86
AMOUNT = 1

BROKER_FEE = 0.25 * 2

INCOME = 0

GAP = 0.2
LOT = 10
MARGIN = 1.01

function main()
    local cntr = 0
    while is_run do
        sleep(2000)
        cntr = cntr + 1
        if cntr % 30 == 0 then
            --message("Income " .. INCOME, 1)
        end
    end
end


function OnStop(stop_flag)

      is_run=false

end

function OnTrade(trade)
    msg = ""
    for key, value in pairs(trade) do
        if  type(value) ~= "table" then
            msg = msg..key.."  "..value.."\n"
        else
            msg = msg..key.."\n"
        end
    end
    message("Trade: \n"..msg, 1)
end

function OnQuote(class_code, sec_code)
	if is_run == false then
		return
	end
    if class_code == p_classcode and sec_code == p_seccode then
        bid, ask = Q.getBidAsk(class_code, sec_code)
        if Q.isValidQuote(bid, ask) ~= true then
            message("Bad quote: "..bid.." "..ask, 1)
            return                                                      --RETURN
        end
        if LAST_PRICE == 0 then -- Buy here
            if  ask <= (LAST_ASK - 0.1) then
                message("Gap " .. LAST_ASK - ask, 1)
            end
            if  ask <= (LAST_ASK - GAP) and Q.canBuy(ask) == true then
                res = Q.buy(p_seccode, ask, 1)
				message(res, 1)
                LAST_PRICE = ask
            end
            LAST_ASK = ask
        else -- Sell here
            if bid >= (LAST_PRICE * MARGIN) then
                res = Q.sell(p_seccode, bid, AMOUNT)
                LAST_PRICE = 0
                INCOME = INCOME + (price - LAST_PRICE - BROKER_FEE) * LOT
                message(res, 1)
                is_run = false                                            --STOP
            end
        
        end
	end

end

