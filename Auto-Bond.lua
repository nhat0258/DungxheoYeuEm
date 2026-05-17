if game:GetService("CoreGui"):FindFirstChild("NexusHub") then return end

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local PlaceId = game.PlaceId

local lp = Players.LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")

local isPaused = false
local isFinished = false
local autoToggleActive = false
local hasStarted = false
local configLoaded = false
local currentStatusBase = "Idle"
local healPickupCooldown = false

local FOLDER_NAME = "Nexus Hub Dead Rails"
local CONFIG_PATH = FOLDER_NAME .. "/NexusHubConfig.json"
local WindowName = "NexusHub"

local NotifyFrame, NStatus, NProgFill
local elapsedSeconds = 0

local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if queue_on_teleport then
    local teleportScript = [[
        repeat task.wait() until game:IsLoaded()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nhat0258/DungxheoYeuEm/refs/heads/main/Auto-Bond.lua"))()
        end)
    ]]
    queue_on_teleport(teleportScript)
    lp.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started then
            queue_on_teleport(teleportScript)
        end
    end)
end

local function createFolder()
    if not isfolder(FOLDER_NAME) then
        makefolder(FOLDER_NAME)
    end
end
createFolder()

local remoteAction = ReplicatedStorage.Shared.Universe.Network.RemoteEvent.Actionable
local remoteParty = ReplicatedStorage.Shared.Universe.Network.RemoteEvent.CreateParty
local remotePickup = ReplicatedStorage.Shared.Universe.Network.RemoteEvent.Pickup

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = WindowName
ScreenGui.Parent = CoreGui

local MainFrameHeight = 135
local isLobby = (PlaceId == 116495829188952)
if isLobby then
    MainFrameHeight = 130
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.Position = UDim2.new(0.5, -85, 0.5, -MainFrameHeight/2)
MainFrame.Size = UDim2.new(0, 170, 0, MainFrameHeight)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1
Stroke.Transparency = 0.5

local TopBar = Instance.new("Frame")
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

local StatusLabel
local ProgBg, ProgFill
local ToggleBtn
local LobbyStatus, LobbyProgBg, LobbyProgFill

if isLobby then
    LobbyStatus = Instance.new("TextLabel")
    LobbyStatus.Parent = MainFrame
    LobbyStatus.BackgroundTransparency = 1
    LobbyStatus.Position = UDim2.new(0, 10, 0, 32)
    LobbyStatus.Size = UDim2.new(1, -20, 0, 12)
    LobbyStatus.Font = Enum.Font.FredokaOne
    LobbyStatus.Text = "Idle"
    LobbyStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
    LobbyStatus.TextSize = 9
    LobbyStatus.TextXAlignment = Enum.TextXAlignment.Center

    LobbyProgBg = Instance.new("Frame")
    LobbyProgBg.Parent = MainFrame
    LobbyProgBg.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    LobbyProgBg.Position = UDim2.new(0, 10, 0, 46)
    LobbyProgBg.Size = UDim2.new(1, -20, 0, 6)
    Instance.new("UICorner", LobbyProgBg).CornerRadius = UDim.new(0, 8)

    LobbyProgFill = Instance.new("Frame")
    LobbyProgFill.Name = "LobbyFill"
    LobbyProgFill.Parent = LobbyProgBg
    LobbyProgFill.BackgroundColor3 = Color3.fromRGB(0, 255, 130)
    LobbyProgFill.Size = UDim2.new(0, 0, 1, 0)
    LobbyProgFill.ClipsDescendants = true
    Instance.new("UICorner", LobbyProgFill).CornerRadius = UDim.new(0, 8)

    local shinyLobby = Instance.new("ImageLabel")
    shinyLobby.Name = "Shiny"
    shinyLobby.Parent = LobbyProgFill
    shinyLobby.BackgroundTransparency = 1
    shinyLobby.Size = UDim2.new(0, 50, 2, 0)
    shinyLobby.Position = UDim2.new(0, -50, -0.5, 0)
    shinyLobby.Image = "rbxassetid://6031283521"
    shinyLobby.ImageTransparency = 0.7
    shinyLobby.ScaleType = Enum.ScaleType.Stretch
    shinyLobby.Rotation = 30
    shinyLobby.Visible = false
