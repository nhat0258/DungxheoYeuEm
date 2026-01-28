local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local shadow = Instance.new("Frame", gui)
shadow.AnchorPoint = Vector2.new(0.5,0.5)
shadow.Position = UDim2.fromScale(0.5,0.5)
shadow.Size = UDim2.fromScale(1,1)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.35
shadow.BorderSizePixel = 0

local main = Instance.new("Frame", gui)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.Position = UDim2.fromScale(0.5,0.5)
main.Size = UDim2.fromScale(0.28,0.22)
main.BackgroundColor3 = Color3.fromRGB(15,18,30)
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 1.2
stroke.Transparency = 0.2

local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1,0.45)
title.BackgroundTransparency = 1
title.Text = "BẠN CÓ PHẢI DOCTOR KHÔNG?"
title.TextColor3 = Color3.fromRGB(220,235,255)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true

local yes = Instance.new("TextButton", main)
yes.Size = UDim2.fromScale(0.42,0.28)
yes.Position = UDim2.fromScale(0.05,0.6)
yes.Text = "YES"
yes.Font = Enum.Font.GothamBold
yes.TextScaled = true
yes.TextColor3 = Color3.fromRGB(0,255,200)
yes.BackgroundColor3 = Color3.fromRGB(20,35,45)
yes.BorderSizePixel = 0
Instance.new("UICorner", yes).CornerRadius = UDim.new(0,14)

local ys = Instance.new("UIStroke", yes)
ys.Color = Color3.fromRGB(0,255,200)
ys.Thickness = 1

local no = Instance.new("TextButton", main)
no.Size = UDim2.fromScale(0.42,0.28)
no.Position = UDim2.fromScale(0.53,0.6)
no.Text = "NO"
no.Font = Enum.Font.GothamBold
no.TextScaled = true
no.TextColor3 = Color3.fromRGB(255,80,80)
no.BackgroundColor3 = Color3.fromRGB(40,20,20)
no.BorderSizePixel = 0
Instance.new("UICorner", no).CornerRadius = UDim.new(0,14)

local ns = Instance.new("UIStroke", no)
ns.Color = Color3.fromRGB(255,80,80)
ns.Thickness = 1

no.MouseButton1Click:Connect(function()
	gui:Destroy()
	StarterGui:SetCore("SendNotification",{
		Title = "ERROR",
		Text = "ACCESS DENIED",
		Duration = 3
	})
end)

