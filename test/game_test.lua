test_game = {}

local game = require "game"
local goals = require "goals"
local territories = require "territories"
local cards = require "cards"

function test_game.test_should_create_new_instance()
	-- given:
	local g = game.new()

	-- then:
	lu.assertIsTable(g.state)
	lu.assertIsFunction(g.enter_player)
	lu.assertIsFunction(g.start)
end

function test_game.test_should_enter_players()
	-- given:
	local g = game.new()

	-- when:
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "white")
	g.enter_player("Ringo", "blue")

	-- then:
	lu.assertEquals(g.state.players[1].name, "John")
	lu.assertEquals(g.state.players[1].army, "red")
	lu.assertEquals(g.state.players[2].name, "Paul")
	lu.assertEquals(g.state.players[2].army, "black")
	lu.assertEquals(g.state.players[3].name, "George")
	lu.assertEquals(g.state.players[3].army, "white")
	lu.assertEquals(g.state.players[4].name, "Ringo")
	lu.assertEquals(g.state.players[4].army, "blue")
end

function test_game.test_should_not_enter_new_player_if_6_already_entered()
	-- given:
	local g = game.new()

	-- when:
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "white")
	g.enter_player("Ringo", "blue")
	g.enter_player("Yoko", "green")
	g.enter_player("Michael Jackson", "yellow")
	g.enter_player("Stallone", "red")

	-- then:
	lu.assertEquals(g.state.players[1].name, "John")
	lu.assertEquals(g.state.players[2].name, "Paul")
	lu.assertEquals(g.state.players[3].name, "George")
	lu.assertEquals(g.state.players[4].name, "Ringo")
	lu.assertEquals(g.state.players[5].name, "Yoko")
	lu.assertEquals(g.state.players[6].name, "Michael Jackson")
	lu.assertNil(g.state.players[7])
end

function test_game.test_should_not_enter_player_if_name_is_already_in_use()
	-- given:
	local g = game.new()

	-- when:
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "white")
	g.enter_player("Paul", "yellow")

	-- then:
	lu.assertEquals(g.state.players[1].name, "John")
	lu.assertEquals(g.state.players[2].name, "Paul")
	lu.assertEquals(g.state.players[3].name, "George")
	lu.assertNil(g.state.players[4])
end

function test_game.test_should_not_enter_player_if_army_is_already_in_use()
	-- given:
	local g = game.new()

	-- when:
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "black")

	-- then:
	lu.assertEquals(g.state.players[1].name, "John")
	lu.assertEquals(g.state.players[2].name, "Paul")
	lu.assertNil(g.state.players[3])
end

function test_game.test_should_not_enter_player_if_army_color_is_unknow()
	-- given:
	local g = game.new()

	-- when:
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "silver")

	-- then:
	lu.assertEquals(g.state.players[1].name, "John")
	lu.assertEquals(g.state.players[2].name, "Paul")
	lu.assertNil(g.state.players[3])
end

function test_game.test_should_draw_starter_player_when_start()
	-- given:
	local g = game.new()
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "white")
	g.enter_player("Ringo", "blue")

	-- when:
	g.start()

	-- then:
	lu.assertTrue(g.state.current_player >= 1 and g.state.current_player <= 4)
	lu.assertEquals(g.state.current_player, g.state.round_started_by_player)
end

function test_game.test_should_distribute_valid_goals_to_players_when_start()
	-- given:
	local g = game.new()
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "white")
	g.enter_player("Ringo", "blue")

	-- when:
	g.start()

	-- then:
	for i, player in ipairs(g.state.players) do
		lu.assertNotNil(goals[player.goal], "The player goal should be available in the goals table.")
	end
end

function test_game.test_should_not_distribute_the_same_goal_to_different_players()
	-- given:
	local g = game.new()
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "white")
	g.enter_player("Ringo", "blue")

	-- when:
	g.start()

	-- then:
	lu.assertNotEquals(g.state.players[1].goal, g.state.players[2].goal)
	lu.assertNotEquals(g.state.players[1].goal, g.state.players[3].goal)
	lu.assertNotEquals(g.state.players[1].goal, g.state.players[4].goal)
	lu.assertNotEquals(g.state.players[2].goal, g.state.players[3].goal)
	lu.assertNotEquals(g.state.players[2].goal, g.state.players[4].goal)
	lu.assertNotEquals(g.state.players[3].goal, g.state.players[4].goal)
