-- [[ BRAINROT ESCAPE TSUNAMI GUI ]] --

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local CloseBtn = Instance.new("TextButton")
local MinBtn = Instance.new("TextButton")

-- Setup UI Parent
ScreenGui.Name = "BrainrotHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame (Bisa di-drag)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- Membuat GUI bisa dipindah-pindah

-- Title
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "BRAINROT HUB V1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- Close & Minimize
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

MinBtn.Parent = MainFrame
MinBtn.Position = UDim2.new(0.7, 0, 0, 0)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.MouseButton1Click:Connect(function()
    Container.Visible = not Container.Visible
    MainFrame.Size = Container.Visible and UDim2.new(0, 200, 0, 250) or UDim2.new(0, 200, 0, 30)
end)

-- Container for Buttons
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 5, 0, 35)
Container.Size = UDim2.new(0, 190, 0, 210)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 2, 0)

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 5)

-- [[ FUNGSI FITUR ]] --

local function CreateButton(txt, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
end

-- 1. Brainrot ESP
CreateButton("Brainrot ESP", function()
    print("ESP Activated")
    -- Logika: Loop Workspace cari item 'Brainrot' dan tambah Highlight/BillboardGui
end)

-- 2. Teleport to Base
CreateButton("Teleport to Base", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0) -- Ganti koordinat base
end)

-- 3. God Mode (Anti Tsunami)
CreateButton("God Mode", function()
    local char = game.Players.LocalPlayer.Character
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.Name = "Immortal" -- Seringkali mengganti nama Humanoid memutus script kill game
    end
end)

-- 4. Noclip
CreateButton("Noclip", function()
    game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end)

-- 5. Instant Take Brainrot
CreateButton("Instant Take", function()
    -- Logika: Fire proximity prompt atau touch interest pada item Brainrot
    print("Auto-collecting items...")
end)

print("Brainrot Script Loaded!")