yes.MouseButton1Click:Connect(function()
	gui:Destroy()
	StarterGui:SetCore("SendNotification",{
		Title = "ACCESS GRANTED",
		Text = "Hải À VERIFIED",
		Duration = 3
	})

	local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/nhat0258/Redz-UI-Library/refs/heads/main/Main.lua"))()

local WindowName = "Nexus Stella ⭐"
local Window = RedzLib:MakeWindow({
    Title = WindowName,
    SubTitle = "Clean Code",
    SaveFolder = "NexusStella_Clean"
})

local MainTab = Window:MakeTab({ "Main", "home" })
local SeaTab = Window:MakeTab({ "Sea Event", "anchor" })
local MovementTab = Window:MakeTab({ "Movement", "rocket" })
local VisualTab = Window:MakeTab({ "Visual", "eye" })
local SettingTab = Window:MakeTab({ "Setting", "settings" })

local FlyToPlayerEnabled = false
local FlyOnSideEnabled = false 
local AutoFlyToSeaEnabled = false
local FlyToSubmergedIslandEnabled = false
local FlyToBoatEnabled = false 
local CurrentFlyTarget = nil
local FlySpeed = 320
local SeaFlySpeed = 500
local FlyOffset = Vector3.new(0, 6, 0)
local KeepY = 167.000 
local SeaDirection = Vector3.new(-0.993, -0.002, 0.116)
local NoclipConnection

local CFrameWalkEnabled = false
local CFrameSpeed = 25
local InfiniteJumpEnabled = true
local InfiniteJumpConnection = nil

local WalkOnSeaEnabled = false
local SeaPart = nil
local SeaLevel = -3
local WalkOnSeaConnection = nil
local AutoBoatHeightEnabled = false
local BoatTargetHeight = 200 
local AutoBoatConnection = nil

local LoopDayBrightEnabled = false 
local LoopDayBrightConnection = nil

local SafeModeEnabled = true
local IsInSafeMode = false 
local SafeModeConnection = nil
local SafeTriggerHealth = 2500
local SafeRecoverHealth = 5500
local SafeHeight = 5000

local Characters = {}
local SortedPlayers = {}
local ESPEnabled = false
local ESPConnections = {}
local ESPUpdateConnection = nil
local HighlightColor = Color3.fromRGB(255, 0, 0)
local HighlightTrans = 0.5

local Toggles = {} 

local function getCharacterFolder()
    local BloxFruitsChars = Workspace:FindFirstChild("Characters")
    if BloxFruitsChars then return BloxFruitsChars end
    return Workspace 
end

local function getPlayerFromCharacter(char)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character == char then return player end
    end
    return nil
end

local function updateCharacterList()
    table.clear(Characters)
    local folder = getCharacterFolder()
    local children = folder:GetChildren()
    for _, char in ipairs(children) do
        if char:IsA("Model") then
            local player = getPlayerFromCharacter(char)
            if player and player ~= LocalPlayer then
                table.insert(Characters, {
                    Character = char,
                    Player = player,
                    Name = player.Name
                })
            end
        end
    end
end

local function calculateDistance(char)
    if not LocalPlayer.Character or not char then return math.huge end
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local charRoot = char:FindFirstChild("HumanoidRootPart")
    if not localRoot or not charRoot then return math.huge end
    return (localRoot.Position - charRoot.Position).Magnitude
end

local function processAndSortCharacters()
    if #Characters == 0 then
        table.clear(SortedPlayers)
        return
    end
    for _, data in ipairs(Characters) do
        data.Distance = calculateDistance(data.Character)
    end
    table.sort(Characters, function(a, b) return a.Distance < b.Distance end)
    table.clear(SortedPlayers)
    for _, data in ipairs(Characters) do
        table.insert(SortedPlayers, data.Name)
    end
end

local PlayerDropdownUI = nil

local function refreshPlayerList()
    updateCharacterList()
    processAndSortCharacters()
    if PlayerDropdownUI then PlayerDropdownUI:Set(SortedPlayers) end
end

local function findNearestCharacter()
    updateCharacterList()
    processAndSortCharacters()
    if #Characters > 0 then return Characters[1].Name end
    return nil
end

local function getCharacterByName(name)
    for _, data in ipairs(Characters) do
        if data.Name == name then return data.Character end
    end
    local player = Players:FindFirstChild(name)
    if player and player.Character then return player.Character end
    local folder = getCharacterFolder()
    return folder:FindFirstChild(name)
end

local function enableNoclip()
    if NoclipConnection then return end
    NoclipConnection = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function disableNoclip()
    if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
end

local function flyToPosition(targetPosition, dt, speed)
    local character = LocalPlayer.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local currentCFrame = humanoidRootPart.CFrame
    local currentPos = currentCFrame.Position
    local rotation = currentCFrame.Rotation

    local newYPos = Vector3.new(currentPos.X, targetPosition.Y, currentPos.Z)
    humanoidRootPart.CFrame = CFrame.new(newYPos) * rotation

    currentPos = humanoidRootPart.CFrame.Position

    local xzTargetPos = Vector3.new(targetPosition.X, currentPos.Y, targetPosition.Z)
    local direction = (xzTargetPos - currentPos)
    local distance = direction.Magnitude

    if distance > 0 then
        direction = direction.Unit
        local step = speed * (dt or 0.016)
        local moveAmount = math.min(step, distance)
        local newPos = currentPos + direction * moveAmount
        humanoidRootPart.CFrame = CFrame.new(newPos) * rotation
    end
end

local FlyToPlayerConnection
local function flyToPlayerLoop(dt)
    if IsInSafeMode then return end
    if FlyToPlayerEnabled and CurrentFlyTarget then
        local targetCharacter = getCharacterByName(CurrentFlyTarget)
        if targetCharacter then
            local humanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                if humanoidRootPart.Position.Y < 5 then
                    FlyToPlayerEnabled = false
                    if FlyToPlayerConnection then FlyToPlayerConnection:Disconnect() FlyToPlayerConnection = nil end
                    disableNoclip()
                    return
                end
                flyToPosition(humanoidRootPart.Position, dt, FlySpeed)
            end
        end
    end
end

local FlyOnSideConnection
local function flyOnSideLoop(dt)
    if IsInSafeMode then return end
    if FlyOnSideEnabled and CurrentFlyTarget then
        local targetCharacter = getCharacterByName(CurrentFlyTarget)
        if targetCharacter then
            local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetRootPart then
                if targetRootPart.Position.Y < 5 then
                    FlyOnSideEnabled = false
                    if FlyOnSideConnection then FlyOnSideConnection:Disconnect() FlyOnSideConnection = nil end
                    disableNoclip()
                    return
                end
                local targetPosition = targetRootPart.Position + FlyOffset
                flyToPosition(targetPosition, dt, FlySpeed)
            end
        end
    end
end

local AutoFlyToSeaConnection
local function autoFlyToSeaLoop(dt)
    if IsInSafeMode then return end
    if AutoFlyToSeaEnabled then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        local currentPos = humanoidRootPart.CFrame.Position
        local rotation = humanoidRootPart.CFrame.Rotation
        
        local KeepY = BoatTargetHeight 
        
        local newYPos = Vector3.new(currentPos.X, KeepY, currentPos.Z)
        humanoidRootPart.CFrame = CFrame.new(newYPos) * rotation
        currentPos = humanoidRootPart.CFrame.Position
        local targetPos = currentPos + (SeaDirection.Unit * SeaFlySpeed * (dt or 0.016))
        targetPos = Vector3.new(targetPos.X, KeepY, targetPos.Z)
        humanoidRootPart.CFrame = CFrame.new(targetPos) * rotation
    end
end

local IsSubmerged = false 

local function toggleWalkOnSea(value)
    WalkOnSeaEnabled = value
    if value then
        IsSubmerged = false 
        if not SeaPart then
            SeaPart = Instance.new("Part"); SeaPart.Name="NexusSeaWalkPart"; SeaPart.Size=Vector3.new(60,1,60); SeaPart.Transparency=1; SeaPart.Anchored=true; SeaPart.CanCollide=true; SeaPart.Parent=Workspace
        end
        if WalkOnSeaConnection then WalkOnSeaConnection:Disconnect() end
        WalkOnSeaConnection = RunService.Heartbeat:Connect(function()
            if not WalkOnSeaEnabled then return end
            if IsSubmerged then return end 

            if not SeaPart or not SeaPart.Parent then 
                SeaPart = Instance.new("Part"); SeaPart.Name="NexusSeaWalkPart"; SeaPart.Size=Vector3.new(60,1,60); SeaPart.Transparency=1; SeaPart.Anchored=true; SeaPart.CanCollide=true; SeaPart.Parent=Workspace
            end
            local character = LocalPlayer.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                if rootPart and humanoid then
                    SeaPart.CFrame = CFrame.new(rootPart.Position.X, SeaLevel, rootPart.Position.Z)
                    if humanoid.Sit then
                        if SeaPart.CanCollide == true then SeaPart.CanCollide = false end
                    else
                        if SeaPart.CanCollide == false then SeaPart.CanCollide = true end
                        if rootPart.Position.Y < (SeaLevel - 5) then
                             rootPart.CFrame = CFrame.new(rootPart.Position.X, SeaLevel + 5, rootPart.Position.Z)
                             rootPart.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                end
            end
        end)
    else
        if WalkOnSeaConnection then WalkOnSeaConnection:Disconnect() end
        if SeaPart then SeaPart:Destroy() SeaPart = nil end
    end
end

local FlyToSubmergedIslandConnection
local SUBMERGED_ISLAND_POS1 = Vector3.new(11493.823, 26, 9827.413)
local SUBMERGED_ISLAND_POS2 = Vector3.new(11493.823, -2155.044, 9827.413)

local function flyToSubmergedIslandLoop(dt)
    if IsInSafeMode then return end
    if FlyToSubmergedIslandEnabled then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        local currentPos = humanoidRootPart.CFrame.Position
        local targetPos = SUBMERGED_ISLAND_POS1
        local distance = (currentPos - targetPos).Magnitude

        if distance > 25 then
            flyToPosition(targetPos, dt, FlySpeed)
        else
            if FlyToSubmergedIslandConnection then 
                FlyToSubmergedIslandConnection:Disconnect() 
                FlyToSubmergedIslandConnection = nil
            end
            FlyToSubmergedIslandEnabled = false
            IsSubmerged = true 
            
            task.wait(0.1)
            humanoidRootPart.CFrame = CFrame.new(SUBMERGED_ISLAND_POS2)
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            
            if Toggles["FlyToSubmerged"] then Toggles["FlyToSubmerged"]:Set(false) end
            disableNoclip()
        end
    end
end

local function findMyBoatGlobal()
    local boatsFolder = Workspace:FindFirstChild("Boats")
    if not boatsFolder then return nil end
    for _, boat in ipairs(boatsFolder:GetChildren()) do
        local owner = boat:FindFirstChild("Owner")
        if owner and tostring(owner.Value) == LocalPlayer.Name then
            return boat.PrimaryPart or boat:FindFirstChildWhichIsA("BasePart", true)
        end
    end
    return nil
end

local FlyToBoatConnection
local function flyToBoatLoop(dt)
    if IsInSafeMode then return end
    if FlyToBoatEnabled then
        local boatPart = findMyBoatGlobal()
        if boatPart then
            local targetPos = boatPart.Position + Vector3.new(0, 10, 0)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - targetPos).Magnitude
                if dist > 5 then
                    flyToPosition(targetPos, dt, FlySpeed)
                else
                    FlyToBoatEnabled = false
                    if Toggles["FlyToBoat"] then Toggles["FlyToBoat"]:Set(false) end
                    disableNoclip()
                end
            end
        else
            FlyToBoatEnabled = false
            if Toggles["FlyToBoat"] then Toggles["FlyToBoat"]:Set(false) end
            disableNoclip()
        end
    end
