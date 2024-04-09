Config = {}

----------------------------------
-- stress settings
----------------------------------
Config.StressChance = 0.1 -- Default: 10% -- Percentage Stress Chance When Shooting (0-1)
Config.MinimumStress = 50 -- Minimum Stress Level For Screen Shaking
Config.MinimumSpeed = 100 -- Going Over This Speed Will Cause Stress

----------------------------------
-- hud player display settings
----------------------------------
Config.HidePlayerHealthNative  = true
Config.HidePlayerStaminaNative = true
Config.HidePlayerDeadEyeNative = true

----------------------------------
-- hud horse display settings
----------------------------------
Config.HideHorseHealthNative  = true
Config.HideHorseStaminaNative = true
Config.HideHorseCourageNative = true

----------------------------------
-- telegrame check settings
----------------------------------
Config.TelegramCheck = 5000 -- amount of milliseconds to check your telegrams

----------------------------------
-- minimap / compass settings
----------------------------------
Config.OnFootMinimap = false -- set to true/false to disable/enable minimap when on foot
Config.OnFootCompass = false -- true = have the minimap set to a compass instead of off or normal minimap
Config.MounttMinimap = true  -- set to false if you want to disable the minimap when on mount
Config.MountCompass  = false -- set to true if you want to have a compass instead of normal minimap while on a mount

----------------------------------
-- turn health damage on/off
----------------------------------
Config.DoHealthDamage = true

----------------------------------
-- turn screen effect on/off
----------------------------------
Config.DoHealthDamageFx = false

----------------------------------
-- turn health damage sound on/off
----------------------------------
Config.DoHealthPainSound = true

----------------------------------
-- temp settings (only one setting)
----------------------------------
Config.TempFormat = 'celsius'
--Config.TempFormat = 'fahrenheit'

----------------------------------
-- warmth add while wearing
----------------------------------
Config.WearingHat      = 0
Config.WearingShirt    = 0
Config.WearingPants    = 0
Config.WearingBoots    = 0
Config.WearingCoat     = 15
Config.WearingOpenCoat = 15
Config.WearingGloves   = 0
Config.WearingVest     = 0
Config.WearingPoncho   = 0
Config.WearingSkirt    = 0
Config.WearingChaps    = 0

----------------------------------
-- warmth limit before impacts health
----------------------------------
Config.MinTemp = -5
Config.MaxTemp = 40

----------------------------------
-- cleanliness limit before impacts health
----------------------------------
Config.FlyEffect = false -- toggle flies on/off
Config.MinCleanliness = 30

----------------------------------
-- amount of health to remove if min/max temp reached
----------------------------------
Config.RemoveHealth = 5

----------------------------------
-- stress settings
----------------------------------
Config.Intensity = {
    ["shake"] = {
        [1] = {
            min = 50,
            max = 60,
            intensity = 0.12,
        },
        [2] = {
            min = 60,
            max = 70,
            intensity = 0.17,
        },
        [3] = {
            min = 70,
            max = 80,
            intensity = 0.22,
        },
        [4] = {
            min = 80,
            max = 90,
            intensity = 0.28,
        },
        [5] = {
            min = 90,
            max = 100,
            intensity = 0.32,
        },
    }
}

Config.EffectInterval = {
    [1] = {
        min = 50,
        max = 60,
        timeout = math.random(50000, 60000)
    },
    [2] = {
        min = 60,
        max = 70,
        timeout = math.random(40000, 50000)
    },
    [3] = {
        min = 70,
        max = 80,
        timeout = math.random(30000, 40000)
    },
    [4] = {
        min = 80,
        max = 90,
        timeout = math.random(20000, 30000)
    },
    [5] = {
        min = 90,
        max = 100,
        timeout = math.random(15000, 20000)
    }
}
