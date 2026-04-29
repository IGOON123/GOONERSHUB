--[[
    SAB / XEN - MAC PRO "STILL" EDITION
    Velocity-based Server Pos (No Shake)
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- 1. GUI SETUP
local ScreenGui = Instance.new("ScreenGui", CoreGui or LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "SAB_Still_Mac"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 150)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SAB MAC V8"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- 2. SERVER POS ESP
local ServerDot = Instance.new("Part")
ServerDot.Shape = Enum.PartType.Ball
ServerDot.Size = Vector3.new(3, 3, 3)
ServerDot.Color = Color3.fromRGB(255, 0, 0)
ServerDot.Material = Enum.Material.ForceField
ServerDot.CanCollide = false
ServerDot.Anchored = true
ServerDot.Parent = workspace

local function createToggle(name, yPos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 180, 0, 35)
    Btn.Position = UDim2.new(0.5, -90, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundTransparency = 0.9
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", Btn)

    local state = false
    Btn.MouseButton1Down:Connect(function()
        state = not state
        Btn.BackgroundTransparency = state and 0.5 or 0.9
        callback(state)
    end)
end

local desyncActive = false
local espActive = false
createToggle("Server Pos Desync", 45, function(v) desyncActive = v end)
createToggle("Server Pos ESP", 90, function(v) espActive = v end)

-- 3. THE NO-SHAKE LOGIC
RS.PostSimulation:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    if desyncActive then
        -- This moves your SERVER HITBOX without moving your CAMERA
        Root.Velocity = Vector3.new(0, 10^7, 0) -- Vertical Desync
        
        if espActive then
            ServerDot.Transparency = 0.5
            ServerDot.CFrame = Root.CFrame * CFrame.new(0, 15, 0) -- Visual check
        else
            ServerDot.Transparency = 1
        end
    else
        ServerDot.Transparency = 1
    end
end)
