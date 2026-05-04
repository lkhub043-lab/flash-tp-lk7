local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Flash TP 92% - Edição Final",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LK7HubConfigs",
        FileName = "config"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Principal", 4483362458)

local player = game.Players.LocalPlayer
local flashTP92Enabled = false

-- Função para usar o Flash (Acionado pelo script após o roubo)
local function useFlashItem()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    -- Busca o item na mochila ou na mão
    local tool = player.Backpack:FindFirstChild("Flash Teleport") or (char and char:FindFirstChild("Flash Teleport"))
    
    if tool and hum then
        hum:EquipTool(tool)
        task.wait(0.01) -- Delay mínimo para troca de item
        tool:Activate() -- Aciona o teletransporte original do item
    end
end

-- Toggle Flash TP 92%
MainTab:CreateToggle({
    Name = "Flash TP 92%",
    CurrentValue = false,
    Flag = "Flash92",
    Callback = function(value)
        flashTP92Enabled = value
    end
})

-- Botão ALIGN CAMERA (Ajustado para o ângulo da sua foto)
MainTab:CreateButton({
    Name = "ALIGN CAMERA",
    Callback = function()
        -- Coordenada base do local de roubo
        local alvoPos = Vector3.new(-321.731, 39.651, 92.335)
        
        -- Ponto de foco: Mira para cima e para frente (Diagonal do teto)
        local pontoDeFoco = alvoPos + Vector3.new(0, 45, -20) 
        
        -- Posição da câmera: Ligeiramente atrás do jogador para dar ângulo
        local cameraPos = alvoPos + Vector3.new(0, 2, 10)
        
        workspace.CurrentCamera.CFrame = CFrame.new(cameraPos, pontoDeFoco)
        
        Rayfield:Notify({
            Title = "LK7 HUB",
            Content = "Câmara Alinhada para Diagonal!",
            Duration = 2
        })
    end
})

-- LÓGICA DE DETECÇÃO (O que seu amigo explicou)
-- Monitora quando a barra de progresso (roubo) é removida da tela
player.PlayerGui.DescendantRemoving:Connect(function(descendant)
    if flashTP92Enabled then
        -- Se o objeto que sumiu for a barra de roubo
        if descendant.Name:lower():find("bar") or descendant.Name:lower():find("progress") then
            -- O roubo acabou! Aguarda um frame e usa o Flash
            task.wait(0.05)
            useFlashItem()
        end
    end
end)

-- Botão Extra para alinhar caso você se mova
MainTab:CreateLabel("Instruções: Ligue o TP, Alinhe a Câmera e Segure para Roubar.")
