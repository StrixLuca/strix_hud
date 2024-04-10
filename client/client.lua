local RSGCore = exports[Config.core]:GetCoreObject()
local speed = 0.0
local stress = 0
local hunger = 100
local thirst = 100
local cashAmount = 0
local bankAmount = 0
local youhavemail = false
local incinematic = false
local inBathing = false
local inClothing = false
local showUI = true
local temperature = 0
local temp = 0
local tempadd = 0
local clean = 0

------------------------------------------------
-- hide ui
------------------------------------------------
RegisterNetEvent('HideAllUI')
AddEventHandler('HideAllUI', function()
    showUI = not showUI
end)

------------------------------------------------
-- hud display settings
------------------------------------------------
CreateThread(function()

    if Config.HidePlayerHealthNative then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 4, 2) -- ICON_HEALTH / HIDE
        Citizen.InvokeNative(0xC116E6DF68DCE667, 5, 2) -- ICON_HEALTH_CORE / HIDE
    end

    if Config.HidePlayerStaminaNative then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 0, 2) -- ICON_STAMINA / HIDE
        Citizen.InvokeNative(0xC116E6DF68DCE667, 1, 2) -- ICON_STAMINA_CORE / HIDE
    end

    if Config.HidePlayerDeadEyeNative then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 2, 2) -- ICON_DEADEYE / HIDE
        Citizen.InvokeNative(0xC116E6DF68DCE667, 3, 2) -- ICON_DEADEYE_CORE / HIDE
    end

    if Config.HideHorseHealthNative then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 6, 2) -- ICON_HORSE_HEALTH / HIDE
        Citizen.InvokeNative(0xC116E6DF68DCE667, 7, 2) -- ICON_HORSE_HEALTH_CORE / HIDE
    end

    if Config.HideHorseStaminaNative then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 8, 2) -- ICON_HORSE_STAMINA / HIDE
        Citizen.InvokeNative(0xC116E6DF68DCE667, 9, 2) -- ICON_HORSE_STAMINA_CORE / HIDE
    end

    if Config.HideHorseCourageNative then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 10, 2) -- ICON_HORSE_COURAGE / HIDE
        Citizen.InvokeNative(0xC116E6DF68DCE667, 11, 2) -- ICON_HORSE_COURAGE_CORE / HIDE
    end

end)

------------------------------------------------
-- functions
------------------------------------------------
local function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for _, v in pairs(Config.Intensity.shake) do
        if stresslevel >= v.min and stresslevel <= v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

local function GetEffectInterval(stresslevel)
    local retval = 60000
    for _, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel <= v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end

------------------------------------------------
-- flies when not clean (Config.MinCleanliness)
------------------------------------------------
local FliesSpawn = function (clean)
    local new_ptfx_dictionary = 'core'
    local new_ptfx_name = 'env_flies'
    local is_particle_effect_active = false
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name
    local current_ptfx_handle_id = false
    local bone_index = 464   -- ["CP_Chest"]  = {bone_index = 464, bone_id = 53684},
    local ptfx_offcet_x = 0.0
    local ptfx_offcet_y = 0.0
    local ptfx_offcet_z = 0.0
    local ptfx_rot_x = -90.0
    local ptfx_rot_y = 0.0
    local ptfx_rot_z = 0.0
    local ptfx_scale = 1.0
    local ptfx_axis_x = 0
    local ptfx_axis_y = 0
    local ptfx_axis_z = 0
    local clean = clean
    if not is_particle_effect_active and clean <= Config.MinCleanliness then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, joaat(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, joaat(current_ptfx_dictionary))  -- RequestNamedPtfxAsset
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, joaat(current_ptfx_dictionary)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
               Wait(0)
            end
        end
        if not filesspawned and Citizen.InvokeNative(0x65BB72F29138F5D6, joaat(current_ptfx_dictionary)) then  -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary) -- UseParticleFxAsset

            current_ptfx_handle_id = Citizen.InvokeNative(0x9C56621462FFE7A6,current_ptfx_name,cache.ped,ptfx_offcet_x,ptfx_offcet_y,ptfx_offcet_z,ptfx_rot_x,ptfx_rot_y,ptfx_rot_z,bone_index,ptfx_scale,ptfx_axis_x,ptfx_axis_y,ptfx_axis_z) -- StartNetworkedParticleFxLoopedOnEntityBone
            is_particle_effect_active = true
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_ptfx_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false)   -- RemoveParticleFx
            end
        end
        current_ptfx_handle_id = false
        is_particle_effect_active = false
    end
end

