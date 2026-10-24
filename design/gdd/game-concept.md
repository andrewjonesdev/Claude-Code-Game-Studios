# Game Concept: Rogue Royale 3D

*Created: 2026-03-25*
*Status: Draft*
*Based on: Rogue Royale Reloaded by IanGoGo (itch.io/rogue-royale)*

---

## Elevator Pitch

> It's a **roguelike FPS** where you pick a hero with unique abilities, drop
> into a **shrinking 3D arena**, scavenge weapons and perk cards, and fight
> through escalating waves of AI enemies — solo or with friends. Survive all
> rounds to win, or die trying and spend upgrade coins to come back stronger.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Roguelike FPS / PvE Battle Royale |
| **Platform** | PC (primary), Console (future) |
| **Target Audience** | Mid-core FPS players who enjoy roguelike progression |
| **Player Count** | 1-4 players (Solo + Co-op PvE) |
| **Session Length** | 20-30 minutes per run |
| **Monetization** | Premium (buy once, play forever) |
| **Estimated Scope** | Medium (vertical slice in 1-3 months) |
| **Comparable Titles** | Risk of Rain 2, Deep Rock Galactic, Roboquest |

---

## Core Fantasy

You are one of a roster of stylized heroes dropped into an arena that's
closing in around you. Enemies swarm from all directions. You grab a shotgun
off the ground, find a perk card that makes your bullets explode, and
activate your ultimate ability to clear a path through the horde. The zone
shrinks. The enemies get harder. Your build gets crazier. Can you survive
all the rounds, or will this be the run where everything falls apart?

The core fantasy is **becoming an unstoppable action hero through improvisation** —
not through pre-planned loadouts, but through adapting to whatever weapons,
perks, and situations the arena throws at you.

---

## Unique Hook

**Like Risk of Rain 2, AND ALSO the zone is shrinking like a battle royale.**

The battle royale structure (shrinking arena, ground loot, round escalation)
applied to PvE instead of PvP. This creates the urgency and scavenging
tension of a battle royale without the frustration of dying to another
player. Every run is fair — it's you vs. the arena.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Sensation** (sensory pleasure) | 1 | Punchy polyart visuals, weapon feedback, ability VFX, hit indicators |
| **Challenge** (obstacle course, mastery) | 2 | Escalating difficulty, zone pressure, boss fights, high skill ceiling |
| **Discovery** (exploration, secrets) | 3 | Random perk combinations, weapon drops, build experimentation |
| **Fantasy** (make-believe, role-playing) | 4 | Hero abilities, stylized characters, power fantasy through builds |
| **Fellowship** (social connection) | 5 | Co-op revives, squad ability synergies, shared war stories |
| **Expression** (self-expression, creativity) | 6 | Hero choice, build variety, cosmetic unlocks |
| **Narrative** (drama, story arc) | 7 | Light lore via NarrativePro quests explaining the arena |
| **Submission** (relaxation, comfort zone) | N/A | Not a relaxing game |

### Key Dynamics (Emergent player behaviors)
- Players will experiment with hero + perk combinations to find broken synergies
- Co-op squads will develop preferred hero compositions (tank/DPS/support)
- Players will learn optimal scavenging routes through the shrinking arena
- Risk/reward decisions: push into danger for better loot vs. play safe
- Players will share "god run" stories where everything clicked

### Core Mechanics (Systems we build)
1. **FPS Combat** — GMC-based movement + GMAS abilities for hero kits
2. **Shrinking Arena** — Procedural zone that closes over rounds, forcing encounters
3. **Weapon Scavenging** — 21 weapon types found on ground or dropped by enemies
4. **Perk Pickup System** — Passive buff cards found during gameplay, stack 5-8 per run
5. **Round Escalation** — Enemy waves increase in difficulty each round, bosses at milestones

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** (freedom, meaningful choice) | Choose hero, choose weapons, choose perks, choose path through arena | Core |
| **Competence** (mastery, skill growth) | Aim skill, movement tech, build knowledge, boss patterns | Core |
| **Relatedness** (connection, belonging) | Co-op synergies, revive mechanics, shared progression | Supporting |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Achievers** — Complete runs, unlock heroes, max upgrades, beat harder difficulties
- [x] **Explorers** — Discover perk synergies, find rare weapons, test hero builds
- [x] **Socializers** — Co-op teamplay, hero composition planning, shared war stories
- [ ] **Killers/Competitors** — Not primary (PvE focused, no PvP leaderboards)

