local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")

if CoreGui:FindFirstChild("NexusHub_V2") then
    CoreGui.NexusHub_V2:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusHub_V2"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.Position = UDim2.new(0.5, -85, 0.5, -95)
MainFrame.Size = UDim2.new(0, 170, 0, 190)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(50, 50, 60)
Stroke.Thickness = 1.5

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundTransparency = 1
TopBar.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(0, 85, 1, -10)
Title.Font = Enum.Font.FredokaOne
Title.Text = "Nexus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = TopBar
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 95, 0, 5)
Subtitle.Size = UDim2.new(0, 70, 1, -10)
Subtitle.Font = Enum.Font.FredokaOne
Subtitle.Text = "v2.0.8 By nhat0258"
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
Subtitle.TextSize = 8
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 30)
StatusLabel.Size = UDim2.new(1, -20, 0, 12)
StatusLabel.Font = Enum.Font.FredokaOne
StatusLabel.Text = "IDLE"
StatusLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
StatusLabel.TextSize = 9
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center

local ProgBg = Instance.new("Frame")
ProgBg.Parent = MainFrame
ProgBg.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
ProgBg.Position = UDim2.new(0, 10, 0, 44)
ProgBg.Size = UDim2.new(1, -20, 0, 6)
Instance.new("UICorner", ProgBg).CornerRadius = UDim.new(0, 8)

local ProgFill = Instance.new("Frame")
ProgFill.Parent = ProgBg
ProgFill.BackgroundColor3 = Color3.fromRGB(0, 255, 130)
ProgFill.Size = UDim2.new(0, 0, 1, 0)
Instance.new("UICorner", ProgFill).CornerRadius = UDim.new(0, 8)

local function btn(txt, pos, clr)
    local t = Instance.new("TextButton")
    t.Parent = MainFrame
    t.BackgroundColor3 = clr
    t.Position = pos
    t.Size = UDim2.new(1, -20, 0, 30)
    t.Font = Enum.Font.FredokaOne
    t.Text = txt
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextSize = 9
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    return t
end

local ToggleBtn = btn("START", UDim2.new(0, 10, 0, 56), Color3.fromRGB(0, 115, 230))
local AutoExecBtn = btn("AUTO EXEC: OFF", UDim2.new(0, 10, 0, 94), Color3.fromRGB(28, 28, 33))

local dragging, dStart, sPos = false, nil, nil

TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dStart = i.Position
        sPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dStart
        MainFrame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if dragging then
            dragging = false
            saveConfig()
        end
    end
end)

local isPaused, isFinished, autoExecActive = false, false, false
local hasStarted = false
local currentStatusBase = "IDLE"
local CONFIG_FILE = "NexusDeadRailsBond.json"

function saveConfig()
    local config = {
        position = {
            X = {MainFrame.Position.X.Scale, MainFrame.Position.X.Offset},
            Y = {MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset}
        },
        autoExecActive = autoExecActive,
        hasStarted = hasStarted
    }
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(config))
    end)
end

function loadConfig()
    if isfile(CONFIG_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success and data then
            if data.position then
                MainFrame.Position = UDim2.new(data.position.X[1], data.position.X[2], data.position.Y[1], data.position.Y[2])
            end
            if data.autoExecActive ~= nil then
                setAutoExec(data.autoExecActive)
            end
            if data.hasStarted == true then
                startFarming()
            end
        end
    end
end

local remoteAction = ReplicatedStorage.Shared.Universe.Network.RemoteEvent.Actionable
local remoteStore = ReplicatedStorage.Shared.Universe.Network.RemoteEvent.Store
local remoteParty = ReplicatedStorage.Shared.Universe.Network.RemoteEvent.CreateParty

local function startFarming()
    if isFinished then return end
    isPaused = false
    hasStarted = true
    ToggleBtn.Text = "PAUSE"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    currentStatusBase = "Bond Collecting"
    saveConfig()
end

local function pauseFarming()
    isPaused = true
    ToggleBtn.Text = "CONTINUE"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 115, 230)
    currentStatusBase = "Temporarily Suspended"
    saveConfig()
end

ToggleBtn.MouseButton1Click:Connect(function()
    if isFinished then return end
    if not hasStarted then
        startFarming()
    else
        if isPaused then
            startFarming()
        else
            pauseFarming()
        end
    end
end)

local FARM_V1_START = 1
local FARM_V2_START = 4000
local FARM_V1_END = 2000

