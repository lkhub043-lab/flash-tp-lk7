local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Interface de Teleporte e Controle",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LK7HubConfigs",
        FileName = "config"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Principal", 4483362458)

Rayfield:Notify({
    Title = "LK7 HUB",
    Content = "Sistema carregado com sucesso!",
    Duration = 5,
    Image = 4483362458,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local statusPing = MainTab:CreateLabel("Ping: --")
local statusDelay = MainTab:CreateLabel("Delay: --")

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

MainTab:CreateToggle({
    Name = "Auto Potion",
    CurrentValue = false,
    Flag = "AutoPotion",
    Callback = function(value)
        autoPotionEnabled = value
    end
})

MainTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(value)
        speedBoostEnabled = value
    end
})

MainTab:CreateToggle({
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

MainTab:CreateButton({
    Name = "ALIGN CAMERA",
    Callback = function()
        local alvoPos = Vector3.new(-321.731, 39.651, 92.335)
        camera.CFrame = CFrame.new(alvoPos + Vector3.new(0, 60, 0), alvoPos)
        
        Rayfield:Notify({
            Title = "LK7 HUB",
            Content = "Câmera alinhada ao alvo!",
            Duration = 2
        })
    end
})

local function executeFlashGrab()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")

    local tool = findToolByName("Flash Teleport")
    
    if tool then
        if tool.Parent ~= character then
            humanoid:EquipTool(tool)
        end
        
        task.wait(0.1)
        pcall(function() tool:Activate() end)

        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -25)
        end
    else
        Rayfield:Notify({
            Title = "Aviso",
            Content = "Item 'Flash Teleport' não encontrado!",
            Duration = 3
        })
    end
end

MainTab:CreateButton({
    Name = "FLASH GRAB",
    Callback = executeFlashGrab
})

local SupportTab = Window:CreateTab("Suporte", 4483362458)

SupportTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})

spawn(function()
    while true do
        task.wait(1)
        if speedBoostEnabled and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 30 end
        end
    end
end)
