-- main.lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/AkinaRulezx/AsUI/main/UI', true))()
local window = Library:Window('Be a Fish Test')

-- ===================================
-- SPEED BOOST SECTION (dengan perbaikan memory leak)
-- ===================================
local speedBoostTab = window:Tab('Speed Boost')
speedBoostTab:Label("Speed Boost", Color3.fromRGB(255, 255, 255))

-- Variabel untuk menyimpan nilai slider (default WalkSpeed)
local speedValue = 55
-- Variabel untuk mengetahui status toggle Speed Boost
local speedBoostToggle = false
-- Variable untuk menyimpan koneksi event
local speedBoostConnection

speedBoostTab:Slider("Speed", 1, 500, speedValue, function(value)
    if not speedBoostToggle then  -- Slider hanya berpengaruh jika toggle nonaktif
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChildOfClass('Humanoid') then
            player.Character.Humanoid.WalkSpeed = value
            speedValue = value  -- Update nilai default
        end
    else
        -- Jika toggle aktif, slider tidak berpengaruh.
        -- Opsional: tampilkan notifikasi atau reset slider ke nilai tetap.
    end
end)

speedBoostTab:Label("When enabled, speed slider will not work.", Color3.fromRGB(200, 200, 200))

-- Fungsi untuk mengatur karakter baru (misalnya saat respawn)
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = speedBoostToggle and 55 or speedValue
    end
end

-- Pasang listener untuk event CharacterAdded
game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

speedBoostTab:Toggle('Enable Speed Boost', false, function(state)
    speedBoostToggle = state
    local player = game.Players.LocalPlayer
    if speedBoostToggle then
        local character = player.Character or player.CharacterAdded:Wait()
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.WalkSpeed = 55
        end

        if speedBoostConnection then
            speedBoostConnection:Disconnect()
            speedBoostConnection = nil
        end

        speedBoostConnection = game:GetService("RunService").Stepped:Connect(function()
            if not speedBoostToggle then
                if speedBoostConnection then
                    speedBoostConnection:Disconnect()
                    speedBoostConnection = nil
                end
                return
            end

            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                local currentHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if currentHumanoid.WalkSpeed ~= 55 then
                    currentHumanoid.WalkSpeed = 55
                end
            end
        end)
    else
        if speedBoostConnection then
            speedBoostConnection:Disconnect()
            speedBoostConnection = nil
        end
        if player.Character and player.Character:FindFirstChildOfClass('Humanoid') then
            player.Character.Humanoid.WalkSpeed = speedValue  -- Reset ke nilai slider
        end
    end
end)

-- ===================================
-- NOCLIP SECTION (dengan perbaikan memory leak)
-- ===================================
local noclipTab = window:Tab('Noclip')
noclipTab:Label("Noclip", Color3.fromRGB(255, 255, 255))

local noclipToggle = false
local noclipConnection

-- Fungsi untuk menerapkan noclip pada semua BasePart di karakter
local function applyNoclip(character)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

noclipTab:Toggle('Enable Noclip', false, function(state)
    noclipToggle = state
    local player = game.Players.LocalPlayer
    if noclipToggle then
        local character = player.Character or player.CharacterAdded:Wait()

        if character then
            applyNoclip(character)  -- Terapkan noclip awal
        end

        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end

        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if not noclipToggle then 
                if noclipConnection then
                    noclipConnection:Disconnect()
                    noclipConnection = nil
                end
                return 
            end
            if player.Character and player.Character ~= character then
                character = player.Character
                applyNoclip(character)  -- Reapply noclip jika karakter berubah
            elseif player.Character then
                if player.Character:FindFirstChildOfClass("Humanoid") then
                    applyNoclip(player.Character)
                end
            end
        end)

        -- Menggunakan task.spawn dengan interval yang lebih realistis untuk mengurangi overhead
        task.spawn(function()
            while noclipToggle do
                task.wait(0.05)
                if player.Character and player.Character:FindFirstChildOfClass('Humanoid') then
                    applyNoclip(player.Character)
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local character = player.Character
        if character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == false then
                    v.CanCollide = true
                end
            end
        end
    end
end)

-- ===================================
-- OTHERS & DISCORD SECTION (tidak ada perbaikan memory leak)
-- ===================================
local othersTab = window:Tab('Others')
othersTab:Button("Inf Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()  -- Load Infinite Yield
end)

local discordTab = window:Tab('Discord')
discordTab:Label("Join our Discord:", Color3.fromRGB(255, 255, 255))
discordTab:Button("Copy Discord Link", function()
    setclipboard("https://discord.gg/4Gq4585R7n")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Discord Link Copied",
        Text = "The Discord link has been copied to your clipboard!",
        Duration = 2
    })
end)
