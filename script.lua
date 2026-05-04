local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Flash TP 92% - Ajustado",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Principal", 4483362458)

local player = game.Players.LocalPlayer
local flashTP92Enabled = false

-- Função que apenas usa o item, sem empurrar o boneco
local function useFlashItem()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local tool = player.Backpack:FindFirstChild("Flash Teleport") or char:FindFirstChild("Flash Teleport")
    
    if tool and hum then
        hum:EquipTool(tool)
        task.wait(0.05) -- Tempo apenas para o Roblox entender a troca
        tool:Activate() -- Aciona o item (o item do jogo faz o teleporte)
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

-- NOVO GATILHO: Detecta apenas quando a barra é DESTRUÍDA (fim do roubo)
player.PlayerGui.DescendantRemoving:Connect(function(descendant)
    if flashTP92Enabled then
        -- Verificamos se o que sumiu foi especificamente a barra de progresso
        if descendant.Name == "Bar" or descendant.Name == "ProgressBar" or descendant.Name == "Progress" then
            -- Pequeno delay para garantir que o jogo contou o roubo antes de fugir
            task.wait(0.1) 
            useFlashItem()
        end
    end
end)
