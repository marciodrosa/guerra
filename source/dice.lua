-- Utility table that simulates a dice.

return {

	-- Returns a new table tha represents a dice. Contains a function named "roll" that changes the value of the field
	-- "value" randomly. The dice number of sides can be configured with the "sides" field (default is 6).
	new = function()
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
		dice.value = generate_random_dice_value()
		return dice
	end

}
