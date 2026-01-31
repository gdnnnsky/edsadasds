--// Dj Hub (Final Stable Version)
--// Features: Scrollable UI, Stable Platform, Noclip, Multi-ESP, Wall Remover, Fast Take

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

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
	return nil
end

local parent = pickGuiParent()
if not parent then return end

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
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
-- Scrolling Container
--========================
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
	btn.Size = UDim2.new(0, 380, 0, 40)
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
local PlatformBtn    = createButton("Platform: OFF", Color3.fromRGB(40, 120, 180), 1)
local NoclipBtn      = createButton("Noclip: OFF", Color3.fromRGB(100, 50, 150), 2)
local FastTakeBtn    = createButton("Fast Take: OFF", Color3.fromRGB(180, 60, 120), 3)
local EspDivineBtn    = createButton("ESP Divine: OFF", Color3.fromRGB(218, 165, 32), 4)
local EspCelestialBtn = createButton("ESP Celestial: OFF", Color3.fromRGB(70, 130, 180), 5)
local EspCommonBtn    = createButton("ESP Common: OFF", Color3.fromRGB(100, 100, 100), 6)
local DelWallsBtn     = createButton("Delete Walls (Safe)", Color3.fromRGB(180, 100, 40), 7)

--========================
-- 1. PLATFORM LOGIC (STABLE)
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
		if pPart then pPart:Destroy() pPart = nil end
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
-- 3. FAST TAKE LOGIC
--========================
--[[
	Struktur yang dicari:
	workspace/
		ActiveBrainrots/
			[FolderNama] (Divine, Celestial, Common, dll)/
				RenderedBrainrot (Model)/
					[Nama Brainrot] (Model)/
						Root (Part)/
							TakePrompt (ProximityPrompt)
								HoldDuration: 0.5 → 0
								MaxActivationDistance: 8 → 15
]]

local fastTakeOn = false
local fastTakeCache = {} -- simpan original values & connections untuk restore
local fastTakeChildConn = nil

local FAST_TAKE_HOLD = 0
local FAST_TAKE_DIST = 15
local ORIG_HOLD = 0.5
local ORIG_DIST = 8

-- Cari dan ubah TakePrompt di dalam satu RenderedBrainrot
local function applyFastTake(renderedModel)
	if not renderedModel or not renderedModel:IsA("Model") then return end
	if renderedModel.Name ~= "RenderedBrainrot" then return end
	if fastTakeCache[renderedModel] then return end -- sudah diproses

	local prompts = {}

	-- Loop semua child model di dalam RenderedBrainrot (misal: "Tim Cheese")
	for _, brainrotModel in pairs(renderedModel:GetChildren()) do
		if brainrotModel:IsA("Model") then
			local root = brainrotModel:FindFirstChild("Root")
			if root and root:IsA("BasePart") then
				local takePrompt = root:FindFirstChild("TakePrompt")
				if takePrompt and takePrompt:IsA("ProximityPrompt") then
					-- Simpan nilai original sebelum ubah
					local origData = {
						prompt = takePrompt,
						origHold = takePrompt.HoldDuration,
						origDist = takePrompt.MaxActivationDistance
					}
					-- Terapkan nilai Fast Take
					takePrompt.HoldDuration = FAST_TAKE_HOLD
					takePrompt.MaxActivationDistance = FAST_TAKE_DIST
					table.insert(prompts, origData)
				end
			end
		end
	end

	if #prompts > 0 then
		fastTakeCache[renderedModel] = prompts
	end
end

-- Restore nilai original pada satu RenderedBrainrot
local function removeFastTake(renderedModel)
	local prompts = fastTakeCache[renderedModel]
	if not prompts then return end

	for _, data in pairs(prompts) do
		pcall(function()
			if data.prompt and data.prompt.Parent then
				data.prompt.HoldDuration = data.origHold
				data.prompt.MaxActivationDistance = data.origDist
			end
		end)
	end

	fastTakeCache[renderedModel] = nil
