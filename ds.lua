-- MAC GUI: DESYNC + BLINK (FAKE LAG)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local BlinkBtn = Instance.new("TextButton")
local DesyncBtn = Instance.new("TextButton")
local UIListLayout = Instance.new("UIListLayout")

local TargetParent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true

UIListLayout.Parent = MainFrame
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(text)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0, 150, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local bBtn = createBtn("Blink: OFF")
local dBtn = createBtn("Desync: OFF")

local blinkActive = false
local desyncActive = false

-- BLINK LOGIC (Stand in place for others)
bBtn.MouseButton1Down:Connect(function()
    blinkActive = not blinkActive
    bBtn.Text = blinkActive and "Blink: ON" or "Blink: OFF"
    bBtn.BackgroundColor3 = blinkActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 45)
    
    if blinkActive then
        settings().Network.IncomingReplicationLag = 1000 -- Freezes you for others
    else
        settings().Network.IncomingReplicationLag = 0 -- Teleports you to your real spot
    end
end)

-- DESYNC LOGIC
dBtn.MouseButton1Down:Connect(function()
    desyncActive = not desyncActive
    dBtn.Text = desyncActive and "Desync: ON" or "Desync: OFF"
    dBtn.BackgroundColor3 = desyncActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 45)
end)

game:GetService("RunService").PostSimulation:Connect(function()
    if desyncActive then
        local Root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local oldV = Root.AssemblyLinearVelocity
            Root.AssemblyLinearVelocity = Vector3.new(0, -5000, 0)
            game:GetService("RunService").RenderStepped:Wait()
            Root.AssemblyLinearVelocity = oldV
        end
    end
end)
