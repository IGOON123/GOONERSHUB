--[[
    SAB BRAINROT - MAC ULTIMATE EDITION
    Optimized for MacBook (No Velocity = No Welding Errors)
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SAB_Final"
ScreenGui.Parent = CoreGui or LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 180)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.Active = true
Frame.Draggable = true 
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createToggle(name, color, callback)
    local TFrame = Instance.new("Frame")
    TFrame.Size = UDim2.new(0, 180, 0, 45)
    TFrame.BackgroundTransparency = 1
    TFrame.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14
    Label.Parent = TFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 0, 20)
    Btn.Position = UDim2.new(1, -45, 0.5, -10)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = ""
    Btn.Parent = TFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local state = false
    Btn.MouseButton1Down:Connect(function()
        state = not state
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = state and color or Color3.fromRGB(40, 40, 40)}):Play()
        callback(state)
    end)
end

-- 1. NET OVERRIDE (Essential for Mac)
createToggle("Net Override", Color3.fromRGB(180, 0, 255), function(state)
    if state then
        sethiddenproperty(LP, "SimulationRadius", 10000)
        sethiddenproperty(LP, "MaxSimulationRadius", 10000)
    end
end)

-- 2. BRAINROT DESYNC (The TikTok Jitter)
local desyncActive = false
createToggle("SAB Desync", Color3.fromRGB(0, 255, 150), function(state)
    desyncActive = state
end)

-- 3. BLINK (Lag Snap)
createToggle("Blink", Color3.fromRGB(255, 100, 0), function(state)
    settings().Network.IncomingReplicationLag = state and 1000 or 0
end)

-- PHYSICS LOOP
RS.Heartbeat:Connect(function()
    if desyncActive then
        local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local oldCF = Root.CFrame
            -- Extremley fast CFrame shifting for the "ghosting" look
            Root.CFrame = oldCF * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
            RS.RenderStepped:Wait()
            Root.CFrame = oldCF
        end
    end
end)
