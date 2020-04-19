-- Table that contains a function "new" that returns a new instance of a state with some default values filled.

local territories = require("territories")
local cards = require("cards")

return {

	-- Returns a new state table with a few default values and the following fields:
	-- - idiom: key to the idioms table.
	-- - players: empty list of players. It expects tables with field "name" and "army" (the army color).
	-- - current_player: current player index that is playing now.
	-- - round_started_by_player: the index of the player that started the current round.
	-- - round_number: the number of the current round.
	-- - number_of_traded_cards: the number of times a player traded his cards.
	-- - territories: current state of the territories in the board. Each key is the same key of the territories table.
	-- The value is a table with fields "owner_player" (the player index that owns the territory) and "armies" (the number
	-- of armies in the territory).
	-- - cards_on_table: array of indexes that points to the cards table.
	new = function()
		local state_instance = {
			idiom = "pt_br",
			players = {
			},
			current_player = 1,
			round_started_by_player = 1,
			round_number = 1,
			number_of_traded_cards = 0,
			territories = {
			},
			cards_on_table = {},
		}
		for k, v in pairs(territories) do
			state_instance.territories[k] = { owner_player = 1, armies = 0 }
		end
		for i, v in ipairs(cards) do
			state_instance.cards_on_table[i] = i
		end
		return state_instance
	end
}