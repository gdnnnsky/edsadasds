--// Dj Hub (Scrollable + Noclip + Divine)
--// LocalScript di StarterPlayerScripts / StarterGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

--========================
-- GUI Parent (robust)
--========================
local function pickGuiParent()
	if lp then
		local pg = lp:FindFirstChildOfClass("PlayerGui")
		if pg then return pg end
	end
	local ok, core = pcall(function() return game:GetService("CoreGui") end)
	if ok and core then return core end
	return nil
end

local parent = pickGuiParent()
if not parent then
	warn("❌ Gagal dapat parent GUI (PlayerGui/CoreGui).")
	return
end

pcall(function()
	local old = parent:FindFirstChild("DjWindowGUI")
	if old then old:Destroy() end
end)

--========================
-- Build GUI
--========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjWindowGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = parent

local Window = Instance.new("Frame")
Window.Name = "Window"
-- [UPDATE] Ukuran GUI dibuat Compact (Kecil) karena sudah ada Scroll
Window.Size = UDim2.new(0, 420, 0, 260) 
Window.Position = UDim2.new(0.5, -210, 0.5, -130)
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Window.BorderSizePixel = 0
Window.Active = true
Window.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Window

-- Header / Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 38)
Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Topbar.BorderSizePixel = 0
Topbar.Parent = Window

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 10)
TopbarCorner.Parent = Topbar

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
Title.Text = "Dj Hub - Scroll & Noclip"
Title.TextSize = 16
Title.Font = Enum.Font.GothamSemibold
Title.TextColor3 = Color3.fromRGB(235, 235, 235)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

-- Tombol Close & Minimize
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 38, 0, 26)
Close.Position = UDim2.new(1, -44, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Parent = Topbar
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 38, 0, 26)
Minimize.Position = UDim2.new(1, -88, 0, 6)
Minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.Parent = Topbar
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 8)

--========================
-- SCROLLING FRAME SETUP
--========================
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -38)
ContentFrame.Position = UDim2.new(0, 0, 0, 38)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Window

-- Label Judul Menu
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -24, 0, 30)
Info.Position = UDim2.new(0, 12, 0, 5)
Info.BackgroundTransparency = 1
Info.Text = "Scroll down for more features"
Info.TextSize = 12
Info.Font = Enum.Font.Gotham
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = ContentFrame

-- Container Scroll
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Size = UDim2.new(1, -10, 1, -40) -- Full size minus padding
ScrollContainer.Position = UDim2.new(0, 5, 0, 35)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 6
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Akan otomatis dihitung
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y -- Fitur penting agar auto-expand
ScrollContainer.Parent = ContentFrame

-- Layout List (Agar tombol otomatis rapi ke bawah)
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8) -- Jarak antar tombol
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Padding agar tidak nempel pinggir
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.Parent = ScrollContainer

--========================
-- Helper Function: Create Button
--========================
-- Fungsi ini biar kita gak capek ngetik ulang settingan tombol
local function createButton(text, color, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 380, 0, 40) -- Lebar tombol mengikuti scroll container
	btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 70)
	btn.Text = text
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamSemibold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.LayoutOrder = order or 0
	btn.Parent = ScrollContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	return btn
end

--========================
-- BUTTONS CREATION
--========================

-- 1. Noclip (FITUR BARU)
local NoclipBtn = createButton("Noclip: OFF", Color3.fromRGB(100, 50, 150), 1)

-- 2. ESP Buttons
local EspCelestialBtn = createButton("ESP Celestial: OFF", nil, 2)
local EspCommonBtn    = createButton("ESP Common: OFF", nil, 3)
local EspDivineBtn    = createButton("ESP Divine: OFF", nil, 4)

-- 3. Delete Walls
local DelWallsBtn = createButton("Delete Walls (Safe)", Color3.fromRGB(180, 100, 40), 5)

--========================
-- LOGIC & FEATURES
--========================

-- 1. NOCLIP LOGIC
local noclipOn = false
local noclipConnection = nil

