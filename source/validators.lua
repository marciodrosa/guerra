-- Table with a list of validators used by the game. Each key is a list of functions that validate
-- the state of the game and an action that is trying to be performed.

local idioms = require "idioms"
local continents = require "continents"

local function expected_status(status)
	return function(state)
		if state.status ~= status then
			error(idioms[state.idiom].validations.expected_status[status], 0)
		end
	end
end

local function validate_army_color(state, army)
	if army ~= "black" and army ~= "white" and army ~= "red" and army ~= "blue" and army ~= "green" and army ~= "yellow" then
		error(idioms[state.idiom].validations.invalid_color, 0)
	end
end

return {

	-- List of functions to be called with 3 arguments: the state, the name of the player and the army color.
	enter_player_validations = {
		expected_status("not_started"),

		function(state)
			if #state.players >= 6 then error(idioms[state.idiom].validations.max_number_of_players_already_achieved, 0) end
		end,

		function(state, name, army)
			for i, player in ipairs(state.players) do
				if player.name == name then
					error(string.format(idioms[state.idiom].validations.player_name_already_in_use, name), 0)
				elseif player.army == army then
					error(string.format(idioms[state.idiom].validations.player_color_already_in_use, idioms[state.idiom].armies[army]), 0)
				end
			end
		end,

		function(state, name, army)
			validate_army_color(state, army)
		end,
	},

	-- List of functions to be called with 1 argument (the state).
	start_game_validations = {
		expected_status("not_started"),

		function(state)
			if #state.players < 2 then error(idioms[state.idiom].validations.cant_start_with_less_than_two_players, 0) end
		end
	},

	-- List of functions to be called with 3 arguments: the state, the number of armies to put and the territory.
	put_armies_validations = {
		expected_status("arrange_armies"),

		function(state, number_of_armies, territory)
			if state.territories[territory].owner_player ~= state.current_player then
				error(string.format(idioms[state.idiom].validations.cant_put_armies_in_territory_that_is_not_owned_by_player, idioms[state.idiom].territories[territory]), 0)
			end
		end,

		function(state, number_of_armies, territory)
			local total_remaining_armies_to_put = state.armies_arrangement.total_armies_to_put - number_of_armies
			if total_remaining_armies_to_put < 0 then
				error(string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_put, state.armies_arrangement.total_armies_to_put), 0)
			end
		end,

		function(state, number_of_armies, territory)
			local total_remaining_armies_to_put = state.armies_arrangement.total_armies_to_put - number_of_armies
			local missing_territories = {}
			for t, number_of_armies_to_put_in_territory in pairs(state.armies_arrangement.armies_to_put_by_territory) do
				if t ~= territory and total_remaining_armies_to_put < number_of_armies_to_put_in_territory then
					table.insert(missing_territories, { territory = idioms[state.idiom].territories[t], armies = number_of_armies_to_put_in_territory })
				end
			end
			if #missing_territories > 0 then
				local message = string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_distribute_between_the_following_territories, state.armies_arrangement.total_armies_to_put)
				for i, v in ipairs(missing_territories) do
					message = string.format("%s\n%s - %s", message, v.territory, v.armies)
				end
				error(message, 0)
			end
		end,

		function(state, number_of_armies, territory)
			local total_remaining_armies_to_put = state.armies_arrangement.total_armies_to_put - number_of_armies
			local missing_continents = {}
			for continent_key, continent in pairs(continents) do
				local is_continent_of_territory = false
				for i, continent_territory in ipairs(continent.territories) do
					if continent_territory == territory then
						is_continent_of_territory = true
						break
					end
				end
				if is_continent_of_territory then
					for c, number_of_armies_to_put_in_continent in pairs(state.armies_arrangement.armies_to_put_by_continent) do
						if c ~= continent_key and total_remaining_armies_to_put < number_of_armies_to_put_in_continent then
							table.insert(missing_continents, { continent = idioms[state.idiom].continents[c], armies = number_of_armies_to_put_in_continent })
						end
					end
					break
				end
			end
			if #missing_continents > 0 then
				local message = string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_distribute_between_the_following_continents, state.armies_arrangement.total_armies_to_put)
				for i, v in ipairs(missing_continents) do
					message = string.format("%s\n%s - %s", message, v.continent, v.armies)
				end
				error(message, 0)
			end
		end
	}

}
