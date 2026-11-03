--[[
-- each tier of elemental Ninjutsu is a piecewise function with a handful of
-- intervals. izanami on ffxiah formulated this as an independent M and V for
-- each interval; here we will implement each interval as just a slope M with a
-- single shared V.
--
-- instead of determining which function to evaluate based on dINT, we will
-- evaluate each interval up to their bounds and sum the results. this produces
-- a slightly more accurate final number.
--
-- this design came about because otherwise the calculation of baseDMG required
-- a different implementation for some intervals (some would floor, some ceil).
--]]
local intervals = {
    ['Ichi'] = {
        base =  16, -- this is our shared V
        sMin =  50, -- the minimum value of skill used for the Ninjutsu bonus
        sMax = 250, -- the maximum value of skill used for the Ninjutsu bonus
        pos = {
            -- these are our ascending intervals, to be used for positive dINT.
            -- s is not exactly the slope, but rather a count of how many 1/2
            -- dINTs should be added or subtracted to achieve the appropriate
            -- M value.
            { lo =   0, hi =  24, s =  0 },
            { lo =  24, hi =  76, s = -1 },
        },
        neg = {
            -- the descending intervals for negative dINT.
            { lo =   0, hi =  10, s = -1 },
        },
    },
    ['Ni'] = {
        base =  69,
        sMin = 125,
        sMax = 349,
        pos = {
            { lo =   0, hi = 112, s =  0 },
            { lo = 112, hi = 338, s = -1 },
        },
        neg = {
            { lo =   0, hi =  44, s = -1 },
        },
    },
    ['San'] = {
        base = 134,
        sMin = 275,
        sMax = 499,
        pos = {
            { lo =   0, hi = 353, s =  1 },
        },
        neg = {
            { lo =   0, hi =  54, s =  0 },
        },
    },
}

--[[
-- dStat modifier and innate magic accuracy are preserved here to keep the feel
-- of being based on the LSB magic code.
--]]
local spells = {
    ['Doton: Ichi']  = { mod  = 'INT', mAcc = 0, params = intervals.Ichi },
    ['Doton: Ni']    = { mod  = 'INT', mAcc = 0, params = intervals.Ni   },
    ['Doton: San']   = { mod  = 'INT', mAcc = 0, params = intervals.San  },
    ['Huton: Ichi']  = { mod  = 'INT', mAcc = 0, params = intervals.Ichi },
    ['Huton: Ni']    = { mod  = 'INT', mAcc = 0, params = intervals.Ni   },
    ['Huton: San']   = { mod  = 'INT', mAcc = 0, params = intervals.San  },
    ['Hyoton: Ichi'] = { mod  = 'INT', mAcc = 0, params = intervals.Ichi },
    ['Hyoton: Ni']   = { mod  = 'INT', mAcc = 0, params = intervals.Ni   },
    ['Hyoton: San']  = { mod  = 'INT', mAcc = 0, params = intervals.San  },
    ['Katon: Ichi']  = { mod  = 'INT', mAcc = 0, params = intervals.Ichi },
    ['Katon: Ni']    = { mod  = 'INT', mAcc = 0, params = intervals.Ni   },
    ['Katon: San']   = { mod  = 'INT', mAcc = 0, params = intervals.San  },
    ['Raiton: Ichi'] = { mod  = 'INT', mAcc = 0, params = intervals.Ichi },
    ['Raiton: Ni']   = { mod  = 'INT', mAcc = 0, params = intervals.Ni   },
    ['Raiton: San']  = { mod  = 'INT', mAcc = 0, params = intervals.San  },
    ['Suiton: Ichi'] = { mod  = 'INT', mAcc = 0, params = intervals.Ichi },
    ['Suiton: Ni']   = { mod  = 'INT', mAcc = 0, params = intervals.Ni   },
    ['Suiton: San']  = { mod  = 'INT', mAcc = 0, params = intervals.San  },
}

local function clamp(val, min, max)
    if val <= min then return min end
    if val >= max then return max end
    return val
end

--- find the dSTAT contribution of a particular interval.
local function calculatePiece(xStat, slopeMod)
    return xStat + slopeMod * math.floor(xStat / 2)
end

--- starting from dINT=0, we work outwards (either positively or negatively)
--- one interval at a time.
local function calculateBaseDmg(caster, params, dStat)
    local accum = 0
    local asc = dStat >= 0

    -- xSTAT is intended to represent how "far" into the whole curve we reach
    local xStat = math.abs(dStat)

    -- walk through each interval and accumulate their portions
    for _, piece in ipairs(asc and params.pos or params.neg) do
        if xStat > piece.lo then
            -- this interval is needed, so nxSTAT is how much dSTAT this
            -- particular step will account for
            local nxStat = math.min(xStat, piece.hi) - piece.lo
            accum = accum + calculatePiece(nxStat, piece.s)
        end
    end

    local baseDmg = asc and params.base + accum or params.base - accum
    return baseDmg + caster.stats.mDMG
end

local function calculateSkillMult(caster, params)
    local baseline = 100
    local effSkill = clamp(caster.skills.Ninjutsu, params.sMin, params.sMax)
    local fSkill = effSkill - params.sMin
    local bonus = math.floor(fSkill / 2)
    return baseline + bonus, baseline
end

local function calculateNinMult(caster)
    local baseline = 100
    local bonus = caster.stats.NinjutsuMult or 0
    return baseline + bonus, baseline
end

local function calculateDayMult(caster)
    local baseline = 100
    local bonus = 0

    if caster.day == 'positive' then
        bonus = bonus + 10
    elseif caster.day == 'negative' then
        bonus = bonus - 10
    end

    if caster.weather and caster.weather[1] == 'positive' then
        bonus = bonus + 10

        if caster.weather[2] == 'double' then
            bonus = bonus + 15
        end
    elseif caster.weather and caster.weather[1] == 'negative' then
        bonus = bonus - 10

        if caster.weather[2] == 'double' then
            bonus = bonus - 15
        end
    end

    return baseline + bonus, baseline
end

local function calculateFutaeMult(caster)
    local baseline = 100
    local bonus = caster.stats.Futae or 0
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

    local baseDmg             = calculateBaseDmg(caster, spellTable.params, dStat)
    local skillMult, skillDiv = calculateSkillMult(caster, spellTable.params)
    local mabMult, mabDiv     = calculateMabMult(caster, target)
    local ninMult, ninDiv     = calculateNinMult(caster)
    local dayMult, dayDiv     = calculateDayMult(caster)
    local futMult, futDiv     = calculateFutaeMult(caster)

    -- work through the multiplications step-by-step to reproduce what is
    -- probably a series of integer math in C++. anything called "mult" should
    -- be a whole int (not a float) and come with a paired divisor.
    local mutDmg = baseDmg
    mutDmg = math.floor(mutDmg * skillMult / skillDiv)
    mutDmg = math.floor(mutDmg * dayMult / dayDiv)
    mutDmg = math.floor(mutDmg * futMult / futDiv)
    mutDmg = math.floor(mutDmg * ninMult / ninDiv)
    mutDmg = math.floor(mutDmg * mabMult / mabDiv)
    return mutDmg
end

return useNinjutsuSpell
