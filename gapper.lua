

local Gapper = {}

local margin      = 0
local lastBid     = 0
local lastAsk     = 0
local maxGap      = 0
local buyPrice    = 0
local brokerFee   = 0
local totalIncome = 0

function Gapper.reset()
	margin      = 0
	lastBid     = 0
	lastAsk     = 0
	maxGap      = 0
	buyPrice    = 0
	brokerFee   = 0
	totalIncome = 0
end

function Gapper.setMargin(mar)
	assert(type(mar) == "number", "setMargin expects margin as a number")
	assert(mar > 0, "setMargin expects positive margin")
	margin = mar
end

function Gapper.setBrokerFee(fee)
	assert(type(fee) == "number", "setBrokerFee expects fee as a number")
	assert(fee > 0, "setBrokerFee expects positive fee")
	brokerFee = fee
end

function Gapper.setMaxGap(gap)
	assert(type(gap) == "number", "setMaxGap expects gap as a number")
	assert(gap > 0, "setMaxGap expects positive gap")
	maxGap = gap
end

function Gapper.getTotalIncome()
	return totalIncome
end

function Gapper.addQuote(bid, ask)
    -- Decide sell or buy
	assert(type(bid) == "number", "addQuote expects bid as a number")
	assert(type(ask) == "number", "addQuote expects ask as a number")

	assert(maxGap    > 0, "maxGap not set")
	assert(margin    > 0, "margin not set")
	assert(brokerFee > 0, "brokerFee not set")

	res = 0
	if buyPrice == 0 and lastAsk > ask + maxGap then
		res = 1
		buyPrice = ask
	elseif buyPrice > 0 and bid >= buyPrice + brokerFee * 2 + margin then
		res = -1
		buyPrice = 0
		totalIncome = totalIncome + (bid - buyPrice - brokerFee * 2)
	end
	lastBid = bid
	lastAsk = ask
	return res
end

return Gapper
