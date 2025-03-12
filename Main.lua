-- UI.lua
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/astraln/SentinelUILIB/main/UI.lua', true))()

local function CreateDraggableWindow(title)
    local window = Library:Window(title, {
        main_color = Color3.fromRGB(35, 35, 35),
        min_size = Vector2.new(350, 250)
    })
    
    local mainFrame = window:GetMain()
    
    -- Custom Drag System
    local dragToggle, dragInput, dragStart, startPos = nil, nil, nil, nil
    
    local function UpdateInput(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        
        -- Boundary Constraint
        newPos = UDim2.new(
            math.clamp(newPos.X.Scale, 0, 1),
            math.clamp(newPos.X.Offset, 0, workspace.CurrentCamera.ViewportSize.X - mainFrame.AbsoluteSize.X),
            math.clamp(newPos.Y.Scale, 0, 1),
            math.clamp(newPos.Y.Offset, 0, workspace.CurrentCamera.ViewportSize.Y - mainFrame.AbsoluteSize.Y)
        )
        
        TweenService:Create(mainFrame, TweenInfo.new(0.15), {Position = newPos}):Play()
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
            mainFrame.BackgroundTransparency = 0.9
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                    mainFrame.BackgroundTransparency = 0.85
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            UpdateInput(input)
        end
    end)
    
    return window
end

return CreateDraggableWindow
