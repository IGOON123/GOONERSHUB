--[[
    SAB / XEN - MAC PRO V19 (STABLE)
    Simplified logic to prevent Shaking and Voiding.
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- 1. GUI SETUP
local ScreenGui = Instance.new("ScreenGui", CoreGui or LP:WaitForChild("PlayerGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 100)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 40)
Status.Text = "SAB DESYNC: OFF"
Status.TextColor3 = Color3.fromRGB(255, 50, 50)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.GothamBold

-- 2. THE BUTTON
local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0, 160, 0, 40)
Btn.Position = UDim2.new(0.5, -80, 0, 45)
Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Btn.Text = "ENABLE"
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.Gotham
Instance.new("UICorner", Btn)

local desyncActive = false
Btn.MouseButton1Down:Connect(function()
    desyncActive = not desyncActive
    if desyncActive then
        Btn.Text = "IT'S WORKING"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        Status.Text = "SAB DESYNC: ON"
        Status.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        Btn.Text = "ENABLE"
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Status.Text = "SAB DESYNC: OFF"
        Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- 3. THE STABLE DESYNC LOGIC
RS.Heartbeat:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Root or not desyncActive then return end

    local oldCF = Root.CFrame
    -- 3 Stud Jitter (Small = No Shake / No Void)
    local jitter = CFrame.new(math.random(-3, 3), 0, math.random(-3, 3))
    
    Root.CFrame = oldCF * jitter
    RS.RenderStepped:Wait()
    Root.CFrame = oldCF
end)
