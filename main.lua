--// Simple Draggable GUI + Minimize + Close
--// Taruh di LocalScript / main.lua

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer

-- Parent yang aman (kalau PlayerGui belum siap, fallback ke CoreGui)
local function getParentGui()
	local pg = lp:FindFirstChildOfClass("PlayerGui")
	if pg then return pg end
	return game:GetService("CoreGui")
end

-- Hapus GUI lama kalau ada (biar ga dobel)
pcall(function()
	local old = getParentGui():FindFirstChild("DjWindowGUI")
	if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjWindowGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getParentGui()

-- Window utama
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 420, 0, 260)
Window.Position = UDim2.new(0.5, -210, 0.5, -130)
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Window.BorderSizePixel = 0
Window.Parent = ScreenGui

-- Biar agak rounded (kalau executor/support UIStroke/UICorner aman)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Window

-- Topbar untuk drag + tombol
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 38)
Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Topbar.BorderSizePixel = 0
Topbar.Parent = Window

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 10)
TopbarCorner.Parent = Topbar

-- Biar corner topbar tidak bikin bawahnya ikut round aneh
local TopbarCover = Instance.new("Frame")
TopbarCover.Size = UDim2.new(1, 0, 0, 10)
TopbarCover.Position = UDim2.new(0, 0, 1, -10)
TopbarCover.BackgroundColor3 = Topbar.BackgroundColor3
TopbarCover.BorderSizePixel = 0
TopbarCover.Parent = Topbar

-- Judul
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dj Hub"
Title.TextSize = 16
Title.Font = Enum.Font.GothamSemibold
Title.TextColor3 = Color3.fromRGB(235, 235, 235)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

-- Tombol Close
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 38, 0, 26)
Close.Position = UDim2.new(1, -44, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
Close.BorderSizePixel = 0
Close.Text = "X"
Close.TextSize = 14
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Parent = Topbar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

-- Tombol Minimize
local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.new(0, 38, 0, 26)
Minimize.Position = UDim2.new(1, -88, 0, 6)
Minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Minimize.BorderSizePixel = 0
Minimize.Text = "-"
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.Parent = Topbar

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 8)
MiniCorner.Parent = Minimize

-- Container isi (yang bakal di-hide saat minimize)
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -38)
Content.Position = UDim2.new(0, 0, 0, 38)
Content.BackgroundTransparency = 1
Content.Parent = Window

-- Contoh isi: label + tombol dummy
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -24, 0, 40)
Info.Position = UDim2.new(0, 12, 0, 12)
Info.BackgroundTransparency = 1
Info.Text = "Isi menu kamu taruh di sini."
Info.TextSize = 14
Info.Font = Enum.Font.Gotham
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Content

local Dummy = Instance.new("TextButton")
Dummy.Size = UDim2.new(0, 160, 0, 34)
Dummy.Position = UDim2.new(0, 12, 0, 60)
Dummy.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
Dummy.BorderSizePixel = 0
Dummy.Text = "Button Contoh"
Dummy.TextSize = 14
Dummy.Font = Enum.Font.GothamSemibold
Dummy.TextColor3 = Color3.fromRGB(255, 255, 255)
Dummy.Parent = Content

local DummyCorner = Instance.new("UICorner")
DummyCorner.CornerRadius = UDim.new(0, 8)
DummyCorner.Parent = Dummy

--// Drag logic (Topbar)
local dragging = false
local dragStart
local startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	Window.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

Topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Window.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Topbar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			updateDrag(input)
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

--// Minimize & Close
local minimized = false
local normalSize = Window.Size
local minimizedSize = UDim2.new(0, 420, 0, 38)

Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		Content.Visible = false
		Window.Size = minimizedSize
		Minimize.Text = "+"
	else
		Content.Visible = true
		Window.Size = normalSize
		Minimize.Text = "-"
	end
end)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

print("GUI Loaded ✅")
