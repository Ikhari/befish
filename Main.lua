-- Main.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Load UI dengan error handling
local success, CreateWindow = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/astraln/SentinelUILIB/main/UI.lua', true))()
end)

if not success then
    warn("Failed to load UI library!")
    return
end

local window = CreateWindow("Fish Simulator Premium")

-- ========== SYSTEM INITIALIZATION ==========
local defaultWalkSpeed = 16
local defaultJumpPower = 50

local function InitializeCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    if character:FindFirstChild("Humanoid") then
        defaultWalkSpeed = character.Humanoid.WalkSpeed
        defaultJumpPower = character.Humanoid.JumpPower
    end
end

InitializeCharacter()

-- ========== MOVEMENT SYSTEM ==========
local movementTab = window:Tab("Movement")

-- Speed Control
local speedToggle = false
local speedConnection = nil

local speedSlider = movementTab:Slider("Walk Speed", 16, 500, defaultWalkSpeed, function(value)
    if not speedToggle and player.Character and player.Character.Humanoid then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

movementTab:Toggle("Lock Speed", false, function(state)
    speedToggle = state
    
    if speedConnection then
        speedConnection:Disconnect()
    end
    
    if speedToggle then
        speedConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character.Humanoid then
                -- Bypass speed limit
                if player.Character.Humanoid:FindFirstChild("WalkSpeed") then
                    player.Character.Humanoid.WalkSpeed:Destroy()
                end
                player.Character.Humanoid.WalkSpeed = speedSlider:GetValue()
            end
        end)
    else
        if player.Character and player.Character.Humanoid then
            player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
            speedSlider:SetValue(defaultWalkSpeed)
        end
    end
end)

-- ========== NOCLIP SYSTEM ==========
local noclipTab = window:Tab("Noclip")
local noclipToggle = false
local noclipConnection = nil

noclipTab:Toggle("Enable Noclip", false, function(state)
    noclipToggle = state
    
    if noclipConnection then
        noclipConnection:Disconnect()
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
local utilsTab = window:Tab("Utilities")
utilsTab:Button("Inf Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- ========== DEBUG SYSTEM ==========
local debugTab = window:Tab("Debug")
debugTab:Label("Connection Monitor")

local function UpdateDebug()
    local connections = 0
    if speedConnection then connections += 1 end
    if noclipConnection then connections += 1 end
    
    debugTab:GetLabel(1):UpdateLabel("Active Connections: "..connections)
end

RunService.Heartbeat:Connect(UpdateDebug)

-- ========== CHARACTER HANDLER ==========
player.CharacterAdded:Connect(function()
    InitializeCharacter()
    
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end)

-- ========== UI VISIBILITY TOGGLE ==========
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        window:GetMain().Visible = not window:GetMain().Visible
    end
end)

window:GetMain().Visible = true
