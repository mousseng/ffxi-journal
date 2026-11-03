local inf = math.huge

--[[
-- SpellParams are the various function pieces that make the overall damage
-- curve for a spell. They are stratified by dStat, and we must order them
-- highest to lowest in order for this particular lookup method to work.
--]]
local SpellParams = function(tbl)
    function tbl:lookup(i)
        local p = nil
        for _, v in ipairs(self) do
            if i <= v.i then
                p = v
            end
        end
        return p
    end
    return tbl
end

--[[
-- LSB models its magic damage formula based on black magic only; it too uses
-- piece-wise curves but Ninjutsu does not fit into the same brackets, so we
-- instead model each spell as a variable list of pieces.
--
-- the dMin/dMax values are untested beyond Ichi. Izanami found caps that line
-- up with my own collected data so far; it's unclear if the caps are actual
-- values, or just emergent properties of a more natural formula.
--]]
local formulae = {
    ['Ichi'] = SpellParams {
        { i = inf, v =  28, m = 0.5, dMin =   11, dMax =  66, sMin =  50, sMax = 250 },
        { i =  24, v =  16, m = 1.0, dMin =   11, dMax =  66, sMin =  50, sMax = 250 },
        { i =  -1, v =  16, m = 0.5, dMin =   11, dMax =  66, sMin =  50, sMax = 250 },
    },
    ['Ni'] = SpellParams {
        { i = inf, v = 125, m = 0.5, dMin = -inf, dMax = inf, sMin = 125, sMax = 349 },
        { i = 112, v =  69, m = 1.0, dMin = -inf, dMax = inf, sMin = 125, sMax = 349 },
        { i =  -1, v =  69, m = 0.5, dMin = -inf, dMax = inf, sMin = 125, sMax = 349 },
    },
    ['San'] = SpellParams {
        { i = inf, v = 134, m = 1.5, dMin = -inf, dMax = inf, sMin = 275, sMax = 499 },
        { i =  -1, v = 134, m = 1.0, dMin = -inf, dMax = inf, sMin = 275, sMax = 499 },
    },
}

--[[
-- dStat modifier and innate magic accuracy are preserved here to keep the feel
-- of being based on the LSB magic code.
--]]
local spells = {
    ['Doton: Ichi']  = { mod  = 'INT', mAcc = 0, params = formulae.Ichi },
    ['Doton: Ni']    = { mod  = 'INT', mAcc = 0, params = formulae.Ni   },
    ['Doton: San']   = { mod  = 'INT', mAcc = 0, params = formulae.San  },
    ['Huton: Ichi']  = { mod  = 'INT', mAcc = 0, params = formulae.Ichi },
    ['Huton: Ni']    = { mod  = 'INT', mAcc = 0, params = formulae.Ni   },
    ['Huton: San']   = { mod  = 'INT', mAcc = 0, params = formulae.San  },
    ['Hyoton: Ichi'] = { mod  = 'INT', mAcc = 0, params = formulae.Ichi },
    ['Hyoton: Ni']   = { mod  = 'INT', mAcc = 0, params = formulae.Ni   },
    ['Hyoton: San']  = { mod  = 'INT', mAcc = 0, params = formulae.San  },
    ['Katon: Ichi']  = { mod  = 'INT', mAcc = 0, params = formulae.Ichi },
    ['Katon: Ni']    = { mod  = 'INT', mAcc = 0, params = formulae.Ni   },
    ['Katon: San']   = { mod  = 'INT', mAcc = 0, params = formulae.San  },
    ['Raiton: Ichi'] = { mod  = 'INT', mAcc = 0, params = formulae.Ichi },
    ['Raiton: Ni']   = { mod  = 'INT', mAcc = 0, params = formulae.Ni   },
    ['Raiton: San']  = { mod  = 'INT', mAcc = 0, params = formulae.San  },
    ['Suiton: Ichi'] = { mod  = 'INT', mAcc = 0, params = formulae.Ichi },
    ['Suiton: Ni']   = { mod  = 'INT', mAcc = 0, params = formulae.Ni   },
    ['Suiton: San']  = { mod  = 'INT', mAcc = 0, params = formulae.San  },
}

local function clamp(val, min, max)
    if val <= min then return min end
    if val >= max then return max end
    return val
end

local function calculateBaseDmg(caster, params, dStat)
    local baseDmg = params.v + math.floor(dStat * params.m)
    return caster.stats.mDMG + clamp(baseDmg, params.dMin, params.dMax)
end

local function calculateSkillMult(caster, params)
    local baseline = 100
    local effSkill = clamp(caster.skills.Ninjutsu, params.sMin, params.sMax)
    local fSkill = effSkill - params.sMin
    local bonus = math.floor(fSkill / 2)
    return baseline + bonus, baseline
end

local function calculateMabMult(caster, target)
    local mab = 100 + caster.stats.MAB
    local mdb = 100 + target.stats.MDB
    return mab, mdb
end

local function useNinjutsuSpell(caster, target, spell)
    local spellTable          = spells[spell]
    local dStat               = caster.stats[spellTable.mod] - target.stats[spellTable.mod]
    local params              = spells[spell].params:lookup(dStat)

    local baseDmg             = calculateBaseDmg(caster, params, dStat)
    local skillMult, skillDiv = calculateSkillMult(caster, params)
    local mabMult, mabDiv     = calculateMabMult(caster, target)

    -- work through the multiplications step-by-step to reproduce what is
    -- probably a series of integer math in C++. anything called "mult" should
    -- be a whole int (not a float) and we handle its divisor within the floor.
    local mutDmg = baseDmg
    mutDmg = math.floor(mutDmg * skillMult / skillDiv)
    mutDmg = math.floor(mutDmg * mabMult / mabDiv)
    return mutDmg
end

return useNinjutsuSpell
