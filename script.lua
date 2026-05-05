local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Versão Final - Tudo em Um",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

-- Tudo em uma aba só para não sumir nada
local MainTab = Window:CreateTab("LK7 HUB", 4483362458)

local player = game.Players.LocalPlayer
local flashTPEnabled = false
local triggerPercent = 91

-- === BARRA DE PROGRESSO VISUAL (A que você pediu na foto) ===
local ScreenGui = Instance.new("ScreenGui")
local BarBackground = Instance.new("Frame")
local BarFill = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")

ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.Name = "LK7_VisualBar"

BarBackground.Name = "BarBackground"
BarBackground.Parent = ScreenGui
BarBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BarBackground.Position = UDim2.new(0.5, -100, 0.85, 0) -- Posição perto dos itens
BarBackground.Size = UDim2.new(0, 200, 0, 15)
BarBackground.Visible = false 

UICorner.Parent = BarBackground
BarFill.Name = "BarFill"
BarFill.Parent = BarBackground
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127) -- Verde
BarFill.Size = UDim2.new(0, 0, 1, 0)
UICorner2.Parent = BarFill

-- === FUNÇÃO DE TELEPORTE ===
local function executeEscape()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    -- Nome do item que você corrigiu: FLASH TELEPORTE
    local tool = player.Backpack:FindFirstChild("FLASH TELEPORTE") or (char and char:FindFirstChild("FLASH TELEPORTE"))
    
    if tool and hum then
        hum:EquipTool(tool)
        task.wait(0.01)
        tool:Activate()
    end
end

-- === INTERFACE DO PAINEL ===

MainTab:CreateToggle({
    Name = "FLASH TP: ON/OFF",
    CurrentValue = false,
    Flag = "FlashTP",
    Callback = function(value)
        flashTPEnabled = value
    end
})

MainTab:CreateSlider({
    Name = "TRIGGER %",
    Min = 50,
    Max = 100,
    CurrentValue = 91,
    Flag = "TriggerVal",
    Callback = function(value)
        triggerPercent = value
    end
})

-- O BOTÃO ALIGN VOLTOU AQUI:
MainTab:CreateButton({
    Name = "ALIGN CAMERA (H: 91)",
    Callback = function()
        -- Usando as coordenadas exatas e a altura 91 que você especificou
        local alvoPos = Vector3.new(-321.731, 39.651, 92.335)
        local pontoDeFoco = alvoPos + Vector3.new(0, 91, -20) 
        local cameraPos = alvoPos + Vector3.new(0, 2, 10)
        workspace.CurrentCamera.CFrame = CFrame.new(cameraPos, pontoDeFoco)
        
        Rayfield:Notify({Title = "LK7 HUB", Content = "Câmera Alinhada na altura 91!", Duration = 2})
    end
})

MainTab:CreateButton({
    Name = "REJOIN SERVER",
    Callback = function()
        local ts = game:GetService("TeleportService")
        ts:Teleport(game.PlaceId, player)
    end
})

-- === LÓGICA DE DETECÇÃO (TRIGGER E BARRA) ===
task.spawn(function()
    while true do
        task.wait(0.05)
        local isStealing = false
        
        if flashTPEnabled then
            -- Procura a barra de porcentagem do jogo na tela
            for _, v in pairs(player.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and v.Text:find("%%") then
                    local currentVal = tonumber(v.Text:match("%d+"))
                    if currentVal then
                        isStealing = true
                        BarBackground.Visible = true
                        -- Sincroniza a barrinha visual com o roubo
                        BarFill.Size = UDim2.new(currentVal/100, 0, 1, 0)
                        
                        -- Se atingir os 91% (ou o que estiver no slider), pula!
                        if currentVal >= triggerPercent then
                            executeEscape()
                            task.wait(2) -- Evita múltiplos usos
                        end
                    end
                end
            end
        end
        
        if not isStealing then
            BarBackground.Visible = false
        end
    end
end)
