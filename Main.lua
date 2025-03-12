-- Main.lua
local CreateWindow = loadstring(game:HttpGet('https://raw.githubusercontent.com/astraln/SentinelUILIB/main/UI.lua', true))()
local window = CreateWindow('Fish Simulator Premium')

-- ========== SYSTEM VARIABLES ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local defaultWalkSpeed = 16
local defaultJumpPower = 50

-- Initialize defaults
local function InitializeDefaults()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        defaultWalkSpeed = player.Character.Humanoid.WalkSpeed
        defaultJumpPower = player.Character.Humanoid.JumpPower
    end
end
InitializeDefaults()

-- ========== SPEED SYSTEM ==========
local speedTab = window:Tab('Movement')
local speedToggle = false
local speedConnection = nil

local speedSlider = speedTab:Slider("Walk Speed", 16, 500, defaultWalkSpeed, function(value)
    if not speedToggle and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

speedTab:Toggle('Lock Speed', false, function(state)
    speedToggle = state
    
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if speedToggle then
        speedConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = speedSlider:GetValue()
            end
        end)
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
            speedSlider:SetValue(defaultWalkSpeed)
        end
    end
end)

-- ========== NOCLIP SYSTEM ==========
local noclipTab = window:Tab('Noclip')
local noclipToggle = false
local noclipConnection = nil

noclipTab:Toggle('Enable Noclip', false, function(state)
    noclipToggle = state
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if noclipToggle then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- ========== UTILITIES ==========
local utilsTab = window:Tab('Utilities')
local debounce = false

utilsTab:Button("Inf Yield", function()
    if not debounce then
        debounce = true
        local success, err = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end)
        if not success then
            warn("Inf Yield Error:", err)
        end
        task.wait(1)
        debounce = false
    end
end)

-- ========== DISCORD ==========
local discordTab = window:Tab('Discord')
discordTab:Label("Join our Discord Server!")

discordTab:Button("Copy Invite Link", function()
    setclipboard("https://discord.gg/example")
    game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):SetCore("SendNotification", {
        Title = "COPIED!",
        Text = "Discord link copied to clipboard",
        Duration = 3,
        Icon = "rbxassetid://6724406029"
    })
end)

-- ========== AUTO RESET HANDLER ==========
player.CharacterAdded:Connect(function()
    InitializeDefaults()
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end)

-- ========== DIAGNOSTICS ==========
if _G.DebugMode then
    window:Tab('Debug'):Label("Connections: 0")
    
    RunService.Heartbeat:Connect(function()
        local connections = #getconnections(RunService.Heartbeat) + 
                          #getconnections(RunService.Stepped)
        window:GetTab('Debug'):GetLabel(1):UpdateLabel("Connections: "..connections)
    end)
end
