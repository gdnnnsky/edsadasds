--// Dj Hub (SAFE untuk game kamu sendiri): Draggable GUI + Minimize + Close + ESP + Wall Remover
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
Window.Size = UDim2.new(0, 420, 0, 300) -- Sedikit diperbesar tingginya
Window.Position = UDim2.new(0.5, -210, 0.5, -150)
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Window.BorderSizePixel = 0
Window.Active = true
Window.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Window

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
Title.Text = "Dj Hub - Map Test"
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
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

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
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 8)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -38)
Content.Position = UDim2.new(0, 0, 0, 38)
Content.BackgroundTransparency = 1
Content.Parent = Window

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -24, 0, 40)
Info.Position = UDim2.new(0, 12, 0, 12)
Info.BackgroundTransparency = 1
Info.Text = "Menu Options"
Info.TextSize = 14
Info.Font = Enum.Font.Gotham
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Content

-- Button 1: Celestial
local EspCelestialBtn = Instance.new("TextButton")
EspCelestialBtn.Size = UDim2.new(0, 180, 0, 34)
EspCelestialBtn.Position = UDim2.new(0, 12, 0, 50)
EspCelestialBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
EspCelestialBtn.BorderSizePixel = 0
EspCelestialBtn.Text = "ESP Celestial: OFF"
EspCelestialBtn.TextSize = 14
EspCelestialBtn.Font = Enum.Font.GothamSemibold
EspCelestialBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspCelestialBtn.Parent = Content
Instance.new("UICorner", EspCelestialBtn).CornerRadius = UDim.new(0, 8)

-- Button 2: Common
local EspCommonBtn = Instance.new("TextButton")
EspCommonBtn.Size = UDim2.new(0, 180, 0, 34)
EspCommonBtn.Position = UDim2.new(0, 12, 0, 94)
EspCommonBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
EspCommonBtn.BorderSizePixel = 0
EspCommonBtn.Text = "ESP Common: OFF"
EspCommonBtn.TextSize = 14
EspCommonBtn.Font = Enum.Font.GothamSemibold
EspCommonBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspCommonBtn.Parent = Content
Instance.new("UICorner", EspCommonBtn).CornerRadius = UDim.new(0, 8)

-- Button 3: Delete Walls (NEW)
local DelWallsBtn = Instance.new("TextButton")
DelWallsBtn.Size = UDim2.new(0, 180, 0, 34)
DelWallsBtn.Position = UDim2.new(0, 12, 0, 138)
DelWallsBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 40) -- Warna beda dikit (Orange)
DelWallsBtn.BorderSizePixel = 0
DelWallsBtn.Text = "Delete Walls (Safe)"
DelWallsBtn.TextSize = 14
DelWallsBtn.Font = Enum.Font.GothamSemibold
DelWallsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DelWallsBtn.Parent = Content
Instance.new("UICorner", DelWallsBtn).CornerRadius = UDim.new(0, 8)


--========================
-- Drag logic
--========================
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

--========================
-- Minimize
--========================
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

--========================
-- ESP Engine
--========================
local ESP = {
	enabled = { Celestial = false, Common = false },
	connections = { Celestial = nil, Common = nil },
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
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Adornee = rendered
	hl.Parent = rendered

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

local function setEsp(modeName, folderName, labelPrefix, isOn)
	ESP.enabled[modeName] = isOn
	if ESP.connections[modeName] then
		ESP.connections[modeName]:Disconnect()
		ESP.connections[modeName] = nil
	end
	local folder = getFolder(folderName)
	if not folder then
		if isOn then warn("Folder ESP not found: " .. folderName) end
		return
	end
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

--========================
-- Button Hooks: ESP
--========================
EspCelestialBtn.MouseButton1Click:Connect(function()
	local newState = not ESP.enabled.Celestial
	setEsp("Celestial", "Celestial", "Celestial", newState)
	EspCelestialBtn.Text = "ESP Celestial: " .. (newState and "ON" or "OFF")
	EspCelestialBtn.BackgroundColor3 = newState and Color3.fromRGB(50, 140, 90) or Color3.fromRGB(70, 70, 70)
end)

EspCommonBtn.MouseButton1Click:Connect(function()
	local newState = not ESP.enabled.Common
	setEsp("Common", "Common", "Common", newState)
	EspCommonBtn.Text = "ESP Common: " .. (newState and "ON" or "OFF")
	EspCommonBtn.BackgroundColor3 = newState and Color3.fromRGB(50, 140, 90) or Color3.fromRGB(70, 70, 70)
end)

--========================
-- Button Hook: DELETE WALLS (NEW FEATURE)
--========================
local wallsDeleted = false

DelWallsBtn.MouseButton1Click:Connect(function()
	if wallsDeleted then
		-- Opsional: Kalau sudah dihapus, kasih notif aja karena tidak bisa dikembalikan tanpa rejoin
		DelWallsBtn.Text = "Already Deleted!"
		wait(1)
		DelWallsBtn.Text = "Walls Deleted (Rejoin to fix)"
		return
	end

	-- Cari Model "Wallses" di workspace
	local wallModel = workspace:FindFirstChild("VIPWalls")
	
	if wallModel then
		local count = 0
		-- Loop semua anak di dalam Wallses
		for _, child in ipairs(wallModel:GetChildren()) do
			-- Cek nama part
			if child.Name == "VIP" or child.Name == "VIP_PLUS" then
				child:Destroy() -- Hapus part
				count = count + 1
			end
		end
		
		if count > 0 then
			wallsDeleted = true
			DelWallsBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60) -- Merah (Destructive action)
			DelWallsBtn.Text = "Deleted " .. count .. " blocks!"
		else
			DelWallsBtn.Text = "No blocks found inside Wallses"
		end
	else
		DelWallsBtn.Text = "Model 'Wallses' not found!"
	end
	
	-- Kembalikan teks status setelah beberapa detik jika gagal/kosong
	if not wallsDeleted then
		wait(2)
		DelWallsBtn.Text = "Delete Walls (Safe)"
	end
end)

--========================
-- Close cleanup
--========================
Close.MouseButton1Click:Connect(function()
	for _, conn in pairs(ESP.connections) do if conn then conn:Disconnect() end end
	for rendered, _ in pairs(ESP.markers) do removeMarker(rendered) end
	ScreenGui:Destroy()
end)

print("✅ GUI Updated with Wall Remover.")