else
    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 10, 0, 30)
    StatusLabel.Size = UDim2.new(1, -20, 0, 12)
    StatusLabel.Font = Enum.Font.FredokaOne
    StatusLabel.Text = "00m:00s | Idle"
    StatusLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    StatusLabel.TextSize = 9
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center

    ProgBg = Instance.new("Frame")
    ProgBg.Parent = MainFrame
    ProgBg.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    ProgBg.Position = UDim2.new(0, 10, 0, 44)
    ProgBg.Size = UDim2.new(1, -20, 0, 6)
    Instance.new("UICorner", ProgBg).CornerRadius = UDim.new(0, 8)

    ProgFill = Instance.new("Frame")
    ProgFill.Name = "ProgFill"
    ProgFill.Parent = ProgBg
    ProgFill.BackgroundColor3 = Color3.fromRGB(0, 255, 130)
    ProgFill.Size = UDim2.new(0, 0, 1, 0)
    ProgFill.ClipsDescendants = true
    Instance.new("UICorner", ProgFill).CornerRadius = UDim.new(0, 8)

    local shinyGame = Instance.new("ImageLabel")
    shinyGame.Name = "Shiny"
    shinyGame.Parent = ProgFill
    shinyGame.BackgroundTransparency = 1
    shinyGame.Size = UDim2.new(0, 50, 2, 0)
    shinyGame.Position = UDim2.new(0, -50, -0.5, 0)
    shinyGame.Image = "rbxassetid://6031283521"
    shinyGame.ImageTransparency = 0.7
    shinyGame.ScaleType = Enum.ScaleType.Stretch
    shinyGame.Rotation = 30
    shinyGame.Visible = false

    ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = MainFrame
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 115, 230)
    ToggleBtn.Position = UDim2.new(0, 10, 0, 56)
    ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
    ToggleBtn.Font = Enum.Font.FredokaOne
    ToggleBtn.Text = "Start Farm Bond"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 9
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)
end

local autoBtnText = "Auto Play Again: Off"
local autoBtnAction = "replay"
if isLobby then
    autoBtnText = "Auto Start Game: Off"
    autoBtnAction = "startgame"
elseif PlaceId == 70876832253163 then
    autoBtnText = "Auto Play Again: Off"
    autoBtnAction = "replay"
end

local AutoBtn = Instance.new("TextButton")
AutoBtn.Parent = MainFrame
AutoBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
AutoBtn.Position = isLobby and UDim2.new(0, 10, 0, 60) or UDim2.new(0, 10, 0, 94)
AutoBtn.Size = UDim2.new(1, -20, 0, 30)
AutoBtn.Font = Enum.Font.FredokaOne
AutoBtn.Text = autoBtnText
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.TextSize = 9
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 6)

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
        if dragging then dragging = false end
    end
end)

local function startFarming()
    if isFinished or isLobby then return end
    isPaused = false
    if ToggleBtn then
        ToggleBtn.Text = "Pause Farm"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
    currentStatusBase = "Bond Collecting"
    task.spawn(function()
        while not (lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0) do
            task.wait(0.2)
        end
        hasStarted = true
    end)
end

local function pauseFarming()
    isPaused = true
    if ToggleBtn then
        ToggleBtn.Text = "Continue Farm"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 115, 230)
    end
    currentStatusBase = "Temporarily Suspended"
end

local function saveConfig()
    pcall(function()
        local config = {
            position = {
                X = {MainFrame.Position.X.Scale, MainFrame.Position.X.Offset},
                Y = {MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset}
            },
            autoToggleActive = autoToggleActive,
            hasStarted = hasStarted,
            isPaused = isPaused,
            guiEnabled = ScreenGui.Enabled
        }
        writefile(CONFIG_PATH, HttpService:JSONEncode(config))
    end)
end

local function loadConfig()
    if isfile(CONFIG_PATH) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_PATH))
        end)
        if success and data then
            if data.position then
                MainFrame.Position = UDim2.new(data.position.X[1], data.position.X[2], data.position.Y[1], data.position.Y[2])
            end
            if data.autoToggleActive ~= nil then
                setAutoToggle(data.autoToggleActive)
            end
            if data.hasStarted == true and not isLobby then
                if data.isPaused == true then
                    isPaused = true
                    hasStarted = true
                    if ToggleBtn then
                        ToggleBtn.Text = "Continue Farm"
                        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 115, 230)
                    end
                    currentStatusBase = "Temporarily Suspended"
                else
                    startFarming()
                end
            end
            if data.guiEnabled ~= nil then
                ScreenGui.Enabled = data.guiEnabled
                if NotifyFrame then
                    NotifyFrame.Visible = not data.guiEnabled
                end
            end
        end
    end
    configLoaded = true
end

if ToggleBtn then
    ToggleBtn.MouseButton1Click:Connect(function()
        if isFinished or isLobby then return end
        if not hasStarted then
            startFarming()
        else
            if isPaused then
                startFarming()
            else
                pauseFarming()
            end
        end
        saveConfig()
    end)
