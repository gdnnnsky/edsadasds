--// Dj Hub (Absolute God Mode Version)
--// Fitur: God Mode Absolut, Platform, Noclip, ESP, Wall Remover

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
	return game:GetService("CoreGui")
end

local parent = pickGuiParent()
pcall(function() if parent:FindFirstChild("DjWindowGUI") then parent.DjWindowGUI:Destroy() end end)

--========================
-- Build Main GUI
--========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjWindowGUI"
ScreenGui.Parent = parent

local Window = Instance.new("Frame")
Window.Size = UDim2.new(0, 420, 0, 260) 
Window.Position = UDim2.new(0.5, -210, 0.5, -130)
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Window.Active = true
Window.Parent = ScreenGui
Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 10)

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 38)
Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Topbar.Parent = Window
Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dj Hub - ABSOLUTE GOD"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamSemibold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 38, 0, 26)
Close.Position = UDim2.new(1, -44, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Parent = Topbar
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

-- Scrolling Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 42)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Window
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 8)
Instance.new("UIPadding", Scroll).PaddingTop = UDim.new(0, 5)

-- Helper Button
local function createButton(text, color, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 380, 0, 40)
	btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 70)
	btn.Text = text
	btn.Font = Enum.Font.GothamSemibold
	btn.TextColor3 = Color3.new(1,1,1)
	btn.LayoutOrder = order
	btn.Parent = Scroll
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

--========================
-- Buttons
--========================
local GodBtn         = createButton("ABSOLUTE GOD: OFF", Color3.fromRGB(200, 50, 50), 0)
local PlatformBtn    = createButton("Platform: OFF", Color3.fromRGB(40, 120, 180), 1)
local NoclipBtn      = createButton("Noclip: OFF", Color3.fromRGB(100, 50, 150), 2)
local EspDivineBtn    = createButton("ESP Divine: OFF", Color3.fromRGB(180, 150, 0), 3)
local DelWallsBtn     = createButton("Delete Walls", Color3.fromRGB(180, 100, 40), 6)

--========================
-- 1. ABSOLUTE GOD LOGIC (ANTI-RESET METODE)
--========================
local absoluteGod = false
local godLoop = nil

GodBtn.MouseButton1Click:Connect(function()
	absoluteGod = not absoluteGod
	GodBtn.Text = "ABSOLUTE GOD: " .. (absoluteGod and "ON" or "OFF")
	GodBtn.BackgroundColor3 = absoluteGod and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

	if absoluteGod then
		-- Hapus semua sensor damage yang ada di map saat ini
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("TouchTransmitter") then v:Destroy() end
		end

		godLoop = RunService.Heartbeat:Connect(function()
			if lp.Character then
				local hum = lp.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					-- Mengunci nyawa agar tidak berkurang sama sekali
					hum.Health = hum.MaxHealth
					-- Menonaktifkan deteksi "Mati"
					hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					
					-- Anti-Kematian Paksa: Jika server memaksa nyawa ke 0, kita tarik ke atas lagi
					if hum.Health <= 0 then
						hum.Health = hum.MaxHealth
					end
				end
				
				-- Membuat seluruh tubuh kebal terhadap sentuhan objek luar
				for _, part in pairs(lp.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanTouch = false
					end
				end
			end
		end)
		
		-- Loop kedua khusus menghapus sensor damage baru yang muncul
		godLoop2 = workspace.DescendantAdded:Connect(function(v)
			if absoluteGod and v:IsA("TouchTransmitter") then
				v:Destroy()
			end
		end)
	else
		if godLoop then godLoop:Disconnect() end
		if godLoop2 then godLoop2:Disconnect() end
		if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
			lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			for _, part in pairs(lp.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanTouch = true end
			end
		end
	end
end)

--========================
-- 2. PLATFORM LOGIC (STABLE)
--========================
local platformEnabled, pPart, pConn, lastY = false, nil, nil, 0
PlatformBtn.MouseButton1Click:Connect(function()
	platformEnabled = not platformEnabled
	PlatformBtn.Text = "Platform: " .. (platformEnabled and "ON" or "OFF")
	if platformEnabled then
		pPart = Instance.new("Part", workspace)
		pPart.Size = Vector3.new(15, 0.5, 15)
		pPart.Anchored = true
		pPart.Transparency = 0.5
		pPart.Material = Enum.Material.ForceField
		if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			lastY = lp.Character.HumanoidRootPart.Position.Y - 3.2
		end
		pConn = RunService.PostSimulation:Connect(function()
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = lp.Character.HumanoidRootPart
				local hum = lp.Character:FindFirstChild("Humanoid")
				if hum and hum.FloorMaterial == Enum.Material.Air then lastY = hrp.Position.Y - 3.2 end
				pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z)
			end
		end)
	else
		if pConn then pConn:Disconnect() end
		if pPart then pPart:Destroy() end
	end
end)

--========================
-- 3. NOCLIP LOGIC
--========================
local noclipOn, noclipConn = false, nil
NoclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	NoclipBtn.Text = "Noclip: " .. (noclipOn and "ON" or "OFF")
	if noclipOn then
		noclipConn = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, v in pairs(lp.Character:GetDescendants()) do
					if v:IsA("BasePart") then v.CanCollide = false end
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
	end
end)

--========================
-- 4. DELETE WALLS
--========================
DelWallsBtn.MouseButton1Click:Connect(function()
	local w = workspace:FindFirstChild("VIPWalls") or workspace:FindFirstChild("Wallses")
	if w then for _, v in pairs(w:GetChildren()) do v:Destroy() end end
end)

--========================
-- GUI Systems
--========================
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
local d, ds, sp
Topbar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		d = true ds = i.Position sp = Window.Position
		i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
	end
end)
UIS.InputChanged:Connect(function(i)
	if d and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - ds
		Window.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
	end
end)
