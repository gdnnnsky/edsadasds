--// Dj Hub - Premium v2 (Mobile Friendly & Minimalist UI)
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

local parent = pickGuiParent() [cite: 1]
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
end [cite: 9]

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
Window.Size = UDim2.new(0, 380, 0, 450)
Window.Position = UDim2.new(0.5, -190, 0.5, -225)
Window.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Window.BackgroundTransparency = 0.4 -- Transparan setengah 
Window.BorderSizePixel = 0
Window.Parent = ScreenGui
Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 40)
Topbar.BackgroundTransparency = 1
Topbar.Parent = Window
makeDraggable(Window, Topbar) [cite: 9]

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "Dj Hub Premium"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -40, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Parent = Topbar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

-- Scrolling Content
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Window

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 10)
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
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14
	Label.BackgroundTransparency = 1
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local ToggleBG = Instance.new("TextButton")
	ToggleBG.Size = UDim2.new(0, 45, 0, 22)
	ToggleBG.Position = UDim2.new(1, -50, 0.5, -11)
	ToggleBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	ToggleBG.Text = ""
	ToggleBG.Parent = Frame
	local corner = Instance.new("UICorner", ToggleBG)
	corner.CornerRadius = UDim.new(1, 0)

	local Dot = Instance.new("Frame")
	Dot.Size = UDim2.new(0, 16, 0, 16)
	Dot.Position = UDim2.new(0, 3, 0.5, -8)
	Dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	Dot.Parent = ToggleBG
	Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

	local enabled = false
	ToggleBG.MouseButton1Click:Connect(function()
		enabled = not enabled
		ToggleBG.BackgroundColor3 = enabled and Color3.fromRGB(230, 126, 34) or Color3.fromRGB(60, 60, 60)
		Dot:TweenPosition(enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8), "Out", "Quad", 0.2, true)
		callback(enabled)
	end) [cite: 8]
end

--========================
-- Features Implementation
--========================

-- 1. Platform [cite: 5]
local pPart, pConn, lastY = nil, nil, 0
createFeature("Stable Platform", function(state)
	if state then
		pPart = Instance.new("Part", workspace)
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
		if pConn then pConn:Disconnect() end
		if pPart then pPart:Destroy() end
	end
end)

-- 2. Noclip
local noclipConn = nil
createFeature("Noclip (Walls Pass)", function(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
	end
end)

-- 3. ESP System (Generic) 
local function toggleEsp(rarity, state)
	local folder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild(rarity)
	if state and folder then
		for _, v in pairs(folder:GetChildren()) do
			if v.Name == "RenderedBrainrot" then
				local hl = Instance.new("Highlight", v)
				hl.FillColor = (rarity == "Divine" and Color3.new(1,0.8,0)) or Color3.new(1,1,1)
			end
		end
	end
end
createFeature("ESP Divine", function(s) toggleEsp("Divine", s) end)
createFeature("ESP Common", function(s) toggleEsp("Common", s) end)

-- 4. Fast Take (Instant) 
local ftConn = nil
createFeature("Fast Take (Instant)", function(state)
	if state then
		ftConn = workspace.ActiveBrainrots.DescendantAdded:Connect(function(d)
			if d.Name == "TakePrompt" then d.HoldDuration = 0 end
		end)
		for _, d in pairs(workspace.ActiveBrainrots:GetDescendants()) do
			if d.Name == "TakePrompt" then d.HoldDuration = 0 end
		end
	elseif ftConn then
		ftConn:Disconnect()
	end
end)

--========================
-- Minimize & Close Logic
--========================
MinBtn.MouseButton1Click:Connect(function()
	Window.Visible = false
	MinBox.Visible = true
	MinBox.Position = Window.Position
end) [cite: 3]

MinBox.MouseButton1Click:Connect(function()
	Window.Visible = true
	MinBox.Visible = false
	Window.Position = MinBox.Position
end)

print("✅ Dj Hub v2 Loaded - Aesthetic & Mobile Ready")
