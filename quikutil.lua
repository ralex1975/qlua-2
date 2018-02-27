local Quik = {}

function Quik.getBidAsk(class_code, sec_code)
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

function Quik.buy(sec_code, price, amount)
  --local p = math.floor( price * SHIFT + 0.5 ) / SHIFT
  t = {
          ["CLASSCODE"]   = p_classcode,
          ["SECCODE"]     = sec_code,
          ["ACTION"]      = "NEW_ORDER",
          ["ACCOUNT"]     = "L01-00000F00",
          ["CLIENT_CODE"] = "346204",
          ["TYPE"]        = "L",
          ["OPERATION"]   = "B",
          ["QUANTITY"]    = tostring(amount),
          ["PRICE"]       = string.format("%0.2f", price),
          ["TRANS_ID"]    = "1"
  }
  res = sendTransaction(t)
  return res
end

function Quik.sell(sec_code, price, amount)
    --local p = math.floor( price * SHIFT + 0.5 ) / SHIFT
  t = {
          ["CLASSCODE"]   = p_classcode,
          ["SECCODE"]     = sec_code,
          ["ACTION"]      = "NEW_ORDER",
          ["ACCOUNT"]     = "L01-00000F00",
          ["CLIENT_CODE"] = "346204",
          ["TYPE"]        = "L",
          ["OPERATION"]   = "S",
          ["QUANTITY"]    = tostring(amount),
          ["PRICE"]       = string.format("%0.2f", price),
          ["TRANS_ID"]    = "1"
  }
  res = sendTransaction(t)
  return res
end

return Quik