------------------------------------------------
-- events
------------------------------------------------

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst, newCleanliness)
    local cleanstats = Citizen.InvokeNative(0x147149F2E909323C, cache.ped, 16, Citizen.ResultAsInteger())
    hunger = newHunger
    thirst = newThirst
    cleanliness = newCleanliness - cleanstats
end)

RegisterNetEvent('hud:client:UpdateThirst', function(newThirst)
    thirst = newThirst
end)

RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    stress = newStress
end)

------------------------------------------------
-- player hud
------------------------------------------------
CreateThread(function()
    while true do
        Wait(500)
        if LocalPlayer.state.isLoggedIn and incinematic == false and inBathing == false and inClothing == false and showUI then
            local show = true
            local stamina = tonumber(string.format('%.2f', Citizen.InvokeNative(0x0FF421E467373FCF, cache.playerId, Citizen.ResultAsFloat())))
            local mounted = IsPedOnMount(cache.ped)
            if IsPauseMenuActive() then
                show = false
            end

            local voice = 0
            local talking = Citizen.InvokeNative(0x33EEF97F, cache.playerId)
            if LocalPlayer.state.proximity then
                voice = LocalPlayer.state.proximity.distance
            end

            -- horse health, stamina & cleanliness
            local horsehealth = 0 
            local horsestamina = 0 
            local horseclean = 0

            if mounted then
                local horse = GetMount(cache.ped)
                local maxHealth = Citizen.InvokeNative(0x4700A416E8324EF3, horse, Citizen.ResultAsInteger())
                local maxStamina = Citizen.InvokeNative(0xCB42AFE2B613EE55, horse, Citizen.ResultAsFloat())
                local horseCleanliness = Citizen.InvokeNative(0x147149F2E909323C, horse, 16, Citizen.ResultAsInteger())
                if horseCleanliness == 0 then
                    horseclean = 100
                else
                    horseclean = 100 - horseCleanliness
                end
                horsehealth = tonumber(string.format('%.2f', Citizen.InvokeNative(0x82368787EA73C0F7, horse) / maxHealth * 100))
                horsestamina = tonumber(string.format('%.2f', Citizen.InvokeNative(0x775A1CA7893AA8B5, horse, Citizen.ResultAsFloat()) / maxStamina * 100))
            end

            -- pvp status
            local pvpstatus = GetRelationshipBetweenGroups(`PLAYER`, `PLAYER`)
            
            if pvpstatus == 5 then
                pvp = true
            else
                pvp = false
            end

            SendNUIMessage({
                action = 'hudtick',
                show = show,
                health = GetEntityHealth(cache.ped) / 6, -- health in red dead max health is 600 so dividing by 6 makes it 100 here
                stamina = stamina,
                armor = Citizen.InvokeNative(0x2CE311A7, cache.ped),
                thirst = thirst,
                hunger = hunger,
                cleanliness = cleanliness,
                stress = stress,
                talking = talking,
                temp = temperature,
                onHorse = mounted,
                horsehealth = horsehealth,
                horsestamina = horsestamina,
                horseclean = horseclean,
                voice = voice,
                youhavemail = youhavemail,
                pvp = pvp,
            })
        else
            SendNUIMessage({
                action = 'hudtick',
                show = false,
            })
        end

        if cleanliness ~= nil and Config.FlyEffect then
            FliesSpawn(cleanliness)
        end
        
    end
end)

------------------------------------------------
-- show minimap setup
------------------------------------------------

local test = true
CreateThread(function()
    while true do
        Wait(500)
        local interiorId = GetInteriorFromEntity(cache.ped)
        local isMounted = IsPedOnMount(cache.ped) or IsPedInAnyVehicle(cache.ped)
        if Config.telegram then
        local IsBirdPostApproaching = exports[Config.telegramname]:IsBirdPostApproaching()
        if isMounted or IsBirdPostApproaching then
        elseif isMounted then
            if Config.MounttMinimap and showUI then
                if Config.MountCompass then
                    SetMinimapType(3)
                else
                    SetMinimapType(1)
                end
            else
                SetMinimapType(0)
            end
        else
            if Config.OnFootMinimap and showUI then
                SetMinimapType(1)
                -- interior zoom
                if interiorId ~= 0 then
                    -- ped entered an interior
                    SetRadarConfigType(0xDF5DB58C, 0) -- zoom in the map by 10x
                else
                    -- ped left an interior
                    SetRadarConfigType(0x25B517BF, 0) -- zoom in the map by 0x (return the minimap back to normal)
                end
            else
                if Config.OnFootCompass and showUI then
                    SetMinimapType(3)
                else
                    SetMinimapType(0)
                end
            end
        end
    end
end
end)