end

-- Scan semua folder di ActiveBrainrots dan apply
local function scanAllBrainrots()
	local activeBrainrots = workspace:FindFirstChild("ActiveBrainrots")
	if not activeBrainrots then return end

	for _, folder in pairs(activeBrainrots:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			for _, rendered in pairs(folder:GetChildren()) do
				applyFastTake(rendered)
			end
		end
	end
end

-- Listen untuk RenderedBrainrot baru yang masuk (spawn)
local function startFastTakeListeners()
	local activeBrainrots = workspace:FindFirstChild("ActiveBrainrots")
	if not activeBrainrots then return end

	-- Dengarkan ChildAdded di setiap subfolder
	for _, folder in pairs(activeBrainrots:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			local conn = folder.ChildAdded:Connect(function(child)
				if fastTakeOn then
					applyFastTake(child)
				end
			end)
			-- Simpan connection ke cache folder
			if not fastTakeCache["_folderConns"] then
				fastTakeCache["_folderConns"] = {}
			end
			table.insert(fastTakeCache["_folderConns"], conn)
		end
	end
end

-- Putus semua folder listeners
local function stopFastTakeListeners()
	local conns = fastTakeCache["_folderConns"]
	if conns then
		for _, c in pairs(conns) do
			if c then c:Disconnect() end
		end
	end
	fastTakeCache["_folderConns"] = nil
end

FastTakeBtn.MouseButton1Click:Connect(function()
	fastTakeOn = not fastTakeOn
	FastTakeBtn.Text = "Fast Take: " .. (fastTakeOn and "ON" or "OFF")
	FastTakeBtn.BackgroundColor3 = fastTakeOn and Color3.fromRGB(220, 80, 140) or Color3.fromRGB(180, 60, 120)

	if fastTakeOn then
		scanAllBrainrots()
		startFastTakeListeners()
	else
		-- Restore semua yang sudah diubah
		stopFastTakeListeners()
		for rendered, _ in pairs(fastTakeCache) do
			if rendered ~= "_folderConns" then
				removeFastTake(rendered)
			end
		end
		fastTakeCache = {}
	end
end)

--========================
-- 4. ESP SYSTEM
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
	if not obj:IsA("Model") or obj.Name ~= "RenderedBrainrot" then return end
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
	btn.Text = "ESP "..mode..": "..(isOn and "ON" or "OFF")
	btn.BackgroundColor3 = isOn and Color3.fromRGB(50, 140, 90) or Color3.fromRGB(70, 70, 70)

	if ESP.connections[mode] then ESP.connections[mode]:Disconnect() end
	local folder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild(folderName)
	
	if isOn and folder then
		for _, v in pairs(folder:GetChildren()) do addMarker(v, mode) end
		ESP.connections[mode] = folder.ChildAdded:Connect(function(c) addMarker(c, mode) end)
	else
		for obj, _ in pairs(ESP.markers) do if obj:IsDescendantOf(folder) then removeMarker(obj) end end
	end
end

EspDivineBtn.MouseButton1Click:Connect(function() toggleEsp("Divine", "Divine", EspDivineBtn) end)
EspCelestialBtn.MouseButton1Click:Connect(function() toggleEsp("Celestial", "Celestial", EspCelestialBtn) end)
EspCommonBtn.MouseButton1Click:Connect(function() toggleEsp("Common", "Common", EspCommonBtn) end)

--========================
-- 5. DELETE WALLS
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
-- GUI Systems (Drag/Min/Close)
--========================
local dragging, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
	-- Cleanup Fast Take saat close
	stopFastTakeListeners()
	for rendered, _ in pairs(fastTakeCache) do
		if rendered ~= "_folderConns" then removeFastTake(rendered) end
	end
	fastTakeCache = {}
	-- Cleanup ESP
	for _, c in pairs(ESP.connections) do if c then c:Disconnect() end end
	ScreenGui:Destroy()
end)

print("✅ Dj Hub Loaded - Enjoy!")
