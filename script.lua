local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Flash TP 92% - Auto Exit",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Principal", 4483362458)

local player = game.Players.LocalPlayer
local flashTP92Enabled = false

-- Função para usar o Flash (focando na direção da câmera/personagem)
local function useFlashItem()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local tool = player.Backpack:FindFirstChild("Flash Teleport") or (char and char:FindFirstChild("Flash Teleport"))
    
    if tool and hum then
        hum:EquipTool(tool)
        task.wait(0.01) -- Delay quase zero
        tool:Activate()
        
        -- Se o item do jogo por algum motivo não te levar longe o suficiente, 
        -- você pode descomentar a linha abaixo para garantir o pulo:
        -- char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
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

-- DETECTOR DE FIM DE ROUBO:
-- Quando a barra de carregar (Progress) sumir, ele executa o Flash
player.PlayerGui.DescendantRemoving:Connect(function(descendant)
    if flashTP92Enabled then
        if descendant.Name:lower():find("bar") or descendant.Name:lower():find("progress") then
            useFlashItem()
        end
    end
end)
