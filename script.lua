local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Interface para controle e teleporte",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LK7HubConfigs",
        FileName = "config"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

-- Força a exibição da interface
Rayfield:Notify({
    Title = "LK7 HUB",
    Content = "Script carregado com sucesso!",
    Duration = 5,
    Image = 4483362458,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local statusPing = Window:CreateLabel({Name = "Ping: --"})
local statusDelay = Window:CreateLabel({Name = "Delay: --"})

local autoPotionEnabled = false
local speedBoostEnabled = false
local laggerOnStealEnabled = false

local function updateStatus()
    local ping = math.floor((player:GetNetworkPing() or 0) * 1000)
    local delay = math.floor(ping / 2)
    statusPing:Set("Ping: " .. ping .. "ms")
    statusDelay:Set("Delay: " .. delay .. "ms")
end

RunService.RenderStepped:Connect(updateStatus)

Window:CreateToggle({
    Name = "Auto Potion",
    CurrentValue = false,
    Flag = "AutoPotion",
    Callback = function(value)
        autoPotionEnabled = value
    end
})

Window:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(value)
        speedBoostEnabled = value
    end
})

Window:CreateToggle({
    Name = "Lagger on Steal",
    CurrentValue = false,
    Flag = "LaggerOnSteal",
    Callback = function(value)
        laggerOnStealEnabled = value
    end
})

local function findToolByName(name)
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()
    return backpack:FindFirstChild(name) or character:FindFirstChild(name)
end

local function getCameraTarget()
    local pet = workspace:FindFirstChild("Pet")
    if pet and pet:IsA("BasePart") then
        return pet
    end
    local char = player.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    end
    return nil
end

local function alignCameraAbove(target)
    if not target then return end
    camera.CFrame = CFrame.new(target.Position + Vector3.new(0, 50, 0), target.Position)
end

Window:CreateButton({
    Name = "ALIGN CAMERA",
    Callback = function()
        local target = getCameraTarget()
        if target then
            alignCameraAbove(target)
        end
    end
})

local function teleportWithFlash()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    local tool = findToolByName("Flash Teleport")
    
    if tool and tool.Parent ~= character then
        humanoid:EquipTool(tool)
    end

    if tool and tool.Parent == character then
        pcall(function() tool:Activate() end)
        
        local direction = hrp.CFrame.LookVector
        local origin = hrp.Position
        local distance = 120
        local step = 12
        local lastValid = origin
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {character}
        params.FilterType = Enum.RaycastFilterType.Blacklist

        for i = step, distance, step do
            local checkPos = origin + direction * i + Vector3.new(0, 4, 0)
            local ray = workspace:Raycast(origin, direction * i + Vector3.new(0, 4, 0), params)
            if not ray then
                lastValid = checkPos
            else
                local ceiling = workspace:Raycast(checkPos, Vector3.new(0, 20, 0), params)
                if not ceiling then
                    lastValid = checkPos
                    break
                end
            end
        end

        if lastValid then
            hrp.CFrame = CFrame.new(lastValid, lastValid + direction)
        end
    end
end

Window:CreateButton({
    Name = "FLASH GRAB",
    Callback = teleportWithFlash
})

local SupportTab = Window:CreateTab("Suporte")

SupportTab:CreateButton({
    Name = "Ragdoll",
    Callback = function()
        print("Ragdoll ativado")
    end
})

SupportTab:CreateButton({
    Name = "Place Clone",
    Callback = function()
        print("Clone posicionado")
    end
})

SupportTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})

spawn(function()
    while true do
        task.wait(1)

        if autoPotionEnabled then
            local potion = findToolByName("Auto Potion") or findToolByName("Potion")
            if potion and potion.Parent == player.Backpack then
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(potion)
                end
            end
        end

        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedBoostEnabled and 30 or 16
            end
        end
    end
end)