end

function test_game.test_should_distribute_territories_among_players_when_start()
	-- given:
	local g = game.new()
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "white")
	g.enter_player("Ringo", "blue")

	-- when:
	g.start()

	-- then:
	for territory_key, territory in pairs(territories) do
		lu.assertNotNil(g.state.territories[territory_key])
		lu.assertTrue(g.state.territories[territory_key].owner_player >= 1 and g.state.territories[territory_key].owner_player <= 4)
		lu.assertEquals(g.state.territories[territory_key].armies, 1)
	end
end

function test_game.test_should_distribute_42_territories_evenly_among_players_starting_with_the_player_that_will_start_the_game()
	-- given:
	local g = game.new()
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")
	g.enter_player("George", "white")
	g.enter_player("Ringo", "blue")

	-- when:
	g.start()

	-- then:
	local players_territories_count = {
		[1] = 0, [2] = 0, [3] = 0, [4] = 0
	}
	for territory_key, territory in pairs(g.state.territories) do
		players_territories_count[territory.owner_player] = players_territories_count[territory.owner_player] + 1
	end
	if g.state.current_player == 1 then
		lu.assertEquals(players_territories_count[1], 11)
		lu.assertEquals(players_territories_count[2], 11)
		lu.assertEquals(players_territories_count[3], 10)
		lu.assertEquals(players_territories_count[4], 10)
	elseif g.state.current_player == 2 then
		lu.assertEquals(players_territories_count[2], 11)
		lu.assertEquals(players_territories_count[3], 11)
		lu.assertEquals(players_territories_count[4], 10)
		lu.assertEquals(players_territories_count[1], 10)
	elseif g.state.current_player == 3 then
		lu.assertEquals(players_territories_count[3], 11)
		lu.assertEquals(players_territories_count[4], 11)
		lu.assertEquals(players_territories_count[1], 10)
		lu.assertEquals(players_territories_count[2], 10)
	elseif g.state.current_player == 4 then
		lu.assertEquals(players_territories_count[4], 11)
		lu.assertEquals(players_territories_count[1], 11)
		lu.assertEquals(players_territories_count[2], 10)
		lu.assertEquals(players_territories_count[3], 10)
	end
end

