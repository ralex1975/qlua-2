local L = require "list"


local Meaner = {}

local margin      = 0
local lastBid     = 0
local lastAsk     = 0
local lastAskMean = 0
local lastBidMean = 0
local buyPrice    = 0
local brokerFee   = 0
local totalIncome = 0
local askList     = {}
local bidList     = {}
local waitPrice   = false
local quoteCounter = 0
local maxSell = 0

function Meaner.init(bid_size, ask_size)
	bidList = L.new(bid_size)
    askList = L.new(ask_size)
end

function Meaner.reset()
	margin      = 0
	lastBid     = 0
	lastAsk     = 0
	lastAskMean = 0
	lastBidMean = 0
	buyPrice    = 0
	brokerFee   = 0
	totalIncome = 0
	askList     = {}
	bidList     = {}
	waitPrice   = false
	quoteCounter = 0
	maxSell = 0

end

function Meaner.setMargin(mar)
	assert(type(mar) == "number", "setMargin expects margin as a number")
	assert(mar > 0, "setMargin expects positive margin")
	margin = 1 + mar/100 
end

function Meaner.setBrokerFee(fee)
	assert(type(fee) == "number", "setBrokerFee expects fee as a number")
	assert(fee > 0, "setBrokerFee expects positive fee")
	brokerFee = fee
end


function Meaner.getTotalIncome()
	return totalIncome
end

function Meaner.addQuote(bid, ask)
    -- Decide sell or buy
	assert(type(bid) == "number", "addQuote expects bid as a number")
	assert(type(ask) == "number", "addQuote expects ask as a number")
	
	assert(margin    > 0, "margin not set")
	assert(brokerFee > 0, "brokerFee not set")
	assert(next(bidList) ~= nil, "empty bid list")
	assert(next(askList) ~= nil, "empty ask list")

	quoteCounter = quoteCounter + 1

	--if quoteCounter % 10 ~= 0 then return 0 end
	
	L.pushright(bidList, bid)
	L.pushright(askList, ask)

	local isAskReady = L.isfull(askList)
	--if isAskReady then print("ask ready") end
	--return 0

	local askMean = L.mean(askList)
	local bidMean = L.mean(bidList)

	--print("buyPrice "..buyPrice.." bid_full: "..tostring(L.isfull(bidList)).." bidMean: "..bidMean.." askMean: "..askMean)

	local res = 0
	if buyPrice == 0 and waitPrice == false then
		if isAskReady and askMean < lastAskMean then
			waitPrice = true
			print("waiting price")
		end
	elseif waitPrice == true then
		if ask >= lastAsk then
			if askMean > lastAskMean then
				buyPrice = ask
				waitPrice = false
				res = 1
				print("Quote: "..quoteCounter.." buy for "..buyPrice)
				print("want sell for "..buyPrice * margin)
			end
		end
	elseif buyPrice > 0 and L.isfull(bidList) == true then
		--print("DBG sell: bid="..bid.." lastBid="..lastBid.." bidMean="..bidMean.." lastBidMean="..lastBidMean)
		if bid > maxSell then
			maxSell = bid
			print("max sell "..bid)
		end

		if bid <= lastBid then
			if bidMean < lastBidMean then
				--print("want sell for "..buyPrice * margin)
				if bid >= buyPrice * margin then
					res = -1
					totalIncome = totalIncome + (bid - buyPrice - brokerFee * 2)
					buyPrice = 0
					print("sell for "..bid)
				end
			end
		end
	end

	lastBid     = bid
	lastAsk     = ask
	lastAskMean = askMean
	lastBidMean = bidMean

	return res
end

return Meaner
