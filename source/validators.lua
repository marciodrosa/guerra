-- Table with a list of validators used by the game. Each key is a list of functions that validate
-- the state of the game and an action that is trying to be performed.

local idioms = require "idioms"

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

	start_game_validations = {
		expected_status("not_started"),

		function(state)
			if #state.players < 2 then error(idioms[state.idiom].validations.cant_start_with_less_than_two_players, 0) end
		end
	}

}