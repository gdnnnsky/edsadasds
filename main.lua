--// Dj Hub (Final Stable Version + Fast Take) [cite: 1]
--// Features: Scrollable UI, Platform, Noclip, Multi-ESP, Wall Remover, Fast Take [cite: 1]

local Players = game:GetService("Players") [cite: 1]
local UIS = game:GetService("UserInputService") [cite: 1]
local RunService = game:GetService("RunService") [cite: 1]

local lp = Players.LocalPlayer [cite: 1]

--========================
-- GUI Parent Setup [cite: 1]
--========================
local function pickGuiParent()
	if lp then
		local pg = lp:FindFirstChildOfClass("PlayerGui") [cite: 1]
		if pg then return pg end [cite: 1]
	end
	local ok, core = pcall(function() return game:GetService("CoreGui") end) [cite: 1]
	if ok and core then return core end [cite: 1]
	return nil [cite: 1]
end

local parent = pickGuiParent() [cite: 1]
if not parent then return end [cite: 1]

pcall(function()
	local old = parent:FindFirstChild("DjWindowGUI") [cite: 1]
	if old then old:Destroy() end [cite: 1]
end)

--========================
-- Build Main GUI [cite: 1]
--========================
local ScreenGui = Instance.new("ScreenGui") [cite: 1]
ScreenGui.Name = "DjWindowGUI" [cite: 1]
ScreenGui.ResetOnSpawn = false [cite: 1]
ScreenGui.Parent = parent [cite: 1]

local Window = Instance.new("Frame") [cite: 1]
Window.Name = "Window" [cite: 1]
Window.Size = UDim2.new(0, 420, 0, 260) [cite: 1]
Window.Position = UDim2.new(0.5, -210, 0.5, -130) [cite: 1]
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25) [cite: 1, 2]
Window.BorderSizePixel = 0 [cite: 1]
Window.Active = true [cite: 1]
Window.Parent = ScreenGui [cite: 1]

Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 10) [cite: 1]

-- Topbar [cite: 1]
local Topbar = Instance.new("Frame") [cite: 1]
Topbar.Size = UDim2.new(1, 0, 0, 38) [cite: 1]
Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35) [cite: 1]
Topbar.BorderSizePixel = 0 [cite: 1]
Topbar.Parent = Window [cite: 1]
Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 10) [cite: 1]

local Title = Instance.new("TextLabel") [cite: 1]
Title.Size = UDim2.new(1, -120, 1, 0) [cite: 1]
Title.Position = UDim2.new(0, 12, 0, 0) [cite: 1]
Title.BackgroundTransparency = 1 [cite: 1]
Title.Text = "Dj Hub - Premium v2" [cite: 1]
Title.TextSize = 16 [cite: 1]
Title.Font = Enum.Font.GothamSemibold [cite: 1]
Title.TextColor3 = Color3.fromRGB(235, 235, 235) [cite: 1]
Title.TextXAlignment = Enum.TextXAlignment.Left [cite: 1]
Title.Parent = Topbar [cite: 1]

local Close = Instance.new("TextButton") [cite: 1]
Close.Size = UDim2.new(0, 38, 0, 26) [cite: 1]
Close.Position = UDim2.new(1, -44, 0, 6) [cite: 1]
Close.BackgroundColor3 = Color3.fromRGB(200, 60, 60) [cite: 1]
Close.Text = "X" [cite: 1]
Close.Font = Enum.Font.GothamBold [cite: 1]
Close.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 1]
Close.Parent = Topbar [cite: 1]
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8) [cite: 1]

local Minimize = Instance.new("TextButton") [cite: 1, 3]
Minimize.Size = UDim2.new(0, 38, 0, 26) [cite: 1]
Minimize.Position = UDim2.new(1, -88, 0, 6) [cite: 1]
Minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70) [cite: 1]
Minimize.Text = "-" [cite: 1]
Minimize.Font = Enum.Font.GothamBold [cite: 1]
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 1]
Minimize.Parent = Topbar [cite: 1]
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 8) [cite: 1]