function test_game.test_should_shuffle_and_put_cards_on_the_table_when_start_game()
	-- given:
	local g = game.new()
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")

	-- when:
	g.start()

	-- then:
	lu.assertEquals(#g.state.cards_on_table, #cards)
	for i, v in ipairs(g.state.cards_on_table) do
		lu.assertIsNumber(v, "All values in the cards_on_table field should be an index to the cards table.")
		lu.assertTrue(v >= 1 and v <= #cards, "The value in the cards_on_table should be an index in range of the cards table.")
		for i2, v2 in ipairs(g.state.cards_on_table) do
			if i ~= i2 then
				lu.assertNotEquals(v, v2, "The cards_on_table should not have repeated numbers.")
			end
		end
	end
end

function test_game.test_should_set_status_to_arrange_armies_after_start_the_game()
	-- given:
	local g = game.new()
	g.enter_player("John", "red")
	g.enter_player("Paul", "black")

	-- when:
	g.start()

	-- then:
	lu.assertEquals(g.state.status, "arrange_armies")
end

function test_game.test_should_not_start_game_if_there_is_less_then_two_players()
	-- given:
	local g = game.new()
	g.enter_player("John", "red")

	-- when:
	g.start()

	-- then:
	lu.assertEquals(g.state.status, "not_started")
end

function test_game.test_should_put_enemies_in_territory()
	-- given:
	local g = game.new()
	g.state.status = "arrange_armies"
	g.state.current_player = 2
	g.state.round_started_by_player = 1
	g.state.territories = {
		brazil = {
			owner_player = 2,
			armies = 5
		}
	}
	g.state.armies_arrangement.total_armies_to_put = 4
	g.state.armies_arrangement.remaining_armies_to_put = 4

	-- when:
	g.put(3, "brazil")

	-- then:
	lu.assertEquals(g.state.armies_arrangement.total_armies_to_put, 4, "Should keep the number of total armies to put.")
	lu.assertEquals(g.state.armies_arrangement.remaining_armies_to_put, 1, "Should update the number of remaining armies to put.")
	lu.assertEquals(g.state.armies_arrangement.armies_placed_by_territory.brazil, 3, "Should add the number of armies placed in the territory.")
	lu.assertEquals(g.state.status, "arrange_armies", "Should still be in the arrange_armies status mode.")
	lu.assertEquals(g.state.current_player, 2, "Should not change the current player.")
	lu.assertEquals(g.state.territories.brazil.armies, 5, "Should not commit the placement in the territories until finish the arrangement.")
end

function test_game.test_should_put_enemies_in_territory_more_than_once()
	-- given:
	local g = game.new()
	g.state.status = "arrange_armies"
	g.state.current_player = 2
	g.state.round_started_by_player = 1
	g.state.territories = {
		brazil = {
			owner_player = 2,
			armies = 5
		},
		moscow = {
			owner_player = 2,
			armies = 1
		}
	}
	g.state.armies_arrangement.total_armies_to_put = 20
	g.state.armies_arrangement.remaining_armies_to_put = 20

	-- when:
	g.put(3, "brazil")
	g.put(2, "brazil")
	g.put(1, "moscow")

	-- then:
	lu.assertEquals(g.state.armies_arrangement.remaining_armies_to_put, 14, "Should update the number of remaining armies to put.")
	lu.assertEquals(g.state.armies_arrangement.armies_placed_by_territory.brazil, 5, "Should add the number of armies placed in the territory.")
	lu.assertEquals(g.state.armies_arrangement.armies_placed_by_territory.moscow, 1, "Should add the number of armies placed in the territory.")
end

function test_game.test_should_not_put_enemies_in_territory_if_not_validated_because_territory_is_owned_by_another_player()
	-- given:
	local g = game.new()
	g.state.status = "arrange_armies"
	g.state.current_player = 2
	g.state.round_started_by_player = 1
	g.state.territories = {
		brazil = {
			owner_player = 3,
			armies = 4
		},
		moscow = {
			owner_player = 2,
			armies = 2
		}
	}
	g.state.armies_arrangement.total_armies_to_put = 10
	g.state.armies_arrangement.remaining_armies_to_put = 10

	-- when:
	g.put(3, "brazil")

	-- then:
	lu.assertEquals(g.state.armies_arrangement.total_armies_to_put, 10, "Should keep the number of total armies to put.")
	lu.assertEquals(g.state.armies_arrangement.remaining_armies_to_put, 10, "Should not update the number of remaining armies to put.")
	lu.assertEquals(g.state.armies_arrangement.armies_placed_by_territory.brazil, nil, "Should not have armies in Brazil.")
	lu.assertEquals(g.state.status, "arrange_armies", "Should still be in the arrange_armies status mode.")
	lu.assertEquals(g.state.current_player, 2, "Should not change the current player.")
end

function test_game.test_should_commit_and_pass_to_next_player_after_put_all_armies()
	-- given:
	local g = game.new()
	g.state.status = "arrange_armies"
	g.state.players = {
		{ name = "John", army = "red" },
		{ name = "Paul", army = "blue" },
		{ name = "Ringo", army = "green" },
	}
	g.state.current_player = 2
	g.state.round_started_by_player = 1
	g.state.territories = {
		brazil = {
			owner_player = 2,
			armies = 5
		},
		moscow = {
			owner_player = 2,
			armies = 3
		}
	}
	g.state.armies_arrangement.total_armies_to_put = 10
	g.state.armies_arrangement.remaining_armies_to_put = 10

	-- when:
	g.put(5, "brazil")
	g.put(5, "moscow")

	-- then:
	lu.assertEquals(g.state.status, "arrange_armies", "Should still be in the arrange_armies status mode.")
	lu.assertEquals(g.state.current_player, 3, "Should change to the next player.")
	lu.assertEquals(g.state.territories.brazil.armies, 10, "Should commit the placement in the territories after finish the arrangement.")
	lu.assertEquals(g.state.territories.moscow.armies, 8, "Should commit the placement in the territories after finish the arrangement.")
end

function test_game.test_should_init_battle_after_the_last_player_put_his_armies()
	-- given:
	local g = game.new()
	g.state.status = "arrange_armies"
	g.state.players = {
		{ name = "John", army = "red" },
		{ name = "Paul", army = "blue" },
		{ name = "Ringo", army = "green" },
	}
	g.state.current_player = 2
	g.state.round_started_by_player = 3
	g.state.territories = {
		brazil = {
			owner_player = 2,
			armies = 5
		},
	}
	g.state.armies_arrangement.total_armies_to_put = 10
	g.state.armies_arrangement.remaining_armies_to_put = 10

	-- when:
	g.put(10, "brazil")

	-- then:
	lu.assertEquals(g.state.status, "battle", "Should go to the battle mode.")
	lu.assertEquals(g.state.current_player, 3, "Should change to the initial player to start the battle.")
	lu.assertEquals(g.state.territories.brazil.armies, 15, "Should commit the placement in the territories after finish the arrangement.")
end

function test_game.test_should_init_armies_arrangement_when_pass_to_the_next_player()
	-- given:
	local g = game.new()
	g.state.status = "arrange_armies"
	g.state.players = {
		{ name = "John", army = "red" },
		{ name = "Paul", army = "blue" },
		{ name = "Ringo", army = "green" },
	}
	g.state.current_player = 2
	g.state.round_started_by_player = 1
	g.state.territories = {
		dudinka = { owner_player = 2, armies = 5 },
		peru = { owner_player = 2, armies = 5 },
		brazil = { owner_player = 3, armies = 5 },
		argentina = { owner_player = 3, armies = 5 },
		venezuela = { owner_player = 3, armies = 5 },
		algeria = { owner_player = 3, armies = 5 },
		egypt = { owner_player = 3, armies = 5 },
		sudan = { owner_player = 3, armies = 5 },
		congo = { owner_player = 3, armies = 5 },
		south_africa = { owner_player = 3, armies = 5 },
		madagascar = { owner_player = 3, armies = 5 },
		sumatra = { owner_player = 3, armies = 5 },
		borneo = { owner_player = 3, armies = 5 },
		australia = { owner_player = 3, armies = 5 },
		new_guinea = { owner_player = 3, armies = 5 },
	}
	g.state.armies_arrangement.total_armies_to_put = 10
	g.state.armies_arrangement.remaining_armies_to_put = 10

	-- when:
	g.put(10, "dudinka")

	-- then:
	lu.assertEquals(g.state.status, "arrange_armies", "Should still be in the arrange_armies status mode.")
	lu.assertEquals(g.state.current_player, 3, "Should change to the next player.")
	lu.assertEquals(g.state.armies_arrangement.total_armies_to_put, 6, "Should calculate the armies for player 3 to put by dividing the territories count by 2.")
	lu.assertItemsEquals(g.state.armies_arrangement.armies_to_put_by_territory, {}, "Player 3 is not bound to put armies in a territory unless he trade cards.")
	lu.assertEquals(g.state.armies_arrangement.armies_to_put_by_continent.oceania, 2, "Should put 2 armies in Oceania because the player 3 owns that continent.")
	lu.assertEquals(g.state.armies_arrangement.armies_to_put_by_continent.africa, 3, "Should put 3 armies in Africa because the player 3 owns that continent.")
	lu.assertNil(g.state.armies_arrangement.armies_to_put_by_continent.south_america, "Should not have armies to put in South America because the player 3 does not own that continent.")
	lu.assertEquals(g.state.armies_arrangement.remaining_armies_to_put, 6, "Should calculate the remaining armies for player 3 to put.")
	lu.assertItemsEquals(g.state.armies_arrangement.remaining_armies_to_put_by_territory, {}, "Should not have any remaining armies to place in territories.")
	lu.assertEquals(g.state.armies_arrangement.remaining_armies_to_put_by_continent.oceania, 2, "Should have the remaining armies to put in Oceania.")
	lu.assertEquals(g.state.armies_arrangement.remaining_armies_to_put_by_continent.africa, 3, "Should have the remaining armies to put in Africa.")
	lu.assertNil(g.state.armies_arrangement.remaining_armies_to_put_by_continent.south_america, "Should not have the remaining armies to put in a continent that the player does not own.")
	lu.assertItemsEquals(g.state.armies_arrangement.armies_placed_by_territory, {}, "Should reset the armies placed by territory before start the placement.")
end