### Flow State Design

- **Onboarding curve**: First run is Soldier (simplest hero) on Easy. Tutorial via gameplay, not menus. Pick up weapon, shoot enemies, find perk, survive.
- **Difficulty scaling**: Rounds escalate within a run. Meta-difficulty settings (Easy/Medium/Hard/Insane) scale enemy stats and spawn rates.
- **Feedback clarity**: Damage numbers, hit markers, kill feed, perk pickup notifications, round completion fanfare, XP/coin earning visible.
- **Recovery from failure**: Death ends the run but keeps upgrade coins. Restart immediately. In co-op, teammates can revive within a timer.

---

## Core Loop

### Moment-to-Moment (30 seconds)
Sprint through the arena, shoot AI enemies with scavenged weapons, dodge
attacks, use hero abilities (tactical on cooldown, ultimate when charged).
Pick up weapons, ammo, health potions (max 3), and perk cards from the
ground and dead enemies. Every action feels punchy and responsive.

### Short-Term (5-15 minutes — one round)
Arena shrinks over ~2-3 minutes. Enemies spawn in waves, increasing in
difficulty. Scavenge while fighting. Round ends when all enemies are
eliminated. Between rounds: brief shop phase to spend coins on weapon
upgrades, pick from random perk cards. Choose wisely — your build defines
your power.

### Session-Level (20-30 minutes — one run)
5-8 rounds of escalating difficulty. Each round: smaller zone, harder
enemies, better loot. Boss encounter at round 5 and round 8. Win by
surviving all rounds. Die and keep upgrade coins proportional to rounds
survived. "One more run" — different hero + different perks = new experience.

### Long-Term Progression
- Upgrade coins buy permanent meta-upgrades (starting health, damage, perk slots)
- Heroes unlock through milestone challenges (reach round 5, complete a run, etc.)
- Perk cards unlock through challenges (kill 100 enemies with shotgun, survive round 8)
- NarrativePro quest line reveals lore (why does the arena exist? who runs it?)
- Difficulty tiers unlock as you prove mastery

### Retention Hooks
- **Curiosity**: "I haven't tried Ninja yet — how does stealth work in this?"
- **Investment**: "I'm 3 upgrades away from maxing out my health tree"
- **Social**: "My friend and I almost beat Insane difficulty last night"
- **Mastery**: "I can consistently reach round 6 now, round 8 is next"

---

## Game Pillars

### Pillar 1: Every Run Tells a Story
Each run produces a unique combination of hero, weapons, perks, and arena
layout. No two runs feel the same.

*Design test*: If a feature makes runs feel samey (e.g., optimal builds),
redesign it — add more randomness, nerf the dominant strategy, or add
new perks that counter it.

### Pillar 2: Easy In, Deep Down
Pick up and play in 30 seconds. Master over 100 hours. Skill ceiling from
movement tech, ability combos, and build knowledge — not from complexity.

*Design test*: If a new player can't understand a mechanic in one run,
simplify it. If a veteran player has nothing to optimize, add depth.

### Pillar 3: The Zone Never Lies
The shrinking arena creates urgency, forces encounters, and prevents camping.
Every design decision serves the forward pressure of the closing zone.

*Design test*: If a feature encourages sitting still or avoiding combat,
it violates the zone. The zone is always pushing you forward.

### Pillar 4: Heroes, Not Classes
Each character is a distinct personality with abilities that change HOW you
play, not just stat differences. Ninja plays fundamentally differently from
Robot plays differently from Cowboy.

*Design test*: If two heroes feel interchangeable in gameplay, redesign one
of them. Cosmetic differences are not enough.

### Pillar 5: Better Together
Co-op is a first-class experience, not bolted on. Hero abilities synergize
across the squad. Revives, shared perks, and coordinated ultimates make
teamplay feel powerful.

*Design test*: If a feature works in solo but breaks in co-op (or vice
versa), redesign it to work in both.

