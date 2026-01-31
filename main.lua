jenganjenggggg

-- Menunggu sampai game benar-benar siap
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Menunggu LocalPlayer
local lp = Players.LocalPlayer
while not lp do
    task.wait(0.1)
    lp = Players.LocalPlayer
end

--========================
-- GUI Parent Setup
--========================
local function pickGuiParent()
	if lp then
		local pg = lp:FindFirstChildOfClass("PlayerGui")
		if pg then return pg end
	end
	local ok, core = pcall(function() return game:GetService("CoreGui") end)
	if ok and core then return core end
    warn("Dj Hub: Gagal menemukan GUI Parent!") -- Notifikasi jika gagal
	return nil
end

local parent = pickGuiParent()
if not parent then return end

-- Hapus GUI lama jika ada
pcall(function()
	local old = parent:FindFirstChild("DjWindowGUI")
	if old then old:Destroy() end
end)

--========================
-- Build Main GUI
--========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjWindowGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parent

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 420, 0, 260) 
Window.Position = UDim2.new(0.5, -210, 0.5, -130)
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Gabungan Source 1 & 2 [cite: 1, 2]
Window.BorderSizePixel = 0
Window.Active = true
Window.Parent = ScreenGui

Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 10)

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 38)
Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Topbar.BorderSizePixel = 0
Topbar.Parent = Window
Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dj Hub - Premium v2"
Title.TextSize = 16
Title.Font = Enum.Font.GothamSemibold
Title.TextColor3 = Color3.fromRGB(235, 235, 235)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 38, 0, 26)
Close.Position = UDim2.new(1, -44, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Parent = Topbar
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

local Minimize = Instance.new("TextButton") -- [cite: 3]
Minimize.Size = UDim2.new(0, 38, 0, 26)
Minimize.Position = UDim2.new(1, -88, 0, 6)
Minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.Parent = Topbar
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 8)

-- Scrolling Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -38)
ContentFrame.Position = UDim2.new(0, 0, 0, 38)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Window

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -10)
Scroll.Position = UDim2.new(0, 5, 0, 5)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = ContentFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", Scroll).PaddingTop = UDim.new(0, 5)

-- Helper Button Function
local function createButton(text, color, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 380, 0, 40) -- [cite: 4]
	btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 70)
	btn.Text = text
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.LayoutOrder = order
	btn.Parent = Scroll
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

--========================
-- Feature Buttons
--========================
local PlatformBtn     = createButton("Platform: OFF", Color3.fromRGB(40, 120, 180), 1)
local NoclipBtn       = createButton("Noclip: OFF", Color3.fromRGB(100, 50, 150), 2)
local EspDivineBtn    = createButton("ESP Divine: OFF", Color3.fromRGB(218, 165, 32), 3)
local EspCelestialBtn = createButton("ESP Celestial: OFF", Color3.fromRGB(70, 130, 180), 4)
local EspCommonBtn    = createButton("ESP Common: OFF", Color3.fromRGB(100, 100, 100), 5)
local DelWallsBtn      = createButton("Delete Walls (Safe)", Color3.fromRGB(180, 100, 40), 6)
local FastTakeBtn     = createButton("Fast Take: OFF", Color3.fromRGB(200, 150, 50), 7)

--========================
-- 1. PLATFORM LOGIC (STABLE) [cite: 5]
--========================
local platformEnabled = false
local pPart, pConn, lastY = nil, nil, 0

PlatformBtn.MouseButton1Click:Connect(function()
	platformEnabled = not platformEnabled
	PlatformBtn.Text = "Platform: " .. (platformEnabled and "ON" or "OFF")
	PlatformBtn.BackgroundColor3 = platformEnabled and Color3.fromRGB(60, 170, 255) or Color3.fromRGB(40, 120, 180)

	if platformEnabled then
		pPart = Instance.new("Part", workspace)
		pPart.Name = "DjPlatform"
		pPart.Size = Vector3.new(15, 0.5, 15)
		pPart.Anchored = true
		pPart.Transparency = 0.5
		pPart.Material = Enum.Material.ForceField
		pPart.Color = Color3.fromRGB(0, 255, 255)

		if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			lastY = lp.Character.HumanoidRootPart.Position.Y - 3.2
		end

		pConn = RunService.PostSimulation:Connect(function()
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = lp.Character.HumanoidRootPart
				local hum = lp.Character:FindFirstChild("Humanoid")
				if hum and hum.FloorMaterial == Enum.Material.Air then
					lastY = hrp.Position.Y - 3.2
				end
				pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z)
			end
		end)
	else
		if pConn then pConn:Disconnect() pConn = nil end
		if pPart then pPart:Destroy() pPart = nil end -- [cite: 6]
	end
end)

--========================
-- 2. NOCLIP LOGIC
--========================
local noclipOn = false
local noclipConn = nil

NoclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	NoclipBtn.Text = "Noclip: " .. (noclipOn and "ON" or "OFF")
	NoclipBtn.BackgroundColor3 = noclipOn and Color3.fromRGB(140, 70, 200) or Color3.fromRGB(100, 50, 150)
	
	if noclipOn then
		noclipConn = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, v in pairs(lp.Character:GetDescendants()) do
					if v:IsA("BasePart") then v.CanCollide = false end
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	end
end)

--========================
-- 3. ESP SYSTEM
--========================
local ESP = { enabled = {}, connections = {}, markers = {} }

local function removeMarker(obj)
	local data = ESP.markers[obj]
	if data then
		pcall(function() data.hl:Destroy() data.bb:Destroy() data.ac:Disconnect() end)
		ESP.markers[obj] = nil
	end
end

