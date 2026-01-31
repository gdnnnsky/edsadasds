dsadaa

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
Window.Size = UDim2.new(0, 420, 0, 260) 
Window.Position = UDim2.new(0.5, -210, 0.5, -130)
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Window.BorderSizePixel = 0
Window.Active = true
Window.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Window

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 38)
Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Topbar.BorderSizePixel = 0
Topbar.Parent = Window

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 10)
TopbarCorner.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dj Hub - Platform Update"
Title.TextSize = 16
Title.Font = Enum.Font.GothamSemibold
Title.TextColor3 = Color3.fromRGB(235, 235, 235)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

-- Close/Minimize
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

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Size = UDim2.new(1, -10, 1, -10)
ScrollContainer.Position = UDim2.new(0, 5, 0, 5)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 6
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollContainer.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.Parent = ScrollContainer

-- Helper Button
local function createButton(text, color, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 380, 0, 40)
	btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 70)
	btn.Text = text
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamSemibold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.LayoutOrder = order
	btn.Parent = ScrollContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

--========================
-- BUTTONS
--========================
local PlatformBtn    = createButton("Platform: OFF", Color3.fromRGB(40, 120, 180), 0)
local NoclipBtn      = createButton("Noclip: OFF", Color3.fromRGB(100, 50, 150), 1)
local EspCelestialBtn = createButton("ESP Celestial: OFF", nil, 2)
local EspCommonBtn    = createButton("ESP Common: OFF", nil, 3)
local EspDivineBtn    = createButton("ESP Divine: OFF", nil, 4)
local DelWallsBtn     = createButton("Delete Walls (Safe)", Color3.fromRGB(180, 100, 40), 5)

--========================
-- 1. PLATFORM LOGIC (FIXED)
--========================
local platformEnabled = false
local pPart = nil
local pConn = nil
local lastY = 0 -- Untuk mengunci tinggi platform

local function togglePlatform()
	platformEnabled = not platformEnabled
	
	if platformEnabled then
		PlatformBtn.Text = "Platform: ON"
		PlatformBtn.BackgroundColor3 = Color3.fromRGB(60, 170, 255)
		
		pPart = Instance.new("Part")
		pPart.Name = "DjPlatform"
		pPart.Size = Vector3.new(15, 0.5, 15) -- Lebih tipis agar tidak bentrok physics
		pPart.Anchored = true
		pPart.Transparency = 0.5
		pPart.Color = Color3.fromRGB(0, 255, 255)
		pPart.Material = Enum.Material.ForceField
		pPart.Parent = workspace
		
		-- Ambil posisi awal saat diaktifkan
		if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			lastY = lp.Character.HumanoidRootPart.Position.Y - 3.2
		end
		
		pConn = RunService.PostSimulation:Connect(function() -- Menggunakan PostSimulation agar lebih stabil
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") then
				local hrp = lp.Character.HumanoidRootPart
				local hum = lp.Character.Humanoid
				
				local targetY = hrp.Position.Y - 3.2
				
				-- LOGIC FIX: 
				-- Jika player sedang melompat atau jatuh (Freefall), platform ikut naik/turun.
				-- Jika player menyentuh sesuatu (Landed), platform diam agar tidak mendorong ke atas.
				if hum.FloorMaterial == Enum.Material.Air then
					lastY = targetY
				end
				
				pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z)
			end
		end)
	else
		PlatformBtn.Text = "Platform: OFF"
		PlatformBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 180)
		
		if pConn then pConn:Disconnect() pConn = nil end
		if pPart then pPart:Destroy() pPart = nil end
	end
end

--========================
-- 2. NOCLIP LOGIC
--========================
local noclipOn = false
local noclipConnection = nil