### Anti-Pillars (What This Game Is NOT)

- **NOT a competitive PvP game**: Pressure comes from AI, not other players. No frustration of dying to someone better.
- **NOT a slow tactical shooter**: Movement is fast. Guns are loud. Action is constant. This is not Tarkov.
- **NOT a story-first game**: Narrative exists via NarrativePro but gameplay is king. You can skip every dialogue and still have a blast.
- **NOT a live-service grind**: Full progression achievable in reasonable playtime. No FOMO, no battle passes, no daily login rewards.

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| Risk of Rain 2 | Roguelike FPS structure, item stacking, escalating difficulty | Battle royale zone pressure instead of open map timer | Proves roguelike FPS PvE loop works and retains players |
| Rogue Royale Reloaded | Shrinking arena, perk cards, weapon scavenging, round progression | 3D FPS instead of 2D top-down, real-time instead of turn-based | The original game whose design we're adapting |
| Deep Rock Galactic | Co-op PvE FPS with distinct classes, procedural maps | Not class-based mining — hero abilities + battle royale structure | Proves co-op PvE FPS has a massive audience |
| Roboquest | FPS roguelike with weapon scavenging | More hero variety, battle royale zone pressure, stylized polyart | Similar space but we differentiate with heroes + zone |
| Hyper Scape | Hitscan-heavy BR, hack abilities, vertical city maps, sector-based shrinking, weapon fusion upgrades | PvE instead of PvP, roguelike progression, hero movement systems | Our #1 BR influence — proves arena FPS gunplay works in BR format. Sector shrinking, verticality, and fusion upgrades directly inform our design |
| Quake Champions | Hero-based arena FPS where each champion has unique movement physics | PvE roguelike instead of PvP arena, more heroes, progression | Proves hero-differentiated movement works and creates skill ceilings |
| Quake 3 / Quake Live | VQ3 strafe jumping — the gold standard of skill-based FPS movement | One hero uses this; others use different movement systems | The movement tech IS the game for skilled players |
| CPMA / Reflex Arena | Full air control bunny hopping, no speed cap, infinite skill ceiling | Adapted as one hero's movement system within a roguelike FPS | Proves movement mastery creates deep replayability |
| Titanfall 2 | Wall running + double jump chaining, momentum-based traversal | Adapted as one hero's movement, combined with roguelike structure | Best-in-class wall running feel, massive fan devotion to the movement |
| Unreal Tournament | Double-tap dodge, dodge-jump chains, wall dodge, impact jumping | Adapted as one hero's movement system | Classic arena movement that feels distinct from Quake |

**Non-game inspirations**: Battle Royale (film) for the arena pressure concept, speedrunning culture for the movement mastery depth, fighting game community for the "lab your character" mentality (each hero is a movement puzzle to master).

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 16-35 |
| **Gaming experience** | Mid-core to hardcore FPS players |
| **Time availability** | 20-60 minute sessions |
| **Platform preference** | PC (Steam), future console |
| **Current games they play** | Risk of Rain 2, Deep Rock Galactic, Fortnite, Gunfire Reborn |
| **What they're looking for** | A co-op FPS with roguelike replay value and accessible action |
| **What would turn them away** | PvP frustration, mandatory grind, pay-to-win, complex systems |

---

## Technical Considerations

## Weapon Design Philosophy

**CORE GUNPLAY IDENTITY**: Weapons feel like classic arena FPS guns — not
military shooters. Projectile-based combat with high skill ceilings.
Tracking aim is as important as flick aim. Every weapon has a unique
rhythm and mastery curve.

**Influences**: Quake 3/Live (LG, Rail, Rocket), Unreal Tournament (Shock
Combo, Flak Cannon), Doom Eternal (weapon switching flow), Overwatch
(Tracer/Zarya tracking), Apex Legends (old Charge Rifle beam).

### Weapon Roster (21 weapons, organized by aim type)

**Tracking Weapons** (sustained beam/stream — reward smooth aim):
| Weapon | Inspiration | Behavior |
|--------|------------|----------|
| Lightning Gun | Quake LG | Continuous beam, high DPS at close-mid range, requires constant tracking |
| Plasma Stream | Custom | Wider beam, lower DPS, easier tracking, good for beginners |
| Charge Beam | Apex Charge Rifle (original) | Hold to charge continuous beam, increasing damage over time |
| Flamethrower | Doom Eternal | Short range cone, sustained fire, area denial |

