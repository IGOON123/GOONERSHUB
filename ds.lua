--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Open source for y'all ❤️‍🩹🥹✌️

local plsraknet = Raknet or raknet
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MacUltimate"
ScreenGui.Parent = CoreGui or LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 160)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true 
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- TOGGLE CREATOR FUNCTION
local function createToggle(name, callback)
    local TFrame = Instance.new("Frame")
    TFrame.Size = UDim2.new(0, 180, 0, 45)
    TFrame.BackgroundTransparency = 1
    TFrame.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14
    Label.Parent = TFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 45, 0, 22)
    Btn.Position = UDim2.new(1, -55, 0.5, -11)
    Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Btn.Text = ""
    Btn.Parent = TFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 2, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(200,200,200)
    Knob.Parent = Btn
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local state = false
    Btn.MouseButton1Down:Connect(function()
        state = not state
        local knobPos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local bgColor = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40,40,40)
        
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = knobPos}):Play()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
        callback(state)
    end)
end

-- RAKNET DESYNC
createToggle("RakNet Desync", function(state)
    if plsraknet and plsraknet.desync then
        plsraknet.desync(state)
    end
end)

-- PHYSICS DESYNC
local physicsActive = false
createToggle("Phys Desync", function(state)
    physicsActive = state
end)

-- BLINK (Fake Lag)
createToggle("Blink (Lag)", function(state)
    settings().Network.IncomingReplicationLag = state and 1000 or 0
end)

-- LOOP FOR PHYSICS DESYNC
RunService.PostSimulation:Connect(function()
    if physicsActive then
        local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local oldV = Root.AssemblyLinearVelocity
            Root.AssemblyLinearVelocity = Vector3.new(0, -5000, 0)
            RunService.RenderStepped:Wait()
            Root.AssemblyLinearVelocity = oldV
        end
    end
end)
