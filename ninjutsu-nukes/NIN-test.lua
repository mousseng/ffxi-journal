--[[
-- barebones NIN profile for ninjutsu nuke damage testing
-- idle:    DT + movespeed
-- precast: fastcast
-- midcast: completely naked for nukes
--]]
local profile = {}

local sets = {
    Idle = {
        Ammo  = 'Staunch Tathlum',
        Head  = 'Hattori Zukin +2',
        Neck  = 'Sanctity Necklace',
        Ear1  = 'Brutal Earring',
        Ear2  = 'Hattori Earring',
        Body  = 'Hiza. Haramaki +2',
        Hands = 'Hizamaru Kote +2',
        Ring1 = 'Defending Ring',
        Ring2 = 'Shneddick Ring',
        Back  = { Name = "Andartia's Mantle", Augment = { 'DEX+20', '"Dbl.Atk."+10' } },
        Waist = 'Sailfi Belt +1',
        Legs  = 'Hattori Hakama +2',
        Feet  = 'Hachiya Kyahan +2',
    },
    FastCast = {
        Ammo  = 'Sapience Orb',
        Neck  = 'Voltsurge Torque',
        Body  = 'Mochi. Chainmail +1',
        Back  = { Name = "Andartia's Mantle", Augment = { 'AGI+20', 'Fast Cast +10%' } },
    },
    Naked = {
        Main  = 'remove',
        Sub   = 'remove',
        Range = 'remove',
        Ammo  = 'remove',
        Head  = 'remove',
        Neck  = 'remove',
        Ear1  = 'remove',
        Ear2  = 'remove',
        Body  = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back  = 'remove',
        Waist = 'remove',
        Legs  = 'remove',
        Feet  = 'remove',
    },
    Futae = {
        -- Main = "Heishi Shorinken", -- mDMG+186
        -- Sub  = "Ternion Dagger +1",

        Main = "Ternion Dagger +1",
        Neck = "Sanctity Necklace", -- MAB+10
    },
    Modulation = {
        [-10] = { Head="Versa Celata", Feet="Versa Sollerets" },
        [ -6] = { Head="Versa Celata" },
        [ -4] = { Feet="Versa Sollerets" },
        [  0] = { },
        [ 22] = { Head="Hattori Zukin +2" },
        [ 40] = { Legs="Hattori Hakama +2" },
        [ 62] = { Head="Hattori Zukin +2", Legs="Hattori Hakama +2" },
        [121] = {
            Head  = "Hattori Zukin +2",
            Body  = "Hattori Ningi +2",
            Hands = "Mummu Wrists +2",
            Legs  = "Hattori Hakama +2",
            Ring1 = "Metamor. Ring +1",
            Ring2 = "Shiva Ring",
        },
        -- [130] = { -- 27 extra skill
        --     Main  = "Shigi",
        --     Head  = "Hachiya Hatsu. +3",
        --     Body  = "Hattori Ningi +2",
        --     Hands = "Mummu Wrists +2",
        --     Legs  = "Hattori Hakama +2",
        --     -- Feet  = "Mochi. Kyahan +1",
        --     Ring1 = "Metamor. Ring +1",
        --     Ring2 = "Shiva Ring",
        -- },
        [130] = { -- 46 extra skill
            Main  = "Shigi",
            Head  = "Hachiya Hatsu. +3",
            Body  = "Hattori Ningi +2",
            Hands = "Mummu Wrists +2",
            Legs  = "Hattori Hakama +2",
            Feet  = "Mochi. Kyahan +1",
            Ring1 = "Metamor. Ring +1",
            Ring2 = "Shiva Ring",
        },
    },
}
profile.Sets = sets

local futae = false
local intModulation = 0
local nukes = T{ 'Katon', 'Hyoton', 'Huton', 'Doton', 'Raiton', 'Suiton' }

local function isNuke(spell)
    local prefix = spell.Name:match('^(%a+):')
    return prefix ~= nil and nukes:contains(prefix)
end

profile.Packer = {}

profile.OnLoad = function()
    gSettings.AllowAddSet = false
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'mod' then
        local newMod = tonumber(args[2]) or 0
        newMod = sets.Modulation[newMod] and newMod or 0
        intModulation = newMod
        print('set INT modulation to ' .. tostring(newMod))
    elseif args[1] == 'futae' then
        futae = not futae
        print('futae is now ' .. tostring(futae))
    end
end

profile.HandleDefault = function()
    local player = gData.GetPlayer()
    if player.Status == 'Idle' then
        gFunc.EquipSet(sets.Idle)
    end
end

profile.HandleAbility = function()
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.FastCast)
end

profile.HandleMidcast = function()
    local spell = gData.GetAction()
    if isNuke(spell) then
        gFunc.EquipSet(sets.Naked)
        gFunc.EquipSet(sets.Modulation[intModulation] or sets.Modulation[0])
        if futae then gFunc.EquipSet(sets.Futae) end
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
end

return profile
