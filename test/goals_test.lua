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

function test_goals.test_goal_defeat_red_army_should_return_true_if_it_was_defeated_by_the_player()
	-- given:
	local state = {
		players = {
			{ army = "blue" }, { army = "green" }, { army = "red", defeated_by_player = 2 }, { army = "black" },
		}
	}

	-- then:
	lu.assertTrue(goals.defeat_red_army.achieved(2, state))
end

function test_goals.test_goal_defeat_yellow_army_should_return_true_if_it_was_defeated_by_the_player()
	-- given:
	local state = {
		players = {
			{ army = "blue" }, { army = "green" }, { army = "yellow", defeated_by_player = 2 }, { army = "black" },
		}
	}

	-- then:
	lu.assertTrue(goals.defeat_yellow_army.achieved(2, state))
end

function test_goals.test_goal_defeat_white_army_should_return_true_if_it_was_defeated_by_the_player()
	-- given:
	local state = {
		players = {
			{ army = "blue" }, { army = "green" }, { army = "white", defeated_by_player = 2 }, { army = "black" },
		}
	}

	-- then:
	lu.assertTrue(goals.defeat_white_army.achieved(2, state))
end

function test_goals.test_goal_defeat_green_army_should_return_true_if_it_was_defeated_by_the_player()
	-- given:
	local state = {
		players = {
			{ army = "blue" }, { army = "white" }, { army = "green", defeated_by_player = 2 }, { army = "black" },
		}
	}

	-- then:
	lu.assertTrue(goals.defeat_green_army.achieved(2, state))
end

function test_goals.test_goal_defeat_black_army_should_return_true_if_it_was_defeated_by_the_player()
	-- given:
	local state = {
		players = {
			{ army = "blue" }, { army = "white" }, { army = "black", defeated_by_player = 2 }, { army = "green" },
		}
	}

	-- then:
	lu.assertTrue(goals.defeat_black_army.achieved(2, state))
end

