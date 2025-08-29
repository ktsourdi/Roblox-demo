## Roblox Studio Setup – Aquarium Egg Game (MVP)

### 1) Create Folder Structure
Place these in Studio:

- `ReplicatedStorage`
  - `RemoteEvents` (Folder)
  - `Modules` (Folder)
  - `FishModels` (Folder)
  - `EggModels` (Folder)
- `ServerStorage`
  - `ShopConfig` (ModuleScript)
  - `FishData` (ModuleScript)
  - `TankData` (ModuleScript)
  - `Decorations` (ModuleScript)
- `ServerScriptService`
  - `Main` (Script)
  - `RemotesSetup` (Script)
  - `Modules` (Folder)
    - `ProfileManager` (ModuleScript)
    - `ShopService` (ModuleScript)
    - `EconomyService` (ModuleScript)
    - `SocialService` (ModuleScript)
    - `EventsService` (ModuleScript)
    - `LeaderboardService` (ModuleScript)
    - `BadgesService` (ModuleScript)
- `StarterGui`
  - Shop UI, Inventory UI, Rating UI, Codes UI
- `StarterPlayer` → `StarterPlayerScripts`
  - `HatchAnimation` (LocalScript)

### 2) Import Scripts from this repo
- Copy `game/ReplicatedStorage/Modules/*` into `ReplicatedStorage/Modules`
- Copy `game/ServerStorage/*` into `ServerStorage`
- Copy `game/ServerScriptService/*` into `ServerScriptService`
- Copy `game/StarterPlayer/StarterPlayerScripts/*` into `StarterPlayer/StarterPlayerScripts`

### 3) Wire Remotes
- Ensure `RemotesSetup` runs on server start; it will create RemoteEvents under `ReplicatedStorage/RemoteEvents`:
  - `BuyEgg`, `HatchEgg`, `PlaceFish`, `VisitBoost`, `LikeAquarium`, `RedeemCode`, `Announcement`

### 4) DataStore Permissions
- Enable Studio API access to DataStores for testing.
- Publish the place to enable DataStores.

### 5) Test Flow
- Join Play Solo → confirm profile creates with starter tank and currency.
- Use dummy button to invoke `BuyEgg`/`HatchEgg` → confirm inventory updates.
- Place fish into tank → watch ticket income increase server-side.
- Use two test clients to try `VisitBoost` and `LikeAquarium`.

### 6) Monetisation (Optional for MVP)
- Set up Dev Products (IDs) and Gamepasses; map them in `ShopConfig`.

### 7) Deployment
- Ensure badges exist and IDs are placed in `BadgesService`.
- Verify leaderboards created via OrderedDataStores after some playtime.

