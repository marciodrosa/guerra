test_cards = {}

local cards = require "cards"
local territories = require "territories"

function test_cards.test_all_cards_territories_should_exist_in_territories_table()
	for i, card in ipairs(cards) do
		if card.territory ~= nil then
			lu.assertNotNil(territories[card.territory], string.format("Territory %s does not exist in the territories table.", card.territory))
		end
	end
end

function test_cards.test_all_territories_should_have_one_card()
	for territory_key, v in pairs(territories) do
		local count = 0
		for i, card in ipairs(cards) do
			if card.territory == territory_key then count = count + 1 end
		end
		lu.assertEquals(count, 1, string.format("The territory %s should appear in exactly one card.", territory_key))
	end
end

function test_cards.test_all_cards_should_have_valid_symbols()
	for i, card in ipairs(cards) do
		lu.assertTrue(card.symbol == "square" or card.symbol == "circle" or card.symbol == "triangle" or card.symbol == "any", string.format("The card symbol '%s' is invalid.", card.symbol))
	end
end