**Projectile Weapons** (leading shots — reward prediction):
| Weapon | Inspiration | Behavior |
|--------|------------|----------|
| Rocket Launcher | Quake RL | Slow projectile, splash damage, rocket jump potential |
| Grenade Launcher | Quake GL | Arcing projectile, bounces, timed detonation |
| Plasma Gun | Quake PG | Fast projectiles, high rate of fire, slight splash |
| Acid Launcher | Custom | Arcing DoT projectile, area denial puddle |

**Flick/Precision Weapons** (single shot — reward snap aim):
| Weapon | Inspiration | Behavior |
|--------|------------|----------|
| Railgun | Quake Rail | Hitscan, high damage, long cooldown between shots, penetrates |
| Sniper Rifle | Classic | Hitscan, scope, headshot multiplier |
| Crossbow | Custom | Projectile, high damage, slow fire rate, pinpoint accuracy |

**Combo Weapons** (multi-mode — reward weapon mastery):
| Weapon | Inspiration | Behavior |
|--------|------------|----------|
| Shock Cannon | UT Shock Rifle | Primary: fast projectile. Alt: energy ball. Shoot ball with primary = COMBO explosion |
| Flak Cannon | UT Flak | Primary: shotgun spread of shrapnel. Alt: flak bomb (grenade-like) |

**Shotguns** (close range burst):
| Weapon | Inspiration | Behavior |
|--------|------------|----------|
| Combat Shotgun | Doom Eternal SSG | Tight spread, devastating up close, rewards aggressive play |
| Auto Shotgun | Custom | Wider spread, faster fire rate, less damage per shot |

**Rapid Fire** (spray control):
| Weapon | Inspiration | Behavior |
|--------|------------|----------|
| Minigun | Quake/UT | Wind-up time, insane DPS when spinning, movement penalty |
| SMG | Custom | Fast fire rate, low damage, high mobility |
| Assault Rifle | Standard | Mid-range workhorse, moderate recoil pattern |

**Special**:
| Weapon | Inspiration | Behavior |
|--------|------------|----------|
| BFG | Doom BFG | Ultra-rare arena pickup, massive AoE, limited ammo |
| Gravity Gun | HL2 | Pick up and throw objects/enemies, utility weapon |

### Weapon Design Rules

1. **Hitscan-dominant roster**. Most weapons are hitscan (beams, bullets, rails)
   to directly reward raw aim skill. Tracking and flicking are the primary
   skill expression. Projectile weapons (Rocket, Grenade) exist for splash
   damage and area denial but hitscan is king.
2. **Every weapon has a skill ceiling**. Rocket jumping with the RL. Shock combos
   with the Shock Cannon. LG tracking at max range. No "hold trigger to win" guns.
3. **Carry all weapons** (classic Quake philosophy). No weapon limit — grab
   everything you find. Weapon switching is instant (Doom Eternal flow).
   The skill is switching to the right weapon for each situation:
   Rail → switch → Rocket → switch → LG.
   **BUT: Each round resets you to ONLY your signature weapon.** You must
   scavenge your arsenal back each round. Fusion levels persist — if you
   fused your LG to Lv3 in round 2, you just need to find ONE LG in round
   3 to get it back at Lv3. This creates a scavenging loop every round
   and makes sector collapses devastating (that Railgun sector just vanished).
4. **No reload on arena weapons** (Quake philosophy for most weapons). Ammo
   management replaces reloading. Some weapons (Shotgun, Sniper) can have
   reload for pacing.
5. **Weapon Fusion** (from Hyper Scape). Pick up a duplicate of a weapon you
   already carry = weapon levels up. Level 1→2→3→4→MAX. Each level improves
   damage, fire rate, or spread. No menus — just grab the same gun again.
   Creates scavenging decisions: keep searching for another LG to fuse, or
   grab a new weapon type?
6. **Weapon pickups glow and hum**. You hear a Railgun before you see it.
   Finding a Lightning Gun should feel like Christmas.