------------------------------------------------
-- work out temperature
------------------------------------------------
CreateThread(function()
    while true do
        Wait(1000)

       
        local coords = GetEntityCoords(cache.ped)

        -- wearing
        local hat      = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0x9925C067) -- hat
        local shirt    = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0x2026C46D) -- shirt
        local pants    = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0x1D4C528A) -- pants
        local boots    = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0x777EC6EF) -- boots
        local coat     = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0xE06D30CE) -- coat
        local opencoat = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0x662AC34) -- open-coat
        local gloves   = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0xEABE0032) -- gloves
        local vest     = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0x485EE834) -- vest
        local poncho   = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0xAF14310B) -- poncho
        local skirts   = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0xA0E3AB7F) -- skirts
        local chaps    = Citizen.InvokeNative(0xFB4891BD7578CDC1, cache.ped, 0x3107499B) -- chaps
        
        -- get temp add
        if hat      == 1 then what      = Config.WearingHat      else what      = 0 end
        if shirt    == 1 then wshirt    = Config.WearingShirt    else wshirt    = 0 end
        if pants    == 1 then wpants    = Config.WearingPants    else wpants    = 0 end
        if boots    == 1 then wboots    = Config.WearingBoots    else wboots    = 0 end
        if coat     == 1 then wcoat     = Config.WearingCoat     else wcoat     = 0 end
        if opencoat == 1 then wopencoat = Config.WearingOpenCoat else wopencoat = 0 end
        if gloves   == 1 then wgloves   = Config.WearingGloves   else wgloves   = 0 end
        if vest     == 1 then wvest     = Config.WearingVest     else wvest     = 0 end
        if poncho   == 1 then wponcho   = Config.WearingPoncho   else wponcho   = 0 end
        if skirts   == 1 then wskirts   = Config.WearingSkirt    else wskirts   = 0 end
        if chaps    == 1 then wchaps    = Config.WearingChaps    else wchaps    = 0 end
        
        local tempadd = (what + wshirt + wpants + wboots + wcoat + wopencoat + wgloves + wvest + wponcho + wskirts + wchaps)
        
        if Config.TempFormat == 'celsius' then
            temperature = math.floor(GetTemperatureAtCoords(coords)) + tempadd .. "°C" --Uncomment for celcius
            temp = math.floor(GetTemperatureAtCoords(coords)) + tempadd
        end
        if Config.TempFormat == 'fahrenheit' then
            temperature = math.floor(GetTemperatureAtCoords(coords) * 9/5 + 32) + tempadd .. "°F" --Comment out for celcius
            temp = math.floor(GetTemperatureAtCoords(coords) * 9/5 + 32) + tempadd
        end
   
    end
end)

------------------------------------------------
-- health/cleanliness damage
------------------------------------------------
CreateThread(function()
    while true do
        Wait(5000)
        if LocalPlayer.state.isLoggedIn and Config.DoHealthDamage then
            health = GetEntityHealth(cache.ped)

            -- cold health damage
            if temp < Config.MinTemp then 
                if Config.DoHealthDamageFx then
                    Citizen.InvokeNative(0x4102732DF6B4005F, 'MP_Downed', 0, true)
                end
                if Config.DoHealthPainSound then
                    PlayPain(cache.ped, 9, 1, true, true)
                end
                SetEntityHealth(cache.ped, health - Config.RemoveHealth)
            elseif Citizen.InvokeNative(0x4A123E85D7C4CA0B, 'MP_Downed') and Config.DoHealthDamageFx then
                Citizen.InvokeNative(0xB4FD7446BAB2F394, 'MP_Downed')
            end
            
            -- hot health damage
            if temp > Config.MaxTemp then
                if Config.DoHealthDamageFx then
                    Citizen.InvokeNative(0x4102732DF6B4005F, 'MP_Downed', 0, true)
                end
                if Config.DoHealthPainSound then
                    PlayPain(cache.ped, 9, 1, true, true)
                end
                SetEntityHealth(cache.ped, health - Config.RemoveHealth)
            elseif Citizen.InvokeNative(0x4A123E85D7C4CA0B, 'MP_Downed') and Config.DoHealthDamageFx then
                Citizen.InvokeNative(0xB4FD7446BAB2F394, 'MP_Downed')
            end

            -- cleanliness health damage
            if cleanliness ~= nil and cleanliness < Config.MinCleanliness then
                if Config.DoHealthDamageFx then
                    Citizen.InvokeNative(0x4102732DF6B4005F, 'MP_Downed', 0, true)
                end
                if Config.DoHealthPainSound then
                    PlayPain(cache.ped, 9, 1, true, true)
                end
                SetEntityHealth(cache.ped, health - Config.RemoveHealth)
            elseif Citizen.InvokeNative(0x4A123E85D7C4CA0B, 'MP_Downed') and Config.DoHealthDamageFx then
                Citizen.InvokeNative(0xB4FD7446BAB2F394, 'MP_Downed')
            end

        end
    end
end)