function test_goals.test_goal_conquer_north_america_and_africa_should_be_achieved_if_both_continents_are_fully_conquered()
	-- given:
	local state = {
		territories = {
			alaska = { owner_player = 2 },
			mackenzie = { owner_player = 2 },
			greenland = { owner_player = 2 },
			vancouver = { owner_player = 2 },
			ottawa = { owner_player = 2 },
			labrador = { owner_player = 2 },
			california = { owner_player = 2 },
			new_york = { owner_player = 2 },
			mexico = { owner_player = 2 },
			algeria = { owner_player = 2 },
			egypt = { owner_player = 2 },
			sudan = { owner_player = 2 },
			congo = { owner_player = 2 },
			south_africa = { owner_player = 2 },
			madagascar = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertTrue(goals.conquer_north_america_and_africa.achieved(2, state))
end

function test_goals.test_goal_conquer_north_america_and_africa_should_not_be_achieved_if_some_territory_in_america_is_owned_by_other_player()
	-- given:
	local state = {
		territories = {
			alaska = { owner_player = 2 },
			mackenzie = { owner_player = 2 },
			greenland = { owner_player = 2 },
			vancouver = { owner_player = 2 },
			ottawa = { owner_player = 3 },
			labrador = { owner_player = 2 },
			california = { owner_player = 2 },
			new_york = { owner_player = 2 },
			mexico = { owner_player = 2 },
			algeria = { owner_player = 2 },
			egypt = { owner_player = 2 },
			sudan = { owner_player = 2 },
			congo = { owner_player = 2 },
			south_africa = { owner_player = 2 },
			madagascar = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_north_america_and_africa.achieved(2, state))
end

function test_goals.test_goal_conquer_north_america_and_africa_should_not_be_achieved_if_some_territory_in_africa_is_owned_by_other_player()
	-- given:
	local state = {
		territories = {
			alaska = { owner_player = 2 },
			mackenzie = { owner_player = 2 },
			greenland = { owner_player = 2 },
			vancouver = { owner_player = 2 },
			ottawa = { owner_player = 2 },
			labrador = { owner_player = 2 },
			california = { owner_player = 2 },
			new_york = { owner_player = 2 },
			mexico = { owner_player = 2 },
			algeria = { owner_player = 2 },
			egypt = { owner_player = 2 },
			sudan = { owner_player = 2 },
			congo = { owner_player = 3 },
			south_africa = { owner_player = 2 },
			madagascar = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_north_america_and_africa.achieved(2, state))
end

function test_goals.test_goal_conquer_north_america_and_africa_should_not_be_achieved_if_neither_of_the_continents_is_fully_conquered()
	-- given:
	local state = {
		territories = {
			alaska = { owner_player = 2 },
			mackenzie = { owner_player = 2 },
			greenland = { owner_player = 3 },
			vancouver = { owner_player = 2 },
			ottawa = { owner_player = 2 },
			labrador = { owner_player = 2 },
			california = { owner_player = 2 },
			new_york = { owner_player = 2 },
			mexico = { owner_player = 2 },
			algeria = { owner_player = 2 },
			egypt = { owner_player = 2 },
			sudan = { owner_player = 2 },
			congo = { owner_player = 3 },
			south_africa = { owner_player = 2 },
			madagascar = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_north_america_and_africa.achieved(2, state))
end

function test_goals.test_goal_conquer_asia_and_africa_should_be_achieved_if_both_continents_are_fully_conquered()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			algeria = { owner_player = 2 },
			egypt = { owner_player = 2 },
			sudan = { owner_player = 2 },
			congo = { owner_player = 2 },
			south_africa = { owner_player = 2 },
			madagascar = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertTrue(goals.conquer_asia_and_africa.achieved(2, state))
end

function test_goals.test_goal_conquer_asia_and_africa_should_not_be_achieved_if_some_territory_in_asia_is_conquered_by_other_player()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 3 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			algeria = { owner_player = 2 },
			egypt = { owner_player = 2 },
			sudan = { owner_player = 2 },
			congo = { owner_player = 2 },
			south_africa = { owner_player = 2 },
			madagascar = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_asia_and_africa.achieved(2, state))
end

function test_goals.test_goal_conquer_asia_and_africa_should_not_be_achieved_if_some_territory_in_africa_is_conquered_by_other_player()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			algeria = { owner_player = 2 },
			egypt = { owner_player = 2 },
			sudan = { owner_player = 2 },
			congo = { owner_player = 3 },
			south_africa = { owner_player = 2 },
			madagascar = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_asia_and_africa.achieved(2, state))
end

function test_goals.test_goal_conquer_north_america_and_oceania_should_be_achieved_if_both_continents_are_fully_conquered()
	-- given:
	local state = {
		territories = {
			alaska = { owner_player = 2 },
			mackenzie = { owner_player = 2 },
			greenland = { owner_player = 2 },
			vancouver = { owner_player = 2 },
			ottawa = { owner_player = 2 },
			labrador = { owner_player = 2 },
			california = { owner_player = 2 },
			new_york = { owner_player = 2 },
			mexico = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertTrue(goals.conquer_north_america_and_oceania.achieved(2, state))
end

function test_goals.test_goal_conquer_north_america_and_oceania_should_not_be_achieved_if_some_territory_in_america_is_conquered_by_other_player()
	-- given:
	local state = {
		territories = {
			alaska = { owner_player = 2 },
			mackenzie = { owner_player = 2 },
			greenland = { owner_player = 3 },
			vancouver = { owner_player = 2 },
			ottawa = { owner_player = 2 },
			labrador = { owner_player = 2 },
			california = { owner_player = 2 },
			new_york = { owner_player = 2 },
			mexico = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_north_america_and_oceania.achieved(2, state))
end

function test_goals.test_goal_conquer_north_america_and_oceania_should_not_be_achieved_if_some_territory_in_oceania_is_conquered_by_other_player()
	-- given:
	local state = {
		territories = {
			alaska = { owner_player = 2 },
			mackenzie = { owner_player = 2 },
			greenland = { owner_player = 2 },
			vancouver = { owner_player = 2 },
			ottawa = { owner_player = 2 },
			labrador = { owner_player = 2 },
			california = { owner_player = 2 },
			new_york = { owner_player = 2 },
			mexico = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 3 },
			australia = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_north_america_and_oceania.achieved(2, state))
end

function test_goals.test_goal_conquer_south_america_and_asia_should_be_achieved_if_both_continents_are_fully_conquered()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertTrue(goals.conquer_south_america_and_asia.achieved(2, state))
end

function test_goals.test_goal_conquer_south_america_and_asia_should_not_be_achieved_if_some_territory_in_asia_is_conquered_by_other_player()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 3 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_south_america_and_asia.achieved(2, state))
end

function test_goals.test_goal_conquer_south_america_and_asia_should_not_be_achieved_if_some_territory_in_south_america_is_conquered_by_other_player()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 3 },
			argentina = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertFalse(goals.conquer_south_america_and_asia.achieved(2, state))
end

function test_goals.test_goal_conquer_europe_and_south_america_and_other_should_be_achieved_if_both_continents_are_fully_conquered_and_one_more()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
			iceland = { owner_player = 2 },
			england = { owner_player = 2 },
			france = { owner_player = 2 },
			germany = { owner_player = 2 },
			sweden = { owner_player = 2 },
			moscow = { owner_player = 2 },
			poland = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertTrue(goals.conquer_europe_and_south_america_and_other.achieved(2, state))
end

function test_goals.test_goal_conquer_europe_and_south_america_and_other_should_be_achieved_if_both_continents_are_fully_conquered_and_two_more()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
			iceland = { owner_player = 2 },
			england = { owner_player = 2 },
			france = { owner_player = 2 },
			germany = { owner_player = 2 },
			sweden = { owner_player = 2 },
			moscow = { owner_player = 2 },
			poland = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
		}
	}
	
	-- then:
	lu.assertTrue(goals.conquer_europe_and_south_america_and_other.achieved(2, state))
end

function test_goals.test_goal_conquer_europe_and_south_america_and_other_should_not_be_achieved_if_three_continents_were_conquered_but_not_europe()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
			iceland = { owner_player = 3 },
			england = { owner_player = 2 },
			france = { owner_player = 2 },
			germany = { owner_player = 2 },
			sweden = { owner_player = 2 },
			moscow = { owner_player = 2 },
			poland = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
		}
	}
	
	-- then:
	lu.assertFalse(goals.conquer_europe_and_south_america_and_other.achieved(2, state))
