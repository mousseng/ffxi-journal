local doNinjutsu = require 'ninjutsu'
local scenarios = require 'scenarios'

for _, scenario in pairs(scenarios) do
    print(scenario.desc)

    local ichi = doNinjutsu(scenario.caster, scenario.target, 'Katon: Ichi')
    print('  Ichi deals ' .. tostring(ichi) .. ' damage')

    local ni = doNinjutsu(scenario.caster, scenario.target, 'Katon: Ni')
    print('  Ni deals ' .. tostring(ni) .. ' damage')

    local san = doNinjutsu(scenario.caster, scenario.target, 'Katon: San')
    print('  San deals ' .. tostring(san) .. ' damage')
    print()
end
