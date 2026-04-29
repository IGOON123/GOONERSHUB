--[[
    SAB / XEN - MAC PRO V17 (STABILIZED)
    Camera Anchor + Velocity Jitter Logic
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- 1. GUI SETUP
local ScreenGui = Instance.new("ScreenGui", CoreGui or LP:WaitForChild("PlayerGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 120)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 40)
Status.Text = "SAB MAC V17: OFF"
Status.TextColor3 = Color3.fromRGB(255, 50, 50)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.GothamBold

-- 2. THE BUTTON
local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0, 160, 0, 45)
Btn.Position = UDim2.new(0.5, -80, 0, 50)
Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Btn.Text = "ENABLE SAB"
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.Gotham
Instance.new("UICorner", Btn)

-- 3. SERVER POS ESP
local ServerDot = Instance.new("Part")
ServerDot.Shape = Enum.PartType.Ball
ServerDot.Size = Vector3.new(2, 2, 2)
ServerDot.Color = Color3.fromRGB(255, 0, 0)
ServerDot.Material = Enum.Material.ForceField
ServerDot.CanCollide = false
ServerDot.Anchored = true
ServerDot.Parent = workspace

local desyncActive = false
Btn.MouseButton1Down:Connect(function()
    desyncActive = not desyncActive
    if desyncActive then
        Btn.Text = "IT'S WORKING"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        Status.Text = "SAB MAC V17: ON"
        Status.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        Btn.Text = "ENABLE SAB"
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Status.Text = "SAB MAC V17: OFF"
        Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- 4. THE V17 VELOCITY JITTER
RS.Heartbeat:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Root or not desyncActive then 
        ServerDot.Transparency = 1 
        return 
    end

    local oldVel = Root.AssemblyLinearVelocity
    
    -- Horizontal Velocity flicking (breaks hit-reg)
    Root.AssemblyLinearVelocity = Vector3.new(math.random(-500, 500), 0, math.random(-500, 500))
    
    -- Visualizer
    ServerDot.Transparency = 0.5
    ServerDot.CFrame = Root.CFrame * CFrame.new(0, 4, 0)

    RS.RenderStepped:Wait()
    Root.AssemblyLinearVelocity = oldVel
end)

-- 5. CAMERA LOCK (STOPS MAC SHAKE)
RS.RenderStepped:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local Hum = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if desyncActive and Root and Hum then
        -- This overrides the Mac's attempt to shake the camera
        Camera.CameraSubject = Hum
        Camera.Focus = Root.CFrame
    end
end)
