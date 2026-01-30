--// Dj Hub (SAFE untuk game kamu sendiri): Draggable GUI + Minimize + Close + ESP Toggle (Celestial/Common) + No Tsu Toggle
--// LocalScript di StarterPlayerScripts / StarterGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

--========================
-- RemoteEvent (client <-> server)
--========================
local REMOTE_NAME = "DjHub_NoTsu"
local NoTsuRemote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not NoTsuRemote then
	NoTsuRemote = Instance.new("RemoteEvent")
	NoTsuRemote.Name = REMOTE_NAME
	NoTsuRemote.Parent = ReplicatedStorage
end

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
Window.Size = UDim2.new(0, 420, 0, 260)
Window.Position = UDim2.new(0.5, -210, 0.5, -130)
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
Info.Text = "ESP: Celestial/Common + No Tsu"
Info.TextSize = 14
Info.Font = Enum.Font.Gotham
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Content

local EspCelestialBtn = Instance.new("TextButton")
EspCelestialBtn.Size = UDim2.new(0, 180, 0, 34)
EspCelestialBtn.Position = UDim2.new(0, 12, 0, 60)
EspCelestialBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
EspCelestialBtn.BorderSizePixel = 0
EspCelestialBtn.Text = "ESP Celestial: OFF"
EspCelestialBtn.TextSize = 14
EspCelestialBtn.Font = Enum.Font.GothamSemibold
EspCelestialBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspCelestialBtn.Parent = Content
Instance.new("UICorner", EspCelestialBtn).CornerRadius = UDim.new(0, 8)

local EspCommonBtn = Instance.new("TextButton")
EspCommonBtn.Size = UDim2.new(0, 180, 0, 34)
EspCommonBtn.Position = UDim2.new(0, 12, 0, 104)
EspCommonBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
EspCommonBtn.BorderSizePixel = 0
EspCommonBtn.Text = "ESP Common: OFF"
EspCommonBtn.TextSize = 14
EspCommonBtn.Font = Enum.Font.GothamSemibold
EspCommonBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspCommonBtn.Parent = Content
Instance.new("UICorner", EspCommonBtn).CornerRadius = UDim.new(0, 8)

-- Tombol No Tsu
local NoTsuBtn = Instance.new("TextButton")
NoTsuBtn.Size = UDim2.new(0, 180, 0, 34)
NoTsuBtn.Position = UDim2.new(0, 210, 0, 60)
NoTsuBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
NoTsuBtn.BorderSizePixel = 0
NoTsuBtn.Text = "No Tsu: OFF"
NoTsuBtn.TextSize = 14
NoTsuBtn.Font = Enum.Font.GothamSemibold
NoTsuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoTsuBtn.Parent = Content
Instance.new("UICorner", NoTsuBtn).CornerRadius = UDim.new(0, 8)

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
-- ESP Engine (fixed naming)
--========================
local ESP = {
	enabled = { Celestial = false, Common = false },
	connections = { Celestial = nil, Common = nil },
	markers = {} -- [RenderedBrainrotModel] = {hl=..., bb=..., ac=...}
}

local function getBrainrotName(rendered)
	for _, ch in ipairs(rendered:GetChildren()) do
		if ch:IsA("Model") then
			return ch.Name
		end
	end
	return rendered.Name
end

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

	local brainrotName = getBrainrotName(rendered)

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
	txt.Text = ("%s: %s"):format(labelPrefix, brainrotName)
	txt.Parent = bb

	local ac = rendered.AncestryChanged:Connect(function(_, parentNow)
		if not parentNow then
			removeMarker(rendered)
		end
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

local function removeMarkersInFolder(folder)
	for rendered, _ in pairs(ESP.markers) do
		if rendered and rendered:IsDescendantOf(folder) then
			removeMarker(rendered)
		end
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
		warn(("Folder tidak ketemu: workspace.ActiveBrainrots.%s"):format(folderName))
		return
	end

	if not isOn then
		removeMarkersInFolder(folder)
		return
	end

	scanFolder(folder, labelPrefix)
	ESP.connections[modeName] = folder.ChildAdded:Connect(function(child)
		addMarker(child, labelPrefix)
	end)
end

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
-- No Tsu toggle (client -> server)
--========================
local noTsuEnabled = false

NoTsuBtn.MouseButton1Click:Connect(function()
	noTsuEnabled = not noTsuEnabled
	NoTsuBtn.Text = "No Tsu: " .. (noTsuEnabled and "ON" or "OFF")
	NoTsuBtn.BackgroundColor3 = noTsuEnabled and Color3.fromRGB(50, 140, 90) or Color3.fromRGB(70, 70, 70)

	-- kirim status ke server
	NoTsuRemote:FireServer(noTsuEnabled)
end)

--========================
-- Close cleanup
--========================
local function cleanupAll()
	for _, conn in pairs(ESP.connections) do
		if conn then conn:Disconnect() end
	end
	ESP.connections.Celestial = nil
	ESP.connections.Common = nil

	for rendered, _ in pairs(ESP.markers) do
		removeMarker(rendered)
	end
end

Close.MouseButton1Click:Connect(function()
	-- matikan no tsu saat close (opsional)
	pcall(function()
		if noTsuEnabled then
			NoTsuRemote:FireServer(false)
		end
	end)

	cleanupAll()
	ScreenGui:Destroy()
end)

print("✅ GUI spawned. Parent:", parent:GetFullName())
