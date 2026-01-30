--// DjHub No Tsu (SAFE untuk game kamu sendiri)
--// Menghapus Part bernama "Hitbox" dari setiap wave yang spawn di workspace.ActiveTsunamis
--// Hitbox = Part tunggal dan selalu ada di setiap wave

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local REMOTE_NAME = "DjHub_NoTsu"
local ACTIVE_FOLDER_NAME = "ActiveTsunamis"
local HITBOX_NAME = "Hitbox"

-- RemoteEvent
local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = REMOTE_NAME
	remote.Parent = ReplicatedStorage
end

-- Folder ActiveTsunamis
local activeFolder = Workspace:WaitForChild(ACTIVE_FOLDER_NAME, 30)
if not activeFolder then
	warn("❌ Folder workspace." .. ACTIVE_FOLDER_NAME .. " tidak ketemu.")
	return
end

-- status per player
local enabledForPlayer = {} :: {[Player]: boolean}

-- Cek apakah ada minimal 1 player yang ON
local function anyEnabled(): boolean
	for _, on in pairs(enabledForPlayer) do
		if on then return true end
	end
	return false
end

-- Hapus hitbox dari 1 wave
local function removeHitbox(waveModel: Instance)
	if not waveModel or not waveModel:IsA("Model") then return end

	-- Hitbox kadang dibuat sedikit telat setelah model masuk folder,
	-- jadi kita tunggu sebentar (retry cepat)
	task.spawn(function()
		for _ = 1, 40 do -- 40 * 0.05 = 2 detik max
			if not waveModel.Parent then return end

			local hb = waveModel:FindFirstChild(HITBOX_NAME)
			if hb and hb:IsA("BasePart") then
				hb:Destroy()
				return
			end

			task.wait(0.05)
		end
	end)
end

-- Bersihin semua wave yang sudah ada
local function removeAllExisting()
	for _, wave in ipairs(activeFolder:GetChildren()) do
		removeHitbox(wave)
	end
end

-- Listen spawn wave baru
activeFolder.ChildAdded:Connect(function(wave)
	if anyEnabled() then
		removeHitbox(wave)
	end
end)

-- Toggle dari client
remote.OnServerEvent:Connect(function(player, isOn)
	if typeof(isOn) ~= "boolean" then return end

	enabledForPlayer[player] = isOn

	-- Kalau dinyalakan, langsung bersihin wave yang sudah ada
	if isOn then
		removeAllExisting()
	end
end)

Players.PlayerRemoving:Connect(function(player)
	enabledForPlayer[player] = nil
end)

print("✅ NoTsu server aktif. Monitoring:", activeFolder:GetFullName())
