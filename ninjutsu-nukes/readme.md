ninjutsu nukes
======================================================================

test setup
----------------------------------------------------------------------
- NIN99/WAR49, ML2
- no gear equipped on cast
- Merits:
  - 1 Raiton Effect
  - 5 Ninjutsu Mag. Atk. Bonus
- Job Points:
  - 2100 total spent
  - 20 Elemental Ninjutsu Effect

this comes to a total of:
- 40 mDMG (20 from jp)
- 50 MAB (2 from merit g1, 20 from merit g2, 28 from jp gifts)
- 99 base INT
- 471 Ninjutsu skill

nuke results
----------------------------------------------------------------------
see `ouphe.csv` - i got tired of manually collecting stats, so i wrote
a little addon to automatically do it for certain mobs.

the formula?
----------------------------------------------------------------------
Izanami on ffxiah is, essentially, correct. not exactly (because FFXI
does most, if not all, math with integers only) but certainly close
enough for government work.

the `test-harness/` directory has a lua script that should be able to
predict exactly the damage values of any nuke against any known stat
block. it's probably not doing what the Square Enix code is doing, but
it should more accurately emulate the behavior of their integer math
down to the order multipliers are applied.
