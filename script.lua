local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Criar a Janela Principal
local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Flash TP 92% + Progress Bar",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Principal", 4483362458)

local player = game.Players.LocalPlayer
local flashTPEnabled = false
local triggerPercent = 91

-- === CRIAR A BARRA DE PROGRESSO VISUAL (GUI) ===
local ScreenGui = Instance.new("ScreenGui")
local BarBackground = Instance.new("Frame")
local BarFill = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")

ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.Name = "LK7_ProgressBar"

-- Fundo da Barra (Preto como na foto)
BarBackground.Name = "BarBackground"
BarBackground.Parent = ScreenGui
BarBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BarBackground.Position = UDim2.new(0.5, -100, 0.85, 0) -- Perto dos equipamentos
BarBackground.Size = UDim2.new(0, 200, 0, 15)
BarBackground.Visible = false -- Só aparece ao roubar

UICorner.Parent = BarBackground

-- Preenchimento da Barra (Verde/Azul)
BarFill.Name = "BarFill"
BarFill.Parent = BarBackground
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
BarFill.Size = UDim2.new(0, 0, 1, 0)

UICorner2.Parent = BarFill

-- === FUNÇÕES DO SCRIPT ===

local function executeEscape()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local tool = player.Backpack:FindFirstChild("FLASH TELEPORTE") or (char and char:FindFirstChild("FLASH TELEPORTE"))
    
    if tool and hum then
        hum:EquipTool(tool)
        task.wait(0.01)
        tool:Activate()
    end
end

-- Toggle Flash TP
MainTab:CreateToggle({
    Name = "FLASH TP: ON/OFF",
    CurrentValue = false,
    Flag = "FlashTP",
    Callback = function(value)
        flashTPEnabled = value
    end
})

-- Slider do Trigger
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

-- Botão de Alinhamento (Diagonal de Fuga)
MainTab:CreateButton({
    Name = "ALIGN CAMERA",
    Callback = function()
        -- Coordenada corrigida com altura 91 para o ponto de fuga
        local alvoPos = Vector3.new(-321.731, 39.651, 92.335)
        local pontoDeFoco = alvoPos + Vector3.new(0, 91, -20) 
        local cameraPos = alvoPos + Vector3.new(0, 2, 10)
        workspace.CurrentCamera.CFrame = CFrame.new(cameraPos, pontoDeFoco)
    end
})

-- === LÓGICA DE DETECÇÃO E BARRA ===
task.spawn(function()
    while true do
        task.wait(0.01)
        local stealing = false
        
        if flashTPEnabled then
            for _, v in pairs(player.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and v.Text:find("%%") then
                    local currentVal = tonumber(v.Text:match("%d+"))
                    if currentVal then
                        stealing = true
                        BarBackground.Visible = true
                        -- Atualiza a largura da barrinha LK7 de 0 a 1 (100%)
                        BarFill.Size = UDim2.new(currentVal/100, 0, 1, 0)
                        
                        -- Verifica se atingiu o Trigger
                        if currentVal >= triggerPercent then
                            executeEscape()
                            task.wait(2)
                        end
                    end
                end
            end
        end
        
        -- Se não estiver roubando, esconde a barra
        if not stealing then
            BarBackground.Visible = false
            BarFill.Size = UDim2.new(0, 0, 1, 0)
        end
    end
end)
