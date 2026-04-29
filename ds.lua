--[[
    SAB / XEN - MAC SERVER POS EDITION
    Includes GUI + Server-Side Position ESP
]]

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- 1. GUI SETUP
local ScreenGui = Instance.new("ScreenGui", CoreGui or LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "SAB_ServerPos"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 150)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SAB MAC V6"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- 2. SERVER POS ESP (Visualizer)
local ServerDot = Instance.new("Part")
ServerDot.Shape = Enum.PartType.Ball
ServerDot.Size = Vector3.new(2, 2, 2)
ServerDot.Color = Color3.fromRGB(255, 0, 0) -- Red = Server Pos
ServerDot.Material = Enum.Material.ForceField
ServerDot.CanCollide = false
ServerDot.Anchored = true
ServerDot.Parent = workspace

local function createToggle(name, yPos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 180, 0, 35)
    Btn.Position = UDim2.new(0.5, -90, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", Btn)

    local state = false
    Btn.MouseButton1Down:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 30, 30)
        callback(state)
    end)
end

-- 3. TOGGLES
local desyncActive = false
local espActive = false

createToggle("Server Pos Desync", 45, function(v) desyncActive = v end)
createToggle("Server Pos ESP", 90, function(v) espActive = v end)

-- 4. LOGIC
RS.Heartbeat:Connect(function()
    local Root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    if desyncActive then
        local oldCF = Root.CFrame
        -- Jitter the server position
        Root.CFrame = oldCF * CFrame.new(math.random(-15, 15), 0, math.random(-15, 15))
        
        -- Update ESP Part to show where the Server thinks you are
        if espActive then
            ServerDot.Transparency = 0
            ServerDot.CFrame = Root.CFrame
        else
            ServerDot.Transparency = 1
        end

        RS.RenderStepped:Wait()
        Root.CFrame = oldCF
    else
        ServerDot.Transparency = 1
    end
end)
