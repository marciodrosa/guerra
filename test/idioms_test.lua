test_idioms = {}

local idioms = require "idioms"
local goals = require "goals"
local territories = require "territories"
local continents = require "continents"

function test_idioms.test_all_idioms_should_have_descriptions_for_all_goals()
	for idiom_key, idiom in pairs(idioms) do
		for goal_key, goal in pairs(goals) do
			lu.assertIsString(idiom.goals[goal_key], string.format("The idiom %s does not have the description for the goal %s", idiom_key, goal_key))
		end
	end
end

function test_idioms.test_all_idioms_should_have_descriptions_for_all_territories()
	for idiom_key, idiom in pairs(idioms) do
		for territory_key, territory in pairs(territories) do
			lu.assertIsString(idiom.territories[territory_key], string.format("The idiom %s does not have the description for the territory %s", idiom_key, territory_key))
		end
	end
end

function test_idioms.test_all_idioms_should_not_repeat_the_description_of_any_territory()
	for idiom_key, idiom in pairs(idioms) do
		for territory_key, territory_description in pairs(idiom.territories) do
			for territory_key2, territory_description2 in pairs(idiom.territories) do
				if territory_key ~= territory_key2 then
					lu.assertNotEquals(territory_description, territory_description2, string.format("The idiom %s does not have equal description for the territories %s and %s.", idiom_key, territory_key, territory_key2))
				end
			end
		end
	end
end

function test_idioms.test_all_idioms_should_have_descriptions_for_all_continents()
	for idiom_key, idiom in pairs(idioms) do
		for continent_key, continent in pairs(continents) do
			lu.assertIsString(idiom.continents[continent_key], string.format("The idiom %s does not have the description for the continent %s", idiom_key, continent_key))
		end
	end
end

function test_idioms.test_all_idioms_should_not_repeat_the_description_of_any_continent()
	for idiom_key, idiom in pairs(idioms) do
		for continent_key, continent_description in pairs(idiom.continents) do
			for continent_key2, continent_description2 in pairs(idiom.continents) do
				if continent_key ~= continent_key2 then
					lu.assertNotEquals(continent_description, continent_description2, string.format("The idiom %s does not have equal description for the continents %s and %s.", idiom_key, continent_key, continent_key2))
				end
			end
		end
	end
end
