-- Table that represents a game. Call the new() function to create a new instance.

local state = require("state")
local goals = require("goals")
local territories = require("territories")
local continents = require("continents")
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

		local function get_next_player()
			local next_player = state.current_player + 1
			if next_player > #state.players then next_player = 1 end
			return next_player
		end

		local function get_territories_owned_by_player()
			local result = {}
			for k, v in pairs(state.territories) do
				if v.owner_player == state.current_player then
					table.insert(result, k)
				end
			end
			return result
		end

		local function get_continents_owned_by_player()
			local result = {}
			for continent_key, continent in pairs(continents) do
				local is_owned = true
				for i, territory in ipairs(continent.territories) do
					if state.territories[territory] == nil or state.territories[territory].owner_player ~= state.current_player then
						is_owned = false
						break
					end
				end
				if is_owned then table.insert(result, continent_key) end
			end
			return result
		end

		local function start_armies_arrangement(player)
			state.status = "arrange_armies"
			state.current_player = player
			state.armies_arrangement.armies_placed_by_territory = {}
			state.armies_arrangement.total_armies_to_put = math.floor(#get_territories_owned_by_player() / 2)
			state.armies_arrangement.armies_to_put_by_territory = {}
			state.armies_arrangement.armies_to_put_by_continent = {}
			local owned_continents = get_continents_owned_by_player()
			for i, v in ipairs(owned_continents) do
				state.armies_arrangement.armies_to_put_by_continent[v] = continents[v].armies_when_conquered
			end
			state.armies_arrangement.remaining_armies_to_put_by_territory = {}
			for k, v in pairs(state.armies_arrangement.armies_to_put_by_territory) do
				state.armies_arrangement.remaining_armies_to_put_by_territory[k] = v
			end
		end

		local function commit_arrangement()
			for territory_key, armies in pairs(state.armies_arrangement.armies_placed_by_territory) do
				state.territories[territory_key].armies = state.territories[territory_key].armies + armies
			end
		end

		local function start_battle(player)
			state.status = "battle"
			state.current_player = player
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

		local function validate_before_put_armies(number_of_armies, territory)
			for i, validator in ipairs(validators.put_armies_validations) do
				local ok, message = pcall(validator, state, number_of_armies, territory)
				if not ok then
					return false
				end
			end
			return true
		end

		local function validate_before_move_armies(number_of_armies, from_territory, to_territory)
			for i, validator in ipairs(validators.move_validations) do
				local ok, message = pcall(validator, state, number_of_armies, from_territory, to_territory)
				if not ok then
					return false
				end
			end
			return true
		end

		local function validate_before_move_in_arrangement_status(number_of_armies, from_territory, to_territory)
			for i, validator in ipairs(validators.move_while_arrange_armies_validations) do
				local ok, message = pcall(validator, state, number_of_armies, from_territory, to_territory)
				if not ok then
					return false
				end
			end
			return true
		end

		local function validate_before_abort()
			for i, validator in ipairs(validators.abort_validations) do
				local ok, message = pcall(validator, state)
				if not ok then
					return false
				end
			end
			return true
		end

		local function validate_before_done()
			for i, validator in ipairs(validators.done_validations) do
				local ok, message = pcall(validator, state)
				if not ok then
					return false
				end
			end
			return true
		end

		local function validate_before_done_put_armies()
			for i, validator in ipairs(validators.done_put_armies_validations) do
				local ok, message = pcall(validator, state)
				if not ok then
					return false
				end
			end
			return true
		end

		local function validate_attack(from_territory, to_territory)
			for i, validator in ipairs(validators.attack_validations) do
				local ok, message = pcall(validator, state, from_territory, to_territory)
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
				table.insert(state.players, { name = name, army = army })
			end
		end

		-- Starts the game. Must be called after at least two players have entered. Draws the player that starts the round,
		-- distributes the goals and territories and put the deck of suffled cards in the table. At least two players must
		-- have entered the game before the start.
		function game_instance.start()
			if validate_before_start_game() then
				draw_player_to_start(state)
				distribute_goals_to_players(state)
				distribute_territories_among_players(state)
				shuffle_and_cards_on_table(state)
				start_armies_arrangement(state.current_player)
			end
		end

		-- Put the given amount of armies in the given territory. Function "abort" can be called to restart the placement
		-- and "move" to edit it. Call "done" to commit.
		function game_instance.put(number_of_armies, territory)
			if validate_before_put_armies(number_of_armies, territory) then
				local armies_arrangement = state.armies_arrangement
				if armies_arrangement.armies_placed_by_territory[territory] == nil then
					armies_arrangement.armies_placed_by_territory[territory] = 0
				end
				armies_arrangement.armies_placed_by_territory[territory] = armies_arrangement.armies_placed_by_territory[territory] + number_of_armies
			end
		end

		-- Moves the given amount of armies from one territory to another.
		function game_instance.move(number_of_armies, from_territory, to_territory)
			if validate_before_move_armies(number_of_armies, from_territory, to_territory) then
				if state.status == "arrange_armies" then
					if validate_before_move_in_arrangement_status(number_of_armies, from_territory, to_territory) then
						state.armies_arrangement.armies_placed_by_territory[from_territory] = state.armies_arrangement.armies_placed_by_territory[from_territory] - number_of_armies
						state.armies_arrangement.armies_placed_by_territory[to_territory] = state.armies_arrangement.armies_placed_by_territory[to_territory] + number_of_armies
					end
				end
			end
		end

		-- Aborts the current enemies arrangement, restarting to the initial state of the placement.
		function game_instance.abort()
			if validate_before_abort() then
				if state.status == "arrange_armies" then
					state.armies_arrangement.armies_placed_by_territory = {}
				end
			end
		end

		-- Finishes the current army placement or finishes the attack.
		function game_instance.done()
			if validate_before_done() then
				if state.status == "arrange_armies" then
					if validate_before_done_put_armies() then
						commit_arrangement()
						local next_player = get_next_player()
						if next_player == state.round_started_by_player then
							start_battle(next_player)
						else
							start_armies_arrangement(next_player)
						end
					end
				end
			end
		end

		function game_instance.attack(from_territory, to_territory)
			if validate_attack(from_territory, to_territory) then
			end
		end

		return game_instance
	end
}
