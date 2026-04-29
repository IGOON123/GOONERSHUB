--[[
    SAB / XEN - MAC PRO V15 (STABLE SIGHT)
    Zero Shake + Anti-Void Logic
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
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SAB MAC V15"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

-- 2. SERVER POS ESP
local ServerDot = Instance.new("Part")
ServerDot.Shape = Enum.PartType.Ball
ServerDot.Size = Vector3.new(1.5, 1.5, 1.5)
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
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Btn)

    local state = false
    Btn.MouseButton1Down:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(35, 35, 35)
        callback(state)
    end)
end

createToggle("SAB Desync", 45, function(v) desyncActive = v end)
createToggle("Server Pos ESP", 90, function(v) espActive = v end)

-- 3. THE NO-SHAKE / NO-VOID LOGIC
RS.Heartbeat:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Root or not desyncActive then 
        ServerDot.Transparency = 1 
        return 
    end

    local oldCF = Root.CFrame
    -- 2.5 Stud Jitter: The limit for Mac without getting voided
    local jitter = CFrame.new(math.random(-2.5, 2.5), 0, math.random(-2.5, 2.5))
    
    -- DETACH CAMERA
    Camera.Focus = oldCF
    Root.CFrame = oldCF * jitter
    
    if espActive then
        ServerDot.Transparency = 0.5
        ServerDot.CFrame = Root.CFrame
    else
        ServerDot.Transparency = 1
    end

    RS.RenderStepped:Wait()
    Root.CFrame = oldCF
end)
