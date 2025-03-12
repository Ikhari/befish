local AsUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/AkinaRulezx/AsUI/main/UI', true))()
local window = AsUI:Window('Be a Fish Test v2.0')

-- ===================================
-- GENERAL UTILITIES
-- ===================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local defaultWalkSpeed = 16

-- Initialize default walkspeed
if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
    defaultWalkSpeed = player.Character.Humanoid.WalkSpeed
end

-- ===================================
-- SPEED BOOST SECTION (Optimized)
-- ===================================
local speedBoostTab = window:Tab('Speed Boost')
local speedBoostToggle = false
local speedBoostConnection = nil

speedBoostTab:Label("Speed Controller", Color3.fromRGB(255, 255, 255))

local speedSlider = speedBoostTab:Slider("Speed", 1, 500, defaultWalkSpeed, function(value)
    if not speedBoostToggle and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

speedBoostTab:Label("Speed Boost will override slider", Color3.fromRGB(200, 200, 200))

speedBoostTab:Toggle('Enable Speed Boost', false, function(state)
    speedBoostToggle = state
    local character = player.Character or player.CharacterAdded:Wait()

    if speedBoostConnection then
        speedBoostConnection:Disconnect()
        speedBoostConnection = nil
    end

    if speedBoostToggle then
        speedBoostConnection = RunService.Stepped:Connect(function()
            if not speedBoostToggle then return end
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.WalkSpeed = 55
            end
        end)
    else
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.WalkSpeed = speedSlider:GetValue()
        end
    end
end)

-- ===================================
-- NOCLIP SECTION (Optimized)
-- ===================================
local noclipTab = window:Tab('Noclip')
local noclipToggle = false
local noclipConnection = nil

noclipTab:Label("Noclip Controller", Color3.fromRGB(255, 255, 255))

noclipTab:Toggle('Enable Noclip', false, function(state)
    noclipToggle = state
    local character = player.Character or player.CharacterAdded:Wait()

    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if noclipToggle then
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipToggle then return end
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- ===================================
-- OTHER FEATURES
-- ===================================
local othersTab = window:Tab('Utilities')
local debounce = false

othersTab:Button("Inf Yield", function()
    if not debounce then
        debounce = true
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        task.wait(1)
        debounce = false
    end
end)

local discordTab = window:Tab('Discord')
discordTab:Label("Join our Community!", Color3.fromRGB(255, 255, 255))

discordTab:Button("Copy Discord Link", function()
    setclipboard("https://discord.gg/4Gq4585R7n")
    game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):SetCore("SendNotification", {
        Title = "LINK COPIED",
        Text = "Discord link has been copied to clipboard!",
        Duration = 3,
        Icon = "rbxassetid://6724406029"
    })
end)

-- ===================================
-- INITIALIZATION
-- ===================================
window:Tab('About'):Label("UI v2.0 - Optimized Performance\nCreated by [Your Name]")
