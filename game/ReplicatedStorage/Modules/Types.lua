-- Luau type stubs for clarity (optional at runtime)

export type Currency = {
	Tickets: number,
	Coins: number,
}

export type Fish = {
	id: string,
	name: string,
	rarity: string?,
}

export type Tank = {
	type: string,
	slots: { Fish },
	decorations: { string },
}

return {}

