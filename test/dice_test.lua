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

function test_dice.test_should_sort_dices_from_bigger_value_to_smaller()
	-- given:
	local d1 = dice.new()
	local d2 = dice.new()
	local d3 = dice.new()
	d1.value = 3
	d2.value = 6
	d3.value = 4

	-- when:
	d1, d2, d3 = dice.sort(d1, d2, d3)

	-- then:
	lu.assertEquals(d1.value, 6)
	lu.assertEquals(d2.value, 4)
	lu.assertEquals(d3.value, 3)
end

function test_dice.test_should_sort_dices_from_bigger_value_to_smaller_including_dices_with_equal_values()
	-- given:
	local d1 = dice.new()
	local d2 = dice.new()
	local d3 = dice.new()
	d1.value = 3
	d2.value = 6
	d3.value = 3

	-- when:
	d1, d2, d3 = dice.sort(d1, d2, d3)

	-- then:
	lu.assertEquals(d1.value, 6)
	lu.assertEquals(d2.value, 3)
	lu.assertEquals(d3.value, 3)
end

function test_dice.test_should_sort_two_dices_from_bigger_value_to_smaller()
	-- given:
	local d1 = dice.new()
	local d2 = dice.new()
	d1.value = 3
	d2.value = 6

	-- when:
	d1, d2 = dice.sort(d1, d2)

	-- then:
	lu.assertEquals(d1.value, 6)
	lu.assertEquals(d2.value, 3)
end

function test_dice.test_should_sort_only_one_dice()
	-- given:
	local d1 = dice.new()
	d1.value = 3

	-- when:
	d1 = dice.sort(d1)

	-- then:
	lu.assertEquals(d1.value, 3)
end

function test_dice.test_should_compare_dices()
	-- given
	local attack_dice_1 = dice.new(3)
	local attack_dice_2 = dice.new(6)
	local attack_dice_3 = dice.new(1)
	local defense_dice_1 = dice.new(5)
	local defense_dice_2 = dice.new(4)
	local defense_dice_3 = dice.new(2)

	-- when:
	local result = dice.compare(attack_dice_1, attack_dice_2, attack_dice_3, defense_dice_1, defense_dice_2, defense_dice_3)

	-- then:
	lu.assertEquals(result.attack_victories, 1)
	lu.assertEquals(result.defense_victories, 2)
end

function test_dice.test_should_compare_two_pair_of_dices()
	-- given
	local attack_dice_1 = dice.new(3)
	local attack_dice_2 = dice.new(6)
	local defense_dice_1 = dice.new(5)
	local defense_dice_2 = dice.new(4)

	-- when:
	local result = dice.compare(attack_dice_1, attack_dice_2, nil, defense_dice_1, defense_dice_2, nil)

	-- then:
	lu.assertEquals(result.attack_victories, 1)
	lu.assertEquals(result.defense_victories, 1)
end

function test_dice.test_should_compare_3_attack_dices_against_1_defense()
	-- given
	local attack_dice_1 = dice.new(3)
	local attack_dice_2 = dice.new(6)
	local attack_dice_3 = dice.new(1)
	local defense_dice_1 = dice.new(5)

	-- when:
	local result = dice.compare(attack_dice_1, attack_dice_2, attack_dice_3, defense_dice_1, nil, nil)

	-- then:
	lu.assertEquals(result.attack_victories, 1)
	lu.assertEquals(result.defense_victories, 0)
end

function test_dice.test_should_compare_3_attack_dices_against_1_defense_where_the_defense_wins()
	-- given
	local attack_dice_1 = dice.new(3)
	local attack_dice_2 = dice.new(4)
	local attack_dice_3 = dice.new(1)
	local defense_dice_1 = dice.new(5)

	-- when:
	local result = dice.compare(attack_dice_1, attack_dice_2, attack_dice_3, defense_dice_1, nil, nil)

	-- then:
	lu.assertEquals(result.attack_victories, 0)
	lu.assertEquals(result.defense_victories, 1)
end

function test_dice.test_should_compare_1_attack_dices_against_3_defense()
	-- given
	local attack_dice_1 = dice.new(3)
	local defense_dice_1 = dice.new(5)
	local defense_dice_2 = dice.new(6)
	local defense_dice_3 = dice.new(1)

	-- when:
	local result = dice.compare(attack_dice_1, nil, nil, defense_dice_1, defense_dice_2, defense_dice_3)

	-- then:
	lu.assertEquals(result.attack_victories, 0)
	lu.assertEquals(result.defense_victories, 1)
end

function test_dice.test_should_compare_1_attack_dices_against_3_defense_where_the_attack_wins()
	-- given
	local attack_dice_1 = dice.new(6)
	local defense_dice_1 = dice.new(5)
	local defense_dice_2 = dice.new(4)
	local defense_dice_3 = dice.new(1)

	-- when:
	local result = dice.compare(attack_dice_1, nil, nil, defense_dice_1, defense_dice_2, defense_dice_3)

	-- then:
	lu.assertEquals(result.attack_victories, 1)
	lu.assertEquals(result.defense_victories, 0)
end

function test_dice.test_should_defense_should_win_when_comparing_draws()
	-- given
	local attack_dice_1 = dice.new(6)
	local attack_dice_2 = dice.new(6)
	local attack_dice_3 = dice.new(3)
	local defense_dice_1 = dice.new(6)
	local defense_dice_2 = dice.new(6)
	local defense_dice_3 = dice.new(1)

	-- when:
	local result = dice.compare(attack_dice_1, attack_dice_2, attack_dice_3, defense_dice_1, defense_dice_2, defense_dice_3)

	-- then:
	lu.assertEquals(result.attack_victories, 1)
	lu.assertEquals(result.defense_victories, 2)
end


