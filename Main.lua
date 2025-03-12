-- Custom UI Framework
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "CustomUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Container
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "BE A FISH UI"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.Parent = titleBar

-- Tabs Container
local tabsContainer = Instance.new("Frame")
tabsContainer.Name = "Tabs"
tabsContainer.Size = UDim2.new(1, 0, 0, 30)
tabsContainer.Position = UDim2.new(0, 0, 0, 30)
tabsContainer.BackgroundTransparency = 1
tabsContainer.Parent = mainFrame

-- Content Container
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -60)
contentFrame.Position = UDim2.new(0, 0, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Draggable Functionality
local dragging = false
local dragStartPos = Vector2.new()
local frameStartPos = Vector2.new()

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPos = Vector2.new(mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = mousePos - dragStartPos
        local newPos = frameStartPos + delta
        
        -- Screen boundary check
        newPos = Vector2.new(
            math.clamp(newPos.X, 0, workspace.CurrentCamera.ViewportSize.X - mainFrame.AbsoluteSize.X),
            math.clamp(newPos.Y, 0, workspace.CurrentCamera.ViewportSize.Y - mainFrame.AbsoluteSize.Y)
        )
        
        mainFrame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
    end
end)

-- Tab System
local currentTab = nil
local tabs = {}

function CreateTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Size = UDim2.new(0.3, 0, 1, 0)
    tabButton.Position = UDim2.new(0.3 * #tabs, 0, 0, 0)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.new(1, 1, 1)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 12
    tabButton.Parent = tabsContainer
    
    local tabContent = Instance.new("Frame")
    tabContent.Name = name
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = contentFrame
    
    tabs[name] = tabContent
    
    tabButton.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Visible = false
        end
        currentTab = tabContent
        currentTab.Visible = true
    end)
    
    return {
        AddButton = function(self, text, callback)
            local button = Instance.new("TextButton")
            button.Text = text
            button.Size = UDim2.new(0.9, 0, 0, 30)
            button.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 35)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Font = Enum.Font.Gotham
            button.TextSize = 12
            button.Parent = tabContent
            
            button.MouseButton1Click:Connect(callback)
            return button
        end,
        
        AddToggle = function(self, text, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(0.9, 0, 0, 30)
            toggleFrame.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 35)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 20, 0, 20)
            toggleButton.Position = UDim2.new(1, -25, 0.5, -10)
            toggleButton.Text = ""
            toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)
            toggleButton.Parent = toggleFrame
            
            local label = Instance.new("TextLabel")
            label.Text = text
            label.Size = UDim2.new(1, -30, 1, 0)
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame
            
            local state = default
            
            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)
                callback(state)
            end)
            
            return {
                SetState = function(self, newState)
                    state = newState
                    toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)
                end
            }
        end,
        
        AddSlider = function(self, text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
            sliderFrame.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 55)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Text = text..": "..default
            label.Size = UDim2.new(1, 0, 0, 20)
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, 5)
            track.Position = UDim2.new(0, 0, 0, 25)
            track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            track.Parent = sliderFrame
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            fill.Parent = track
            
            local dragging = false
            local function update(value)
                local ratio = math.clamp((value - min)/(max - min), 0, 1)
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                label.Text = text..": "..math.floor(value)
                callback(value)
            end
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            track.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            track.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = input.Position.X - track.AbsolutePosition.X
                    local ratio = math.clamp(pos / track.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * ratio
                    update(value)
                end
            end)
            
            update(default)
            return {Update = update}
        end
    }
end

-- ====================
-- MAIN FUNCTIONALITY
-- ====================
local defaultWalkSpeed = 16
local speedBoostEnabled = false
local speedConnection = nil

-- Initialize default speed
if player.Character and player.Character:FindFirstChild("Humanoid") then
    defaultWalkSpeed = player.Character.Humanoid.WalkSpeed
end

-- Speed Tab
local speedTab = CreateTab("Speed")

local speedSlider = speedTab:AddSlider("Walk Speed", 16, 500, defaultWalkSpeed, function(value)
    if not speedBoostEnabled then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

local speedToggle = speedTab:AddToggle("Speed Boost", false, function(state)
    speedBoostEnabled = state
    if speedConnection then
        speedConnection:Disconnect()
    end
    
    if state then
        speedConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 100
            end
        end)
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speedSlider:Update(defaultWalkSpeed)
        end
    end
end)

-- Noclip Tab
local noclipTab = CreateTab("Noclip")
local noclipToggle = noclipTab:AddToggle("Enable Noclip", false, function(state)
    if state then
        RunService.Stepped:Connect(function()
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

-- Utilities Tab
local utilsTab = CreateTab("Utilities")
utilsTab:AddButton("Inf Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- Toggle UI Visibility
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
