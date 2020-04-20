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