task.spawn(function()
    local overallStep = 0
    while true do
        local v1, v2, loop = FARM_V1_START, FARM_V2_START, 1
        overallStep = 0
        while not hasStarted do task.wait(0.1) end
        while hasStarted do
            if not isPaused and not isFinished then
                pcall(function()
                    remoteAction:FireServer(v1)
                    remoteAction:FireServer(v2)
                end)
                overallStep = overallStep + 1
                local progress = overallStep / (3 * 2000)
                ProgFill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
                v1 = v1 + 1
                v2 = v2 - 1
                if v1 > FARM_V1_END then
                    loop = loop + 1
                    v1 = FARM_V1_START
                    v2 = FARM_V2_START
                    if loop > 3 then
                        isFinished = true
                        currentStatusBase = "Play Again"
                        pcall(function() lp.Character.Humanoid.Health = 0 end)
                        task.wait(11)
                        repeat
                            pcall(function() ReplicatedStorage.Remotes.EndDecision:FireServer(false) end)
                            task.wait(1)
                        until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
                        isFinished = false
                        hasStarted = false
                        isPaused = false
                        ToggleBtn.Text = "START"
                        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 115, 230)
                        currentStatusBase = "IDLE"
                        ProgFill.Size = UDim2.new(0, 0, 1, 0)
                        saveConfig()
                        startFarming()
                    end
                end
            end
            task.wait(0.02)
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    local dotCount = 0
    while true do
        dotCount = dotCount % 3 + 1
        local dots = string.rep(".", dotCount)
        StatusLabel.Text = currentStatusBase .. dots
        task.wait(0.5)
    end
end)

local autoExecFile = "NexusAutoExec_v2.txt"

function setAutoExec(state)
    if state then
        autoExecActive = true
        AutoExecBtn.Text = "AUTO EXEC: ON"
        AutoExecBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
        pcall(function() writefile(autoExecFile, "1") end)
        task.spawn(function()
            while autoExecActive do
                for i = 0, 4 do
                    local n = i == 0 and "PartyZone" or "PartyZone" .. i
                    local partyZones = workspace:FindFirstChild("PartyZones")
                    if partyZones then
                        local z = partyZones:FindFirstChild(n)
                        if z and z:FindFirstChild("Hitbox") then
                            pcall(function()
                                firetouchinterest(lp.Character.HumanoidRootPart, z.Hitbox, 0)
                                firetouchinterest(lp.Character.HumanoidRootPart, z.Hitbox, 1)
                            end)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
        task.spawn(function()
            while autoExecActive do
                pcall(function()
                    remoteParty:FireServer({
                        ["isPrivate"] = false,
                        ["trainId"] = "default",
                        ["maxMembers"] = 1,
                        ["gameMode"] = "Nightmare"
                    })
                end)
                task.wait(1)
            end
        end)
    else
        autoExecActive = false
        AutoExecBtn.Text = "AUTO EXEC: OFF"
        AutoExecBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
        pcall(function() delfile(autoExecFile) end)
    end
    saveConfig()
end

AutoExecBtn.MouseButton1Click:Connect(function()
    setAutoExec(not autoExecActive)
end)

if isfile(autoExecFile) then
    setAutoExec(true)
end

RunService.Heartbeat:Connect(function()
    pcall(function()
        pGui.BondGui.BondInfo.Position = UDim2.new(0.01, 0, 0.593, 0)
    end)
end)

local WindowName = "NexusHub_V2"
local function CreateLogo()
    if CoreGui:FindFirstChild("NexusLogoGui") then
        CoreGui:FindFirstChild("NexusLogoGui"):Destroy()
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusLogoGui"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 10000

    local LogoButton = Instance.new("ImageButton")
    LogoButton.Name = "Logo"
    LogoButton.Parent = ScreenGui
    LogoButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogoButton.BackgroundTransparency = 0.5
    LogoButton.Position = UDim2.new(0.1, 0, 0.1, 0)
    LogoButton.Size = UDim2.new(0, 50, 0, 50)
    LogoButton.Active = true
    LogoButton.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = LogoButton

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = LogoButton
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5

    task.spawn(function()
        local ok, imgAsset = pcall(function()
            local fileName = "NexusLogo_ATx.png"
            local url = "https://raw.githubusercontent.com/nguyennhlat2004/Roblox-Api/main/ATx.png"
            if not isfile(fileName) then
                writefile(fileName, game:HttpGet(url))
            end
            return getcustomasset(fileName)
        end)
        if ok and imgAsset then
            LogoButton.Image = imgAsset
        else
            LogoButton.Image = "rbxassetid://13347535978"
        end
    end)

    LogoButton.MouseButton1Click:Connect(function()
        local gui = CoreGui:FindFirstChild(WindowName)
        if gui and gui:IsA("ScreenGui") then
            gui.Enabled = not gui.Enabled
        end
    end)
end

CreateLogo()
loadConfig()