local function addMarker(obj, label)
	if not obj:IsA("Model") or obj.Name ~= "RenderedBrainrot" then return end -- [cite: 7]
	local root = obj:FindFirstChild("Root") or obj:FindFirstChildWhichIsA("BasePart", true)
	if not root or ESP.markers[obj] then return end

	local hl = Instance.new("Highlight", obj)
	hl.FillColor = (label == "Divine" and Color3.fromRGB(255,215,0)) or (label == "Celestial" and Color3.fromRGB(0,255,255)) or Color3.fromRGB(200,200,200)

	local bb = Instance.new("BillboardGui", obj)
	bb.Adornee = root
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0, 3, 0)
	
	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,1,1)
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.GothamBold
	txt.Text = label .. " Brainrot"

	ESP.markers[obj] = { hl = hl, bb = bb, ac = obj.AncestryChanged:Connect(function() if not obj.Parent then removeMarker(obj) end end) }
end

local function toggleEsp(mode, folderName, btn)
	ESP.enabled[mode] = not ESP.enabled[mode]
	local isOn = ESP.enabled[mode]
	btn.Text = "ESP "..mode..": "..(isOn and "ON" or "OFF") -- [cite: 8]
	btn.BackgroundColor3 = isOn and Color3.fromRGB(50, 140, 90) or Color3.fromRGB(70, 70, 70)

	if ESP.connections[mode] then ESP.connections[mode]:Disconnect() end
	local abFolder = workspace:FindFirstChild("ActiveBrainrots")
	local folder = abFolder and abFolder:FindFirstChild(folderName)
	
	if isOn and folder then
		for _, v in pairs(folder:GetChildren()) do addMarker(v, mode) end
		ESP.connections[mode] = folder.ChildAdded:Connect(function(c) addMarker(c, mode) end)
	else
		for obj, _ in pairs(ESP.markers) do 
			if folder and obj:IsDescendantOf(folder) then 
				removeMarker(obj) 
			end 
		end
	end
end

EspDivineBtn.MouseButton1Click:Connect(function() toggleEsp("Divine", "Divine", EspDivineBtn) end)
EspCelestialBtn.MouseButton1Click:Connect(function() toggleEsp("Celestial", "Celestial", EspCelestialBtn) end)
EspCommonBtn.MouseButton1Click:Connect(function() toggleEsp("Common", "Common", EspCommonBtn) end)

--========================
-- 4. DELETE WALLS
--========================
DelWallsBtn.MouseButton1Click:Connect(function()
	local walls = workspace:FindFirstChild("VIPWalls") or workspace:FindFirstChild("Wallses")
	if walls then
		for _, v in pairs(walls:GetChildren()) do v:Destroy() end
		DelWallsBtn.Text = "Walls Removed!"
		DelWallsBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	else
		DelWallsBtn.Text = "Walls Folder Not Found"
	end
end)

--========================
-- 5. FAST TAKE LOGIC
--========================
local fastTakeEnabled = false
local fastTakeConnections = {}

local function processTakePrompt(renderedBrainrot)
	if not renderedBrainrot:IsA("Model") then return end
	-- Masuk ke model spesifik di dalam RenderedBrainrot (misal: Tim Cheese)
	for _, itemModel in pairs(renderedBrainrot:GetChildren()) do
		if itemModel:IsA("Model") then
			local root = itemModel:FindFirstChild("Root")
			if root then
				local prompt = root:FindFirstChild("TakePromt") or root:FindFirstChildWhichIsA("ProximityPrompt")
				if prompt then
					prompt.HoldDuration = 0
					prompt.MaxActivationDistance = 15
				end
			end
		end
	end
end

FastTakeBtn.MouseButton1Click:Connect(function()
	fastTakeEnabled = not fastTakeEnabled
	FastTakeBtn.Text = "Fast Take: " .. (fastTakeEnabled and "ON" or "OFF")
	FastTakeBtn.BackgroundColor3 = fastTakeEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(200, 150, 50)

	local ab = workspace:FindFirstChild("ActiveBrainrots")
	if not ab then return end

	if fastTakeEnabled then
		for _, category in pairs(ab:GetChildren()) do
			if category:IsA("Folder") then
				-- Terapkan ke yang sudah ada
				for _, rb in pairs(category:GetChildren()) do
					processTakePrompt(rb)
				end
				-- Monitor item baru yang muncul
				fastTakeConnections[category.Name] = category.ChildAdded:Connect(function(child)
					task.wait(0.2)
					processTakePrompt(child)
				end)
			end
		end
	else
		-- Matikan monitor
		for _, conn in pairs(fastTakeConnections) do conn:Disconnect() end
		fastTakeConnections = {}
	end
end)

--========================
-- GUI Systems (Drag/Min/Close)
--========================
local dragging, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then -- [cite: 9]
		dragging = true dragStart = input.Position startPos = Window.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

Minimize.MouseButton1Click:Connect(function()
	ContentFrame.Visible = not ContentFrame.Visible
	Window.Size = ContentFrame.Visible and UDim2.new(0, 420, 0, 260) or UDim2.new(0, 420, 0, 38)
	Minimize.Text = ContentFrame.Visible and "-" or "+"
end)

Close.MouseButton1Click:Connect(function()
	if pConn then pConn:Disconnect() end
	if pPart then pPart:Destroy() end
	if noclipConn then noclipConn:Disconnect() end
	for _, c in pairs(ESP.connections) do if c then c:Disconnect() end end
	for _, c in pairs(fastTakeConnections) do if c then c:Disconnect() end end
	ScreenGui:Destroy()
end)

print("✅ Dj Hub Loaded Successfully!")
