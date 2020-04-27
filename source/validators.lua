-- Table with a list of validators used by the game. Each key is a list of functions that validate
-- the state of the game and an action that is trying to be performed.

local idioms = require "idioms"
local continents = require "continents"
local territories = require "territories"

local function expected_status(status)
	if type(status) == "table" then
		return function(state)
			local status_valid = false
			for i, v in ipairs(status) do
				if v == state.status then
					status_valid = true
					break
				end
			end
			if not status_valid then
				local message = idioms[state.idiom].validations.unexpected_status_multiple
				for i, v in ipairs(status) do
					message = message.."\n"..idioms[state.idiom].validations.expected_status_multiple[v]
				end
				error(message, 0)
			end
		end
	else
		return function(state)
			if state.status ~= status then
				error(idioms[state.idiom].validations.expected_status[status], 0)
			end
		end
	end
end

local function validate_army_color(state, army)
	if army ~= "black" and army ~= "white" and army ~= "red" and army ~= "blue" and army ~= "green" and army ~= "yellow" then
		error(idioms[state.idiom].validations.invalid_color, 0)
	end
end

local function validate_type(state, value, expected_type)
	if type(value) ~= expected_type then
		if expected_type == "number" then
			error(idioms[state.idiom].validations.invalid_number, 0)
		else
			error(idioms[state.idiom].validations.invalid_value, 0)
		end
	end
end

local function validate_positive_number(state, number)
	validate_type(state, number, "number")
	if number <= 0 then
		error(idioms[state.idiom].validations.number_must_be_positive, 0)
	end
end

local function validate_territory(state, territory)
	if territories[territory] == nil then
		error(idioms[state.idiom].validations.unknow_territory, 0)
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

local function simulate_armies_move(current_placement, number_of_armies_to_move, from_territory, to_territory)
	local result = {}
	for k, v in pairs(current_placement) do
		result[k] = v
	end
	result[from_territory] = result[from_territory] - number_of_armies_to_move
	result[to_territory] = result[to_territory] + number_of_armies_to_move
	return result
end

local function convert_missing_mandatory_armies_by_territory_to_string(state, missing_mandatory_armies_by_territory)
	local descriptions = {}
	for k, v in pairs(missing_mandatory_armies_by_territory) do
		table.insert(descriptions, string.format("%s - %s", idioms[state.idiom].territories[k], v))
	end
	table.sort(descriptions)
	local result = ""
	for i, v in ipairs(descriptions) do
		if i == 1 then result = v else result = string.format("%s\n%s", result, v) end
	end
	return result
end

local function get_missing_mandatory_armies_in_territories_after_new_placement(state, current_armies_arrangement, new_placement)
	local missing_mandatory_armies_by_territory = {}
	local total_missing_armies = 0
	for territory_key, armies_to_put in pairs(current_armies_arrangement.armies_to_put_by_territory) do
		local current_armies_placed_in_territory = new_placement[territory_key] or 0
		if armies_to_put > current_armies_placed_in_territory then
			missing_mandatory_armies_by_territory[territory_key] = armies_to_put - current_armies_placed_in_territory
			total_missing_armies = total_missing_armies + missing_mandatory_armies_by_territory[territory_key]
		end
	end
	return total_missing_armies, convert_missing_mandatory_armies_by_territory_to_string(state, missing_mandatory_armies_by_territory)
end

local function convert_missing_mandatory_armies_by_continent_to_string(state, missing_mandatory_armies_by_continent)
	local descriptions = {}
	for k, v in pairs(missing_mandatory_armies_by_continent) do
		table.insert(descriptions, string.format("%s - %s", idioms[state.idiom].continents[k], v))
	end
	table.sort(descriptions)
	local result = ""
	for i, v in ipairs(descriptions) do
		if i == 1 then result = v else result = string.format("%s\n%s", result, v) end
	end
	return result
end

