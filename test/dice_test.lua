test_dice = {}

local dice = require "dice"

function test_dice.test_should_create_new_dice_with_value_and_sides()
	-- given:
	local d = dice.new()

	-- then:
	lu.assertEquals(d.sides, 6, "Should create a new dice with the default number of 6 sides.")
	lu.assertTrue(d.value >= 1 and d.value <= 6, "The initial value should be a random number between 1 and the number of sides of the dice.")
end

function test_dice.test_should_roll_the_dice_a_few_times_to_generate_new_values()
	-- given:
	local d = dice.new()
	d.sides = 8

	-- then:
	d.roll()
	lu.assertTrue(d.value >= 1 and d.value <= 8)
	d.roll()
	lu.assertTrue(d.value >= 1 and d.value <= 8)
	d.roll()
	lu.assertTrue(d.value >= 1 and d.value <= 8)
	d.roll()
	lu.assertTrue(d.value >= 1 and d.value <= 8)
end

function test_dice.test_should_return_the_value_after_call_roll_function()
	-- given:
	local d = dice.new()
	d.sides = 8

	-- when:
	local returned_value = d.roll()

	-- then:
	lu.assertEquals(returned_value, d.value, "The roll function should return the same value of the dice.")
end
