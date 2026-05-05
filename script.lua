local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LK7 HUB",
    LoadingTitle = "LK7 HUB",
    LoadingSubtitle = "Fix Geral - Align, Rejoin e Slider",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

-- ABAS SEPARADAS PARA GARANTIR QUE TUDO APAREÇA
local MainTab = Window:CreateTab("Automação", 4483362458)
local UtilityTab = Window:CreateTab("Utilidades", 4483362458)

local player = game.Players.LocalPlayer
local flashTPEnabled = false
local triggerPercent = 91 -- Valor inicial conforme sua especificação

-- === BARRA DE PROGRESSO VISUAL (BASEADA NA SUA FOTO) ===
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
BarBackground.Position = UDim2.new(0.5, -100, 0.85, 0) 
BarBackground.Size = UDim2.new(0, 200, 0, 15)
BarBackground.Visible = false 

UICorner.Parent = BarBackground
BarFill.Name = "BarFill"
BarFill.Parent = BarBackground
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
BarFill.Size = UDim2.new(0, 0, 1, 0)
UICorner2.Parent = BarFill

-- === FUNÇÃO DE FUGA ===
local function executeEscape()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    -- Alvo: FLASH TELEPORTE conforme sua correção
    local tool = player.Backpack:FindFirstChild("FLASH TELEPORTE") or (char and char:FindFirstChild("FLASH TELEPORTE"))
    
    if tool and hum then
        hum:EquipTool(tool)
        task.wait(0.01)
        tool:Activate()
    end
end

-- === ABA DE AUTOMAÇÃO (TRIGGER E FLASH) ===

MainTab:CreateToggle({
    Name = "FLASH TP: ON/OFF",
    CurrentValue = false,
    Flag = "FlashTP",
    Callback = function(value)
        flashTPEnabled = value
    end
})

-- Slider corrigido para ser interativo
MainTab:CreateSlider({
    Name = "TRIGGER %",
    Min = 1,
    Max = 100,
    CurrentValue = 91,
    Flag = "SliderTrigger",
    Callback = function(Value)
        triggerPercent = Value
    end
})

-- === ABA DE UTILIDADES (ALIGN E REJOIN) ===

UtilityTab:CreateButton({
    Name = "ALIGN CAMERA (H: 91)",
    Callback = function()
        -- Coordenada de altura 91 conforme solicitado
        local alvoPos = Vector3.new(-321.731, 39.651, 92.335)
        local pontoDeFoco = alvoPos + Vector3.new(0, 91, -20) 
        local cameraPos = alvoPos + Vector3.new(0, 2, 10)
        workspace.CurrentCamera.CFrame = CFrame.new(cameraPos, pontoDeFoco)
        
        Rayfield:Notify({Title = "LK7 HUB", Content = "Câmera Alinhada!", Duration = 2})
    end
})

UtilityTab:CreateButton({
    Name = "REJOIN SERVER",
    Callback = function()
        local ts = game:GetService("TeleportService")
        ts:Teleport(game.PlaceId, player)
    end
})

-- === LÓGICA DE DETECÇÃO ===
task.spawn(function()
    while true do
        task.wait(0.05)
        local isStealing = false
        
        if flashTPEnabled then
            for _, v in pairs(player.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and v.Text:find("%%") then
                    local currentVal = tonumber(v.Text:match("%d+"))
                    if currentVal then
                        isStealing = true
                        BarBackground.Visible = true
                        BarFill.Size = UDim2.new(currentVal/100, 0, 1, 0)
                        
                        if currentVal >= triggerPercent then
                            executeEscape()
                            task.wait(2)
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
