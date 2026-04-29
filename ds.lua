--[[
    MACBOOK OPTIMIZED DESYNC (2026)
    Fixes "Exception while welding" by using CFrame offsets instead of raw velocity.
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Check for RakNet support (Common in high-end Mac executors)
local plsraknet = Raknet or raknet

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MacSafeDesync"
ScreenGui.Parent = CoreGui or LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 160)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true 
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- TOGGLE MAKER
local function createToggle(name, callback)
    local TFrame = Instance.new("Frame")
    TFrame.Size = UDim2.new(0, 180, 0, 45)
    TFrame.BackgroundTransparency = 1
    TFrame.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
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
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 40)}):Play()
        callback(state)
    end)
end

-- RAKNET DESYNC
createToggle("RakNet Desync", function(state)
    if plsraknet and plsraknet.desync then
        plsraknet.desync(state)
    end
end)

-- SAFE MAC DESYNC
local physActive = false
createToggle("Safe Desync", function(state)
    physActive = state
end)

-- BLINK (LAG)
createToggle("Blink Lag", function(state)
    settings().Network.IncomingReplicationLag = state and 1000 or 0
end)

-- THE PHYSICS LOOP (MAC OPTIMIZED)
RS.PostSimulation:Connect(function()
    if physActive then
        local Char = LP.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        if Root then
            -- We use a tiny CFrame offset + a safe velocity
            -- This jitters your hitbox without snapping welds
            local oldCF = Root.CFrame
            Root.CFrame = oldCF * CFrame.new(0, 0.02, 0)
            Root.AssemblyLinearVelocity = Vector3.new(0, -10, 0)
            RS.RenderStepped:Wait()
            Root.CFrame = oldCF
        end
    end
end)
