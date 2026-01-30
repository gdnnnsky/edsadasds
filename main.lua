-- [[ RE-OPTIMIZED BRAINROT HUB ]] --
local player = game:GetService("Players").LocalPlayer
local sg = Instance.new("ScreenGui")

-- Cek apakah GUI sudah ada, kalau ada hapus dulu biar gak double
if game:GetService("CoreGui"):FindFirstChild("BrainrotHub") then
    game:GetService("CoreGui").BrainrotHub:Destroy()
end

sg.Name = "BrainrotHub"
sg.Parent = game:GetService("CoreGui")
sg.IgnoreGuiInset = true -- Supaya posisi bener-bener akurat

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = sg
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -100, 0.5, -125)
Main.Size = UDim2.new(0, 220, 0, 300)
Main.Active = true
Main.Draggable = true -- Standard Draggable

-- Header / Title
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Text = "BRAINROT V2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = Header
MinBtn.Position = UDim2.new(0.7, 0, 0, 0)
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.new(1, 1, 1)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 33, 1, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

-- Content Scroll
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Main
Scroll.Position = UDim2.new(0, 0, 0, 35)
Scroll.Size = UDim2.new(1, 0, 1, -35)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0) -- Muat banyak tombol

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Helper Function Create Button
local function AddBtn(txt, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = Scroll
    b.MouseButton1Click:Connect(func)
    return b
end

--- [[ FITUR LOGIC ]] ---

-- 1. Close & Min Logic
CloseBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Scroll.Visible = not minimized
    Main.Size = minimized and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 220, 0, 300)
end)

-- 2. Brainrot Notifier & ESP (Placeholder Logic)
AddBtn("ESP & Notifier", function()
    print("Mencari Brainrot Items...")
    -- Logic: Cari part di workspace yang namanya mengandung 'Brainrot'
    -- Gunakan BillboardGui untuk ESP
    game.StarterGui:SetCore("SendNotification", {
        Title = "Brainrot Found!";
        Text = "Item spawned nearby!";
        Duration = 5;
    })
end)

-- 3. Teleport Zones (Contoh: Common ke Celestial)
AddBtn("TP to Celestial Zone", function()
    -- Ganti "CelestialPart" dengan nama part yang kamu temukan di Explorer
    local target = workspace:FindFirstChild("CelestialZone", true) 
    if target then
        player.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0,3,0)
    end
end)

-- 4. Noclip (Looping)
local noclip = false
AddBtn("Noclip: OFF", function(self)
    noclip = not noclip
    script.Parent.Text = "Noclip: " .. (noclip and "ON" or "OFF")
    game:GetService("RunService").Stepped:Connect(function()
        if noclip then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- 5. God Mode (Anti-Tsunami)
AddBtn("God Mode", function()
    -- Tsunami biasanya kill lewat .Touched. Kita hapus koneksi sentuhan.
    local char = player.Character
    char.HumanoidRootPart:ClearAllChildren() -- Menghapus TouchInterest jika ada
    print("God Mode Active (May not work in all games)")
end)

-- 6. Instant Take
AddBtn("Instant Take", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end)
