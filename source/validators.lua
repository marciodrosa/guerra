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

local function get_number_of_armies_placed(armies_placed_by_territory)
	local count = 0
	for k, v in pairs(armies_placed_by_territory) do
		count = count + v
	end
	return count
end

local function get_number_of_remaining_armies_to_put_in_arrangement(state)
	return state.armies_arrangement.total_armies_to_put - get_number_of_armies_placed(state.armies_arrangement.armies_placed_by_territory)
end

local function simulate_armies_placement(current_placement, number_of_armies_to_put, territory)
	local result = {}
	for k, v in pairs(current_placement) do
		result[k] = v
	end
	if result[territory] == nil then result[territory] = 0 end
	result[territory] = result[territory] + number_of_armies_to_put
	return result
end

local function get_missing_mandatory_armies_by_territory_after_put(armies_arrangement, number_of_armies_to_put, territory)
	local new_placement = simulate_armies_placement(armies_arrangement.armies_placed_by_territory, number_of_armies_to_put, territory)
	local result = {}
	local total_missing_armies = 0
	for territory_key, armies_to_put in pairs(armies_arrangement.armies_to_put_by_territory) do
		local current_armies_placed_in_territory = new_placement[territory_key] or 0
		if armies_to_put > current_armies_placed_in_territory then
			result[territory_key] = armies_to_put - current_armies_placed_in_territory
			total_missing_armies = total_missing_armies + result[territory_key]
		end
	end
	return result, total_missing_armies
end

local function get_missing_mandatory_armies_by_continent_after_put(armies_arrangement, number_of_armies_to_put, territory)
	local new_placement = simulate_armies_placement(armies_arrangement.armies_placed_by_territory, number_of_armies_to_put, territory)
	local result = {}
	local total_missing_armies = 0
	for continent_key, armies_to_put in pairs(armies_arrangement.armies_to_put_by_continent) do
		local armies_placed_in_continent = 0
		for i, territory in ipairs(continents[continent_key].territories) do
			local armies_placed_in_territory = new_placement[territory] or 0
			local armies_to_put_in_territory = armies_arrangement.armies_to_put_by_territory[territory] or 0
			armies_placed_in_continent = armies_placed_in_continent + armies_placed_in_territory - armies_to_put_in_territory
		end
		if armies_to_put > armies_placed_in_continent then
			result[continent_key] = armies_to_put - armies_placed_in_continent
			total_missing_armies = total_missing_armies + result[continent_key]
		end
	end
	return result, total_missing_armies
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
			local current_remaining_armies_to_put = get_number_of_remaining_armies_to_put_in_arrangement(state)
			local new_remaining_armies_to_put = current_remaining_armies_to_put - number_of_armies
			if new_remaining_armies_to_put < 0 then
				error(string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_put, current_remaining_armies_to_put), 0)
			end
		end,

		function(state, number_of_armies, territory)
			local missing_mandatory_armies_by_territory, total_missing_armies = get_missing_mandatory_armies_by_territory_after_put(state.armies_arrangement, number_of_armies, territory)
			local armies_still_available_to_put = get_number_of_remaining_armies_to_put_in_arrangement(state) - number_of_armies
			if armies_still_available_to_put < total_missing_armies then
				local missing_territories_descriptions = {}
				for k, v in pairs(missing_mandatory_armies_by_territory) do
					table.insert(missing_territories_descriptions, string.format("%s - %s", idioms[state.idiom].territories[k], v))
				end
				table.sort(missing_territories_descriptions)
				local message = string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_distribute_between_the_following_territories, get_number_of_remaining_armies_to_put_in_arrangement(state))
				for i, v in ipairs(missing_territories_descriptions) do
					message = string.format("%s\n%s", message, v)
				end
				error(message, 0)
			end
		end,

		function(state, number_of_armies, territory)
			local missing_mandatory_armies_by_continent, total_missing_armies = get_missing_mandatory_armies_by_continent_after_put(state.armies_arrangement, number_of_armies, territory)
			local armies_still_available_to_put = get_number_of_remaining_armies_to_put_in_arrangement(state) - number_of_armies
			if armies_still_available_to_put < total_missing_armies then
				local missing_continents_descriptions = {}
				for k, v in pairs(missing_mandatory_armies_by_continent) do
					table.insert(missing_continents_descriptions, string.format("%s - %s", idioms[state.idiom].continents[k], v))
				end
				table.sort(missing_continents_descriptions)
				local message = string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_distribute_between_the_following_continents, get_number_of_remaining_armies_to_put_in_arrangement(state))
				for i, v in ipairs(missing_continents_descriptions) do
					message = string.format("%s\n%s", message, v)
				end
				error(message, 0)
			end
		end
	}

}
