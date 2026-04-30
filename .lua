local __HAZE_WATERMARK = "HAZE_WM_daf3ce73bf93696fbb5e"
    -- ================= KICK =================
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

if not game:IsLoaded() then game.Loaded:Wait() end
pcall(function() game:GetService("Players").RespawnTime = 0 end)
local privateBuild = false


-- ============================================================
-- ESTADO GENERAL DEL SCRIPT
-- ============================================================
local SharedState = {
    SelectedPetData = nil,
    AllAnimalsCache = nil,
    DisableStealSpeed = nil,
    ListNeedsRedraw = true,
    AdminButtonCache = {},
    StealSpeedToggleFunc = nil,
    _ssUpdateBtn = nil,
    AdminProxBtn = nil,
    BalloonedPlayers = {},
    MobileScaleObjects = {},
    RefreshMobileScale = nil,
    MobileActionButtons = {},
    RefreshMobileActionButtons = nil,
}

do
-- SOURCE: :contentReference[oaicite:0]{index=0}
-- ITSB HUB v5 - TRUE INSTANT STEAL (BRAINROT DETECTOR + BOX FILTER)
-- MOD: SOLO ROBA PROMPTS QUE ESTÉN EN EL MISMO CUADRO (BOX) QUE EL JUGADOR
-- VERSION SIN UI

local CONFIG = {
    AUTO_STEAL = false,
    RADIUS = 12
}

