--// Draggable GUI + Minimize + Close (Robust / Anti Gagal)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer

-- pilih parent GUI paling aman utk executor
local function pickGuiParent()
	-- beberapa executor punya gethui()
	if typeof(gethui) == "function" then
		local ok, hui = pcall(gethui)
		if ok and hui then return hui end
	end

	-- Synapse-style (kalau ada)
	if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
		-- nanti kita protect setelah parent
	end

	-- fallback umum
	local ok, core = pcall(function() return game:GetService("CoreGui") end)
	if ok and core then return core end

	-- fallback terakhir
	if lp then
		local pg = lp:FindFirstChildOfClass("PlayerGui")
		if pg then return pg end
	end

	return nil
end

local parent = pickGuiParent()
if not parent then
	warn("❌ Gagal dapat parent GUI (gethui/CoreGui/PlayerGui).")
	return
end

-- bersihin GUI lama biar ga dobel
pcall(function()
	local old = parent:FindFirstChild("DjWindowGUI")
	if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjWindowGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = parent

-- protect kalau executor mendukung (optional)
pcall(function()
	if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
		syn.protect_gui(ScreenGui)
	end
end)

-- Window utama
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 420, 0, 260)
Window.Position = UDim2.new(0.5, -210, 0.5, -130)
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Window.BorderSizePixel = 0
Window.Active = true
Window.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Window

-- Topbar (drag)
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 38)
Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Topbar.BorderSizePixel = 0
Topbar.Parent = Window

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 10)
TopbarCorner.Parent = Topbar

-- cover supaya bawah topbar tetap kotak
local TopbarCover = Instance.new("Frame")
TopbarCover.Size = UDim2.new(1, 0, 0, 10)
TopbarCover.Position = UDim2.new(0, 0, 1, -10)
TopbarCover.BackgroundColor3 = Topbar.BackgroundColor3
TopbarCover.BorderSizePixel = 0
TopbarCover.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dj Hub"
Title.TextSize = 16
Title.Font = Enum.Font.GothamSemibold
Title.TextColor3 = Color3.fromRGB(235, 235, 235)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local Close = Instance.new("TextButton")
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

local Minimize = Instance.new("TextButton")
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

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -38)
Content.Position = UDim2.new(0, 0, 0, 38)
Content.BackgroundTransparency = 1
Content.Parent = Window

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -24, 0, 40)
Info.Position = UDim2.new(0, 12, 0, 12)
Info.BackgroundTransparency = 1
Info.Text = "GUI berhasil dibuat ✅"
Info.TextSize = 14
Info.Font = Enum.Font.Gotham
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Content

-- Drag logic
local dragging = false
local dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	Window.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

Topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

-- Minimize & Close
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

print("✅ GUI spawned. Parent:", parent:GetFullName())

