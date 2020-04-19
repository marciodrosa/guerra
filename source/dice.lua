-- Utility table that simulates a dice.

local function sort_dices(dice_1, dice_2, dice_3)
	local list = {}
	if dice_1 ~= nil then table.insert(list, dice_1) end
	if dice_2 ~= nil then table.insert(list, dice_2) end
	if dice_3 ~= nil then table.insert(list, dice_3) end
	table.sort(list, function(d1, d2) return d1.value > d2.value end)
	return list[1], list[2], list[3]
end

local function compare_dices_pair(attack_dice, defence_dice)
	if attack_dice ~= nil and defence_dice ~= nil then
		if attack_dice.value > defence_dice.value then
			return 1, 0
		else
			return 0, 1
		end
	else
		return 0, 0
	end
end

return {

	-- Returns a new table tha represents a dice. Contains a function named "roll" that changes the value of the field
	-- "value" randomly. The dice number of sides can be configured with the "sides" field (default is 6).
	-- Receives an optional initial_value. If nil, a random initial value is setted.
	new = function(initial_value)
		local dice = {
			sides = 6,
			value = 1
		}

		local function generate_random_dice_value()
			return math.random(1, dice.sides)
		end

		local function roll()
			dice.value = generate_random_dice_value()
			return dice.value
		end

		dice.roll = roll
		if initial_value ~= nil then
			dice.value = initial_value
		else
			dice.value = generate_random_dice_value()
		end
		return dice
	end,

	-- Receives three dices and returns the same three values, but sorted from the bigger value to the smaller one.
	sort = sort_dices,

	-- Compares the value of the dices. Each dice is optional, may be nil. Defense dices win in case of a draw.
	-- Returns a table with two numeric fields: "attack_victories" and "defense_victories".
	compare = function(attack_dice_1, attack_dice_2, attack_dice_3, defence_dice_1, defence_dice_2, defence_dice_3)
		attack_dice_1, attack_dice_2, attack_dice_3 = sort_dices(attack_dice_1, attack_dice_2, attack_dice_3)
		defence_dice_1, defence_dice_2, defence_dice_3 = sort_dices(defence_dice_1, defence_dice_2, defence_dice_3)
		local attack_victories_pair_1, defence_victories_pair_1 = compare_dices_pair(attack_dice_1, defence_dice_1)
		local attack_victories_pair_2, defence_victories_pair_2 = compare_dices_pair(attack_dice_2, defence_dice_2)
		local attack_victories_pair_3, defence_victories_pair_3 = compare_dices_pair(attack_dice_3, defence_dice_3)
		return {
			attack_victories = attack_victories_pair_1 + attack_victories_pair_2 + attack_victories_pair_3,
			defense_victories = defence_victories_pair_1 + defence_victories_pair_2 + defence_victories_pair_3
		}
	end
}
