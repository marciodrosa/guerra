test_continents = {}

local continents = require "continents"
local territories = require "territories"

local function does_continent_have_territory(continent, territory)
	for i, v in ipairs(continent.territories) do
		if v == territory then return true end
	end
	return false
end

function test_continents.test_all_territories_should_exist_in_the_territories_table()
	for continent_key, continent in pairs(continents) do
		for i, territory_key in ipairs(continent.territories) do
			lu.assertNotNil(territories[territory_key], string.format("The territory %s is in continent %s, but not in the territories table.", territory_key, continent_key))
		end
	end
end

function test_continents.test_all_territories_in_the_territories_table_should_be_in_a_continent()
	for territory_key, territory in pairs(territories) do
		local found = false
		for continent_key, continent in pairs(continents) do
			if does_continent_have_territory(continent, territory_key) then
				found = true
				break
			end
		end
		lu.assertTrue(found, string.format("Territory %s was not found in any continent.", territory_key))
	end
end

function test_continents.test_all_continents_should_have_the_number_of_armies_to_add_when_are_conquered()
	for k, v in pairs(continents) do
		lu.assertIsNumber(v.armies_when_conquered, string.format("Continent %s should have the number of armies to add.", k))
	end
end
