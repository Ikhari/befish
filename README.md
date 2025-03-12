# beafish this is a test!

# Improvement, Fix UI, Fix Memory Leak, add debugging

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ikhari/befish/main/main%20script.lua", true))()
```

```lua
local success, err = pcall(function()
    local uiScript = loadstring(game:HttpGet('https://raw.githubusercontent.com/Ikhari/befish/main/main%20script.lua', true))()
    
    if not uiScript then
        error("Failed to load the UI script")
    end
  
    uiScript()
end)

if not success then
    warn("Error loading script: " .. tostring(err))
end
```