local function toggleNoclip()
	noclipOn = not noclipOn
	
	if noclipOn then
		NoclipBtn.Text = "Noclip: ON"
		NoclipBtn.BackgroundColor3 = Color3.fromRGB(140, 70, 200)
		
		-- Loop RunService
		noclipConnection = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, part in pairs(lp.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide == true then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		NoclipBtn.Text = "Noclip: OFF"
		NoclipBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
		
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
	end
end

NoclipBtn.MouseButton1Click:Connect(toggleNoclip)

-- 2. ESP LOGIC (Updated with Divine)
local ESP = {
	enabled = { Celestial = false, Common = false, Divine = false },
	connections = { Celestial = nil, Common = nil, Divine = nil },
	markers = {}
}

local function getRootPart(rendered)
	local root = rendered:FindFirstChild("Root")
	if root and root:IsA("BasePart") then return root end
	return rendered:FindFirstChildWhichIsA("BasePart", true)
end

local function removeMarker(rendered)
	local pack = ESP.markers[rendered]
	if not pack then return end
	pcall(function() pack.hl:Destroy() end)
	pcall(function() pack.bb:Destroy() end)
	if pack.ac then pcall(function() pack.ac:Disconnect() end) end
	ESP.markers[rendered] = nil
end

local function addMarker(rendered, labelPrefix)
	if not rendered or not rendered:IsA("Model") then return end
	if rendered.Name ~= "RenderedBrainrot" then return end
	if ESP.markers[rendered] then return end

	local rootPart = getRootPart(rendered)
	if not rootPart then return end

	local modelName = "Unknown"
	for _, ch in ipairs(rendered:GetChildren()) do
		if ch:IsA("Model") then modelName = ch.Name break end
	end

	local hl = Instance.new("Highlight")
	hl.Name = "DjESP_HL"
	hl.Adornee = rendered
	hl.Parent = rendered
	hl.FillTransparency = 0.5
	hl.OutlineTransparency = 0

	-- Custom Colors
	if labelPrefix == "Divine" then
		hl.FillColor = Color3.fromRGB(255, 215, 0) -- Gold
		hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	elseif labelPrefix == "Celestial" then
		hl.FillColor = Color3.fromRGB(0, 255, 255) -- Cyan
	else
		hl.FillColor = Color3.fromRGB(255, 0, 0) -- Red default
	end

	local bb = Instance.new("BillboardGui")
	bb.Name = "DjESP_BB"
	bb.Adornee = rootPart
	bb.Size = UDim2.new(0, 260, 0, 34)
	bb.StudsOffset = Vector3.new(0, 2.8, 0)
	bb.AlwaysOnTop = true
	bb.Parent = rendered

	local txt = Instance.new("TextLabel")
	txt.BackgroundTransparency = 1
	txt.Size = UDim2.new(1, 0, 1, 0)
	txt.Font = Enum.Font.GothamBold
	txt.TextSize = 14
	txt.TextColor3 = Color3.fromRGB(255, 255, 255)
	txt.TextStrokeTransparency = 0.6
	txt.Text = ("%s: %s"):format(labelPrefix, modelName)
	if labelPrefix == "Divine" then txt.TextColor3 = Color3.fromRGB(255, 220, 50) end
	txt.Parent = bb

	local ac = rendered.AncestryChanged:Connect(function(_, parentNow)
		if not parentNow then removeMarker(rendered) end
	end)

	ESP.markers[rendered] = { hl = hl, bb = bb, ac = ac }
end

local function getFolder(folderName)
	local root = workspace:FindFirstChild("ActiveBrainrots")
	if not root then return nil end
	return root:FindFirstChild(folderName)
end

local function scanFolder(folder, labelPrefix)
	for _, child in ipairs(folder:GetChildren()) do
		addMarker(child, labelPrefix)
	end
end

local function setEsp(modeName, folderName, labelPrefix, isOn, btn)
	ESP.enabled[modeName] = isOn
	if ESP.connections[modeName] then
		ESP.connections[modeName]:Disconnect()
		ESP.connections[modeName] = nil
	end
	
	-- Update Button Visual
	btn.Text = "ESP " .. labelPrefix .. ": " .. (isOn and "ON" or "OFF")
	btn.BackgroundColor3 = isOn and Color3.fromRGB(50, 140, 90) or Color3.fromRGB(70, 70, 70)

	local folder = getFolder(folderName)
	if not folder then return end
	
	if not isOn then
		for rendered, _ in pairs(ESP.markers) do
			if rendered:IsDescendantOf(folder) then removeMarker(rendered) end
		end
		return
	end
	
	scanFolder(folder, labelPrefix)
	ESP.connections[modeName] = folder.ChildAdded:Connect(function(child)
		addMarker(child, labelPrefix)
	end)
end

EspCelestialBtn.MouseButton1Click:Connect(function()
	setEsp("Celestial", "Celestial", "Celestial", not ESP.enabled.Celestial, EspCelestialBtn)
end)

EspCommonBtn.MouseButton1Click:Connect(function()
	setEsp("Common", "Common", "Common", not ESP.enabled.Common, EspCommonBtn)
end)

EspDivineBtn.MouseButton1Click:Connect(function()
	setEsp("Divine", "Divine", "Divine", not ESP.enabled.Divine, EspDivineBtn)
end)

-- 3. DELETE WALLS LOGIC
local wallsDeleted = false
DelWallsBtn.MouseButton1Click:Connect(function()
	if wallsDeleted then
		DelWallsBtn.Text = "Already Deleted!"
		wait(1)
		DelWallsBtn.Text = "Walls Deleted (Rejoin to fix)"
		return
	end
	local wallModel = workspace:FindFirstChild("VIPWalls")
	if wallModel then
		local count = 0
		for _, child in ipairs(wallModel:GetChildren()) do
			if child.Name == "VIP" or child.Name == "VIP_PLUS" then
				child:Destroy()
				count = count + 1
			end
		end
		wallsDeleted = true
		DelWallsBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		DelWallsBtn.Text = "Deleted " .. count .. " blocks!"
	else
		DelWallsBtn.Text = "Model 'VIPWalls' not found!"
	end
end)

--========================
-- GUI DRAGGING
--========================
local dragging, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Window.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--========================
-- CLEANUP
--========================
local minimized = false
local normalSize = Window.Size
local minimizedSize = UDim2.new(0, 420, 0, 38)

Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		ContentFrame.Visible = false
		Window.Size = minimizedSize
		Minimize.Text = "+"
	else
		ContentFrame.Visible = true
		Window.Size = normalSize
		Minimize.Text = "-"
	end
end)

Close.MouseButton1Click:Connect(function()
	-- Matikan Noclip loop jika ada
	if noclipConnection then noclipConnection:Disconnect() end
	-- Matikan ESP loop
	for _, conn in pairs(ESP.connections) do if conn then conn:Disconnect() end end
	for rendered, _ in pairs(ESP.markers) do removeMarker(rendered) end
	ScreenGui:Destroy()
end)

print("✅ GUI Updated: Scrollable + Noclip + Divine.")
