
p_classcode="TQBR" --Код класса

p_seccode="SBER" --Код инструмента

p_my_price = 264.98

p_my_newprice = p_my_price * 1.01

is_run=true


function getInfo()
    local tn = "depo_limits"
    rn = getNumberOf(tn)
    message("table: "..tn.." rows: "..rn)
    mes = ""
    for i = 0, rn - 1, 1 do
        ltab = getItem(tn, i)
        if ltab == nil then
            message("table: "..tn.." rows: "..rn.." NIL item: "..i)
        else
            for k,v in pairs( ltab ) do
                --message("key: "..k.." value: "..v)
            end
            if ltab.awg_position_price > 0 then
                --message("sec: "..ltab.sec_code.." price: "..ltab.awg_position_price)
                mes = mes.."sec: "..ltab.sec_code.." price: "..ltab.awg_position_price.."\n"
            end
        end
    end
    PrintDbgStr("dbg from " ..getScriptPath())
    message(mes)
    TABLE getBuySellInfo (STRING firm_id, STRING client_code, STRING class_code, STRING sec_code, NUMBER price)



end


function main()
    while is_run do
        sleep(2000)
        getInfo()
        is_run = false
    end
end

function OnStop(stop_flag)

      is_run=false

end


function OnQuote(class_code, sec_code)
	if is_run == false then
		return
	end
    if class_code == p_classcode and sec_code == p_seccode then
		-- tb = getQuoteLevel2(class_code, sec_code)
			-- --message(class_code.."   "..sec_code.."  bid_count: "..tostring(tb.bid_count),1)
			-- --p = tb.bid[tb.bid_count].price
		-- cur_price = tb.bid[tonumber(tb.bid_count)].price
            -- --message(class_code.."   "..sec_code.."  bid: "..cur_price.."  i want "..tostring(p_my_newprice),1)
		-- p = tonumber(cur_price)

		-- if p >= p_my_newprice then
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