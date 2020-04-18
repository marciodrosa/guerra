return {
	brazil = {
		borders = { "argentina", "peru", "venezuela", "algeria" },
	},
	venezuela = {
		borders = { "brazil", "peru", "mexico" }
	},
	peru = {
		borders = { "brazil", "venezuela", "argentina" }
	},
	argentina = {
		borders = { "brazil", "peru" }
	},
	mexico = {
		borders = { "venezuela", "california", "new_york" }
	},
	california = {
		borders = { "mexico", "new_york", "vancouver", "ottawa" }
	},
	new_york = {
		borders = { "mexico", "california", "ottawa", "labrador" }
	},
	vancouver = {
		borders = { "california", "ottawa", "alaska", "mackenzie" }
	},
	ottawa = {
		borders = { "california", "new_york", "labrador", "mackenzie", "vancouver" }
	},
	labrador = {
		borders = { "ottawa", "new_york", "greenland" }
	},
	alaska = {
		borders = { "vancouver", "mackenzie", "vladivostok" }
	},
	mackenzie = {
		borders = { "alaska", "vancouver", "ottawa", "greenland" }
	},
	greenland = {
		borders = { "mackenzie", "labrador", "iceland" }
	},
	iceland = {
		borders = { "greenland", "england" }
	},
	england = {
		borders = { "iceland", "sweden", "france", "germany" }
	},
	france = {
		borders = { "england", "germany", "poland", "algeria", "egypt" }
	},
	germany = {
		borders = { "england", "france", "poland" }
	},
	sweden = {
		borders = { "england", "moscow" }
	},
	poland = {
		borders = { "germany", "france", "egypt", "moscow", "middle_east" }
	},
	moscow = {
		borders = { "sweden", "poland", "omsk", "aral", "middle_east" }
	},
	omsk = {
		borders = { "moscow", "dudinka", "aral", "mongolia", "china" }
	},
	aral = {
		borders = { "omsk", "moscow", "middle_east", "india", "china" }
	},
	middle_east = {
		borders = { "aral", "india", "egypt", "poland", "moscow" }
	},
	dudinka = {
		borders = { "omsk", "mongolia", "tchita", "siberia" }
	},
	siberia = {
		borders = { "dudinka", "tchita", "vladivostok" }
	},
	tchita = {
		borders = { "siberia", "dudinka", "mongolia", "china", "vladivostok" }
	},
	mongolia = {
		borders = { "dudinka", "omsk", "china", "tchita" }
	},
	china = {
		borders = { "omsk", "aral", "india", "vietnam", "japan", "vladivostok", "tchita", "mongolia" }
	},
	india = {
		borders = { "middle_east", "aral", "china", "vietnam", "sumatra" }
	},
	vietnam = {
		borders = { "india", "china", "borneo" }
	},
	vladivostok = {
		borders = { "siberia", "tchita", "china", "japan", "alaska" }
	},
	japan = {
		borders = { "china", "vladivostok" }
	},
	algeria = {
		borders = { "france", "brazil", "egypt", "sudan", "congo" }
	},
	egypt = {
		borders = { "france", "poland", "middle_east", "algeria", "sudan" }
	},
	sudan = {
		borders = { "egypt", "algeria", "congo", "south_africa", "madagascar" }
	},
	congo = {
		borders = { "algeria", "sudan", "south_africa" }
	},
	south_africa = {
		borders = { "congo", "sudan", "madagascar" }
	},
	madagascar = {
		borders = { "south_africa", "sudan" }
	},
	sumatra = {
		borders = { "india", "australia" }
	},
	borneo = {
		borders = { "vietnam", "australia", "new_guinea" }
	},
	new_guinea = {
		borders = { "borneo", "australia" }
	},
	australia = {
		borders = { "sumatra", "borneo", "new_guinea" }
	}
}
