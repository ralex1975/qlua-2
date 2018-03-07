local L = require "list"


local Statgainer = {}

-- local margin      = 0
local maxBid     = 0
local minAsk     = 0
local maxDif    = 0
-- local lastAskMean = 0
-- local lastBidMean = 0
-- local buyPrice    = 0
-- local brokerFee   = 0
-- local totalIncome = 0
-- local askList     = {}
-- local bidList     = {}
-- local waitPrice   = false
 local quoteCounter = 0
-- local maxSell = 0

-- function Meaner.init(bid_size, ask_size)
-- 	bidList = L.new(bid_size)
--     askList = L.new(ask_size)
-- end

function Statgainer.reset()
	-- margin      = 0
	maxBid     = 0
	minAsk     = 0
	maxDif    = 0
	-- lastAskMean = 0
	-- lastBidMean = 0
	-- buyPrice    = 0
	-- brokerFee   = 0
	-- totalIncome = 0
	-- askList     = {}
	-- bidList     = {}
	-- waitPrice   = false
	 quoteCounter = 0
	-- maxSell = 0

end

-- function Meaner.setMargin(mar)
-- 	assert(type(mar) == "number", "setMargin expects margin as a number")
-- 	assert(mar > 0, "setMargin expects positive margin")
-- 	margin = 1 + mar/100 
-- end

-- function Meaner.setBrokerFee(fee)
-- 	assert(type(fee) == "number", "setBrokerFee expects fee as a number")
-- 	assert(fee > 0, "setBrokerFee expects positive fee")
-- 	brokerFee = fee
-- end


-- function Meaner.getTotalIncome()
-- 	return totalIncome
-- end

function Statgainer.addQuote(bid, ask)
    -- Decide sell or buy
	assert(type(bid) == "number", "addQuote expects bid as a number")
	assert(type(ask) == "number", "addQuote expects ask as a number")
	
	-- assert(margin    > 0, "margin not set")
	-- assert(brokerFee > 0, "brokerFee not set")
	-- assert(next(bidList) ~= nil, "empty bid list")
	-- assert(next(askList) ~= nil, "empty ask list")

	quoteCounter = quoteCounter + 1
	
	if bid > maxBid then
		maxBid = bid
	end
	if minAsk  == 0 then minAsk = ask end
	if ask < minAsk then
		print("new min. Last dif "..maxDif)
		minAsk = ask
		maxBid = 0
		maxDif = 0
	end
	local curDif = maxBid - minAsk;
	if maxBid > 0 and curDif > maxDif then
		maxDif = curDif
		print("At "..quoteCounter.." new dif "..curDif)
	end
    --lastDif = maxBid - minAsk;
	-- --if quoteCounter % 10 ~= 0 then return 0 end
	
	-- -- L.pushright(bidList, bid)
	-- -- L.pushright(askList, ask)

	-- local isAskReady = L.isfull(askList)
	-- --if isAskReady then print("ask ready") end
	-- --return 0

	-- local askMean = L.mean(askList)
	-- local bidMean = L.mean(bidList)

	-- local res = 0
	-- if buyPrice == 0 and waitPrice == false then
	-- 	if isAskReady then
	-- 		waitPrice = true
	-- 		print("waiting price")
	-- 	end
	-- elseif waitPrice == true then
	-- 	if ask >= lastAsk then
	-- 		if askMean > lastAskMean then
	-- 			buyPrice = ask
	-- 			waitPrice = false
	-- 			res = 1
	-- 			print("Quote: "..quoteCounter.." buy for "..buyPrice)
	-- 		end
	-- 	end
	-- elseif buyPrice > 0 and L.isfull(bidList) == true then
	-- 	if bid > maxSell then
	-- 		maxSell = bid
	-- 		print("max sell "..bid)
	-- 	end
	-- 	if bid <= lastBid then
	-- 		if bidMean < lastBidMean then
	-- 			if bid >= buyPrice * margin then
	-- 				res = -1
	-- 				totalIncome = totalIncome + (bid - buyPrice - brokerFee * 2)
	-- 				buyPrice = 0
	-- 				print("sell for "..bid)
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- lastBid     = bid
	-- lastAsk     = ask
	-- lastAskMean = askMean
	-- lastBidMean = bidMean

	-- return res
end

return Statgainer
