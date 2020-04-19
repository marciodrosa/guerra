-- Table that represents a game. Call the new() function to create a new instance.

local state = require("state")
local goals = require("goals")
local territories = require("territories")
local cards = require("cards")

local function shuffle_list(list)
	local result = {}
	for i, v in ipairs(list) do
		result[i] = v
	end
	for i = #result, 1, -1 do
		local j = math.random(1, i)
		local temp = result[i]
		result[i] = result[j]
		result[j] = temp
	end
	return result
end

local function draw_player_to_start(state)
	state.current_player = math.random(1, #state.players)
	state.round_started_by_player = state.current_player
end

local function distribute_goals_to_players(state)
	local goals_keys = {}
	for k, v in pairs(goals) do
		table.insert(goals_keys, k)
	end
	goals_keys = shuffle_list(goals_keys)
	for i, player in ipairs(state.players) do
		player.goal = goals_keys[i]
	end
end

local function distribute_territories_among_players(state)
	state.territories = {}
	local territories_keys = {}
	for k, v in pairs(territories) do
		table.insert(territories_keys, k)
	end
	territories_keys = shuffle_list(territories_keys)
	local player_index = state.current_player
	for i, territory_key in ipairs(territories_keys) do
		state.territories[territory_key] = {
			owner_player = player_index,
			armies = 1			
		}
		player_index = player_index + 1
		if player_index > #state.players then player_index = 1 end
	end
end

local function shuffle_and_put_cards_on_table(state)
	local cards_indexes = {}
	for i, v in ipairs(cards) do
		table.insert(cards_indexes, i)
	end
	cards_indexes = shuffle_list(cards_indexes)
	state.cards_on_table = cards_indexes
end

return {

	-- Returns a new instance of the game table. The table contains a "state" field with the current state of the game
	-- and functions to manipulate the state. Call "enter_player" to add players, "start" to start the game and the
	-- other functions to do the actions in the game.
	new = function()

		local game_instance = {
			state = state.new()
		}

		-- Adds a player to the game. Must be done before call the "start" function.
		-- The army argument must be a valid color: black, white, blue, red, green or yellow.
		function game_instance.enter_player(name, army)
			table.insert(game_instance.state.players, { name = name, army = army })
		end

		-- Starts the game. Must be called after at least two players have entered. Draws the player that starts the round,
		-- distributes the goals and territories and put the deck of suffled cards in the table.
		function game_instance.start()
			draw_player_to_start(game_instance.state)
			distribute_goals_to_players(game_instance.state)
			distribute_territories_among_players(game_instance.state)
			shuffle_and_put_cards_on_table(game_instance.state)
		end

		return game_instance
	end
}