end

local FARM_V1_START = 800
local FARM_V2_START = 4000
local FARM_V1_END = 2000

local function resetAfterFinish()
    isFinished = false
    isPaused = false
    elapsedSeconds = 0
    currentStatusBase = "Idle"
    if ToggleBtn then
        ToggleBtn.Text = "Start Farm Bond"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 115, 230)
    end
    if ProgFill then ProgFill.Size = UDim2.new(0, 0, 1, 0) end
    if NProgFill then NProgFill.Size = UDim2.new(0, 0, 1, 0) end
    if autoToggleActive and not isLobby then
        startFarming()
    else
        saveConfig()
    end
end

local function handlePlayAgain()
    if isLobby then return end
    isFinished = true
    hasStarted = false
    isPaused = false
    currentStatusBase = "Play Again"
    if ToggleBtn then
        ToggleBtn.Text = "Start Farm Bond"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 115, 230)
    end
    if ProgFill then ProgFill.Size = UDim2.new(0, 0, 1, 0) end
    if NProgFill then NProgFill.Size = UDim2.new(0, 0, 1, 0) end

    task.wait(11)
    if PlaceId == 70876832253163 then
        repeat
            pcall(function() ReplicatedStorage.Remotes.EndDecision:FireServer(false) end)
            task.wait(1)
        until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
    end
    resetAfterFinish()
end

task.spawn(function()
    while true do
        if hasStarted and not isPaused and not isFinished and not isLobby then
            elapsedSeconds = elapsedSeconds + 1
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local overallStep = 0
    while true do
        local v1, v2 = FARM_V1_START, FARM_V2_START
        local loopNum = 1
        overallStep = 0
        while not hasStarted do task.wait(0.1) end
        while hasStarted do
            if not isPaused and not isFinished and not isLobby then
                if not healPickupCooldown then
                    pcall(function()
                        remoteAction:FireServer(v1)
                        remoteAction:FireServer(v2)
                    end)
                    overallStep = overallStep + 1
                    local progress = overallStep / (3 * (FARM_V1_END - FARM_V1_START + 1))
                    if ProgFill then
                        ProgFill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
                    end
                    if NProgFill then
                        NProgFill.Size = ProgFill and ProgFill.Size or UDim2.new(0, 0, 1, 0)
                    end
                    v1 = v1 + 1
                    v2 = v2 - 1
                    if v1 > FARM_V1_END then
                        loopNum = loopNum + 1
                        v1 = FARM_V1_START
                        v2 = FARM_V2_START
                        if loopNum > 3 then
                            handlePlayAgain()
                        end
                    end
                end
            end
            task.wait(0.03)
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    local dotCount = 0
    while true do
        dotCount = dotCount % 3 + 1
        local dots = string.rep(".", dotCount)
        local minutes = math.floor(elapsedSeconds / 60)
        local seconds = elapsedSeconds % 60
        local timeStr = string.format("%02dm:%02ds", minutes, seconds)
        local totalTxt = timeStr .. " | " .. currentStatusBase .. dots
        if StatusLabel then
            StatusLabel.Text = totalTxt
        end
        if isLobby and autoToggleActive then
            local lobbyState = "Idle"
            if LobbyProgFill then
                if LobbyProgFill.Size.X.Scale < 0.34 then
                    lobbyState = "Creating a Party" .. dots
                elseif LobbyProgFill.Size.X.Scale < 0.67 then
                    lobbyState = "Creating a Party" .. dots
                else
                    lobbyState = "Waiting To Join The Game" .. dots
                end
            end
            if LobbyStatus then LobbyStatus.Text = lobbyState end
            if NStatus then NStatus.Text = lobbyState end
            if NProgFill and LobbyProgFill then
                NProgFill.Size = LobbyProgFill.Size
            end
        else
            if NStatus then NStatus.Text = totalTxt end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        if hasStarted and not isFinished and not isLobby then
            local character = lp.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            if not character or not humanoid or humanoid.Health <= 0 then
                handlePlayAgain()
            end
        end
        task.wait(0.5)
    end
end)

