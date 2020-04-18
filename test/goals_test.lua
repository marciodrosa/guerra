test_goals = {}

local goals = require "goals"
local territories = require "territories"

local function put_territories_owned_by_player_in_state(territories_count, player, state)
	state.territories = {}
	local count = 0
	for k, v in pairs(territories) do
		count = count + 1
		state.territories[k] = {
			owner_player = player
		}
		if count == territories_count then break end
	end
end

function test_goals.test_goal_defeat_blue_army_should_return_true_if_it_was_defeated_by_the_player()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "green" }, { army = "blue", defeated_by_player = 2 }, { army = "black" },
		}
	}

	-- then:
	lu.assertTrue(goals.defeat_blue_army.achieved(2, state))
end

function test_goals.test_goal_defeat_blue_army_should_return_false_if_it_was_not_defeated_at_all()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "green" }, { army = "blue" }, { army = "black" },
		}
	}

	-- then:
	lu.assertFalse(goals.defeat_blue_army.achieved(2, state))
end

function test_goals.test_goal_defeat_blue_army_should_return_false_if_it_was_defeated_by_another_player()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "green" }, { army = "blue", defeated_by_player = 4 }, { army = "black" },
		},
		territories = {}
	}

	-- then:
	lu.assertFalse(goals.defeat_blue_army.achieved(2, state))
end

function test_goals.test_goal_defeat_blue_army_should_return_true_if_blue_army_is_unavailable_and_24_territories_were_conquered()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "green" }, { army = "black" },
		}
	}
	put_territories_owned_by_player_in_state(24, 2, state)

	-- then:
	lu.assertTrue(goals.defeat_blue_army.achieved(2, state))
end

function test_goals.test_goal_defeat_blue_army_should_return_true_if_blue_army_was_defeated_by_other_player_and_24_territories_were_conquered()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "green" }, { army = "blue", defeated_by_player = 4 }, { army = "black" },
		}
	}
	put_territories_owned_by_player_in_state(24, 2, state)

	-- then:
	lu.assertTrue(goals.defeat_blue_army.achieved(2, state))
end

function test_goals.test_goal_defeat_blue_army_should_return_true_if_blue_is_the_player_and_24_territories_were_conquered()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "blue" }, { army = "black" }
		}
	}
	put_territories_owned_by_player_in_state(24, 2, state)

	-- then:
	lu.assertTrue(goals.defeat_blue_army.achieved(2, state))
end

function test_goals.test_goal_defeat_blue_army_should_return_true_if_blue_army_cant_be_defeated_and_more_than_24_territories_were_conquered()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "green" }, { army = "black" },
		}
	}
	put_territories_owned_by_player_in_state(25, 2, state)

	-- then:
	lu.assertTrue(goals.defeat_blue_army.achieved(2, state))
end

function test_goals.test_goal_defeat_blue_army_should_return_false_if_blue_army_cant_be_defeated_and_less_than_24_territories_were_conquered()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "green" }, { army = "black" },
		}
	}
	put_territories_owned_by_player_in_state(23, 2, state)

	-- then:
	lu.assertFalse(goals.defeat_blue_army.achieved(2, state))
end

function test_goals.test_goal_defeat_blue_army_should_return_false_if_24_territories_were_conquered_but_the_blue_army_still_can_be_defeated()
	-- given:
	local state = {
		players = {
			{ army = "red" }, { army = "green" }, { army = "blue" }, { army = "black" },
		}
	}
	put_territories_owned_by_player_in_state(24, 2, state)

	-- then:
	lu.assertFalse(goals.defeat_blue_army.achieved(2, state))
end
