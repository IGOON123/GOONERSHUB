-- MAC GUI: DESYNC, BLINK, & RAKNET
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

local TargetParent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 170, 0, 210)
MainFrame.Active = true
MainFrame.Draggable = true

UIListLayout.Parent = MainFrame
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(text)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0, 160, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local bBtn = createBtn("Blink: OFF")
local dBtn = createBtn("Desync: OFF")
local rBtn = createBtn("RakNet Anti-Stomp: OFF")

local blinkActive = false
local desyncActive = false
local raknetActive = false

-- RAKNET / NETWORK LOGIC
rBtn.MouseButton1Down:Connect(function()
    raknetActive = not raknetActive
    rBtn.Text = raknetActive and "RakNet: ACTIVE" or "RakNet: OFF"
    rBtn.BackgroundColor3 = raknetActive and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(40, 40, 40)
    
    -- Forces network ownership to prevent server "stomp" or pulls
    if raknetActive then
        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 1000)
        sethiddenproperty(game.Players.LocalPlayer, "MaxSimulationRadius", 1000)
    else
        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 100)
    end
end)

-- BLINK (FAKE LAG)
bBtn.MouseButton1Down:Connect(function()
    blinkActive = not blinkActive
    bBtn.Text = blinkActive and "Blink: ON" or "Blink: OFF"
    bBtn.BackgroundColor3 = blinkActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    settings().Network.IncomingReplicationLag = blinkActive and 1000 or 0
end)

-- DESYNC
dBtn.MouseButton1Down:Connect(function()
    desyncActive = not desyncActive
    dBtn.Text = desyncActive and "Desync: ON" or "Desync: OFF"
    dBtn.BackgroundColor3 = desyncActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

game:GetService("RunService").PostSimulation:Connect(function()
    if desyncActive then
        local Root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local oldV = Root.AssemblyLinearVelocity
            Root.AssemblyLinearVelocity =