end

function test_goals.test_goal_conquer_europe_and_south_america_and_other_should_not_be_achieved_if_three_continents_were_conquered_but_not_south_america()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 3 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
			iceland = { owner_player = 2 },
			england = { owner_player = 2 },
			france = { owner_player = 2 },
			germany = { owner_player = 2 },
			sweden = { owner_player = 2 },
			moscow = { owner_player = 2 },
			poland = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
		}
	}
	
	-- then:
	lu.assertFalse(goals.conquer_europe_and_south_america_and_other.achieved(2, state))
end

function test_goals.test_goal_conquer_europe_and_oceania_and_other_should_be_achieved_if_both_continents_are_fully_conquered_and_one_more()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
			iceland = { owner_player = 2 },
			england = { owner_player = 2 },
			france = { owner_player = 2 },
			germany = { owner_player = 2 },
			sweden = { owner_player = 2 },
			moscow = { owner_player = 2 },
			poland = { owner_player = 2 },
		}
	}

	-- then:
	lu.assertTrue(goals.conquer_europe_and_oceania_and_other.achieved(2, state))
end

function test_goals.test_goal_conquer_europe_and_oceania_and_other_should_be_achieved_if_both_continents_are_fully_conquered_and_two_more()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
			iceland = { owner_player = 2 },
			england = { owner_player = 2 },
			france = { owner_player = 2 },
			germany = { owner_player = 2 },
			sweden = { owner_player = 2 },
			moscow = { owner_player = 2 },
			poland = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
		}
	}
	
	-- then:
	lu.assertTrue(goals.conquer_europe_and_oceania_and_other.achieved(2, state))
end

function test_goals.test_goal_conquer_europe_and_oceania_and_other_should_not_be_achieved_if_three_continents_were_conquered_but_not_europe()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
			iceland = { owner_player = 3 },
			england = { owner_player = 2 },
			france = { owner_player = 2 },
			germany = { owner_player = 2 },
			sweden = { owner_player = 2 },
			moscow = { owner_player = 2 },
			poland = { owner_player = 2 },
			sumatra = { owner_player = 2 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
		}
	}
	
	-- then:
	lu.assertFalse(goals.conquer_europe_and_oceania_and_other.achieved(2, state))
end

function test_goals.test_goal_conquer_europe_and_oceania_and_other_should_not_be_achieved_if_three_continents_were_conquered_but_not_oceania()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2 },
			aral = { owner_player = 2 },
			middle_east = { owner_player = 2 },
			dudinka = { owner_player = 2 },
			siberia = { owner_player = 2 },
			tchita = { owner_player = 2 },
			mongolia = { owner_player = 2 },
			china = { owner_player = 2 },
			india = { owner_player = 2 },
			vietnam = { owner_player = 2 },
			vladivostok = { owner_player = 2 },
			japan = { owner_player = 2 },
			venezuela = { owner_player = 2 },
			brazil = { owner_player = 2 },
			peru = { owner_player = 2 },
			argentina = { owner_player = 2 },
			iceland = { owner_player = 2 },
			england = { owner_player = 2 },
			france = { owner_player = 2 },
			germany = { owner_player = 2 },
			sweden = { owner_player = 2 },
			moscow = { owner_player = 2 },
			poland = { owner_player = 2 },
			sumatra = { owner_player = 3 },
			borneo = { owner_player = 2 },
			new_guinea = { owner_player = 2 },
			australia = { owner_player = 2 },
		}
	}
	
	-- then:
	lu.assertFalse(goals.conquer_europe_and_oceania_and_other.achieved(2, state))
end

