--[[
    SAB / XEN - MAC PRO "SILENT" DESYNC
    No GUI. No Shake. Just Desync.
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")

-- 1. SILENT NET BOOST (Essential for Mac stability)
sethiddenproperty(LP, "SimulationRadius", 10000)
sethiddenproperty(LP, "MaxSimulationRadius", 10000)

-- 2. THE DESYNC LOOP (Velocity Flick)
-- This jitters your hitbox for the server without moving your camera's focus.
RS.Heartbeat:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    
    if Root then
        local oldVel = Root.Velocity
        
        -- High-frequency velocity jitter (SAB Style)
        -- We use 9e9 to overwhelm the server's hit registration
        Root.Velocity = Vector3.new(9e9, 9e9, 9e9) 
        
        -- Wait for the physics frame to register the "fake" position
        RS.RenderStepped:Wait()
        
        -- Reset velocity before the next frame so you can still move normally
        Root.Velocity = oldVel
    end
end)

print("SAB Desync Loaded - No Shake Edition")
