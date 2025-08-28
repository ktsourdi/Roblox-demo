## Roblox Aquarium Egg Game – MVP Specification

### 1. Core Gameplay Loop
- **Join**: Player spawns with a starter aquarium and starter currency.
- **Buy Egg**: Shop offers Common, Rare, Mythic eggs.
- **Hatch**: Egg rolls onto a fish based on rarity weights; fish goes to Inventory.
- **Place**: Player places fish into a Tank within their Aquarium.
- **Earn**: Tanks generate Tickets over time based on housed fish and multipliers.
- **Spend**: Tickets buy more Eggs or Decorations; Coins buy upgrades.
- **Social**: Friends can visit, like, and grant temporary boosts.

### 2. Game Systems

#### A. Economy
- **Tickets**: Passive income from tanks. Generated per minute.
- **Coins**: Earned via play; used for upgrades and progression.
- **Robux**: Optional monetisation (egg bundles, cosmetics, event décor).
- **Fish rarity**: Higher rarity → higher ticket generation.
- **Decorations**: Multipliers to tank ticket output and increase Aquarium Rating.
- **Friend visit**: Temporary boost to ticket rate for both players.

#### B. Egg Shop
- **Common Egg**: Cheap; 80% common / 15% rare / 5% epic.
- **Rare Egg**: Mid-tier; 60% rare / 30% epic / 10% legendary.
- **Mythic Egg**: Expensive; 80% epic / 20% legendary/mythic.
- **Special Event Eggs**: Limited-time (e.g., Jelly Egg) with event fish pool.

#### C. Aquarium & Tanks
- **Starter Aquarium**: 1 small tank.
- **Tank Upgrades**: Unlock more tank slots and larger capacity.
- **Decorations**: Increase Aquarium Rating and provide multipliers.
- **Rating Progression**: Higher rating unlocks new tanks and badges.

#### D. Social Features
- **Friend Visits**: Grant boosts to tickets for both players.
- **Likes System**: Leaderboard of most liked aquariums.
- **Announcements**: Server broadcast when someone hatches a rare+ fish.

#### E. Events & Retention
- **Weekly Event Egg**: Rotating egg with unique fish.
- **Daily Login Bonus**: Coins and occasional free egg chance.
- **Promo Codes**: Redeemable codes for rewards.

### 3. Content for MVP
- **Fish (20 total)**
  - Common (10): Clownfish, Goldfish, Guppy, Neon Tetra, Molly, Platy, Zebra Danio, Betta, Cardinal Tetra, Blenny
  - Rare (5): Angelfish, Seahorse, Puffer, Butterflyfish, Lionfish
  - Epic (3): Shark Pup, Jellyfish, Electric Ray
  - Legendary/Mythic (2): Coelacanth, Sea Dragon
- **Tanks (3 types)**: Small (2 fish), Medium (5 fish), Large (10 fish)
- **Decorations (10 items)**: Plants, rocks, coral, lights, treasure chest, seaweed, anemone, bubble maker, shipwreck, glowing coral

### 4. Technical Setup

#### Services
- **DataStore / ProfileService**: Player saves (profile template with inventory, tanks, currencies, stats).
- **ReplicatedStorage**: Shared assets and RemoteEvents.
- **ServerScripts**: Economy, hatching, shop, social, retention logic.
- **LocalScripts**: UI, animations, hatch sequence.
- **RemoteEvents**: `BuyEgg`, `HatchEgg`, `PlaceFish`, `VisitBoost`, `LikeAquarium`, `RedeemCode`, `Announcement`.
- **Badges**: Milestones (first hatch, mythic hatch, aquarium rating).
- **OrderedDataStores**: Leaderboards (likes, tickets earned).

#### Studio Folders
- `ReplicatedStorage`: `RemoteEvents`, `Modules`, `FishModels`, `EggModels`
- `ServerStorage`: `ShopConfig`, `FishData`, `TankData`, `Decorations`
- `ServerScriptService`: `Main`, `Modules` (ProfileManager, ShopService, EconomyService, SocialService, EventsService, LeaderboardService, BadgesService)
- `Workspace`: `Lobby`, `ExampleAquarium`
- `StarterGui`: Shop UI, Inventory UI, Rating UI, Codes UI
- `StarterPlayerScripts`: Hatch animation and client listeners

### 5. Monetisation
- **Gamepasses**: Extra tank slots, faster hatching, VIP décor.
- **Dev Products**: Egg bundles (x3, x5, x10), ticket boosts, event décor.

### 6. MVP Deliverables
- Aquarium Lobby hub
- Shop with 3 egg types
- 20 fish collection
- Aquarium placement system (fish + décor)
- Ticket income system
- Save/load player progress
- Friend visit boosts + like system
- Hatch animation + announcement system

### 7. Data Model (Profile Template)
```lua
local ProfileTemplate = {
	Currencies = {
		Tickets = 0,
		Coins = 0,
	},
	Inventory = {
		Fish = {}, -- array of { id, rarity, name }
		Decorations = {}, -- array of { id, modifier }
	},
	Aquarium = {
		Tanks = {
			-- array of tanks: { type = "Small"|"Medium"|"Large", slots = {}, decorations = {} }
		},
		Rating = 0,
	},
	Stats = {
		Likes = 0,
		TicketsEarnedLifetime = 0,
		LastDailyLogin = 0,
	},
}
```

### 8. Remotes
- `BuyEgg(eggType: string)` → server validates price and returns result
- `HatchEgg(eggType: string)` → rolls fish, adds to inventory
- `PlaceFish(tankIndex: number, fishIndex: number)` → places inventory fish into a tank slot
- `VisitBoost(targetUserId: number)` → triggers visit boost for both
- `LikeAquarium(targetUserId: number)` → increments like count
- `RedeemCode(code: string)` → processes promo rewards
- `Announcement(message: string)` → server → all clients broadcast

### 9. Rarity Weights (MVP)
- Common Egg: { Common = 80, Rare = 15, Epic = 5 }
- Rare Egg: { Rare = 60, Epic = 30, Legendary = 10 }
- Mythic Egg: { Epic = 80, Legendary = 15, Mythic = 5 }

### 10. Ticket Rate Formula (MVP)
Let \( R_f \) be fish base rate by rarity; \( M_d \) the product of decoration multipliers; \( B_v \) the friend visit boost; \( C_t \) tank capacity scaler.

\[ \text{TicketsPerMinute} = (\sum R_f) \times M_d \times B_v \times C_t \]

Defaults:
- Base rates by rarity: Common 1, Rare 2, Epic 4, Legendary 8, Mythic 12 (tickets/min)
- Decoration multipliers: 1.0–1.5 per decoration; stack multiplicatively
- Visit boost: 1.25× for 5 minutes
- Tank capacity scaler: 1.0 when not exceeding slots

### 11. Badges (MVP)
- First Hatch, Mythic Hatch, Rating Milestones (10, 25, 50)

### 12. Leaderboards (MVP)
- Most Likes, Most Tickets Earned Lifetime (OrderedDataStore keys by userId)