end

local function toggleAutoBoat(value)
    AutoBoatHeightEnabled = value
    if value then
        if AutoBoatConnection then AutoBoatConnection:Disconnect() end
        AutoBoatConnection = RunService.Heartbeat:Connect(function()
            if not AutoBoatHeightEnabled then return end
            local currentBoatPart = findMyBoatGlobal()
            if currentBoatPart then
                local currentCF = currentBoatPart.CFrame
                local currentVel = currentBoatPart.AssemblyLinearVelocity
                local newCFrame = CFrame.new(currentCF.X, BoatTargetHeight, currentCF.Z) * currentCF.Rotation
                currentBoatPart.CFrame = newCFrame
                currentBoatPart.AssemblyLinearVelocity = Vector3.new(currentVel.X, 0, currentVel.Z)
            end
        end)
    else
        if AutoBoatConnection then AutoBoatConnection:Disconnect() end
    end
end

local function toggleLoopDayBright(value)
    LoopDayBrightEnabled = value
    if value then
        pcall(function()
            Lighting.Brightness = 2
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end)
        
        if LoopDayBrightConnection then LoopDayBrightConnection:Disconnect() end
        LoopDayBrightConnection = RunService.Heartbeat:Connect(function()
            Lighting.ClockTime = 12
            Lighting.Brightness = 2
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        end)
    else
        if LoopDayBrightConnection then LoopDayBrightConnection:Disconnect() end
        Lighting.GlobalShadows = true
    end