local function get_missing_mandatory_armies_by_continent_after_new_placement(state, current_armies_arrangement, new_placement)
	local missing_mandatory_armies_by_continent = {}
	local total_missing_armies = 0
	for continent_key, armies_to_put in pairs(current_armies_arrangement.armies_to_put_by_continent) do
		local armies_placed_in_continent = 0
		for i, territory in ipairs(continents[continent_key].territories) do
			local armies_placed_in_territory = new_placement[territory] or 0
			local armies_to_put_in_territory = current_armies_arrangement.armies_to_put_by_territory[territory] or 0
			armies_placed_in_continent = armies_placed_in_continent + armies_placed_in_territory - armies_to_put_in_territory
		end
		if armies_to_put > armies_placed_in_continent then
			missing_mandatory_armies_by_continent[continent_key] = armies_to_put - armies_placed_in_continent
			total_missing_armies = total_missing_armies + missing_mandatory_armies_by_continent[continent_key]
		end
	end
	return total_missing_armies, convert_missing_mandatory_armies_by_continent_to_string(state, missing_mandatory_armies_by_continent)
end

local function does_territories_have_borders(territory1, territory2)
	local found_border_between_territories = false
	for i, v in ipairs(territories[territory1].borders) do
		if v == territory2 then
			found_border_between_territories = true
			break
		end
	end
	return found_border_between_territories
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
			validate_territory(state, territory)
		end,

		function(state, number_of_armies, territory)
			validate_positive_number(state, number_of_armies)
		end,

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
			local future_placement = simulate_armies_placement(state.armies_arrangement.armies_placed_by_territory, number_of_armies, territory)
			local total_missing_armies, missing_territories_description = get_missing_mandatory_armies_in_territories_after_new_placement(state, state.armies_arrangement, future_placement)
			local armies_still_remaining_to_put = get_number_of_remaining_armies_to_put_in_arrangement(state) - number_of_armies
			if armies_still_remaining_to_put < total_missing_armies then
				local message = string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_distribute_between_the_following_territories, get_number_of_remaining_armies_to_put_in_arrangement(state))
				message = message.."\n"..missing_territories_description
				error(message, 0)
			end
		end,

		function(state, number_of_armies, territory)
			local future_placement = simulate_armies_placement(state.armies_arrangement.armies_placed_by_territory, number_of_armies, territory)
			local total_missing_armies, missing_continents_description = get_missing_mandatory_armies_by_continent_after_new_placement(state, state.armies_arrangement, future_placement)
			local armies_still_remaining_to_put = get_number_of_remaining_armies_to_put_in_arrangement(state) - number_of_armies
			if armies_still_remaining_to_put < total_missing_armies then
				local message = string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_distribute_between_the_following_continents, get_number_of_remaining_armies_to_put_in_arrangement(state))
				message = message.."\n"..missing_continents_description
				error(message, 0)
			end
		end
	},

	move_validations = {
		expected_status { "arrange_armies", "moving_armies", "battle" },

		function(state, number_of_armies, from_territory, to_territory)
			validate_territory(state, from_territory)
			validate_territory(state, to_territory)
		end,

		function(state, number_of_armies, from_territory, to_territory)
			validate_positive_number(state, number_of_armies)
		end,

		function(state, number_of_armies, from_territory, to_territory)
			if state.territories[from_territory].owner_player ~= state.current_player then
				error(string.format(idioms[state.idiom].validations.origin_territory_does_not_belong_to_player, idioms[state.idiom].territories[from_territory]), 0)
			end
		end,

		function(state, number_of_armies, from_territory, to_territory)
			if state.territories[to_territory].owner_player ~= state.current_player then
				error(string.format(idioms[state.idiom].validations.dest_territory_does_not_belong_to_player, idioms[state.idiom].territories[to_territory]), 0)
			end
		end,

		function(state, number_of_armies, from_territory, to_territory)
			if not does_territories_have_borders(from_territory, to_territory) then
				error(string.format(idioms[state.idiom].validations.territories_does_not_have_borders, idioms[state.idiom].territories[from_territory], idioms[state.idiom].territories[to_territory]), 0)
			end
		end
	},

	move_while_arrange_armies_validations = {

		function(state, number_of_armies, from_territory, to_territory)
			if (state.armies_arrangement.armies_placed_by_territory[from_territory] or 0) == 0 then
				error(string.format(idioms[state.idiom].validations.no_armies_placed_in_origin_on_arrangement, idioms[state.idiom].territories[from_territory]), 0)
			end
		end,

		function(state, number_of_armies, from_territory, to_territory)
			if state.armies_arrangement.armies_placed_by_territory[from_territory] < number_of_armies then
				error(string.format(idioms[state.idiom].validations.does_not_have_enough_armies_in_origin_on_arrangement, state.armies_arrangement.armies_placed_by_territory[from_territory]), 0)
			end
		end,

		function(state, number_of_armies, from_territory, to_territory)
			local future_placement = simulate_armies_move(state.armies_arrangement.armies_placed_by_territory, number_of_armies, from_territory, to_territory)
			local total_missing_armies, missing_territories_description = get_missing_mandatory_armies_in_territories_after_new_placement(state, state.armies_arrangement, future_placement)
			local armies_still_remaining_to_put = get_number_of_remaining_armies_to_put_in_arrangement(state)
			if armies_still_remaining_to_put < total_missing_armies then
				local message = string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_distribute_between_the_following_territories, get_number_of_remaining_armies_to_put_in_arrangement(state))
				message = message.."\n"..missing_territories_description
				error(message, 0)
			end
		end,

		function(state, number_of_armies, from_territory, to_territory)
			local future_placement = simulate_armies_move(state.armies_arrangement.armies_placed_by_territory, number_of_armies, from_territory, to_territory)
			local total_missing_armies, missing_continents_description = get_missing_mandatory_armies_by_continent_after_new_placement(state, state.armies_arrangement, future_placement)
			local armies_still_remaining_to_put = get_number_of_remaining_armies_to_put_in_arrangement(state)
			if armies_still_remaining_to_put < total_missing_armies then
				local message = string.format(idioms[state.idiom].validations.player_has_only_x_armies_remaining_to_distribute_between_the_following_continents, get_number_of_remaining_armies_to_put_in_arrangement(state))
				message = message.."\n"..missing_continents_description
				error(message, 0)
			end
		end
	},

	abort_validations = {
		expected_status { "arrange_armies", "moving_armies" },
	},

	done_validations = {
		expected_status { "arrange_armies", "moving_armies", "battle" },
	},

	done_put_armies_validations = {
		function(state)
			local armies_still_available_to_put = get_number_of_remaining_armies_to_put_in_arrangement(state)
			if armies_still_available_to_put > 0 then
				error(string.format(idioms[state.idiom].validations.player_still_have_x_armies_to_put, armies_still_available_to_put), 0)
			end
		end
	},

	attack_validations = {
		expected_status("battle"),

		function(state, from_territory, to_territory)
			if state.territories[from_territory].owner_player ~= state.current_player then
				error(string.format(idioms[state.idiom].validations.attacker_territory_does_not_belong_to_player, idioms[state.idiom].territories[from_territory]), 0)
			end
		end,

		function(state, from_territory, to_territory)
			if state.territories[to_territory].owner_player == state.current_player then
				error(string.format(idioms[state.idiom].validations.attacked_territory_belongs_to_player, idioms[state.idiom].territories[to_territory]), 0)
			end
		end,

		function(state, from_territory, to_territory)
			if state.territories[from_territory].armies < 2 then
				error(idioms[state.idiom].validations.cant_attack_with_less_than_two_armies, 0)
			end
		end,

		function(state, from_territory, to_territory)
			if not does_territories_have_borders(from_territory, to_territory) then
				error(string.format(idioms[state.idiom].validations.territories_does_not_have_borders, idioms[state.idiom].territories[from_territory], idioms[state.idiom].territories[to_territory]), 0)
			end
		end,
	}

}
