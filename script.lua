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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local statusPing = MainTab:CreateLabel("Ping: --")
local statusDelay = MainTab:CreateLabel("Delay: --")

local speedBoostEnabled = false

-- Atualização de Status
RunService.RenderStepped:Connect(function()
    local ping = math.floor((player:GetNetworkPing() or 0) * 1000)
    local delay = math.floor(ping / 2)
    statusPing:Set("Ping: " .. ping .. "ms")
    statusDelay:Set("Delay: " .. delay .. "ms")
end)

MainTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(value)
        speedBoostEnabled = value
    end
})

-- Botão ALIGN CAMERA (Coordenadas da sua imagem)
MainTab:CreateButton({
    Name = "ALIGN CAMERA",
    Callback = function()
        local alvoPos = Vector3.new(-321.731, 39.651, 92.335)
        camera.CFrame = CFrame.new(alvoPos + Vector3.new(0, 60, 0), alvoPos)
    end
})

-- FUNÇÃO FLASH GRAB IGUAL AO VÍDEO 1
local function executeFlashGrab()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")

    -- Busca o item na mochila ou na mão
    local tool = player.Backpack:FindFirstChild("Flash Teleport") or character:FindFirstChild("Flash Teleport")
    
    if tool then
        -- 1. Equipa o item se não estiver na mão
        if tool.Parent ~= character then
            humanoid:EquipTool(tool)
            task.wait(0.1) -- Tempo mínimo para o Roblox registrar o equipamento
        end
        
        -- 2. Tenta ativar o item (O "Flash" do jogo)
        tool:Activate()

        -- 3. LOGICA DO VÍDEO 1: Só teleporta se o item foi usado
        -- Adicionamos um pequeno delay para esperar a animação do Flash começar
        task.wait(0.05) 

        if hrp then
            local direction = hrp.CFrame.LookVector
            local origin = hrp.Position
            local distance = 100 -- Distância do Flash
            
            -- Raycast para atravessar paredes (Igual ao vídeo 1)
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {character}
            params.FilterType = Enum.RaycastFilterType.Blacklist

            local ray = workspace:Raycast(origin, direction * distance, params)
            local targetPos = origin + (direction * distance)

            -- Se houver uma parede no caminho, ele calcula a posição atrás dela
            if ray then
                targetPos = ray.Position + (direction * 4) 
            end

            -- Executa o movimento de CFrame sincronizado
            hrp.CFrame = CFrame.new(targetPos, targetPos + direction)
        end
    else
        Rayfield:Notify({Title = "Erro", Content = "Flash Teleport não encontrado!", Duration = 3})
    end
end

MainTab:CreateButton({
    Name = "FLASH GRAB",
    Callback = executeFlashGrab
})

-- Loop de Velocidade
spawn(function()
    while true do
        task.wait(1)
        if speedBoostEnabled and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 30 end
        end
    end
end)