7. **Weapons have personality**. The Flak Cannon SOUNDS like metal shredding.
   The Rocket Launcher has weight. The LG crackles and hums.

### Aim Skill Expression

The weapon roster is designed so EVERY aim style has weapons to master:

| Aim Style | Kovaak's Equivalent | Weapons |
|-----------|-------------------|---------|
| **Tracking** | Smooth tracking, reactive tracking | Lightning Gun, Plasma Stream, Charge Beam, Flamethrower |
| **Clicking/Flick** | Static/dynamic clicking | Railgun, Sniper, Crossbow |
| **Projectile Leading** | Leading (custom) | Rocket Launcher, Plasma Gun, Grenade Launcher |
| **Shotgun Flick** | Close-range flick | Flak Cannon, Combat Shotgun |
| **Spray Control** | Recoil control | Minigun, SMG, Assault Rifle |
| **Combo/Switching** | Target switching | Shock Combo, weapon switch chains |

---

| Consideration | Assessment |
| ---- | ---- |
| **Engine** | Unreal Engine 5.7 (already configured) |
| **Key Technical Challenges** | Procedural arena generation, AI enemy pathfinding in shrinking zone, co-op networking |
| **Art Style** | Stylized polyart (using BattleRoyaleHeroesPolyart + LowPolyFPSBundle assets) |
| **Art Pipeline Complexity** | Low (existing asset packs + modifications) |
| **Audio Needs** | Moderate (weapon SFX, ability SFX, music, announcer) |
| **Networking** | Client-Server via GMCv2 (1-4 players co-op) |
| **Content Volume** | 8 heroes, 21 weapons, 30+ perks, 12+ enemy types, 3 boss fights |
| **Procedural Systems** | Arena layout variation (modular tile-based), enemy spawn patterns, perk/loot distribution |
| **Movement Framework** | NarrativeGMC plugin (GMCv2 + GMCExtended + GMAS + NarrativePro bridge) |
| **UI System** | WebUI + JsonLibrary (HTML/CSS/JS for HUD, menus, inventory) |
| **Ability System** | GMAS (GMCAbilitySystem) — 14 base abilities ported from NarrativePro |

---

## Risks and Open Questions

### Design Risks
- Core loop may not sustain runs beyond 20 minutes without enough build variety
- 8 heroes with full kits (passive + tactical + ultimate) is ambitious for vertical slice
- Perk balance — "broken" combos are fun in roguelikes but can trivialize content

### Technical Risks
- Procedural arena generation quality with polyart assets
- AI enemy behavior in a shrinking zone (pathfinding to player, respecting zone boundaries)
- Co-op networking stability with GMCv2 (proven framework but our integration is new)

### Market Risks
- Roguelike FPS is an active space (Risk of Rain 2, Gunfire Reborn, Roboquest)
- Polyart style may not appeal to players expecting realistic graphics
- PvE-only may limit audience compared to PvP battle royales

### Scope Risks
- 8 heroes with full kits could take longer than estimated
- WebUI integration for game HUD is less proven than UMG
- NarrativeGMC plugin is v0.1.0 and may need iteration

### Open Questions
- How should the arena procedurally generate? (Tile-based sectors using PCG framework)
- CONFIRMED: Zone shrink uses **Hyper Scape sector collapse** — entire map
  sectors dissolve/vanish instead of a closing ring. The map is built from
  modular sectors; each round, sectors are selected to collapse. Players on
  collapsing sectors take damage or are pushed out. Creates unpredictable
  zone patterns, dramatic moments, and natural map reshaping.
- What's the right number of rounds per run? (5? 8? Dynamic based on difficulty?)
- CONFIRMED: **Crown Mechanic** (from Hyper Scape) — final round spawns a
  Crown in the last sector. Win by eliminating all enemies OR holding the
  Crown for X seconds while enemies swarm you. Creates a dramatic endgame
  objective and an alternative win condition.
- How do hero abilities interact with the zone? (Can abilities slow the zone? Expand it temporarily?)
- Should perks persist between runs in any form? (Or fully reset each run?)

---

## MVP Definition