function test_goals.test_goal_conquer_18_territories_with_2_armies_in_each_should_be_achieved()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2, armies = 2 },
			aral = { owner_player = 2, armies = 2 },
			middle_east = { owner_player = 2, armies = 2 },
			dudinka = { owner_player = 2, armies = 3 },
			siberia = { owner_player = 2, armies = 2 },
			tchita = { owner_player = 2, armies = 2 },
			mongolia = { owner_player = 2, armies = 2 },
			china = { owner_player = 2, armies = 3 },
			india = { owner_player = 2, armies = 2 },
			vietnam = { owner_player = 2, armies = 2 },
			vladivostok = { owner_player = 2, armies = 3 },
			japan = { owner_player = 2, armies = 2 },
			venezuela = { owner_player = 2, armies = 2 },
			brazil = { owner_player = 2, armies = 2 },
			peru = { owner_player = 2, armies = 3 },
			argentina = { owner_player = 2, armies = 2 },
			iceland = { owner_player = 2, armies = 2 },
			england = { owner_player = 2, armies = 2 },
		}
	}
	
	-- then:
	lu.assertTrue(goals.conquer_18_territories_with_2_armies_in_each.achieved(2, state))
end

function test_goals.test_goal_conquer_18_territories_with_2_armies_in_each_should_be_achieved_with_more_than_18_territories()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2, armies = 2 },
			aral = { owner_player = 2, armies = 2 },
			middle_east = { owner_player = 2, armies = 2 },
			dudinka = { owner_player = 2, armies = 3 },
			siberia = { owner_player = 2, armies = 2 },
			tchita = { owner_player = 2, armies = 2 },
			mongolia = { owner_player = 2, armies = 2 },
			china = { owner_player = 2, armies = 3 },
			india = { owner_player = 2, armies = 2 },
			vietnam = { owner_player = 2, armies = 2 },
			vladivostok = { owner_player = 2, armies = 3 },
			japan = { owner_player = 2, armies = 2 },
			venezuela = { owner_player = 2, armies = 2 },
			brazil = { owner_player = 2, armies = 2 },
			peru = { owner_player = 2, armies = 3 },
			argentina = { owner_player = 2, armies = 2 },
			iceland = { owner_player = 2, armies = 2 },
			england = { owner_player = 2, armies = 2 },
			germany = { owner_player = 2, armies = 2 },
		}
	}
	
	-- then:
	lu.assertTrue(goals.conquer_18_territories_with_2_armies_in_each.achieved(2, state))
end

function test_goals.test_goal_conquer_18_territories_with_2_armies_in_each_should_not_be_achieved_if_less_than_18_territories()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2, armies = 2 },
			aral = { owner_player = 2, armies = 2 },
			middle_east = { owner_player = 2, armies = 2 },
			dudinka = { owner_player = 2, armies = 3 },
			siberia = { owner_player = 2, armies = 2 },
			tchita = { owner_player = 2, armies = 2 },
			mongolia = { owner_player = 2, armies = 2 },
			china = { owner_player = 2, armies = 3 },
			india = { owner_player = 2, armies = 2 },
			vietnam = { owner_player = 2, armies = 2 },
			vladivostok = { owner_player = 2, armies = 3 },
			japan = { owner_player = 2, armies = 2 },
			venezuela = { owner_player = 2, armies = 2 },
			brazil = { owner_player = 2, armies = 2 },
			peru = { owner_player = 2, armies = 3 },
			argentina = { owner_player = 2, armies = 2 },
			iceland = { owner_player = 2, armies = 2 },
		}
	}
	
	-- then:
	lu.assertFalse(goals.conquer_18_territories_with_2_armies_in_each.achieved(2, state))
end

function test_goals.test_goal_conquer_18_territories_with_2_armies_in_each_should_not_be_achieved_if_there_are_18_conquered_territories_but_some_does_not_have_two_armies_in_it()
	-- given:
	local state = {
		territories = {
			omsk = { owner_player = 2, armies = 2 },
			aral = { owner_player = 2, armies = 2 },
			middle_east = { owner_player = 2, armies = 2 },
			dudinka = { owner_player = 2, armies = 3 },
			siberia = { owner_player = 2, armies = 2 },
			tchita = { owner_player = 2, armies = 2 },
			mongolia = { owner_player = 2, armies = 2 },
			china = { owner_player = 2, armies = 3 },
			india = { owner_player = 2, armies = 2 },
			vietnam = { owner_player = 2, armies = 2 },
			vladivostok = { owner_player = 2, armies = 1 },
			japan = { owner_player = 2, armies = 2 },
			venezuela = { owner_player = 2, armies = 2 },
			brazil = { owner_player = 2, armies = 2 },
			peru = { owner_player = 2, armies = 3 },
			argentina = { owner_player = 2, armies = 2 },
			iceland = { owner_player = 2, armies = 2 },
			england = { owner_player = 2, armies = 2 },
		}
	}
	
	-- then:
	lu.assertFalse(goals.conquer_18_territories_with_2_armies_in_each.achieved(2, state))
end