end

local function toggleCFrameWalk(value)
    CFrameWalkEnabled = value
    if value then
        RunService:BindToRenderStep("NexusCFrameWalk", Enum.RenderPriority.Camera.Value - 1, function(dt)
            if not CFrameWalkEnabled then return end
            
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                
                if hum and hum.Sit then return end
                
                if hum and hrp and hum.MoveDirection.Magnitude > 0 then
                    local moveDir = hum.MoveDirection
                    local flatDir = Vector3.new(moveDir.X, 0, moveDir.Z) 
                    
                    if flatDir.Magnitude > 0 then
                        local newPos = hrp.Position + (flatDir * CFrameSpeed * dt)
                        hrp.CFrame = CFrame.new(newPos) * hrp.CFrame.Rotation
                        local currentVel = hrp.AssemblyLinearVelocity
                        hrp.AssemblyLinearVelocity = Vector3.new(0, currentVel.Y, 0)
                    end
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("NexusCFrameWalk")
    end
end

local function zeroPhysics(part)
    if part:IsA("BasePart") then part.AssemblyLinearVelocity = Vector3.zero; part.AssemblyAngularVelocity = Vector3.zero end
end

local function teleportToMansionLogic()
    pcall(function()
        local seat = Workspace:WaitForChild("Game"):WaitForChild("P1")
        if not seat then return end
        local MAINSON_CF = CFrame.new(-12546.615, 332.362, -7603.319)
        local LIFT_Y = 3700
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:WaitForChild("Humanoid")
        local hrp = char:WaitForChild("HumanoidRootPart")
        seat.Anchored = false; seat.CFrame = MAINSON_CF; zeroPhysics(seat); task.wait(); seat.Anchored = true
        hrp.CFrame = MAINSON_CF * CFrame.new(0, 12, 0); zeroPhysics(hrp); task.wait(0.1); seat:Sit(hum)
        local startTime = tick()
        repeat task.wait() until hum.SeatPart == seat or (tick() - startTime > 2)
        task.wait(0.25); hum.Sit = false; hum:ChangeState(Enum.HumanoidStateType.Jumping); task.wait(0.05)
        seat.Anchored = false; seat.CFrame = seat.CFrame + Vector3.new(0, LIFT_Y, 0); zeroPhysics(seat); seat.Anchored = true
    end)
end

local function SafeModeLoop()
    if not SafeModeEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hum and hrp then
        local hp = hum.Health
        if IsInSafeMode then
            if hp >= SafeRecoverHealth then IsInSafeMode = false else hrp.CFrame = CFrame.new(hrp.Position.X, SafeHeight, hrp.Position.Z); hrp.AssemblyLinearVelocity = Vector3.zero end
        else
            if hp < SafeTriggerHealth and hp > 0 then IsInSafeMode = true end
        end
    end
end

local function removeESP(character)
    if ESPConnections[character] then
        if ESPConnections[character].box then ESPConnections[character].box:Destroy() end
        if ESPConnections[character].billboard then ESPConnections[character].billboard:Destroy() end
        ESPConnections[character] = nil
    end
end

local function updateESPInfo(character, billboard)
    local player = getPlayerFromCharacter(character)
    if not player or player == LocalPlayer then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChild("Humanoid")
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and hum and myRoot then
        local dist = math.floor((myRoot.Position - root.Position).Magnitude)
        local hp = math.floor(hum.Health)
        local maxHp = math.floor(hum.MaxHealth)
        
        local textLabel = billboard:FindFirstChild("Info")
        if textLabel then 
            textLabel.Text = string.format("%s\nDst: %d | ❤️ %d/%d", player.Name, dist, hp, maxHp)
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end

local function createESP(character)
    local player = getPlayerFromCharacter(character)
    if not player or player == LocalPlayer then return end
    if ESPConnections[character] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "NexusESP_Box"
    highlight.FillColor = HighlightColor 
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = HighlightTrans
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NexusESP_Info"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = character
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Info"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.Parent = billboard
    
    ESPConnections[character] = { box = highlight, billboard = billboard }
end

local function scanAllCharactersOnce()
    for character, _ in pairs(ESPConnections) do removeESP(character) end
    updateCharacterList()
    for _, data in ipairs(Characters) do createESP(data.Character) end
end

Toggles["SafeMode"] = MainTab:AddToggle({ Name = "Safe Mode", Default = true, Callback = function(v) SafeModeEnabled = v; if v then if SafeModeConnection then SafeModeConnection:Disconnect() end SafeModeConnection = RunService.Heartbeat:Connect(SafeModeLoop) else if SafeModeConnection then SafeModeConnection:Disconnect() end IsInSafeMode = false end end })
MainTab:AddSlider({Name = "Trigger HP", Min = 100, Max = 10000, Default = 2500, Callback = function(v) SafeTriggerHealth = v end})
MainTab:AddSlider({Name = "Recover HP", Min = 100, Max = 15000, Default = 5500, Callback = function(v) SafeRecoverHealth = v end})

MainTab:AddSection({ Name = "Player Selector" })
MainTab:AddButton({ Name = "Refresh List", Callback = refreshPlayerList })
PlayerDropdownUI = MainTab:AddDropdown({ Name = "Select Player", Options = {}, Default = nil, Callback = function(v) CurrentFlyTarget = v; if FlyToPlayerEnabled then enableNoclip() end end })
MainTab:AddButton({ Name = "Select Nearest", Callback = function() local n = findNearestCharacter() if n then CurrentFlyTarget = n; if PlayerDropdownUI then PlayerDropdownUI:Set(SortedPlayers, n) end end end})

MainTab:AddSection({ Name = "Fly & Combat" })
Toggles["FlyToPlayer"] = MainTab:AddToggle({ Name = "Fly To Player", Default = false, Callback = function(v)
    FlyToPlayerEnabled = v
    if v then if FlyToPlayerConnection then FlyToPlayerConnection:Disconnect() end FlyToPlayerConnection = RunService.Heartbeat:Connect(flyToPlayerLoop); enableNoclip() else if FlyToPlayerConnection then FlyToPlayerConnection:Disconnect() end if not FlyOnSideEnabled and not AutoFlyToSeaEnabled and not FlyToSubmergedIslandEnabled and not FlyToBoatEnabled then disableNoclip() end end
end})
Toggles["FlyOnSide"] = MainTab:AddToggle({ Name = "Fly On Side", Default = false, Callback = function(v)
    FlyOnSideEnabled = v
    if v then if FlyOnSideConnection then FlyOnSideConnection:Disconnect() end FlyOnSideConnection = RunService.Heartbeat:Connect(flyOnSideLoop); enableNoclip() else if FlyOnSideConnection then FlyOnSideConnection:Disconnect() end if not FlyToPlayerEnabled and not AutoFlyToSeaEnabled and not FlyToSubmergedIslandEnabled and not FlyToBoatEnabled then disableNoclip() end end
end})
MainTab:AddDropdown({ Name = "Fly Speed", Options = {"100", "200", "320", "500"}, Default = "320", Callback = function(v) FlySpeed = tonumber(v) end })
MainTab:AddButton({ Name = "TP To Mansion", Callback = teleportToMansionLogic })

SeaTab:AddSection({ Name = "Sea Auto Fly" })
Toggles["AutoFlyToSea"] = SeaTab:AddToggle({ Name = "Auto Fly To Sea", Default = false, Callback = function(v) AutoFlyToSeaEnabled = v; if v then if AutoFlyToSeaConnection then AutoFlyToSeaConnection:Disconnect() end AutoFlyToSeaConnection = RunService.Heartbeat:Connect(autoFlyToSeaLoop); enableNoclip() else if AutoFlyToSeaConnection then AutoFlyToSeaConnection:Disconnect() end if not FlyToPlayerEnabled and not FlyOnSideEnabled and not FlyToSubmergedIslandEnabled and not FlyToBoatEnabled then disableNoclip() end end end})

Toggles["FlyToSubmerged"] = SeaTab:AddToggle({ Name = "Fly To Submerged", Default = false, Callback = function(v)
    FlyToSubmergedIslandEnabled = v
    if v then
        if WalkOnSeaEnabled then toggleWalkOnSea(false); if Toggles["WalkOnSea"] then Toggles["WalkOnSea"]:Set(false) end end
        FlyToPlayerEnabled = false; FlyOnSideEnabled = false; AutoFlyToSeaEnabled = false; enableNoclip(); FlyToSubmergedIslandConnection = RunService.Heartbeat:Connect(flyToSubmergedIslandLoop)
    else
        if FlyToSubmergedIslandConnection then FlyToSubmergedIslandConnection:Disconnect() end disableNoclip()
    end
end})
SeaTab:AddDropdown({ Name = "Sea Fly Speed", Options = {"200", "300", "400", "500"}, Default = "500", Callback = function(v) SeaFlySpeed = tonumber(v) end })

SeaTab:AddSection({ Name = "Boat Features" })
Toggles["FlyToBoat"] = SeaTab:AddToggle({ Name = "Fly To My Boat", Default = false, Callback = function(v)
    FlyToBoatEnabled = v
    if v then if FlyToBoatConnection then FlyToBoatConnection:Disconnect() end FlyToBoatConnection = RunService.Heartbeat:Connect(flyToBoatLoop); enableNoclip() else if FlyToBoatConnection then FlyToBoatConnection:Disconnect() end if not FlyToPlayerEnabled and not FlyOnSideEnabled and not AutoFlyToSeaEnabled and not FlyToSubmergedIslandEnabled then disableNoclip() end end
end})

Toggles["AutoBoat"] = SeaTab:AddToggle({ Name = "Auto Boat Height", Default = false, Callback = toggleAutoBoat })
SeaTab:AddSlider({Name = "Boat/Sea Height", Min = 50, Max = 500, Default = 200, Callback = function(v) BoatTargetHeight = v end})

SeaTab:AddSection({ Name = "Walk On Sea" })
Toggles["WalkOnSea"] = SeaTab:AddToggle({ Name = "Walk On Sea", Default = false, Callback = toggleWalkOnSea })
SeaTab:AddSlider({Name = "Sea Level", Min = -10, Max = 50, Default = -3, Callback = function(v) SeaLevel = v end})

MovementTab:AddSection({ Name = "Movement" })
Toggles["CFrameWalk"] = MovementTab:AddToggle({ Name = "CFrame Walk", Default = false, Callback = toggleCFrameWalk })
MovementTab:AddSlider({Name = "Speed", Min = 16, Max = 350, Default = 25, Callback = function(v) CFrameSpeed = v end})
Toggles["InfiniteJump"] = MovementTab:AddToggle({ Name = "Infinite Jump", Default = true, Callback = function(v) InfiniteJumpEnabled = v; if v then InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function() if InfiniteJumpEnabled and LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end) else if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end end end})

