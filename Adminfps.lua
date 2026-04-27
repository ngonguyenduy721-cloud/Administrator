local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 230)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Parent = gui

-- DRAG
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- TITLE (Rainbow Gradient)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Nguyễn Duy xd"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local gradient = Instance.new("UIGradient", title)

RunService.RenderStepped:Connect(function()
	local t = tick() * 0.3
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromHSV(t%1,1,1)),
		ColorSequenceKeypoint.new(0.5, Color3.fromHSV((t+0.5)%1,1,1)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV((t+1)%1,1,1)),
	}
end)

-- FPS LABEL
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 0, 30)
fpsLabel.Position = UDim2.new(0, 0, 0, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextColor3 = Color3.fromRGB(255,255,255)
fpsLabel.Parent = frame

-- FPS update
local fps = 0
local alpha = 0.1

RunService.RenderStepped:Connect(function(dt)
	local current = 1/dt
	fps = fps + (current - fps)*alpha
	fpsLabel.Text = "FPS: "..math.floor(fps)
end)

-- BUTTON
local function makeBtn(text, x, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 85, 0, 40)
	btn.Position = UDim2.new(0, x, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(120,120,120)
	btn.TextScaled = true
	btn.Parent = frame
	return btn
end

local btnX = makeBtn("X", 0, 80)
local btnMinus = makeBtn("-", 95, 80)

local btnUp = makeBtn("UP", 0, 130)
local btnPlus = makeBtn("+", 95, 130)

local btnDown = makeBtn("DOWN", 0, 180)
local btnMinus2 = makeBtn("-", 95, 180)

local btnSpeed = makeBtn("1", 190, 180)
local btnFly = makeBtn("FLY", 285, 180)

-- FLY SYSTEM
local flying = false
local speed = 1
local bodyGyro, bodyVel

local function startFly()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	bodyGyro = Instance.new("BodyGyro", hrp)
	bodyVel = Instance.new("BodyVelocity", hrp)

	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)

	bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)

	RunService.RenderStepped:Connect(function()
		if flying and hrp then
			bodyVel.Velocity = workspace.CurrentCamera.CFrame.LookVector * (speed * 50)
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
		end
	end)
end

local function stopFly()
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVel then bodyVel:Destroy() end
end

-- BUTTON EVENTS
btnFly.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then startFly() else stopFly() end
end)

btnUp.MouseButton1Click:Connect(function()
	speed += 1
	btnSpeed.Text = tostring(speed)
end)

btnDown.MouseButton1Click:Connect(function()
	speed = math.max(1, speed - 1)
	btnSpeed.Text = tostring(speed)
end)

btnPlus.MouseButton1Click:Connect(function()
	speed += 5
	btnSpeed.Text = tostring(speed)
end)

btnMinus2.MouseButton1Click:Connect(function()
	speed = math.max(1, speed - 5)
	btnSpeed.Text = tostring(speed)
end)

btnX.MouseButton1Click:Connect(function()
	gui:Destroy()
end)