**Core hypothesis**: Players find the hero-based FPS roguelike loop engaging
for 20+ minute sessions, and the shrinking arena creates meaningful urgency.

**Required for MVP**:
1. 1 procedural arena (modular, with zone shrinking)
2. 3 playable heroes (Soldier, Ninja, Robot) with full kits
3. 8 weapons (AssaultRifle, Shotgun, Pistol, SMG, SniperRifle, Knife, Grenade, Minigun)
4. 10 perk pickups (damage boost, speed boost, health regen, etc.)
5. 5 enemy types (fodder, ranged, tank, fast, elite)
6. 5 rounds of escalating difficulty
7. Basic meta-progression (upgrade coins, 1 upgrade tree)

**Explicitly NOT in MVP** (defer to later):
- Co-op multiplayer (solo validates core loop first)
- WebUI HUD (use placeholder UMG for MVP)
- NarrativePro quests (pure gameplay MVP)
- All 21 weapons and 8 heroes (expand after core loop validated)
- Boss fights (add after enemy AI is proven)

### Scope Tiers

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | 1 arena, 3 heroes, 8 weapons, 10 perks | Core loop, basic AI, zone | 4-6 weeks |
| **Vertical Slice** | 1 arena with variation, 6 heroes, 15 weapons, 20 perks | + Co-op, WebUI HUD, 1 boss | 8-12 weeks |
| **Alpha** | 2 arenas, 8 heroes, 21 weapons, 30 perks | + Meta-progression, quests, all enemies | 16-20 weeks |
| **Full Vision** | 3 arena themes, 8 heroes, 21 weapons, 40+ perks | + Polish, 3 bosses, full narrative | 24-32 weeks |

---

## Hero Roster (Initial 8)

**CRITICAL DESIGN PHILOSOPHY**: Each hero's primary differentiation is their
**movement system**, not their abilities. Every hero implements a different
classic arena FPS movement mechanic as their core identity. Mastering the
movement IS the skill ceiling. Abilities complement the movement, not
the other way around.

Inspired by: Quake Champions (each champion moves differently), classic
arena FPS movement tech from Quake 3, CPMA, Quakeworld, Unreal Tournament,
Titanfall, Doom, Reflex Arena, and Shootmania.

| Hero | Mesh | Movement System | Movement Source | Tactical | Ultimate |
|------|------|----------------|-----------------|----------|----------|
| Soldier | Soldier_SK | **VQ3 Strafe Jumping** | Quake 3 / Quake Live — acceleration-based strafe jumping, circle jumping, requires precise air strafing at specific angles | Frag Grenade | Airstrike |
| Ninja | Ninja_SK | **Wall Running + Double Jump** | Titanfall — chain wall runs, maintain momentum through wall touches, double jump to chain gaps | Smoke Bomb | Shadow Clone |
| Robot | Robot_SK | **Flight / Hover** | Custom — sustained jetpack flight, hover strafe, vertical dominance, slow on ground but owns the air | Deploy Shield | Overclock |
| Samurai | Samurai_SK | **CPMA Air Control (Bunny Hop)** | Reflex Arena / CPMA — full air control, W-key bunny hopping, no speed cap, curves through air freely | Blade Dash | Dragon Slash |
| Cowboy | Cowboy_SK | **UT-Style Dodge Dashing** | Unreal Tournament — double-tap directional dodge, dodge-jump chains, wall dodge, impact jump combos | Fan the Hammer | Dead Eye |
| Spaceman | Spaceman_SK | **Quakeworld Bunny Hop** | Quakeworld — classic forward bunny hopping, air strafing with no speed cap, ground accel preservation | Jetpack Burst | Orbital Strike |
| Knight | Knight_SK | **Shootmania Slide** | Shootmania — quick double-tap jump to initiate ground slide, maintain speed through slides, slide-jump chains | Shield Bash | Fortify |
| Alien | Alien_SK | **Grapple Swing** | Custom / Spider-Man — grapple point to swing through air, momentum-based traversal, ceiling crawl, pounce leap | Acid Spit | Mind Control |

### Movement System Technical Notes

Each movement system is implemented as a **GMC Solver** (UGMCE_BaseSolver subclass)
within UNarrativeGMCMovementComponent. The solver pattern from GMCExtended allows
clean separation of movement physics per hero.

