-- Table which each value is the number or armies to add to the player when trading cards,
-- and the key is the trade number (first trade of the game, second trade, third trade...).
local trades = {
	[1] = 4,
	[2] = 6,
	[3] = 8,
	[4] = 10,
	[5] = 12,
	[6] = 15
}

local trades_metatable = {
	__index = function(table, key)
		return ((key - 6) * 5) + 15
	end
}

setmetatable(trades, trades_metatable)

return trades