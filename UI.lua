-- UI.lua
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Sentinel = loadstring(game:HttpGet('https://raw.githubusercontent.com/astraln/SentinelUILIB/main/UI.lua', true))()

local function MakeDraggable(frame)
    local dragging, dragOffset = false, Vector2.new()
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragOffset = input.Position - frame.AbsolutePosition
            frame.BackgroundTransparency = 0.85
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            frame.BackgroundTransparency = 0.8
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging and frame then
            local mousePos = UserInputService:GetMouseLocation()
            local newPos = mousePos - dragOffset
            
            newPos = Vector2.new(
                math.clamp(newPos.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
                math.clamp(newPos.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
            )
            
            frame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
        end
    end)
end

return function(title)
    local window = Sentinel:Window(title)
    MakeDraggable(window:GetMain())
    return window
end
