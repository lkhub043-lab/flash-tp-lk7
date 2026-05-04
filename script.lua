local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Interface de Teleporte",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LK7HubConfigs",
        FileName = "config"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

-- CRIANDO A ABA PRINCIPAL (Obrigatório para os botões aparecerem)
local MainTab = Window:CreateTab("Principal", 4483362458) 

-- Notificação de inicialização
Rayfield:Notify({
    Title = "LK7 HUB",
    Content = "Interface carregada com sucesso!",
    Duration = 5,
    Image = 4483362458,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Labels de Status (dentro da MainTab)
local statusPing = MainTab:CreateLabel("Ping: --")
local statusDelay = MainTab:CreateLabel("Delay: --")

local autoPotionEnabled = false
local speedBoostEnabled = false

local function updateStatus()
    local ping = math.floor((player:GetNetworkPing() or 0) * 1000)
    local delay = math.floor(ping / 2)
    statusPing:Set("Ping: " .. ping .. "ms")
    statusDelay:Set("Delay: " .. delay .. "ms")
end

RunService.RenderStepped:Connect(updateStatus)

-- Toggles (dentro da MainTab)
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

-- Botões de Ação
MainTab:CreateButton({
    Name = "ALIGN CAMERA",
    Callback = function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            camera.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 50, 0), hrp.Position)
        end
    end
})

MainTab:CreateButton({
    Name = "FLASH GRAB",
    Callback = function()
        local character = player.Character
        local tool = player.Backpack:FindFirstChild("Flash Teleport") or character:FindFirstChild("Flash Teleport")
        
        if tool then
            player.Character.Humanoid:EquipTool(tool)
            task.wait(0.1)
            tool:Activate()
            
            -- Lógica de TP Simples (CFrame)
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -20) -- Teleporta 20 studs para frente
            end
        else
            Rayfield:Notify({Title = "Erro", Content = "Flash Teleport não encontrado!", Duration = 3})
        end
    end
})

-- Seção de Suporte
local SupportTab = Window:CreateTab("Suporte", 4483362458)

SupportTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})
