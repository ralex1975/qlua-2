local Q = require "quikutil"
local gapper = require "gapper"

p_classcode="TQBR" --Код класса

--p_seccode="SBER" --Код инструмента
p_seccode="VTBR" --Код инструмента


is_run=true

AMOUNT = 1

BROKER_FEE = 0.25

GAP = 0.00024
LOT = 10
MARGIN = 1.3 --percent

gapper.reset()
gapper.setMargin(MARGIN)
gapper.setMaxGap(GAP)
gapper.setBrokerFee(BROKER_FEE)

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
      local inc = gapper.getTotalIncome()
      message("Total income: "..inc, 1)
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
        local res = 0
        bid, ask = Q.getBidAsk(class_code, sec_code)
        if Q.isValidQuote(bid, ask) ~= true then
            --message("Bad quote: "..bid.." "..ask, 1)
            return                                                      --RETURN
        end
        local rc = gapper.addQuote(bid, ask)
        if rc == 1 then
            if Q.canBuy(ask) then
            res = Q.buy(p_seccode, ask, AMOUNT)
            end
            message("Bought "..ask, 1)
        elseif rc == -1 then
            res = Q.sell(p_seccode, bid, AMOUNT)
            message("Sold "..bid, 1)
            local inc = gapper.getTotalIncome()
            message("Total income: "..inc * LOT, 1)
        end
	end
end

