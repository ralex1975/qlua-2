
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

message("Hello, World!",1)

--t = getMoney (STRING client_code, STRING firmid, STRING tag, STRING currcode)
tname = 'money_limits'
num = getNumberOf(tname)

for i = 0, num - 1, 1 do
    t = getItem (tname, i)
    if t ~= nil then
        --message("Good table",1)
        m = ""
        for k, v in pairs(t) do
            m = m..k.." "..v.."\n"
        end
        l = tonumber(t.currentbal)
         message(m, 1)
        if l ~= 0 then message(l, 1) end
    else
        message("Bad table",1)
    end
end