local boxes = {
    {min = Vector3.new(-337.448303, -3.898971, -122.397758), max = Vector3.new(-328.004578, -3.898971, 242.625626)},
    {min = Vector3.new(-327.257660, -3.899109, -122.228622), max = Vector3.new(-320.600891, -3.899109, 242.612259)},
    {min = Vector3.new(-319.783386, -3.898970, -122.227089), max = Vector3.new(-312.908325, -3.898970, 242.585617)},
    {min = Vector3.new(-312.445648, -3.899108, -122.389832), max = Vector3.new(-305.489899, -3.899108, 242.456818)},
    {min = Vector3.new(-305.037048, -3.898970, -122.230743), max = Vector3.new(-293.957489, -3.898970, 242.606873)},
    {min = Vector3.new(-491.448608, -3.898972, -122.253258), max = Vector3.new(-481.811737, -3.898972, 242.615005)},
    {min = Vector3.new(-498.971069, -3.898970, -122.382767), max = Vector3.new(-491.748840, -3.898970, 242.612061)},
    {min = Vector3.new(-506.436737, -3.898972, -122.411476), max = Vector3.new(-499.318542, -3.898972, 242.615982)},
    {min = Vector3.new(-513.783569, -3.898972, -122.223297), max = Vector3.new(-506.801849, -3.898972, 242.627090)},
    {min = Vector3.new(-525.236938, -3.898972, -122.409813), max = Vector3.new(-514.265015, -3.898972, 242.608932)},
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local trackedPrompts = {}
local lastFire = {}

local SAFE_POLL_RATE = 0.10
local SAFE_POLL_OVERRIDE_UNTIL = 0

function _G.getSafePollRate()
    if os.clock() < SAFE_POLL_OVERRIDE_UNTIL then
        return 0.27
    end
    return SAFE_POLL_RATE
end

function _G.triggerSafePollBoost()
    SAFE_POLL_OVERRIDE_UNTIL = os.clock() + 3
end

local FIRE_DEBOUNCE = 0.12
local FIRE_BURST = 3

local ENABLE_BURST = 25
local ENABLE_DEBOUNCE = 0.00
local ENABLE_COOLDOWN = 0.08

local lastEnableFire = {}

------------------------------------------------
-- CHARACTER
------------------------------------------------
local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

------------------------------------------------
-- BOX DETECTION
------------------------------------------------
local function getBoxIndex(pos)
    for i,b in ipairs(boxes) do
        if pos.X >= math.min(b.min.X,b.max.X) and pos.X <= math.max(b.min.X,b.max.X)
        and pos.Z >= math.min(b.min.Z,b.max.Z) and pos.Z <= math.max(b.min.Z,b.max.Z) then
            return i
        end
    end
end

------------------------------------------------
-- SAFE POSITION GET
------------------------------------------------
local function getPromptPosition(prompt)
    local p = prompt.Parent
    if not p then return end

    if p:IsA("Attachment") and p.Parent then
        p = p.Parent
    end

    if p:IsA("BasePart") then
        return p.Position
    elseif p:IsA("Model") then
        return p:GetPivot().Position
    end
end

------------------------------------------------
-- AVAILABLE CHECK
------------------------------------------------
local function promptMatchesSelectedPet(prompt)
    if not SharedState then return false end

    local selected = SharedState.SelectedPetData
    if not selected then return false end

    local model = prompt:FindFirstAncestorOfClass("Model")
    if not model then return false end

    if selected.slot then
        local slotAncestor = prompt:FindFirstAncestor(selected.slot)
        if slotAncestor then
            return true
        end

        if model.Name == selected.slot then
            return true
        end

        if model.Parent and model.Parent.Name == selected.slot then
            return true
        end
    end

    if selected.name then
        local wantedName = string.lower(selected.name)
        local current = model

        while current do
            if current.Name and string.lower(current.Name) == wantedName then
                return true
            end
            current = current.Parent
        end
    end

    return false
end

local function isPromptAvailable(prompt, hrpPos)
    if not prompt or not prompt.Parent then return false end
    if not prompt.Enabled then return false end

    local pos = getPromptPosition(prompt)
    if not pos then return false end

-- NO ROBAR PROMPTS DE MI PROPIO PLOT
local plot = prompt:FindFirstAncestorOfClass("Model")
if plot then
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        local parentPlot = prompt:FindFirstAncestorWhichIsA("Model")
        while parentPlot and parentPlot.Parent ~= plots do
            parentPlot = parentPlot.Parent
        end

        if parentPlot then
            local sign = parentPlot:FindFirstChild("PlotSign")
            if sign then
                local gui = sign:FindFirstChildWhichIsA("SurfaceGui", true)
                local label = gui and gui:FindFirstChildWhichIsA("TextLabel", true)

                if label then
                    local txt = label.Text:lower()
                    if txt:find(game.Players.LocalPlayer.Name:lower(), 1, true)
                    or txt:find(game.Players.LocalPlayer.DisplayName:lower(), 1, true) then
                        return false
                    end
                end
            end
        end
    end
end

-- SOLO NEAREST RESPETA BOXES
if _G.NEAREST_INSTANT_MODE == true then
    local playerBox = getBoxIndex(hrpPos)
    local promptBox = getBoxIndex(pos)

    if not playerBox or playerBox ~= promptBox then
        return false
    end
end

-- SI ESTA EN NEAREST + INSTANT STEAL NO USAR TABLA
if not (_G.NEAREST_INSTANT_MODE == true) then
    if not promptMatchesSelectedPet(prompt) then
        return false
    end
end

    local maxDist = (typeof(prompt.MaxActivationDistance) == "number" and prompt.MaxActivationDistance > 0)
        and prompt.MaxActivationDistance
        or CONFIG.RADIUS

    local effective = math.min(CONFIG.RADIUS, maxDist)

    return (pos - hrpPos).Magnitude <= effective
end

------------------------------------------------
-- FIRE
------------------------------------------------
local function canFire(prompt, debounce)
    local t = os.clock()
    local last = lastFire[prompt]
    if last and (t - last) < debounce then
        return false
    end
    lastFire[prompt] = t
    return true
end

local function firePrompt(prompt, burst, debounce)
    if not prompt or not prompt.Parent then return end
    if not prompt.Enabled then return end
    if not canFire(prompt, debounce) then return end

    for i = 1, burst do
        pcall(function()
            fireproximityprompt(prompt, 0)
        end)
    end
end

------------------------------------------------
-- PROMPT TRACK
------------------------------------------------
local function trackPrompt(prompt)
    if trackedPrompts[prompt] then return end
    trackedPrompts[prompt] = true

    local function tryInstantEnableFire()
        local hrp = getHRP()
        if not hrp then return end
        local myPos = hrp.Position

        if isPromptAvailable(prompt, myPos) then
            CONFIG.AUTO_STEAL = true

            local now = os.clock()
            local le = lastEnableFire[prompt]

            if not le or (now - le) >= ENABLE_COOLDOWN then
                lastEnableFire[prompt] = now
                firePrompt(prompt, ENABLE_BURST, ENABLE_DEBOUNCE)
            end
        end
    end

    task.defer(function()
        tryInstantEnableFire()
    end)

    pcall(function()
        prompt:GetPropertyChangedSignal("Enabled"):Connect(function()
            if prompt.Enabled then
                tryInstantEnableFire()
            end
        end)
    end)

    prompt.AncestryChanged:Connect(function()
        if not prompt:IsDescendantOf(workspace) then
            trackedPrompts[prompt] = nil
            lastFire[prompt] = nil
            lastEnableFire[prompt] = nil
        end
    end)
end

------------------------------------------------
-- SCAN
------------------------------------------------
local function scanBrainrotPrompts()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    for _, plot in ipairs(plots:GetChildren()) do
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            for _, obj in ipairs(podiums:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    trackPrompt(obj)
                end
            end
        end
    end
end

scanBrainrotPrompts()

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") and obj:FindFirstAncestor("AnimalPodiums") then
        trackPrompt(obj)
    end
end)

------------------------------------------------
-- BACKUP LOOP
------------------------------------------------
task.spawn(function()
    while task.wait(_G.getSafePollRate()) do

        local hrp = getHRP()

        if not hrp then
            CONFIG.AUTO_STEAL = false
            continue
        end

        local myPos = hrp.Position
        local anyAvailable = false

        for prompt in pairs(trackedPrompts) do
            if isPromptAvailable(prompt, myPos) then
                anyAvailable = true

                if CONFIG.AUTO_STEAL then
                    firePrompt(prompt, FIRE_BURST, FIRE_DEBOUNCE)
                end
            end
        end

        CONFIG.AUTO_STEAL = anyAvailable
    end
end)

end

-- ============================================================
-- SYNC
-- ============================================================
do

    local Sync = require(game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Synchronizer"))
    local patched = 0

    for name, fn in pairs(Sync) do
        if typeof(fn) ~= "function" then continue end
        if isexecutorclosure(fn) then continue end

        local ok, ups = pcall(debug.getupvalues, fn)
        if not ok then continue end

        for idx, val in pairs(ups) do
            if typeof(val) == "function" and not isexecutorclosure(val) then
                local ok2, innerUps = pcall(debug.getupvalues, val)
                if ok2 then
                    local hasBoolean = false
                    for _, v in pairs(innerUps) do
                        if typeof(v) == "boolean" then
                            has
