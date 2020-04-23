test_validators = {}

local validators = require "validators"

local function execute_enter_player_validations(state, name, army)
	for i, f in ipairs(validators.enter_player_validations) do
		f(state, name, army)
	end
end

local function execute_start_game_validations(state)
	for i, f in ipairs(validators.start_game_validations) do
		f(state)
	end
end

local function execute_put_armies_validations(state, number_of_armies, territory)
	for i, f in ipairs(validators.put_armies_validations) do
		f(state, number_of_armies, territory)
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

	-- then:
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

	-- then:
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

	-- then:
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

	-- then:
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

	-- then:
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

	-- then:
	lu.assertErrorMsgEquals("Cor de exército inválida ou desconhecida.", execute_enter_player_validations, state, "Ringo", "silver")
end

function test_validators.test_should_validate_start_game()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "not_started",
		players = {
			{ name = "John", army = "black" },
			{ name = "Paul", army = "white" },
		}
	}

	-- then:
	execute_start_game_validations(state)
end

function test_validators.test_should_not_validate_start_game_if_it_is_already_started()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "battle",
		players = {
			{ name = "John", army = "black" },
			{ name = "Paul", army = "white" },
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Esta ação só pode ser realizada antes do começo da partida.", execute_start_game_validations, state)
end

function test_validators.test_should_not_validate_start_game_if_there_are_less_then_two_players()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "not_started",
		players = {
			{ name = "John", army = "black" },
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Não é possível iniciar o jogo até que pelo menos dois jogadores tenham entrado.", execute_start_game_validations, state)
end

function test_validators.test_should_validate_put_armies()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 3,
			armies_to_put_by_territory = {},
			armies_to_put_by_continent = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	execute_put_armies_validations(state, 3, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_territory_is_owned_by_another_player()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 3
			}
		},
		armies_arrangement = {
			total_armies_to_put = 3,
			armies_to_put_by_territory = {},
			armies_to_put_by_continent = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Não é possível colocar exércitos no território Brasil porque o mesmo não pertence ao jogador.", execute_put_armies_validations, state, 3, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_putting_more_armies_than_possible()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 3,
			armies_to_put_by_territory = {},
			armies_to_put_by_continent = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Jogador só possui mais 3 exércitos para colocar nos territórios.", execute_put_armies_validations, state, 4, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_it_made_impossible_to_put_mandatory_armies_in_another_territory()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 4,
			armies_to_put_by_territory = {
				argentina = 2
			},
			armies_to_put_by_continent = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Jogador só possui mais 4 exércitos e obrigatoriamente precisa distribuir para os seguintes territórios:\nArgentina - 2", execute_put_armies_validations, state, 4, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_it_made_impossible_to_put_mandatory_armies_in_many_other_territories()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 5,
			armies_to_put_by_territory = {
				argentina = 2,
				moscow = 1
			},
			armies_to_put_by_continent = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Jogador só possui mais 5 exércitos e obrigatoriamente precisa distribuir para os seguintes territórios:\nArgentina - 2\nMoscou - 1", execute_put_armies_validations, state, 3, "brazil")
end

function test_validators.test_should_validate_put_armies_if_there_are_territories_to_receive_armies_but_the_current_is_one_of_them()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 5,
			armies_to_put_by_territory = {
				argentina = 2,
				brazil = 2
			},
			armies_to_put_by_continent = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	execute_put_armies_validations(state, 3, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_the_territory_is_mandatory_but_there_are_others_also_mandatory()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 5,
			armies_to_put_by_territory = {
				argentina = 2,
				brazil = 2
			},
			armies_to_put_by_continent = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Jogador só possui mais 5 exércitos e obrigatoriamente precisa distribuir para os seguintes territórios:\nArgentina - 2", execute_put_armies_validations, state, 4, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_it_made_impossible_to_put_mandatory_armies_in_another_continent()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 4,
			armies_to_put_by_continent = {
				europe = 2
			},
			armies_to_put_by_territory = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Jogador só possui mais 4 exércitos e obrigatoriamente precisa distribuir para os seguintes continentes:\nEuropa - 2", execute_put_armies_validations, state, 4, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_it_made_impossible_to_put_mandatory_armies_in_many_other_continents()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 7,
			armies_to_put_by_continent = {
				europe = 2,
				africa = 3
			},
			armies_to_put_by_territory = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Jogador só possui mais 7 exércitos e obrigatoriamente precisa distribuir para os seguintes continentes:\nEuropa - 2\nÁfrica - 3", execute_put_armies_validations, state, 3, "brazil")
end

function test_validators.test_should_validate_put_armies_if_there_are_some_continents_to_receive_armies_but_the_territory_is_from_that_continent()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 7,
			armies_to_put_by_continent = {
				south_america = 2,
				africa = 3
			},
			armies_to_put_by_territory = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	execute_put_armies_validations(state, 3, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_there_are_some_other_continents_to_receive_armies()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = {
				owner_player = 2
			}
		},
		armies_arrangement = {
			total_armies_to_put = 7,
			armies_to_put_by_continent = {
				south_america = 2,
				africa = 4
			},
			armies_to_put_by_territory = {},
			armies_placed_by_territory = {}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Jogador só possui mais 7 exércitos e obrigatoriamente precisa distribuir para os seguintes continentes:\nÁfrica - 4", execute_put_armies_validations, state, 4, "brazil")
end

function test_validators.test_should_not_validate_put_armies_if_there_are_other_countries_in_the_same_continent_that_must_receive_armies()
	-- given:
	local state = {
		idiom = "pt_br",
		status = "arrange_armies",
		current_player = 2,
		territories = {
			brazil = { owner_player = 2	},
			madagascar = { owner_player = 2	},
		},
		armies_arrangement = {
			total_armies_to_put = 8,
			armies_to_put_by_continent = {
				south_america = 2,
				africa = 3
			},
			armies_to_put_by_territory = {
				brazil = 2,
			},
			armies_placed_by_territory = {
				brazil = 2
			}
		}
	}

	-- then:
	lu.assertErrorMsgEquals("Jogador só possui mais 6 exércitos e obrigatoriamente precisa distribuir para os seguintes continentes:\nAmérica do Sul - 2", execute_put_armies_validations, state, 5, "madagascar")
end