-- Scrolling Container [cite: 1]
local ContentFrame = Instance.new("Frame") [cite: 1]
ContentFrame.Size = UDim2.new(1, 0, 1, -38) [cite: 1]
ContentFrame.Position = UDim2.new(0, 0, 0, 38) [cite: 1]
ContentFrame.BackgroundTransparency = 1 [cite: 1]
ContentFrame.Parent = Window [cite: 1]

local Scroll = Instance.new("ScrollingFrame") [cite: 1]
Scroll.Size = UDim2.new(1, -10, 1, -10) [cite: 1]
Scroll.Position = UDim2.new(0, 5, 0, 5) [cite: 1]
Scroll.BackgroundTransparency = 1 [cite: 1]
Scroll.BorderSizePixel = 0 [cite: 1]
Scroll.ScrollBarThickness = 4 [cite: 1]
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y [cite: 1]
Scroll.Parent = ContentFrame [cite: 1]

local UIList = Instance.new("UIListLayout") [cite: 1]
UIList.Parent = Scroll [cite: 1]
UIList.Padding = UDim.new(0, 8) [cite: 1]
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center [cite: 1]

Instance.new("UIPadding", Scroll).PaddingTop = UDim.new(0, 5) [cite: 1]

-- Helper Button Function [cite: 1]
local function createButton(text, color, order)
	local btn = Instance.new("TextButton") [cite: 1]
	btn.Size = UDim2.new(0, 380, 0, 40) [cite: 1, 4]
	btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 70) [cite: 1]
	btn.Text = text [cite: 1]
	btn.Font = Enum.Font.GothamSemibold [cite: 1]
	btn.TextSize = 14 [cite: 1]
	btn.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 1]
	btn.LayoutOrder = order [cite: 1]
	btn.Parent = Scroll [cite: 1]
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8) [cite: 1]
	return btn [cite: 1]
end

--========================
-- Feature Buttons [cite: 1]
--========================
local PlatformBtn     = createButton("Platform: OFF", Color3.fromRGB(40, 120, 180), 1) [cite: 1]
local NoclipBtn       = createButton("Noclip: OFF", Color3.fromRGB(100, 50, 150), 2) [cite: 1]
local EspDivineBtn    = createButton("ESP Divine: OFF", Color3.fromRGB(218, 165, 32), 3) [cite: 1]
local EspCelestialBtn = createButton("ESP Celestial: OFF", Color3.fromRGB(70, 130, 180), 4) [cite: 1]
local EspCommonBtn    = createButton("ESP Common: OFF", Color3.fromRGB(100, 100, 100), 5) [cite: 1]
local DelWallsBtn      = createButton("Delete Walls (Safe)", Color3.fromRGB(180, 100, 40), 6) [cite: 1]
local FastTakeBtn     = createButton("Fast Take: OFF", Color3.fromRGB(200, 150, 50), 7) -- NEW FEATURE

--========================
-- 1. PLATFORM LOGIC (STABLE) [cite: 1, 5]
--========================
local platformEnabled = false [cite: 1]
local pPart, pConn, lastY = nil, nil, 0 [cite: 1]

PlatformBtn.MouseButton1Click:Connect(function()
	platformEnabled = not platformEnabled [cite: 1]
	PlatformBtn.Text = "Platform: " .. (platformEnabled and "ON" or "OFF") [cite: 1]
	PlatformBtn.BackgroundColor3 = platformEnabled and Color3.fromRGB(60, 170, 255) or Color3.fromRGB(40, 120, 180) [cite: 1]

	if platformEnabled then
		pPart = Instance.new("Part", workspace) [cite: 1]
		pPart.Name = "DjPlatform" [cite: 1]
		pPart.Size = Vector3.new(15, 0.5, 15) [cite: 1]
		pPart.Anchored = true [cite: 1]
		pPart.Transparency = 0.5 [cite: 1]
		pPart.Material = Enum.Material.ForceField [cite: 1]
		pPart.Color = Color3.fromRGB(0, 255, 255) [cite: 1]

		if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then [cite: 1]
			lastY = lp.Character.HumanoidRootPart.Position.Y - 3.2 [cite: 1]
		end [cite: 1]

		pConn = RunService.PostSimulation:Connect(function() [cite: 1]
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then [cite: 1]
				local hrp = lp.Character.HumanoidRootPart [cite: 1]
				local hum = lp.Character:FindFirstChild("Humanoid") [cite: 1]
				if hum and hum.FloorMaterial == Enum.Material.Air then [cite: 1]
					lastY = hrp.Position.Y - 3.2 [cite: 1]
				end [cite: 1]
				pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z) [cite: 1]
			end [cite: 1]
		end) [cite: 1]
	else
		if pConn then pConn:Disconnect() pConn = nil end [cite: 1, 6]
		if pPart then pPart:Destroy() pPart = nil end [cite: 1, 6]
	end
