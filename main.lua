print("STEP 0: script start")

local parent
if typeof(gethui) == "function" then
	local ok, hui = pcall(gethui)
	if ok and hui then parent = hui end
end

if not parent then
	parent = game:GetService("CoreGui")
end

print("STEP 1: parent =", parent:GetFullName())

local ok, err = pcall(function()
	local gui = Instance.new("ScreenGui")
	gui.Name = "DjTestGUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = parent

	local fr = Instance.new("Frame")
	fr.Size = UDim2.new(0, 300, 0, 150)
	fr.Position = UDim2.new(0.5, -150, 0.5, -75)
	fr.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- merah mencolok
	fr.Parent = gui

	print("STEP 2: GUI created ✅")
end)

if not ok then
	warn("STEP X: error =", err)
else
	print("DONE ✅")
end
