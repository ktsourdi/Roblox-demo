local FishData = {}

FishData.BaseRates = {
	Common = 1,
	Rare = 2,
	Epic = 4,
	Legendary = 8,
	Mythic = 12,
}

FishData.FishByRarity = {
	Common = {
		{ id = "clownfish", name = "Clownfish" },
		{ id = "goldfish", name = "Goldfish" },
		{ id = "guppy", name = "Guppy" },
		{ id = "neon_tetra", name = "Neon Tetra" },
		{ id = "molly", name = "Molly" },
		{ id = "platy", name = "Platy" },
		{ id = "zebra_danio", name = "Zebra Danio" },
		{ id = "betta", name = "Betta" },
		{ id = "cardinal_tetra", name = "Cardinal Tetra" },
		{ id = "blenny", name = "Blenny" },
	},
	Rare = {
		{ id = "angelfish", name = "Angelfish" },
		{ id = "seahorse", name = "Seahorse" },
		{ id = "puffer", name = "Puffer" },
		{ id = "butterflyfish", name = "Butterflyfish" },
		{ id = "lionfish", name = "Lionfish" },
	},
	Epic = {
		{ id = "shark_pup", name = "Shark Pup" },
		{ id = "jellyfish", name = "Jellyfish" },
		{ id = "electric_ray", name = "Electric Ray" },
	},
	Legendary = {
		{ id = "coelacanth", name = "Coelacanth" },
	},
	Mythic = {
		{ id = "sea_dragon", name = "Sea Dragon" },
	},
	Event = {
		{ id = "event_jelly", name = "Jelly Sprout" },
	},
}

return FishData

