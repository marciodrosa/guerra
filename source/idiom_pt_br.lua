return {
	goals = {
		defeat_blue_army = "SEU OBJETIVO É destruir completamente os EXÉRCITOS AZUIS. Se é você quem possui os exércitos AZUIS ou se o jogador que os possui for eliminado por um outro jogador, o seu objetivo passa a ser automaticamente conquistar 24 TERRITÓRIOS.",
		defeat_yellow_army = "SEU OBJETIVO É destruir completamente os EXÉRCITOS AMARELOS. Se é você quem possui os exércitos AMARELOS ou se o jogador que os possui for eliminado por um outro jogador, o seu objetivo passa a ser automaticamente conquistar 24 TERRITÓRIOS.",
		defeat_white_army = "SEU OBJETIVO É destruir completamente os EXÉRCITOS BRANCOS. Se é você quem possui os exércitos BRANCOS ou se o jogador que os possui for eliminado por um outro jogador, o seu objetivo passa a ser automaticamente conquistar 24 TERRITÓRIOS.",
		defeat_green_army = "SEU OBJETIVO É destruir completamente os EXÉRCITOS VERDES. Se é você quem possui os exércitos VERDES ou se o jogador que os possui for eliminado por um outro jogador, o seu objetivo passa a ser automaticamente conquistar 24 TERRITÓRIOS.",
		defeat_black_army = "SEU OBJETIVO É destruir completamente os EXÉRCITOS PRETOS. Se é você quem possui os exércitos PRETOS ou se o jogador que os possui for eliminado por um outro jogador, o seu objetivo passa a ser automaticamente conquistar 24 TERRITÓRIOS.",
		defeat_red_army = "SEU OBJETIVO É destruir completamente os EXÉRCITOS VERMELHOS. Se é você quem possui os exércitos VERMELHOS ou se o jogador que os possui for eliminado por um outro jogador, o seu objetivo passa a ser automaticamente conquistar 24 TERRITÓRIOS.",
		conquer_north_america_and_africa = "SEU OBJETIVO É conquistar na totalidade a AMÉRICA DO NORTE e a ÁFRICA.",
		conquer_asia_and_africa = "SEU OBJETIVO É conquistar na totalidade a ÁSIA e a ÁFRICA.",
		conquer_north_america_and_oceania = "SEU OBJETIVO É conquistar na totalidade a AMÉRICA DO NORTE e a OCEANIA.",
		conquer_south_america_and_asia = "SEU OBJETIVO É conquistar na totalidade a ÁSIA e a AMÉRICA DO SUL.",
		conquer_europe_and_south_america_and_other = "SEU OBJETIVO É conquistar na totalidade a EUROPA, a AMÉRICA DO SUL e mais um continente à sua escolha.",
		conquer_europe_and_oceania_and_other = "SEU OBJETIVO É conquistar na totalidade a EUROPA, a OCEANIA e mais um terceiro continente à sua escolha.",
		conquer_18_territories_with_2_armies_in_each = "SEU OBJETIVO É conquistar 18 TERRITÓRIOS e ocupar cada um deles com pelo menos dois exércitos.",
		conquer_24_territories = "SEU OBJETIVO É conquistar 24 TERRITÓRIOS à sua escolha.",
	},

	validations = {
		expected_status = {
			not_started = "Esta ação só pode ser realizada antes do começo da partida.",
		},
		expected_status_multiple = {
			not_started = "Antes do começo da partida",
			arrange_armies = "Enquanto os exércitos são posicionados",
			battle = "Durante a batalha",
			moving_armies = "Enquanto os exércitos são reposicionados",
		},
		unexpected_status_multiple = "Esta ação só pode ser realizada em um dos seguintes momentos:",
		max_number_of_players_already_achieved = "O máximo de jogadores já foi atingido (6).",
		player_name_already_in_use = "Já existe um jogador com o nome %s.",
		player_color_already_in_use = "Já existe um jogador com o exército %s.",
		invalid_color = "Cor de exército inválida ou desconhecida.",
		cant_start_with_less_than_two_players = "Não é possível iniciar o jogo até que pelo menos dois jogadores tenham entrado.",
		cant_put_armies_in_territory_that_is_not_owned_by_player = "Não é possível colocar exércitos no território %s porque o mesmo não pertence ao jogador.",
		player_has_only_x_armies_remaining_to_put = "Jogador só possui mais %s exércitos para colocar nos territórios.",
		player_has_only_x_armies_remaining_to_distribute_between_the_following_territories = "Jogador só possui mais %s exércitos e obrigatoriamente precisa distribuir para os seguintes territórios:",
		player_has_only_x_armies_remaining_to_distribute_between_the_following_continents = "Jogador só possui mais %s exércitos e obrigatoriamente precisa distribuir para os seguintes continentes:",
		origin_territory_does_not_belong_to_player = "O território %s não pertence ao jogador.",
		dest_territory_does_not_belong_to_player = "O território %s não pertence ao jogador.",
		territories_does_not_have_borders = "Os territórios %s e %s não fazem fronteira.",
		no_armies_placed_in_origin_on_arrangement = "Não é possível mover do território de origem %s porque nenhum exército foi colocado ali.",
		does_not_have_enough_armies_in_origin_on_arrangement = "Só há %s exércitos no território de origem.",
	},
	armies = {
		blue = "Azul",
		yellow = "Amarelo",
		white = "Branco",
		green = "Verde",
		black = "Preto",
		red = "Vermelho",
	},
	territories = {
		brazil = "Brasil",
		venezuela = "Venezuela",
		peru = "Peru",
		argentina = "Argentina",
		mexico = "México",
		california = "Califórnia",
		new_york = "Nova York",
		vancouver = "Vancouver",
		ottawa = "Ottawa",
		labrador = "Labrador",
		alaska = "Alaska",
		mackenzie = "Mackenzie",
		greenland = "Groenlândia",
		iceland = "Islândia",
		england = "Inglaterra",
		france = "França",
		germany = "Alemanha",
		sweden = "Suécia",
		poland = "Polônia",
		moscow = "Moscou",
		omsk = "Omsk",
		aral = "Aral",
		middle_east = "Oriente Médio",
		dudinka = "Dudinka",
		siberia = "Sibéria",
		tchita = "Tchita",
		mongolia = "Mongólia",
		china = "China",
		india = "Índia",
		vietnam = "Vietnã",
		vladivostok = "Vladivostok",
		japan = "Japão",
		algeria = "Argélia",
		egypt = "Egito",
		sudan = "Sudão",
		congo = "Congo",
		south_africa = "África do Sul",
		madagascar = "Madagascar",
		sumatra = "Sumatra",
		borneo = "Borneo",
		new_guinea = "Nova Guiné",
		australia = "Austrália",
	},
	continents = {
		north_america = "América do Norte",
		south_america = "América do Sul",
		europe = "Europa",
		africa = "África",
		asia = "Ásia",
		oceania = "Oceania",
	}
}
