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
}
profile.Sets = sets

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
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
end

return profile
