-- Table that represents a game. Call the new() function to create a new instance.

local state = require("state")
local goals = require("goals")
local territories = require("territories")
local cards = require("cards")
local validators = require("validators")

return {

	-- Returns a new instance of the game table. The table contains a "state" field with the current state of the game
	-- and functions to manipulate the state. Call "enter_player" to add players, "start" to start the game and the
	-- other functions to do the actions in the game.
	new = function()

		local state = state.new()

		local game_instance = {
			state = state
		}

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

		local function draw_player_to_start()
			state.current_player = math.random(1, #state.players)
			state.round_started_by_player = state.current_player
		end

		local function distribute_goals_to_players()
			local goals_keys = {}
			for k, v in pairs(goals) do
				table.insert(goals_keys, k)
			end
			goals_keys = shuffle_list(goals_keys)
			for i, player in ipairs(state.players) do
				player.goal = goals_keys[i]
			end
		end

		local function distribute_territories_among_players()
			local territories_keys = {}
			for k, v in pairs(territories) do
				table.insert(territories_keys, k)
			end
			territories_keys = shuffle_list(territories_keys)
			local player_index = state.current_player
			for i, territory_key in ipairs(territories_keys) do
				state.territories[territory_key].owner_player = player_index
				state.territories[territory_key].armies = 1
				player_index = player_index + 1
				if player_index > #state.players then player_index = 1 end
			end
		end

		local function shuffle_and_cards_on_table()
			state.cards_on_table = shuffle_list(state.cards_on_table)
		end

		local function validate_before_enter_player(name, army)
			for i, validator in ipairs(validators.enter_player_validations) do
				local ok, message = pcall(validator, state, name, army)
				if not ok then
					return false
				end
			end
			return true
		end

		local function validate_before_start_game()
			for i, validator in ipairs(validators.start_game_validations) do
				local ok, message = pcall(validator, state)
				if not ok then
					return false
				end
			end
			return true
		end

		-- Adds a player to the game. Must be done before call the "start" function.
		-- The army argument must be a valid color: black, white, blue, red, green or yellow.
		-- It's not allowed to enter players with same name or army color.
		function game_instance.enter_player(name, army)
			if validate_before_enter_player(name, army) then
				table.insert(game_instance.state.players, { name = name, army = army })
			end
		end

		-- Starts the game. Must be called after at least two players have entered. Draws the player that starts the round,
		-- distributes the goals and territories and put the deck of suffled cards in the table. At least two players must
		-- have entered the game before the start.
		function game_instance.start()
			if validate_before_start_game() then
				draw_player_to_start(game_instance.state)
				distribute_goals_to_players(game_instance.state)
				distribute_territories_among_players(game_instance.state)
				shuffle_and_cards_on_table(game_instance.state)
				game_instance.state.status = "arrange_armies"
			end
		end

		-- Put the given amount of armies in the given territory. After the current player puts all the armies that he cards_on_table
		-- put in the board, the game passes to the next player, unless the placement is invalid. In this case, call abort() to restart
		-- the placement.
		function game_instance.put(number_of_armies, territory)
		end

		function game_instance.abort()
		end

		return game_instance
	end
}