VisualTab:AddSection({ Name = "World Visuals" })
Toggles["LoopDayBright"] = VisualTab:AddToggle({ Name = "Loop Day & Max Bright", Default = false, Callback = toggleLoopDayBright }) 

VisualTab:AddSection({ Name = "ESP" })
Toggles["ESP"] = VisualTab:AddToggle({ Name = "ESP", Default = false, Callback = function(v) ESPEnabled = v; if v then scanAllCharactersOnce(); if ESPUpdateConnection then ESPUpdateConnection:Disconnect() end ESPUpdateConnection = RunService.Heartbeat:Connect(function() for character, data in pairs(ESPConnections) do if character and character.Parent then updateESPInfo(character, data.billboard) else removeESP(character) end end end) else if ESPUpdateConnection then ESPUpdateConnection:Disconnect() end for character, _ in pairs(ESPConnections) do removeESP(character) end end end})
VisualTab:AddButton({ Name = "Refresh ESP", Callback = function() if ESPEnabled then scanAllCharactersOnce() end end })

Toggles["AutoHop"] = SettingTab:AddToggle({ Name = "Auto Hop", Default = false, Callback = function(v) AutoHopEnabled = v; if v then AutoHopConnection = RunService.Heartbeat:Connect(function() local PlaceId = game.PlaceId local function GetServers(cursor) local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" if cursor then url = url .. "&cursor=" .. cursor end return HttpService:JSONDecode(game:HttpGet(url)) end local cursor = nil while true do local data = GetServers(cursor) for _, server in ipairs(data.data) do if server.playing >= 1 and server.playing < server.maxPlayers and server.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer) return end end cursor = data.nextPageCursor if not cursor then break end end task.wait(5) end) else if AutoHopConnection then AutoHopConnection:Disconnect() end end end})

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
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = LogoButton

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = LogoButton
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5

    task.spawn(function()
        local success, imgAsset = pcall(function()
            local fileName = "NexusLogo_reFX.png"
            local url = "https://raw.githubusercontent.com/nguyennhlat2004/Roblox-Api/main/reFX.png"
            if not isfile(fileName) then writefile(fileName, game:HttpGet(url)) end
            return getcustomasset(fileName)
        end)
        if success and imgAsset then LogoButton.Image = imgAsset else LogoButton.Image = "rbxassetid://13347535978" end
    end)

    local dragging, dragInput, dragStart, startPos
    LogoButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = LogoButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    LogoButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            LogoButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    LogoButton.MouseButton1Click:Connect(function()
        local found = false
        local targetName = WindowName 

        for _, gui in pairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "NexusLogoGui" then
                local descendants = gui:GetDescendants()
                for _, desc in pairs(descendants) do
                    if desc:IsA("TextLabel") and desc.Text == targetName then
                        gui.Enabled = not gui.Enabled
                        found = true
                        break
                    end
                end
                if found then break end
            end
        end
        
        if not found then
            for _, gui in pairs(CoreGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name ~= "NexusLogoGui" and gui.Name ~= "RobloxGui" then 
                    local mainFrame = gui:FindFirstChild("Main")
                    if mainFrame then
                        gui.Enabled = not gui.Enabled
                        break
                    end
                end
            end
        end
    end)
end

CreateLogo()

local FolderName = "NexusStella"
local FileName = "Config.json"
local function SaveConfig()
    local Config = {
        SafeMode = SafeModeEnabled, FlyToPlayer = FlyToPlayerEnabled, FlyOnSide = FlyOnSideEnabled,
        AutoFlyToSea = AutoFlyToSeaEnabled, FlyToSubmerged = FlyToSubmergedIslandEnabled, FlySpeed = tostring(FlySpeed),
        SeaFlySpeed = tostring(SeaFlySpeed), CFrameWalk = CFrameWalkEnabled, CFrameSpeed = CFrameSpeed,
        InfiniteJump = InfiniteJumpEnabled, AutoHop = AutoHopEnabled, ESP = ESPEnabled, WalkOnSea = WalkOnSeaEnabled, AutoBoat = AutoBoatHeightEnabled,
        FlyToBoat = FlyToBoatEnabled, LoopDayBright = LoopDayBrightEnabled
    }
    if not isfolder(FolderName) then makefolder(FolderName) end
    writefile(FolderName.."/"..FileName, HttpService:JSONEncode(Config))
end
local function LoadConfig()
    if not isfolder(FolderName) then makefolder(FolderName) end
    if not isfile(FolderName.."/"..FileName) then return end
    local Success, Config = pcall(function() return HttpService:JSONDecode(readfile(FolderName.."/"..FileName)) end)
    if Success and Config then
        if Config.SafeMode ~= nil then Toggles["SafeMode"]:Set(Config.SafeMode) end
        if Config.FlyToPlayer ~= nil then Toggles["FlyToPlayer"]:Set(Config.FlyToPlayer) end
        if Config.FlyOnSide ~= nil then Toggles["FlyOnSide"]:Set(Config.FlyOnSide) end
        if Config.AutoFlyToSea ~= nil then Toggles["AutoFlyToSea"]:Set(Config.AutoFlyToSea) end
        if Config.FlyToSubmerged ~= nil then Toggles["FlyToSubmerged"]:Set(Config.FlyToSubmerged) end
        if Config.CFrameWalk ~= nil then Toggles["CFrameWalk"]:Set(Config.CFrameWalk) end
        if Config.InfiniteJump ~= nil then Toggles["InfiniteJump"]:Set(Config.InfiniteJump) end
        if Config.ESP ~= nil then Toggles["ESP"]:Set(Config.ESP) end
        if Config.WalkOnSea ~= nil then Toggles["WalkOnSea"]:Set(Config.WalkOnSea) end
        if Config.AutoBoat ~= nil then Toggles["AutoBoat"]:Set(Config.AutoBoat) end
        if Config.FlyToBoat ~= nil then Toggles["FlyToBoat"]:Set(Config.FlyToBoat) end
        if Config.LoopDayBright ~= nil then Toggles["LoopDayBright"]:Set(Config.LoopDayBright) end
    end
end
SettingTab:AddButton({ Name = "Save Config", Callback = SaveConfig })
SettingTab:AddButton({ Name = "Delete Config", Callback = function() if isfile(FolderName.."/"..FileName) then delfile(FolderName.."/"..FileName) end end })

refreshPlayerList()
local CharFolder = getCharacterFolder()
CharFolder.ChildAdded:Connect(function(char) if ESPEnabled then task.wait(0.5) createESP(char) end end)
CharFolder.ChildRemoved:Connect(function(char) if ESPEnabled then removeESP(char) end end)
LoadConfig()
end)