------------------------------------------------
-- money hud
------------------------------------------------
RegisterNetEvent('hud:client:ShowAccounts', function(type, amount)
    if type == 'cash' then
        SendNUIMessage({
            action = 'show',
            type = 'cash',
            cash = string.format('%.2f', amount)
        })
    elseif type == 'bloodmoney' then
        SendNUIMessage({
            action = 'show',
            type = 'bloodmoney',
            bloodmoney = string.format('%.2f', amount)
        })
    elseif type == 'bank' then
        SendNUIMessage({
            action = 'show',
            type = 'bank',
            bank = string.format('%.2f', amount)
        })
    end
end)

------------------------------------------------
-- on money change
------------------------------------------------
RegisterNetEvent('hud:client:OnMoneyChange', function(type, amount, isMinus)
    RSGCore.Functions.GetPlayerData(function(PlayerData)
        cashAmount = PlayerData.money.cash
        bloodmoneyAmount = PlayerData.money.bloodmoney
        bankAmount = PlayerData.money.bank
    end)
    SendNUIMessage({
        action = 'update',
        cash = RSGCore.Shared.Round(cashAmount, 2),
        bloodmoney = RSGCore.Shared.Round(bloodmoneyAmount, 2),
        bank = RSGCore.Shared.Round(bankAmount, 2),
        amount = RSGCore.Shared.Round(amount, 2),
        minus = isMinus,
        type = type,
    })
end)

------------------------------------------------
-- stress gain when speeding
------------------------------------------------
CreateThread(function() -- Speeding
    while true do
        if RSGCore ~= nil then
            if IsPedInAnyVehicle(cache.ped, false) then
                speed = GetEntitySpeed(GetVehiclePedIsIn(cache.ped, false)) * 2.237 --mph
                if speed >= Config.MinimumSpeed then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                end
            end
        end
        Wait(20000)
    end
end)

------------------------------------------------
-- stress gained while shooting
------------------------------------------------
CreateThread(function()
    while true do
        if RSGCore ~= nil  then
            if IsPedShooting(cache.ped) then
                if math.random() < Config.StressChance then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                end
            end
        end
        Wait(6)
    end
end)

------------------------------------------------
-- stress screen effects
------------------------------------------------
CreateThread(function()
    while true do
     
        local sleep = GetEffectInterval(stress)

        if stress >= 100 then
            local ShakeIntensity = GetShakeIntensity(stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)

            if not IsPedRagdoll(cache.ped) and IsPedOnFoot(cache.ped) and not IsPedSwimming(cache.ped) then
              
                SetPedToRagdollWithFall(cache.ped, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(cache.ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end

            Wait(500)
            for i = 1, FallRepeat, 1 do
                Wait(750)
                DoScreenFadeOut(200)
                Wait(1000)
                DoScreenFadeIn(200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            end
        elseif stress >= Config.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
        end
        Wait(sleep)
    end
end)

------------------------------------------------
-- check telegrams
------------------------------------------------
if Config.telegram then
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            RSGCore.Functions.TriggerCallback('hud:server:getTelegramsAmount', function(amount)
                if amount > 0 then
                    youhavemail = true
                else
                    youhavemail = false
                end
            end)
        end
        Wait(Config.TelegramCheck)
    end
end)
end

------------------------------------------------
-- check cinematic and hide hud
------------------------------------------------
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local cinematic = Citizen.InvokeNative(0xBF7C780731AADBF8, Citizen.ResultAsInteger())
            local isBathingActive = exports['rsg-bathing']:IsBathingActive()
            local IsCothingActive = exports['rsg-appearance']:IsCothingActive()

            -- cinematic check
            if cinematic == 1 then
                incinematic = true
            else
                incinematic = false
            end
            -- bathing check
            if isBathingActive then
                inBathing = true
            else
                inBathing = false
            end
            -- clothing check
            if IsCothingActive then
                inClothing = true
            else
                inClothing = false
            end

        end

        Wait(500)
    end
end)
