-- MAC DESYNC GUI
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

-- Setup GUI
ScreenGui.Parent = game.CoreGui
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Text = "Desync: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Draggable = true

local Active = false
local Connection

-- Desync Logic
local function StartDesync()
    Connection = game:GetService("RunService").PostSimulation:Connect(function()
        local Char = game.Players.LocalPlayer.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        if Root then
            local oldV = Root.AssemblyLinearVelocity
            Root.AssemblyLinearVelocity = Vector3.new(0, -9999, 0)
            game:GetService("RunService").RenderStepped:Wait()
            Root.AssemblyLinearVelocity = oldV
        end
    end)
end

-- Button Logic
ToggleButton.MouseButton1Click:Connect(function()
    Active = not Active
    if Active then
        ToggleButton.Text = "Desync: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        StartDesync()
    else
        ToggleButton.Text = "Desync: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if Connection then Connection:Disconnect() end
    end
end)

print("GUI Loaded - Click the button to toggle")
