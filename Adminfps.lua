local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Tạo GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FPS_UI"
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 420, 0, 45)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundTransparency = 1
label.RichText = true
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Parent = gui

-- Hàm tạo chữ cầu vồng từng ký tự
local function rainbowText(text, timeOffset)
	local result = ""
	for i = 1, #text do
		local char = text:sub(i, i)

		local hue = (timeOffset + i * 0.08) % 1
		local color = Color3.fromHSV(hue, 1, 1)

		local r = math.floor(color.R * 255)
		local g = math.floor(color.G * 255)
		local b = math.floor(color.B * 255)

		result ..= string.format(
			"<font color=\"rgb(%d,%d,%d)\">%s</font>",
			r, g, b, char
		)
	end
	return result
end

-- FPS smoothing (ổn định hơn, không nhảy loạn)
local fps = 0
local alpha = 0.1 -- độ mượt (càng nhỏ càng mượt)

RunService.RenderStepped:Connect(function(dt)
	local currentFPS = 1 / dt
	fps = fps + (currentFPS - fps) * alpha

	local display = string.format("Admin nguyenduydz / FPS: %d", math.floor(fps))
	label.Text = rainbowText(display, tick() * 0.5)
end)