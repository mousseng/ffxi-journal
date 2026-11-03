return {
    [  1] = {
        desc = 'Naked Sivvi vs Wild Rabbit',
        caster = {
            name     = 'Sivvi',
            level    = 99,
            sublevel = 49,
            mlevel   = 2,
            stats = {
                INT = 99,
                MAB = 50,
                mDMG = 40,
            },
            skills = {
                Ninjutsu = 470,
            },
        },
        target = {
            name = 'Wild Rabbit',
            level = 1,
            stats = {
                INT = 6,
                MDB = 0,
            },
        }
    },
    [  2] = {
        desc = 'Naked Sivvi vs Chapuli',
        caster = {
            name     = 'Sivvi',
            level    = 99,
            sublevel = 49,
            mlevel   = 2,
            stats = {
                INT = 99,
                MAB = 50,
                mDMG = 40,
            },
            skills = {
                Ninjutsu = 470,
            },
        },
        target = {
            name = 'Fernfeller Chapuli',
            level = 100,
            stats = {
                INT = 96,
                MDB = 0,
            },
        }
    },
    [  3] = {
        desc = 'High INT and Skill vs Chapuli',
        caster = {
            name     = 'Sivvi',
            level    = 99,
            sublevel = 49,
            mlevel   = 2,
            stats = {
                INT = 229,
                MAB = 50,
                mDMG = 40,
            },
            skills = {
                Ninjutsu = 498,
            },
        },
        target = {
            name = 'Fernfeller Chapuli',
            level = 100,
            stats = {
                INT = 96,
                MDB = 0,
            },
        }
    },
    [  4] = {
        desc = 'Actual nuking stats vs Chapuli',
        caster = {
            name     = 'Sivvi',
            level    = 99,
            sublevel = 49,
            mlevel   = 2,
            stats = {
                INT = 99 + 172,
                MAB = 50 + 228,
                mDMG = 40 + 255,
                NinjutsuMult = 25,
            },
            skills = {
                Ninjutsu = 490,
            },
        },
        target = {
            name = 'Fernfeller Chapuli',
            level = 100,
            stats = {
                INT = 96,
                MDB = 0,
            },
        },
        observations = {
            ichi = 3409,
            ni   = 5084,
            san  = 6754,
        }
    },
    [  5] = {
        desc = 'Real daynuking vs Chapuli',
        caster = {
            name     = 'Sivvi',
            level    = 99,
            sublevel = 49,
            mlevel   = 2,
            day      = 'positive',
            stats = {
                -- base stats + nuking stats - skrymir being swapped for obi
                INT = 99 + 172,
                MAB = 50 + 228 - 5,
                mDMG = 40 + 255 - 30,
                NinjutsuMult = 25,
            },
            skills = {
                Ninjutsu = 490,
            },
        },
        target = {
            name = 'Fernfeller Chapuli',
            level = 100,
            stats = {
                INT = 96,
                MDB = 0,
            },
        },
        observations = {
            ichi = 3394,
            ni   = 5192,
            san  = 7012,
        }
    },
    [  6] = {
        desc = 'Futae nuking vs Chapuli',
        caster = {
            name     = 'Sivvi',
            level    = 99,
            sublevel = 49,
            mlevel   = 2,
            stats = {
                INT = 99 + 172,
                MAB = 50 + 228,
                mDMG = 40 + 255 + 100,
                NinjutsuMult = 25,
                Futae = 50,
            },
            skills = {
                Ninjutsu = 490,
            },
        },
        target = {
            name = 'Fernfeller Chapuli',
            level = 100,
            stats = {
                INT = 96,
                MDB = 0,
            },
        },
        observations = {
            ichi = 7378,
            ni   = 10264,
            san  = 12951,
        }
    },
}
