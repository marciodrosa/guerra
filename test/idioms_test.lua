test_idioms = {}

local idioms = require "idioms"
local goals = require "goals"

function test_idioms.test_all_idioms_should_have_descriptions_for_all_goals()
	for idiom_key, idiom in pairs(idioms) do
		for goal_key, goal in pairs(goals) do
			lu.assertIsString(idiom.goals[goal_key], string.format("The idiom %s does not have the description for the goal %s", idiom_key, goal_key))
		end
	end
end