local function toggleNoclip()
	noclipOn = not noclipOn
	NoclipBtn.Text = "Noclip: " .. (noclipOn and "ON" or "OFF")
	NoclipBtn.BackgroundColor3 = noclipOn and Color3.fromRGB(140, 70, 200) or Color3.fromRGB(100, 50, 150)
	
	if noclipOn then
		noclipConnection = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, part in pairs(lp.Character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	else
		if noclipConnection then noclipConnection:Disconnect() end
	end
end
NoclipBtn.MouseButton1Click:Connect(toggleNoclip)

--========================
-- 3. ESP LOGIC
--========================
local ESP = { enabled = {}, connections = {}, markers = {} }

local function removeMarker(rendered)
	local pack = ESP.markers[rendered]
	if pack then
		pcall(function() pack.hl:Destroy() pack.bb:Destroy() pack.ac:Disconnect() end)
		ESP.markers[rendered] = nil
	end
end

local function addMarker(rendered, labelPrefix)
	if not rendered:IsA("Model") or rendered.Name ~= "RenderedBrainrot" then return end
	if ESP.markers[rendered] then return end
	
	local root = rendered:FindFirstChild("Root") or rendered:FindFirstChildWhichIsA("BasePart", true)
	if not root then return end

	local hl = Instance.new("Highlight", rendered)
	hl.FillTransparency = 0.5
	hl.FillColor = (labelPrefix == "Divine" and Color3.fromRGB(255,215,0)) or (labelPrefix == "Celestial" and Color3.fromRGB(0,255,255)) or Color3.fromRGB(255,0,0)

	local bb = Instance.new("BillboardGui", rendered)
	bb.Adornee = root
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0, 3, 0)
	
	local txt = Instance.new("TextLabel", bb)
	txt.BackgroundTransparency = 1
	txt.Size = UDim2.new(1,0,1,0)
	txt.Text = labelPrefix
	txt.TextColor3 = Color3.new(1,1,1)
	txt.Font = Enum.Font.GothamBold

	ESP.markers[rendered] = { hl = hl, bb = bb, ac = rendered.AncestryChanged:Connect(function() if not rendered.Parent then removeMarker(rendered) end end) }
end

local function setEsp(mode, folderName, isOn, btn)
	ESP.enabled[mode] = isOn
	btn.Text = "ESP "..mode..": "..(isOn and "ON" or "OFF")
	btn.BackgroundColor3 = isOn and Color3.fromRGB(50, 140, 90) or Color3.fromRGB(70, 70, 70)
	
	if ESP.connections[mode] then ESP.connections[mode]:Disconnect() end
	local folder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild(folderName)
	if not folder then return end
	
	if isOn then
		for _, v in pairs(folder:GetChildren()) do addMarker(v, mode) end
		ESP.connections[mode] = folder.ChildAdded:Connect(function(c) addMarker(c, mode) end)
	else
		for rendered, _ in pairs(ESP.markers) do if rendered:IsDescendantOf(folder) then removeMarker(rendered) end end
	end
end

EspCelestialBtn.MouseButton1Click:Connect(function() setEsp("Celestial", "Celestial", not ESP.enabled.Celestial, EspCelestialBtn) end)
EspCommonBtn.MouseButton1Click:Connect(function() setEsp("Common", "Common", not ESP.enabled.Common, EspCommonBtn) end)
EspDivineBtn.MouseButton1Click:Connect(function() setEsp("Divine", "Divine", not ESP.enabled.Divine, EspDivineBtn) end)

--========================
-- 4. DELETE WALLS
--========================
DelWallsBtn.MouseButton1Click:Connect(function()
	local wallModel = workspace:FindFirstChild("VIPWalls")
	if wallModel then
		for _, child in ipairs(wallModel:GetChildren()) do
			if child.Name == "VIP" or child.Name == "VIP_PLUS" then child:Destroy() end
		end
		DelWallsBtn.Text = "Walls Deleted!"
		DelWallsBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	end
end)

--========================
-- DRAG & SYSTEM
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
	if noclipConnection then noclipConnection:Disconnect() end
	for _, conn in pairs(ESP.connections) do if conn then conn:Disconnect() end end
	ScreenGui:Destroy()
end)

print("✅ Platform Feature Loaded.")
