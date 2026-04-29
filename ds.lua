-- MAC DESYNC SCRIPT
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    local Char = LP.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local oldV = Char.HumanoidRootPart.Velocity
        Char.HumanoidRootPart.Velocity = Vector3.new(0, -100, 0)
        RunService.RenderStepped:Wait()
        Char.HumanoidRootPart.Velocity = oldV
    end
end)
print("Desync Loaded")
