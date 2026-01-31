--// Dj Hub - Premium v2 (Mobile Friendly & Minimalist UI)
--// Credits: Dj Hub Team
--// Features: Platform, Noclip, ESP, Wall Remover, Fast Take (Instant)

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
-- Utility: Draggable System (PC & Mobile)
--========================
local function makeDraggable(gui, handle)
	local dragging, dragInput, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	RunService.RenderStepped:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

--========================
-- Main GUI Components
--========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjWindowGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parent

-- Kotak Minimize (Kecil)
local MinBox = Instance.new("TextButton")
MinBox.Name = "MinBox"
MinBox.Size = UDim2.new(0, 50, 0, 50)
MinBox.Position = UDim2.new(0.1, 0, 0.5, 0)
MinBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinBox.BackgroundTransparency = 0.3
MinBox.Text = "Dj"
MinBox.Font = Enum.Font.GothamBold
MinBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBox.Visible = false
MinBox.Parent = ScreenGui
Instance.new("UICorner", MinBox).CornerRadius = UDim.new(0, 12)
makeDraggable(MinBox, MinBox)

-- Main Window
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 380, 0, 420)
Window.Position = UDim2.new(0.5, -190, 0.5, -210)
Window.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Window.BackgroundTransparency = 0.5 -- Transparan setengah
Window.BorderSizePixel = 0
Window.Parent = ScreenGui
Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundTransparency = 1
Topbar.Parent = Window
makeDraggable(Window, Topbar)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "Dj Hub Premium"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -45, 0, 6)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Parent = Topbar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

-- Scrolling Content
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Window

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 12)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

--========================
-- Minimalist Toggle Function
--========================
local function createFeature(text, callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(0, 340, 0, 45)
	Frame.BackgroundTransparency = 1
	Frame.Parent = Scroll

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(230, 230, 230)
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 15
	Label.BackgroundTransparency = 1
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local ToggleBG = Instance.new("TextButton")
	ToggleBG.Size = UDim2.new(0, 48, 0, 24)
	ToggleBG.Position = UDim2.new(1, -55, 0.5, -12)
	ToggleBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	ToggleBG.Text = ""
	ToggleBG.Parent = Frame
	local corner = Instance.new("UICorner", ToggleBG)
	corner.CornerRadius = UDim.new(1, 0)

	local Dot = Instance.new("Frame")
	Dot.Size = UDim2.new(0, 18, 0, 18)
	Dot.Position = UDim2.new(0, 3, 0.5, -9)
	Dot.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	Dot.Parent = ToggleBG
	Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

	local enabled = false
	ToggleBG.MouseButton1Click:Connect(function()
		enabled = not enabled
		ToggleBG.BackgroundColor3 = enabled and Color3.fromRGB(230, 126, 34) or Color3.fromRGB(60, 60, 60)
		Dot:TweenPosition(enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), "Out", "Quad", 0.2, true)
		callback(enabled)
	end)
end

--========================
-- Features Implementation
--========================

-- 1. Platform
local pPart, pConn, lastY = nil, nil, 0
createFeature("Stable Platform", function(state)
	if state then
		pPart = Instance.new("Part", workspace)
		pPart.Name = "DjPlatform"
		pPart.Size, pPart.Anchored, pPart.Transparency = Vector3.new(15, 0.5, 15), true, 0.5
		pPart.Material, pPart.Color = Enum.Material.ForceField, Color3.fromRGB(0, 255, 255)
		if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then lastY = lp.Character.HumanoidRootPart.Position.Y - 3.2 end
		pConn = RunService.PostSimulation:Connect(function()
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = lp.Character.HumanoidRootPart
				if lp.Character.Humanoid.FloorMaterial == Enum.Material.Air then lastY = hrp.Position.Y - 3.2 end
				pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z)
			end
		end)
	else
		if pConn then pConn:Disconnect() pConn = nil end
		if pPart then pPart:Destroy() pPart = nil end
	end
end)

-- 2. Noclip
local noclipConn = nil
createFeature("Noclip (Pass Walls)", function(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	end
end)

-- 3. ESP System (Generic)
local ESP_Markers = {}
local function clearEsp(rarity)
    for obj, folderName in pairs(ESP_Markers) do
        if folderName == rarity and obj:FindFirstChild("Highlight") then obj.Highlight:Destroy() end
    end
end

createFeature("ESP Divine", function(state)
	local folder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild("Divine")
	if state and folder then
		for _, v in pairs(folder:GetChildren()) do
			if v.Name == "RenderedBrainrot" then
				local hl = Instance.new("Highlight", v)
				hl.FillColor = Color3.fromRGB(255, 215, 0)
                ESP_Markers[v] = "Divine"
			end
		end
	else
		clearEsp("Divine")
	end
end)

createFeature("ESP Common", function(state)
	local folder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild("Common")
	if state and folder then
		for _, v in pairs(folder:GetChildren()) do
			if v.Name == "RenderedBrainrot" then
				local hl = Instance.new("Highlight", v)
				hl.FillColor = Color3.fromRGB(200, 200, 200)
                ESP_Markers[v] = "Common"
			end
		end
	else
		clearEsp("Common")
	end
end)

-- 4. Delete Walls
createFeature("Delete VIP Walls", function(state)
	if state then
		local walls = workspace:FindFirstChild("VIPWalls") or workspace:FindFirstChild("Wallses")
		if walls then for _, v in pairs(walls:GetChildren()) do v:Destroy() end end
	end
end)

-- 5. Fast Take (Instant)
local ftConn = nil
local function setupPrompt(p)
    if p:IsA("ProximityPrompt") and p.Name == "TakePrompt" then
        p.HoldDuration = 0
        p.MaxActivationDistance = 20
    end
end

createFeature("Fast Take (Instant)", function(state)
	local activeFolder = workspace:FindFirstChild("ActiveBrainrots")
	if not activeFolder then return end

	if state then
		for _, d in pairs(activeFolder:GetDescendants()) do setupPrompt(d) end
		ftConn = activeFolder.DescendantAdded:Connect(function(d)
			task.wait(0.1)
			setupPrompt(d)
		end)
	elseif ftConn then
		ftConn:Disconnect()
		ftConn = nil
	end
end)

--========================
-- Minimize Logic
--========================
MinBtn.MouseButton1Click:Connect(function()
	Window.Visible = false
	MinBox.Visible = true
	MinBox.Position = Window.Position
end)

MinBox.MouseButton1Click:Connect(function()
	Window.Visible = true
	MinBox.Visible = false
	Window.Position = MinBox.Position
end)

print("✅ Dj Hub v2 Fully Loaded - Aesthetic & Fixed!")
