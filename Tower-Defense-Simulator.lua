local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
	if playerGui:FindFirstChild("SuspendNotice") then
		playerGui.SuspendNotice:Destroy()
	end
	if Lighting:FindFirstChild("SuspendBlur") then
		Lighting.SuspendBlur:Destroy()
	end
end)

local blur = Instance.new("BlurEffect")
blur.Name = "SuspendBlur"
blur.Size = 0
blur.Parent = Lighting

local gui = Instance.new("ScreenGui")
gui.Name = "SuspendNotice"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.new(0, 0, 0)
overlay.BackgroundTransparency = 1
overlay.Parent = gui

local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(0, 0)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
main.BorderSizePixel = 0
main.Parent = overlay

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 90, 110)
stroke.Thickness = 1
stroke.Transparency = 1
stroke.Parent = main

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 34, 42)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 24))
})
gradient.Rotation = 90
gradient.Parent = main

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 0, 18)
title.Position = UDim2.new(0, 10, 0, 12)
title.Font = Enum.Font.GothamBold
title.Text = "Nexus Stella ⭐️ ( Notification )"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = main

local content = Instance.new("TextLabel")
content.BackgroundTransparency = 1
content.Size = UDim2.new(1, -24, 0, 40)
content.Position = UDim2.new(0, 12, 0, 34)
content.Font = Enum.Font.Gotham
content.Text = "Service Temporarily Suspended Due to Ban Wave"
content.TextColor3 = Color3.fromRGB(210, 210, 220)
content.TextTransparency = 1
content.TextSize = 10
content.TextWrapped = true
content.TextXAlignment = Enum.TextXAlignment.Center
content.TextYAlignment = Enum.TextYAlignment.Center
content.Parent = main

local button = Instance.new("TextButton")
button.AnchorPoint = Vector2.new(0.5, 1)
button.Position = UDim2.new(0.5, 0, 1, -14)
button.Size = UDim2.fromOffset(78, 24)
button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
button.BackgroundTransparency = 1
button.Text = "Okay"
button.Font = Enum.Font.GothamBold
button.TextSize = 10
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextTransparency = 1
button.AutoButtonColor = false
button.Parent = main

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = button

TweenService:Create(
	overlay,
	TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{BackgroundTransparency = 0.35}
):Play()

TweenService:Create(
	blur,
	TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{Size = 24}
):Play()

TweenService:Create(
	main,
	TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Size = UDim2.fromOffset(215, 115)}
):Play()

task.wait(0.15)

TweenService:Create(
	stroke,
	TweenInfo.new(0.3),
	{Transparency = 0}
):Play()

TweenService:Create(
	title,
	TweenInfo.new(0.3),
	{TextTransparency = 0}
):Play()

TweenService:Create(
	content,
	TweenInfo.new(0.3),
	{TextTransparency = 0}
):Play()

TweenService:Create(
	button,
	TweenInfo.new(0.3),
	{
		BackgroundTransparency = 0,
		TextTransparency = 0
	}
):Play()

local closing = false

button.MouseButton1Click:Connect(function()
	if closing then
		return
	end

	closing = true

	TweenService:Create(
		overlay,
		TweenInfo.new(0.3),
		{BackgroundTransparency = 1}
	):Play()

	TweenService:Create(
		blur,
		TweenInfo.new(0.3),
		{Size = 0}
	):Play()

	TweenService:Create(
		title,
		TweenInfo.new(0.2),
		{TextTransparency = 1}
	):Play()

	TweenService:Create(
		content,
		TweenInfo.new(0.2),
		{TextTransparency = 1}
	):Play()

	TweenService:Create(
		button,
		TweenInfo.new(0.2),
		{
			BackgroundTransparency = 1,
			TextTransparency = 1
		}
	):Play()

	TweenService:Create(
		stroke,
		TweenInfo.new(0.2),
		{Transparency = 1}
	):Play()

	local tween = TweenService:Create(
		main,
		TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{Size = UDim2.fromOffset(0, 0)}
	)

	tween:Play()
	tween.Completed:Wait()

	gui:Destroy()
	blur:Destroy()
end)
