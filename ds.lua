-- VERSION 2: AGGRESSIVE MAC DESYNC
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

-- Optimized connection for Mac executors
RunService.PostSimulation:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    
    if Root then
        local oldV = Root.AssemblyLinearVelocity
        -- Extreme velocity spike to desync the server-side hitbox
        Root.AssemblyLinearVelocity = Vector3.new(0, -9999, 0) 
        RunService.RenderStepped:Wait()
        Root.AssemblyLinearVelocity = oldV
    end
end)

print("Hyper-Desync Active")
