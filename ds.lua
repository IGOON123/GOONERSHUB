--[[
    SAB / XEN - MAC PRO V17 (STABILIZED ANCHOR)
    Total Camera Lock + Anti-Void Velocity
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
Title.Text = "SAB MAC V17"
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

-- 3. THE FIX: CAMERA ANCHORING
RS.RenderStepped:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if desyncActive and Root then
        -- Force the camera to stay at a fixed distance from your REAL position
        -- This ignores the "jitter" caused by the desync loop
        Camera.CameraSubject = LP.Character:FindFirstChild("Humanoid")
        Camera.Focus = Root.CFrame
    end
end)

-- 4. VELOCITY DESYNC (MAP SAFE)
RS.Heartbeat:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Root or not desyncActive then 
        ServerDot.Transparency = 1 
        return 
    end

    local oldVel = Root.AssemblyLinearVelocity
    
    -- Jitter Velocity without moving CFrame (Anti-Void)
    Root.AssemblyLinearVelocity = Vector3.new(math.random(-500, 500), 0, math.random(-500, 500))
    
    if espActive then
        ServerDot.Transparency = 0.5
        ServerDot.CFrame = Root.CFrame * CFrame.new(0, 4, 0)
    else
        ServerDot.Transparency = 1
    end

    RS.RenderStepped:Wait()
    Root.AssemblyLinearVelocity = oldVel
end)
