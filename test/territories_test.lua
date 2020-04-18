test_territories = {}

local territories = require "territories"

local function does_territory_have_border(territory, border)
	for i, v in ipairs(territory.borders) do
		if v == border then return true end
	end
	return false
end

function test_territories.test_all_borders_should_exist_as_territories()
	for territory_key, territory in pairs(territories) do
		for border_index, border in ipairs(territory.borders) do
			lu.assertNotNil(territories[border], string.format("The border %s of the territory %s should also be a valid territory.", border, territory_key))
		end
	end
end

function test_territories.test_borders_must_match()
	for territory_key, territory in pairs(territories) do
		for border_index, border in ipairs(territory.borders) do
			local other_territory_key = border
			local other_territory = territories[other_territory_key]
			lu.assertTrue(does_territory_have_border(other_territory, territory_key), string.format("The territory %s is listing %s as a border, but the territory %s is not listing the territory %s as a border too.", territory_key, other_territory_key, other_territory_key, territory_key))
		end
	end
end

