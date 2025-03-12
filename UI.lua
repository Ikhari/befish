local AsUI = {}

-- Load the actual UI library
local success, Library = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/AkinaRulezx/AsUI/main/UI', true))()
end)

if not success then
    warn("Failed to load UI library:", Library)
    return
end

function AsUI:Window(title)
    local window = Library:Window(title)

    -- Custom drag implementation
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local function makeDraggable(frame)
        local dragging = false
        local dragOffset = Vector2.new()

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragOffset = input.Position - frame.AbsolutePosition
                frame.BackgroundTransparency = 0.9
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                frame.BackgroundTransparency = 0.8
            end
        end)

        RunService.Heartbeat:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local newPos = mousePos - dragOffset

                -- Screen bounds checking
                newPos = Vector2.new(
                    math.clamp(newPos.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
                    math.clamp(newPos.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
                )

                frame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
            end
        end)
    end

    -- Make main window draggable
    makeDraggable(window:GetMain())

    return window
end

return AsUI
