-- Table of available goals to be given to each player. Each goal is a table with a function called 'achieved' that returns true if the goal
-- was achieved in the game (receives the player id and the game state as an argument).
-- Each goal table may have, optionally, a function called 'can_player_receive', which receives the player index, the game states and returns
-- true if the given player can receive this goal or false if not.
-- The description of each goal should be in the idiom tables, where the key of the goal in the goals table is equal to the key in the
-- idiom.goals table.

local function can_army_be_defeated_by_player(army, player, state)
	local is_army_in_the_game = false
	local is_army_the_player = false
	local is_army_defeated = false
	local is_army_defeated_by_player = false
	for i, p in ipairs(state.players) do
		if p.army == army then
			is_army_in_the_game = true
			is_army_the_player = i == player
			is_army_defeated = p.defeated_by_player ~= nil
			is_army_defeated_by_player = p.defeated_by_player == player
			break
		end
	end
	return is_army_in_the_game and not is_army_the_player and not (is_army_defeated and not is_army_defeated_by_player)
end

local function is_army_defeated_by_player(army, player, state)
	local is_army_defeated = false
	local is_army_defeated_by_player = false
	for i, p in ipairs(state.players) do
		if p.army == army then
			is_army_defeated = p.defeated_by_player ~= nil
			is_army_defeated_by_player = p.defeated_by_player == player
			break
		end
	end
	return is_army_defeated and is_army_defeated_by_player
end

local function get_number_or_conquered_territories_by_player(player, state)
	local conquered_territories_count = 0
	for territory_key, territory in pairs(state.territories) do
		if territory.owner_player == player then
			conquered_territories_count = conquered_territories_count + 1
		end
	end
	return conquered_territories_count
end

return {
	defeat_blue_army = {

		achieved = function(player, state)
			if can_army_be_defeated_by_player("blue", player, state) then
				return is_army_defeated_by_player("blue", player, state)
			else
				return get_number_or_conquered_territories_by_player(player, state) >= 24
			end
		end,

		can_player_receive = function(player, state)
			return true
		end
	}
}
