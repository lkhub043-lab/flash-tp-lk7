local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Flash TP 92% Edition",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Principal", 4483362458)

local player = game.Players.LocalPlayer
local flashTP92Enabled = false

-- Função de execução do Flash
local function useFlash()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local tool = player.Backpack:FindFirstChild("Flash Teleport") or char:FindFirstChild("Flash Teleport")
    
    if tool and hum and hrp then
        hum:EquipTool(tool)
        task.wait(0.05)
        tool:Activate()
        
        -- Bypass de CFrame para atravessar a parede (Igual ao vídeo)
        local direction = hrp.CFrame.LookVector
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -25) 
    end
end

MainTab:CreateToggle({
    Name = "Flash TP 92%",
    CurrentValue = false,
    Flag = "Flash92",
    Callback = function(value)
        flashTP92Enabled = value
    end
})

MainTab:CreateButton({
    Name = "ALIGN CAMERA",
    Callback = function()
        local alvoPos = Vector3.new(-321.731, 39.651, 92.335)
        workspace.CurrentCamera.CFrame = CFrame.new(alvoPos + Vector3.new(0, 60, 0), alvoPos)
    end
})

-- GATILHO POR FIM DA BARRA DE PROGRESSO
-- Detecta quando o GUI de roubo ("Barra") é removido da sua tela
player.PlayerGui.DescendantRemoving:Connect(function(descendant)
    if flashTP92Enabled then
        -- Verificamos se o que sumiu foi a barra de roubo (comum em jogos de 'Steal')
        -- Geralmente a barra tem nomes como 'Bar', 'Progress' ou 'MainBar'
        if descendant.Name:lower():find("bar") or descendant.Name:lower():find("progress") then
            task.wait(0.05) -- Pequeno delay para garantir que o roubo processou
            useFlash()
        end
    end
end)