**Key implementation challenges per system:**

- **VQ3 Strafe Jump**: Replicate Quake 3's `PM_Accelerate()` function — the "bug"
  that creates strafe jumping is actually a specific interaction between air
  acceleration, max speed, and the dot product between wish direction and current
  velocity. Must feel frame-perfect to Q3 veterans.

- **CPMA Air Control**: Full air directional control independent of velocity
  direction. No speed cap. This is the most "broken" feeling movement — intentionally.
  Speed builds infinitely with skill.

- **Quakeworld Bunny Hop**: Forward-key bunny hopping (unlike Q3 which is strafe-only).
  Air strafe works differently than CPMA. Must preserve ground acceleration into air.

- **UT Dodge**: Double-tap direction within a window triggers dodge. Dodge-jump
  multiplies momentum. Wall dodge on contact. Must feel snappy and responsive.

- **Titanfall Wall Run**: Surface detection, wall run timer, momentum preservation
  through wall touches, double jump to chain. Gauntlet-style run chains.

- **Shootmania Slide**: Ground slide triggered by double-tap jump at speed.
  Slide preserves and can build momentum. Slide-jump chains for sustained speed.

- **Flight**: Sustained hover with fuel management. Vertical strafe. Slow ground
  speed compensated by total air freedom. Fuel recharges on ground.

- **Grapple Swing**: Projectile grapple hook, pendulum physics, momentum transfer
  on release. Ceiling crawl as secondary movement. Pounce from ceiling/walls.

### Hero Signature Weapons

Each hero has a **signature weapon** that defines their combat identity alongside
their movement system. All heroes can pick up any ground weapon, but signature
weapons have unique interactions with their hero:
- Spawn more frequently near that hero
- Fuse faster (or grant bonus fusion levels)
- Unlock a unique alt-fire or modifier only that hero can use

| Hero | Movement | Signature Weapon | Synergy |
|------|----------|-----------------|---------|
| Soldier | VQ3 Strafe Jump | Rocket Launcher | Self-damage rocket jumping for vertical mobility — movement IS the weapon |
| Samurai | CPMA Air Control | Railgun | Precision shots while flying through air with full control |
| Spaceman | QW Bunny Hop | Lightning Gun | Tracking beam while maintaining bhop speed — classic QW combo |
| Cowboy | UT Dodge | Shock Cannon | Shock combo detonation while dodge-chaining — UT identity |
| Ninja | Titanfall Wallrun | SMG + Knife | High-mobility spray while wallrunning, knife for wall-pounce kills |
| Knight | Shootmania Slide | Flak Cannon | Slide into close range, flak burst, slide out — brawler loop |
| Robot | Flight | Minigun | Hovering suppression fire — aerial gunship fantasy |
| Alien | Grapple Swing | Acid Launcher | Swing-by DoT bombing runs — hit-and-run predator |

### Movement Progression Philosophy

Each movement system is a **mastery journey**:
- **Floor 1** (first run): Walk, shoot, use ability. Movement system works but
  player doesn't understand the depth yet.
- **Floor 2** (5+ runs): Player discovers the movement tech (strafe jumping,
  bunny hopping, wall run chains). Speed and efficiency improve dramatically.
- **Floor 3** (50+ runs): Player chains movement tech with combat seamlessly.
  Strafe-jumping while headshotting. Wall-running through enemy fire. Movement
  becomes second nature and creates the "flow state" moments.
- **Ceiling**: Effectively infinite. Like real Quake movement — there's always
  a faster route, a tighter strafe, a better chain.

---

## Next Steps

- [x] Engine configured (UE 5.7 with NarrativeGMC plugin)
- [ ] Run `/map-systems` to decompose concept into individual systems with dependencies
- [ ] Run `/design-system` for each system (combat, arena, weapons, perks, heroes, enemies)
- [ ] Create architecture decision records for procedural arena and AI systems
- [ ] Prototype core loop: `/prototype core-combat` (1 hero, 1 arena, 3 weapons, basic AI)
- [ ] Playtest the prototype: `/playtest-report`
- [ ] Plan first sprint: `/sprint-plan new`
