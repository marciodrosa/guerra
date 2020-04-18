-- Table with all available continents in the game. Each key has a table with two fields: "armies_when_conquered" (number of
-- armies to add to the player if he have the continent conquered in the end of a turn) and "territories" (list of keys to the
-- territories table).
return {
	north_america = {
		territories = {
			"alaska",
			"mackenzie",
			"greenland",
			"vancouver",
			"ottawa",
			"labrador",
			"california",
			"new_york",
			"mexico"
		},
		armies_when_conquered = 5
	},
	south_america = {
		territories = {
			"venezuela",
			"brazil",
			"peru",
			"argentina"
		},
		armies_when_conquered = 2
	},
	europe = {
		territories = {
			"iceland",
			"england",
			"france",
			"germany",
			"sweden",
			"moscow",
			"poland"
		},
		armies_when_conquered = 5
	},
	africa = {
		territories = {
			"algeria",
			"egypt",
			"sudan",
			"congo",
			"south_africa",
			"madagascar"
		},
		armies_when_conquered = 3
	},
	asia = {
		territories = {
			"omsk",
			"aral",
			"middle_east",
			"dudinka",
			"siberia",
			"tchita",
			"mongolia",
			"china",
			"india",
			"vietnam",
			"vladivostok",
			"japan"
		},
		armies_when_conquered = 7
	},
	oceania = {
		territories = {
			"sumatra",
			"borneo",
			"new_guinea",
			"australia"
		},
		armies_when_conquered = 2
	}
}