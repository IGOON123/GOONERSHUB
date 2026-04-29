-- MAC DESYNC GUI (STABLE)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local Corner = Instance.new("UICorner")

-- Setup GUI - Fallback for executors that block CoreGui
local TargetParent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "MacDesync"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.15, 0, 0.15, 0)
ToggleButton.Size = UDim2.new(0, 160, 0, 50)
ToggleButton.Text = "DESYNC: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Draggable = true 
ToggleButton.Active = true

Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = ToggleButton

local Active = false
local Connection

-- High-Priority Physics Logic
local function ToggleLogic()
    if Active then
        Connection = game:GetService("RunService").PostSimulation:Connect(function()
            local Char = game.Players.LocalPlayer.Character
            local Root = Char and Char:FindFirstChild("HumanoidRootPart")
            if Root then
                local oldV = Root.AssemblyLinearVelocity
                Root.AssemblyLinearVelocity = Vector3.new(0, -10000, 0)
                game:GetService("RunService").RenderStepped:Wait()
                Root.AssemblyLinearVelocity = oldV
            end
        end)
    else
        if Connection then Connection:Disconnect() end
    end
end

-- MouseButton1Down is more reliable for Mac executors than Click
ToggleButton.MouseButton1Down:Connect(function()
    Active = not Active
    if Active then
        ToggleButton.Text = "DESYNC: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        ToggleButton.Text = "DESYNC: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
    ToggleLogic()
end)

print("Script Loaded - Press Button to Toggle")
