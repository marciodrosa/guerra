test_state = {}

local state = require "state"
local idioms = require "idioms"
local territories = require "territories"
local cards = require "cards"

function test_state.test_should_create_new_state()
	-- given:
	local s = state.new()

	-- then:
	lu.assertIsTable(idioms[s.idiom], "The idiom field should be a key in the idioms table.")
	lu.assertIsTable(s.players)
	lu.assertEquals(s.current_player, 1)
	lu.assertEquals(s.round_started_by_player, 1)
	lu.assertEquals(s.round_number, 1)
	lu.assertEquals(s.number_of_traded_cards, 0)
	for territory_key, territory in pairs(s.territories) do
		lu.assertNotNil(territories[territory_key], "All state.territories keys should also be a key in the territories table.")
		lu.assertEquals(territory.owner_player, 1)
		lu.assertEquals(territory.armies, 0)
	end
	lu.assertEquals(#s.cards_on_table, #cards, "The cards on table should have the same count of the cards table.")
	for i, v in ipairs(s.cards_on_table) do
		lu.assertEquals(v, i)
	end
end
