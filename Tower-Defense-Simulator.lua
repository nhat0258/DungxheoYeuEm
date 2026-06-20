local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local oldGui = PlayerGui:FindFirstChild("NexusStellaNotify")
if oldGui then
	oldGui:Destroy()
end

local oldBlur = Lighting:FindFirstChild("NexusBlur")
if oldBlur then
	oldBlur:Destroy()
end

local blur = Instance.new("BlurEffect")
blur.Name = "NexusBlur"
blur.Size = 0
blur.Parent = Lighting

local gui = Instance.new("ScreenGui")
gui.Name = "NexusStellaNotify"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = PlayerGui

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 1
overlay.Parent = gui

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.Size = UDim2.fromOffset(360, 180)
frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
frame.BackgroundTransparency = 1
frame.Parent = overlay

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.8
stroke.Thickness = 1.2
stroke.Parent = frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 28))
})
gradient.Rotation = 45
gradient.Parent = frame

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 20, 0, 18)
title.Font = Enum.Font.GothamBold
title.Text = "Nexus Stella ⭐️ (Notification)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.TextTransparency = 1
title.Parent = frame

local message = Instance.new("TextLabel")
message.BackgroundTransparency = 1
message.Size = UDim2.new(1, -40, 0, 45)
message.Position = UDim2.new(0, 20, 0, 65)
message.Font = Enum.Font.Gotham
message.Text = "The script will be updated within the next 3–4 hours."
message.TextWrapped = true
message.TextColor3 = Color3.fromRGB(210, 210, 210)
message.TextSize = 16
message.TextTransparency = 1
message.Parent = frame

local button = Instance.new("TextButton")
button.AnchorPoint = Vector2.new(0.5, 1)
button.Position = UDim2.new(0.5, 0, 1, -16)
button.Size = UDim2.fromOffset(120, 38)
button.BackgroundColor3 = Color3.fromRGB(110, 90, 255)
button.BackgroundTransparency = 1
button.Text = "Okay"
button.Font = Enum.Font.GothamBold
button.TextSize = 17
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextTransparency = 1
button.AutoButtonColor = false
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 14)
buttonCorner.Parent = button

local function tween(obj, time, props)
	return TweenService:Create(
		obj,
		TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		props
	)
end

tween(blur, 0.45, {Size = 24}):Play()
tween(overlay, 0.45, {BackgroundTransparency = 0.35}):Play()
tween(frame, 0.45, {BackgroundTransparency = 0.15}):Play()
tween(title, 0.45, {TextTransparency = 0}):Play()
tween(message, 0.45, {TextTransparency = 0}):Play()
tween(button, 0.45, {
	BackgroundTransparency = 0,
	TextTransparency = 0
}):Play()

button.MouseEnter:Connect(function()
	tween(button, 0.15, {
		BackgroundColor3 = Color3.fromRGB(135, 115, 255)
	}):Play()
end)

button.MouseLeave:Connect(function()
	tween(button, 0.15, {
		BackgroundColor3 = Color3.fromRGB(110, 90, 255)
	}):Play()
end)

local closing = false

button.MouseButton1Click:Connect(function()
	if closing then
		return
	end

	closing = true

	tween(blur, 0.4, {Size = 0}):Play()
	tween(overlay, 0.4, {BackgroundTransparency = 1}):Play()
	tween(frame, 0.4, {BackgroundTransparency = 1}):Play()
	tween(title, 0.4, {TextTransparency = 1}):Play()
	tween(message, 0.4, {TextTransparency = 1}):Play()
	tween(button, 0.4, {
		BackgroundTransparency = 1,
		TextTransparency = 1
	}):Play()

	task.wait(0.45)

	blur:Destroy()
	gui:Destroy()
end)
