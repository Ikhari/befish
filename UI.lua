-- UI.lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/astraln/SentinelUILIB/main/UI.lua', true))()

local window = Library:Window('Sentinel')

-- Aktifkan fitur drag pada UI (jika library mendukung)
if window.GetMain and window:GetMain() then
    local mainFrame = window:GetMain()
    if mainFrame then
        mainFrame.Draggable = true
        mainFrame.Active = true
        mainFrame.Selectable = true
    end
end

local tab = window:Tab('Home')

tab:Button('Button', function()
    -- Fungsi button
end)

tab:Toggle('Toggle', false, function(t)
    -- Fungsi toggle
end)

tab:Label("Label")

tab:Keybind("Keybind", Enum.KeyCode.E, function(t)
    -- Fungsi keybind
end)

local dropdown = tab:Dropdown("Dropdown", {"1", "2", "3", "4", "5", "6", "7", "8"}, function(item)
    print(item)
end)

tab:Button('Refresh', function()
    dropdown:RefreshDropdown({"69"})
end)

tab:Slider("Slider", 16, 1000, 16, function(value)
    -- Fungsi slider
end)
