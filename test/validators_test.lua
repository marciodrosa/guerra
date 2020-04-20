test_validators = {}

local validators = require "validators"

local function execute_enter_player_validations(state, name, army)
	for i, f in ipairs(validators.enter_player_validations) do
		f(state, name, army)
	end
end

function test_validators.test_validate_enter_player()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "not_started",
		players = {
			{ name = "John", army = "black" },
			{ name = "Paul", army = "white" },
			{ name = "George", army = "yellow" },
			{ name = "Ringo", army = "green" },
			{ name = "Yoko", army = "red" },
		}
	}

	-- when:
	execute_enter_player_validations(state, "Michael Jackson", "blue")
end

function test_validators.test_should_not_validate_enter_player_if_there_are_already_6_players()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "not_started",
		players = {
			{ name = "John", army = "black" },
			{ name = "Paul", army = "white" },
			{ name = "George", army = "yellow" },
			{ name = "Ringo", army = "green" },
			{ name = "Yoko", army = "red" },
			{ name = "Stallone", army = "red" },
		}
	}

	-- when:
	lu.assertErrorMsgEquals("O máximo de jogadores já foi atingido (6).", execute_enter_player_validations, state, "Michael Jackson", "blue")
end

function test_validators.test_should_not_validate_enter_player_if_current_status_is_not_not_started()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "battle",
		players = {
			{ name = "John", army = "black" },
			{ name = "Paul", army = "white" },
		}
	}

	-- when:
	lu.assertErrorMsgEquals("Esta ação só pode ser realizada antes do começo da partida.", execute_enter_player_validations, state, "Michael Jackson", "blue")
end

function test_validators.test_should_not_validate_enter_player_if_the_name_is_already_in_use()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "not_started",
		players = {
			{ name = "John", army = "black" },
			{ name = "Paul", army = "white" },
			{ name = "George", army = "yellow" },
		}
	}

	-- when:
	lu.assertErrorMsgEquals("Já existe um jogador com o nome Paul.", execute_enter_player_validations, state, "Paul", "blue")
end

function test_validators.test_should_not_validate_enter_player_if_the_army_color_is_already_in_use()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "not_started",
		players = {
			{ name = "John", army = "black" },
			{ name = "Paul", army = "white" },
			{ name = "George", army = "yellow" },
		}
	}

	-- when:
	lu.assertErrorMsgEquals("Já existe um jogador com o exército Branco.", execute_enter_player_validations, state, "Ringo", "white")
end

function test_validators.test_should_not_validate_enter_player_if_the_army_color_is_unknow()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "not_started",
		players = {
			{ name = "John", army = "black" },
			{ name = "Paul", army = "white" },
			{ name = "George", army = "yellow" },
		}
	}

	-- when:
	lu.assertErrorMsgEquals("Cor de exército inválida ou desconhecida.", execute_enter_player_validations, state, "Ringo", "silver")
end
