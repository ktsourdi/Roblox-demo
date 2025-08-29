local ShopConfig = {}

ShopConfig.Eggs = {
	Common = {
		priceType = "Tickets",
		priceAmount = 100,
		weights = { Common = 80, Rare = 15, Epic = 5 },
	},
	Rare = {
		priceType = "Tickets",
		priceAmount = 1000,
		weights = { Rare = 60, Epic = 30, Legendary = 10 },
	},
	Mythic = {
		priceType = "Tickets",
		priceAmount = 7500,
		weights = { Epic = 80, Legendary = 15, Mythic = 5 },
	},
	-- EventEgg example (disabled by default)
	Event = {
		enabled = false,
		priceType = "Tickets",
		priceAmount = 2500,
		pool = "Event",
		weights = { Rare = 50, Epic = 40, Legendary = 10 },
	},
}

ShopConfig.Gamepasses = {
	ExtraTankSlots = 0, -- set your gamepass ID
	FasterHatching = 0,
	VIPDecor = 0,
}

ShopConfig.DevProducts = {
	EggBundle3 = 0,
	EggBundle5 = 0,
	EggBundle10 = 0,
	TicketBoost = 0,
	EventDecor = 0,
}

return ShopConfig