end)

--========================
-- 2. NOCLIP LOGIC [cite: 1]
--========================
local noclipOn = false [cite: 1]
local noclipConn = nil [cite: 1]

NoclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn [cite: 1]
	NoclipBtn.Text = "Noclip: " .. (noclipOn and "ON" or "OFF") [cite: 1]
	NoclipBtn.BackgroundColor3 = noclipOn and Color3.fromRGB(140, 70, 200) or Color3.fromRGB(100, 50, 150) [cite: 1]
	
	if noclipOn then
		noclipConn = RunService.Stepped:Connect(function() [cite: 1]
			if lp.Character then [cite: 1]
				for _, v in pairs(lp.Character:GetDescendants()) do [cite: 1]
					if v:IsA("BasePart") then v.CanCollide = false end [cite: 1]
				end [cite: 1]
			end [cite: 1]
		end) [cite: 1]
	else
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end [cite: 1]
	end
end)

--========================
-- 3. ESP SYSTEM [cite: 1]
--========================
local ESP = { enabled = {}, connections = {}, markers = {} } [cite: 1]

local function removeMarker(obj) [cite: 1]
	local data = ESP.markers[obj] [cite: 1]
	if data then
		pcall(function() data.hl:Destroy() data.bb:Destroy() data.ac:Disconnect() end) [cite: 1]
		ESP.markers[obj] = nil [cite: 1]
	end
end

local function addMarker(obj, label) [cite: 1]
	if not obj:IsA("Model") or obj.Name ~= "RenderedBrainrot" then return end [cite: 1]
	local root = obj:FindFirstChild("Root") or obj:FindFirstChildWhichIsA("BasePart", true) [cite: 1, 7]
	if not root or ESP.markers[obj] then return end [cite: 1]

	local hl = Instance.new("Highlight", obj) [cite: 1]
	hl.FillColor = (label == "Divine" and Color3.fromRGB(255,215,0)) or (label == "Celestial" and Color3.fromRGB(0,255,255)) or Color3.fromRGB(200,200,200) [cite: 1]

	local bb = Instance.new("BillboardGui", obj) [cite: 1]
	bb.Adornee = root [cite: 1]
	bb.Size = UDim2.new(0, 200, 0, 50) [cite: 1]
	bb.AlwaysOnTop = true [cite: 1]
	bb.StudsOffset = Vector3.new(0, 3, 0) [cite: 1]
	
	local txt = Instance.new("TextLabel", bb) [cite: 1]
	txt.Size = UDim2.new(1,0,1,0) [cite: 1]
	txt.BackgroundTransparency = 1 [cite: 1]
	txt.TextColor3 = Color3.new(1,1,1) [cite: 1]
	txt.TextStrokeTransparency = 0 [cite: 1]
	txt.Font = Enum.Font.GothamBold [cite: 1]
	txt.Text = label .. " Brainrot" [cite: 1]

	ESP.markers[obj] = { hl = hl, bb = bb, ac = obj.AncestryChanged:Connect(function() if not obj.Parent then removeMarker(obj) end end) } [cite: 1]
end

local function toggleEsp(mode, folderName, btn) [cite: 1]
	ESP.enabled[mode] = not ESP.enabled[mode] [cite: 1]
	local isOn = ESP.enabled[mode] [cite: 1]
	btn.Text = "ESP "..mode..": "..(isOn and "ON" or "OFF") [cite: 1, 8]
	btn.BackgroundColor3 = isOn and Color3.fromRGB(50, 140, 90) or Color3.fromRGB(70, 70, 70) [cite: 1]

	if ESP.connections[mode] then ESP.connections[mode]:Disconnect() end [cite: 1]
	local folder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild(folderName) [cite: 1]
	
	if isOn and folder then
		for _, v in pairs(folder:GetChildren()) do addMarker(v, mode) end [cite: 1]
		ESP.connections[mode] = folder.ChildAdded:Connect(function(c) addMarker(c, mode) end) [cite: 1]
	else
		for obj, _ in pairs(ESP.markers) do if obj:IsDescendantOf(folder) then removeMarker(obj) end end [cite: 1]
	end
