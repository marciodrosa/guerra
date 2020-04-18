test_trades = {}

local trades = require "trades"

function test_trades.test_number_of_armies_by_trade()
	lu.assertEquals(trades[1], 4)
	lu.assertEquals(trades[2], 6)
	lu.assertEquals(trades[3], 8)
	lu.assertEquals(trades[4], 10)
	lu.assertEquals(trades[5], 12)
	lu.assertEquals(trades[6], 15)
	lu.assertEquals(trades[7], 20)
	lu.assertEquals(trades[8], 25)
	lu.assertEquals(trades[9], 30)
	lu.assertEquals(trades[10], 35)
	lu.assertEquals(trades[11], 40)
	lu.assertEquals(trades[12], 45)
end
