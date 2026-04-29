-- MAC DESYNC GUI (FIXED)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local Corner = Instance.new("UICorner")

-- Setup GUI
local Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = Parent

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Text = "Desync: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Active = true
ToggleButton.Draggable = true 

Corner.CornerRadius = UDim.new(0, 8) -- FIXED THIS LINE
Corner.Parent = ToggleButton

local Active = false
local Connection

-- Physics Logic
local function StartDesync()
    Connection = game:GetService("RunService").PostSimulation:Connect(function()
        local Char = game.Players.LocalPlayer.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        if Root then
            local oldV = Root.AssemblyLinearVelocity
            Root.AssemblyLinearVelocity = Vector3.new(0, -5000, 0)
            game:GetService("RunService").RenderStepped:Wait()
            Root.AssemblyLinearVelocity = oldV
        end
    end)
end

-- Toggle Logic
ToggleButton.MouseButton1Down:Connect(function() -- Better for Mac executors
    Active = not Active
    if Active then
        ToggleButton.Text = "Desync: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        StartDesync()
    else
        ToggleButton.Text = "Desync: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        if Connection then Connection:Disconnect() end
    end
end)
