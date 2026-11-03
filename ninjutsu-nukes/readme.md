ninjutsu nukes
================================================================================

[izanami's post from 2022](https://www.ffxiah.com/forum/topic/56749) is
basically correct. elemental ninjutsu damage is accurately modeled with
a piece-wise function over dINT.

at the present time i have not thought deeply about how to explain or show
it any better, so for now you will have to settle for code.

the test harness
--------------------------------------------------------------------------------

i've provided a lightly-annotated implementation in lua. it differs from the
ffxiah post because i sought to find a more natural representation that still
gets everything exactly right - i suspect SE's actual code is pure integer math
so everything gets floored, multipliers are not crunched into doubles, and the
order of operations does matter.

if you would like to run it for yourself:
```sh
luajit run.lua
```

this will read the array from `scenarios.lua` and produce the expected damage
for each tier.

not all the fields are necessary, but are included for posterity anyway; all
are samples i built from my own character's stats. some notes:
- day and weather are treated as properties of the caster
  - `day = 'positive' | 'negative'`
  - `weather = { 'positive' | 'negative', ['single' | 'double'] }`
- the `NinjutsuMult` stat is the bonus provided by Relic Feet
- if you want to nuke with Futae, you need to set the `Futae` caster stat
  - this should be a base of 50
  - pieces like Empyrean Gloves add directly to the base, eg 50 + 26
  - there is a JP Bonus that grants 5 mDMG per level (max 100) as well
- a lot of gear has weird effects, but they mostly boil down to just INT, MAB,
  mDMG, and skill.
