local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

-- Use Heartbeat for maximum priority
RunService.Heartbeat:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    
    if Root then
        -- Forcefully sets velocity and CFrame offset
        local oldV = Root.Velocity
        Root.Velocity = Vector3.new(0, 5000, 0) -- High vertical velocity
        Root.CFrame = Root.CFrame * CFrame.new(0, 0.0001, 0)
        RunService.RenderStepped:Wait()
        Root.Velocity = oldV
    end
end)