function setAutoToggle(state)
    autoToggleActive = state
    if autoBtnAction == "startgame" then
        if state then
            AutoBtn.Text = "Auto Start Game: On"
            AutoBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
            task.spawn(function()
                while autoToggleActive and isLobby do
                    local lobbyFill = LobbyProgFill
                    if lobbyFill then
                        lobbyFill.Size = UDim2.new(0, 0, 1, 0)
                    end
                    for step = 1, 4 do
                        if not autoToggleActive then break end
                        local zones = Workspace:FindFirstChild("PartyZones")
                        if zones then
                            for i = 0, 4 do
                                local n = i == 0 and "PartyZone" or "PartyZone" .. i
                                local z = zones:FindFirstChild(n)
                                if z and z:FindFirstChild("Hitbox") then
                                    pcall(function()
                                        firetouchinterest(lp.Character.HumanoidRootPart, z.Hitbox, 0)
                                        firetouchinterest(lp.Character.HumanoidRootPart, z.Hitbox, 1)
                                    end)
                                end
                            end
                        end
                        if lobbyFill then
                            lobbyFill.Size = UDim2.new((step / 4) * 0.33, 0, 1, 0)
                        end
                        task.wait(0.3)
                    end
                    if not autoToggleActive then break end
                    if lobbyFill then
                        local startF = lobbyFill.Size.X.Scale
                        for t = 0, 0.5, 0.02 do
                            lobbyFill.Size = UDim2.new(startF + (0.33 * (t / 0.5)), 0, 1, 0)
                            task.wait(0.02)
                        end
                    end
                    pcall(function()
                        remoteParty:FireServer({
                            ["isPrivate"] = false,
                            ["trainId"] = "default",
                            ["maxMembers"] = 1,
                            ["gameMode"] = "Nightmare"
                        })
                    end)
                    if not autoToggleActive then break end
                    if lobbyFill then
                        local startF2 = lobbyFill.Size.X.Scale
                        for t = 0.1, 9, 0.1 do
                            lobbyFill.Size = UDim2.new(startF2 + (0.34 * (t / 9)), 0, 1, 0)
                            task.wait(0.1)
                        end
                        lobbyFill.Size = UDim2.new(1, 0, 1, 0)
                    end
                    task.wait(0.5)
                end
                if LobbyStatus and LobbyProgFill then
                    LobbyStatus.Text = "Idle"
                    LobbyProgFill.Size = UDim2.new(0, 0, 1, 0)
                end
            end)
        else
            AutoBtn.Text = "Auto Start Game: Off"
            AutoBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
            if LobbyProgFill then LobbyProgFill.Size = UDim2.new(0, 0, 1, 0) end
        end
    elseif autoBtnAction == "replay" then
        if state then
            AutoBtn.Text = "Auto Play Again: On"
            AutoBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
        else
            AutoBtn.Text = "Auto Play Again: Off"
            AutoBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
        end
    end
    saveConfig()
end

AutoBtn.MouseButton1Click:Connect(function()
    setAutoToggle(not autoToggleActive)
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        if pGui:FindFirstChild("BondGui") and pGui.BondGui:FindFirstChild("BondInfo") then
            pGui.BondGui.BondInfo.Position = UDim2.new(0.01, 0, 0.593, 0)
        end
    end)
    if ProgFill then
        local shiny = ProgFill:FindFirstChild("Shiny")
        if shiny then
            if ProgFill.Size.X.Scale > 0.01 then
                shiny.Visible = true
                local w = ProgFill.AbsolutePosition.X + ProgFill.AbsoluteSize.X
                local t = tick() * 1.5
                local x = (math.sin(t) + 1) / 2 * (w - ProgFill.AbsolutePosition.X)
                shiny.Position = UDim2.new(0, x - 25, -0.5, 0)
            else
                shiny.Visible = false
            end
        end
    end
    if LobbyProgFill then
        local shiny = LobbyProgFill:FindFirstChild("Shiny")
        if shiny then
            if LobbyProgFill.Size.X.Scale > 0.01 then
                shiny.Visible = true
                local w = LobbyProgFill.AbsolutePosition.X + LobbyProgFill.AbsoluteSize.X
                local t = tick() * 1.5
                local x = (math.sin(t) + 1) / 2 * (w - LobbyProgFill.AbsolutePosition.X)
                shiny.Position = UDim2.new(0, x - 25, -0.5, 0)
            else
                shiny.Visible = false
            end
        end
    end
end)

