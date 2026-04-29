--[[
    SAB / XEN - SERVER POSITION DESYNC
    MAC-ONLY: No Shake, No GUI, Pure Desync.
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")

-- 1. SILENT NET OVERRIDE
-- This forces the server to prioritize your local physics data.
sethiddenproperty(LP, "SimulationRadius", 10000)
sethiddenproperty(LP, "MaxSimulationRadius", 10000)

-- 2. THE SERVER-POS FLICKER
RS.Heartbeat:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    
    if Root then
        -- Store your real velocity
        local oldVel = Root.Velocity
        
        -- SERVER POS DESYNC:
        -- We set a massive AssemblyLinearVelocity. 
        -- To the server, your "Position" is now "Infinite" or "NaN"
        Root.AssemblyLinearVelocity = Vector3.new(10^6, 10^6, 10^6)
        
        -- Wait for the physics engine to replicate this "Fake Position"
        RS.RenderStepped:Wait()
        
        -- Reset so you don't actually fly away
        Root.AssemblyLinearVelocity = oldVel
    end
end)

print("Server-Pos Desync Active - MacBook Pro Optimized")