end

EspDivineBtn.MouseButton1Click:Connect(function() toggleEsp("Divine", "Divine", EspDivineBtn) end) [cite: 1]
EspCelestialBtn.MouseButton1Click:Connect(function() toggleEsp("Celestial", "Celestial", EspCelestialBtn) end) [cite: 1]
EspCommonBtn.MouseButton1Click:Connect(function() toggleEsp("Common", "Common", EspCommonBtn) end) [cite: 1]

--========================
-- 4. DELETE WALLS [cite: 1]
--========================
DelWallsBtn.MouseButton1Click:Connect(function()
	local walls = workspace:FindFirstChild("VIPWalls") or workspace:FindFirstChild("Wallses") [cite: 1]
	if walls then
		for _, v in pairs(walls:GetChildren()) do v:Destroy() end [cite: 1]
		DelWallsBtn.Text = "Walls Removed!" [cite: 1]
		DelWallsBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60) [cite: 1]
	else
		DelWallsBtn.Text = "Walls Folder Not Found" [cite: 1]
	end
end)

--========================
-- 5. FAST TAKE LOGIC (NEW)
--========================
local fastTakeEnabled = false
local fastTakeConnections = {}

local function processTakePrompt(renderedBrainrot)
	if not renderedBrainrot:IsA("Model") then return end
	-- Masuk ke model di dalamnya (misal: Tim Cheese)
	for _, subObj in pairs(renderedBrainrot:GetChildren()) do
		if subObj:IsA("Model") then
			local root = subObj:FindFirstChild("Root")
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
		-- Apply ke yang sudah ada di semua folder (Common, Divine, dll)
		for _, category in pairs(ab:GetChildren()) do
			if category:IsA("Folder") then
				for _, rb in pairs(category:GetChildren()) do
					processTakePrompt(rb)
				end
				-- Monitor spawn baru
				fastTakeConnections[category.Name] = category.ChildAdded:Connect(function(child)
					task.wait(0.2)
					processTakePrompt(child)
				end)
			end
		end
	else
		-- Disconnect monitoring
		for name, conn in pairs(fastTakeConnections) do
			conn:Disconnect()
		end
		fastTakeConnections = {}
	end
end)

--========================
-- GUI Systems (Drag/Min/Close) [cite: 1, 9]
--========================
local dragging, dragStart, startPos [cite: 1]
Topbar.InputBegan:Connect(function(input) [cite: 1]
	if input.UserInputType == Enum.UserInputType.MouseButton1 then [cite: 1, 9]
		dragging = true dragStart = input.Position startPos = Window.Position [cite: 1]
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) [cite: 1]
	end
end)
UIS.InputChanged:Connect(function(input) [cite: 1]
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then [cite: 1]
		local delta = input.Position - dragStart [cite: 1]
		Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) [cite: 1]
	end
end)

Minimize.MouseButton1Click:Connect(function() [cite: 1]
	ContentFrame.Visible = not ContentFrame.Visible [cite: 1]
	Window.Size = ContentFrame.Visible and UDim2.new(0, 420, 0, 260) or UDim2.new(0, 420, 0, 38) [cite: 1]
	Minimize.Text = ContentFrame.Visible and "-" or "+" [cite: 1]
end)

Close.MouseButton1Click:Connect(function() [cite: 1]
	if pConn then pConn:Disconnect() end [cite: 1]
	if pPart then pPart:Destroy() end [cite: 1]
	if noclipConn then noclipConn:Disconnect() end [cite: 1]
	for _, c in pairs(ESP.connections) do if c then c:Disconnect() end end [cite: 1]
	for _, c in pairs(fastTakeConnections) do if c then c:Disconnect() end end
	ScreenGui:Destroy() [cite: 1]
end)

print("✅ Dj Hub Loaded - Fast Take Feature Integrated!") [cite: 1]