local function CreateLogo()
    if CoreGui:FindFirstChild("NexusLogoGui") then
        CoreGui:FindFirstChild("NexusLogoGui"):Destroy()
    end
    local LogoGui = Instance.new("ScreenGui")
    LogoGui.Name = "NexusLogoGui"
    LogoGui.Parent = CoreGui
    LogoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LogoGui.DisplayOrder = 10000

    local LogoButton = Instance.new("ImageButton")
    LogoButton.Name = "Logo"
    LogoButton.Parent = LogoGui
    LogoButton.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    LogoButton.BackgroundTransparency = 0.2
    LogoButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    LogoButton.Size = UDim2.new(0, 45, 0, 45)
    LogoButton.Active = true
    LogoButton.Draggable = true

    Instance.new("UICorner", LogoButton).CornerRadius = UDim.new(0, 10)
    local logoStroke = Instance.new("UIStroke", LogoButton)
    logoStroke.Color = Color3.fromRGB(255, 255, 255)
    logoStroke.Thickness = 1
    logoStroke.Transparency = 0.5

    NotifyFrame = Instance.new("Frame")
    NotifyFrame.Name = "NotifyFrame"
    NotifyFrame.Parent = LogoGui
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    NotifyFrame.Position = UDim2.new(0.05, 55, 0.1, 2)
    NotifyFrame.Size = UDim2.new(0, 165, 0, 40)
    NotifyFrame.ClipsDescendants = true
    NotifyFrame.Visible = false
    Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 8)
    local notifyStroke = Instance.new("UIStroke", NotifyFrame)
    notifyStroke.Color = Color3.fromRGB(255, 255, 255)
    notifyStroke.Thickness = 1
    notifyStroke.Transparency = 0.5

    NStatus = Instance.new("TextLabel")
    NStatus.Parent = NotifyFrame
    NStatus.BackgroundTransparency = 1
    NStatus.Position = UDim2.new(0, 10, 0, 6)
    NStatus.Size = UDim2.new(1, -20, 0, 12)
    NStatus.Font = Enum.Font.FredokaOne
    NStatus.Text = "00m:00s | Idle"
    NStatus.TextColor3 = Color3.fromRGB(240, 240, 240)
    NStatus.TextSize = 9
    NStatus.TextXAlignment = Enum.TextXAlignment.Left

    local NProgBg = Instance.new("Frame")
    NProgBg.Parent = NotifyFrame
    NProgBg.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    NProgBg.Position = UDim2.new(0, 10, 0, 24)
    NProgBg.Size = UDim2.new(1, -20, 0, 5)
    Instance.new("UICorner", NProgBg).CornerRadius = UDim.new(0, 4)

    NProgFill = Instance.new("Frame")
    NProgFill.Parent = NProgBg
    NProgFill.BackgroundColor3 = Color3.fromRGB(0, 255, 130)
    NProgFill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", NProgFill).CornerRadius = UDim.new(0, 4)

    task.spawn(function()
        while true do
            if LogoButton and NotifyFrame then
                NotifyFrame.Position = UDim2.new(LogoButton.Position.X.Scale, LogoButton.Position.X.Offset + 55, LogoButton.Position.Y.Scale, LogoButton.Position.Y.Offset + 2)
            end
            task.wait(0.01)
        end
    end)

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
            NotifyFrame.Visible = not gui.Enabled
            saveConfig()
        end
    end)
end

task.spawn(function()
    while task.wait(0.1) do
        if not (hasStarted and not isFinished and not isLobby) then continue end
        local character = lp.Character
        if not character then continue end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        local backpack = lp:FindFirstChild("Backpack")
        if not backpack then continue end

        local bandageCount = 0
        local firstBandage = nil
        local equippedBandage = character:FindFirstChild("Bandage")

        for _, item in ipairs(backpack:GetChildren()) do
            if string.lower(item.Name) == "bandage" then
                bandageCount = bandageCount + 1
                if not firstBandage then firstBandage = item end
            end
        end
        if equippedBandage then
            bandageCount = bandageCount + 1
        end

        if bandageCount < 20 then
            local objectModels = Workspace:FindFirstChild("ObjectModels")
            if objectModels then
                for _, item in ipairs(objectModels:GetChildren()) do
                    if string.lower(item.Name) == "bandage" then
                        local serverEntity = nil
                        if item:FindFirstChild("serverEntity") then
                            serverEntity = item.serverEntity.Value
                        else
                            serverEntity = item:GetAttribute("serverEntity") or item:GetAttribute("entity_server")
                        end
                        if serverEntity then
                            healPickupCooldown = true
                            task.wait(0.075)
                            pcall(function()
                                remotePickup:FireServer(tonumber(serverEntity) or serverEntity)
                            end)
                            task.wait(0.05)
                            healPickupCooldown = false
                            break
                        end
                    end
                end
            end
        end

        if humanoid.Health < 100 then
            if equippedBandage then
                local useEvent = equippedBandage:FindFirstChild("Use")
                if useEvent then
                    pcall(function()
                        useEvent:FireServer()
                    end)
                end
            elseif firstBandage then
                humanoid:EquipTool(firstBandage)
            end
        end
    end
end)

task.spawn(function()
    while true do
        if configLoaded then
            saveConfig()
        end
        task.wait(0.5)
    end
end)

CreateLogo()
loadConfig()
