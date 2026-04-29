--[[
    SAB / XEN - MAC PRO V18 (DESYNC FIXED)
    High-Frequency CFrame Jitter + Camera Lock
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- 1. GUI SETUP
local ScreenGui = Instance.new("ScreenGui", CoreGui or LP:WaitForChild("PlayerGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 150)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SAB MAC V18"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

-- 2. SERVER POS ESP
local ServerDot = Instance.new("Part")
ServerDot.Shape = Enum.PartType.Ball
ServerDot.Size = Vector3.new(2, 2, 2)
ServerDot.Color = Color3.fromRGB(255, 0, 0)
ServerDot.Material = Enum.Material.ForceField
ServerDot.CanCollide = false
ServerDot.Anchored = true
ServerDot.Parent = workspace

local desyncActive = false
local espActive = false

local function createToggle(name, yPos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 180, 0, 35)
    Btn.Position = UDim2.new(0.5, -90, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Btn)

    local state = false
    Btn.MouseButton1Down:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

createToggle("SAB Desync", 45, function(v) desyncActive = v end)
createToggle("Server Pos ESP", 90, function(v) espActive = v end)

-- 3. THE DESYNC (HITBOX BREAK)
-- This moves your character 20 studs away and back every frame.
RS.Heartbeat:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Root or not desyncActive then 
        ServerDot.Transparency = 1 
        return 
    end

    local oldCF = Root.CFrame
    -- We flick you 20 studs into the air/side and back instantly
    local desyncCF = oldCF * CFrame.new(0, 20, 0)
    
    Root.CFrame = desyncCF
    
    if espActive then
        ServerDot.Transparency = 0.5
        ServerDot.CFrame = desyncCF
    else
        ServerDot.Transparency = 1
    end

    RS.RenderStepped:Wait()
    Root.CFrame = oldCF
end)

-- 4. THE CAMERA LOCK (STOPS SHAKE)
RS.RenderStepped:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if desyncActive and Root then
        -- This keeps your view locked to your REAL position
        Camera.Focus = Root.CFrame
    end
end)
