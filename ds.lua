--[[
    SAB / XEN - MACBOOK "STILL" EDITION
    Linear Back-Flick Method (Kills Camera Vibration)
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SAB_Mac_Still"
ScreenGui.Parent = CoreGui or LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 180)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
    Label.TextSize = 13
    Label.Parent = TFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 42, 0, 22)
    Btn.Position = UDim2.new(1, -50, 0.5, -11)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = ""
    Btn.Parent = TFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local state = false
    Btn.MouseButton1Down:Connect(function()
        state = not state
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = state and color or Color3.fromRGB(30, 30, 30)}):Play()
        callback(state)
    end)
end

-- 1. NET OVERRIDE (Essential)
createToggle("Net Override", Color3.fromRGB(160, 50, 255), function(state)
    if state then sethiddenproperty(LP, "SimulationRadius", 10000) end
end)

-- 2. SAB DESYNC (The Jitter)
local desyncActive = false
createToggle("SAB Desync", Color3.fromRGB(0, 255, 180), function(state)
    desyncActive = state
end)

-- 3. BLINK (Lag Snap)
createToggle("Blink Snap", Color3.fromRGB(255, 150, 0), function(state)
    settings().Network.IncomingReplicationLag = state and 1000 or 0
end)

-- THE FIX: "BACK-FLICK" PHYSICS
RS.Heartbeat:Connect(function()
    if desyncActive then
        local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local oldCF = Root.CFrame
            -- Instead of random jitter, we flick backwards based on where you face
            -- This is significantly easier on the Mac camera
            Root.CFrame = oldCF * CFrame.new(0, 0, 15) 
            RS.RenderStepped:Wait()
            Root.CFrame = oldCF
        end
    end
end)
