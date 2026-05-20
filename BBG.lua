local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Verificación del Módulo de Combate (Original Blox Fruits)
local CombatUtil
pcall(function() CombatUtil = require(ReplicatedStorage.Modules.CombatUtil) end)
local originalGetWeaponData = CombatUtil and clonefunction(CombatUtil.GetWeaponData) or nil

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Limpieza de interfaces previas (FIXED: was referencing BBG_Pro instead of BBG)
if pgui:FindFirstChild("BBG") then
    pgui.BBG:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BBG"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = pgui

-- ==================== INTERFAZ PRINCIPAL ====================
local mainFrame = Instance.new("Frame")
local normalSize = UDim2.new(0, 320, 0, 420)
local minimizedSize = UDim2.new(0, 160, 0, 40)

mainFrame.Name = "Main"
mainFrame.Size = minimizedSize
mainFrame.Position = UDim2.new(0.5, -160, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BBG"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left

local controlBtn = Instance.new("TextButton", mainFrame)
controlBtn.Size = UDim2.new(0, 35, 0, 35)
controlBtn.Position = UDim2.new(1, -38, 0, 2)
controlBtn.BackgroundTransparency = 1
controlBtn.Text = "≡"
controlBtn.TextColor3 = Color3.new(1, 1, 1)
controlBtn.TextSize = 25
controlBtn.ZIndex = 10

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
scrollFrame.Visible = false
scrollFrame.ZIndex = 5

local layout = Instance.new("UIListLayout", scrollFrame)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 8)

-- ==================== FUNCIONES DE CREADOR ====================
local function crearSeccion(txt)
    local l = Instance.new("TextLabel", scrollFrame)
    l.Size = UDim2.new(1, 0, 0, 25)
    l.BackgroundTransparency = 1
    l.Text = "-- " .. txt:upper() .. " --"
    l.TextColor3 = Color3.fromRGB(0, 255, 255)
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
end

local function crearBtn(txt, color)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 6
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", btn)
    s.Color = color
    s.Thickness = 1.2
    return btn
end

-- ==================== BOTONES Y SECCIONES ====================
crearSeccion("Combat & Visuals")
local hitBtn     = crearBtn("Hitbox: 10000 STUDS", Color3.new(1, 0, 0))
local espBtn     = crearBtn("ESP Players & NPCs", Color3.new(1, 0.5, 0))

crearSeccion("Stats")
local speedToggleBtn = crearBtn("Speed Controller", Color3.new(0, 1, 0.5))

crearSeccion("Movement Hacks")
local jumpBtn   = crearBtn("Infinite Jump", Color3.new(0, 0.5, 1))
local noclipBtn = crearBtn("No Clip", Color3.new(1, 1, 1))

crearSeccion("Teleports Sea 2")
local tpBoatBtn = crearBtn("Ir al Barco", Color3.new(0, 1, 0.5))

crearSeccion("Teleports Sea 3")
local tpCastleBtn = crearBtn("Ir al Castillo", Color3.new(0.5, 0, 1))

-- ==================== LÓGICA ESP AVANZADA (NPCs y Jugadores) ====================
local espActive = false

local function createESPObj(model, name, color)
    if not model:FindFirstChild("HumanoidRootPart") then return end

    local hl = model:FindFirstChild("BBG_Highlight") or Instance.new("Highlight")
    hl.Name = "BBG_Highlight"
    hl.FillColor = color
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.5
    hl.Enabled = espActive
    hl.Parent = model

    local bg = model.HumanoidRootPart:FindFirstChild("BBG_Tag") or Instance.new("BillboardGui", model.HumanoidRootPart)
    bg.Name = "BBG_Tag"
    bg.Size = UDim2.new(0, 200, 0, 50)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    bg.AlwaysOnTop = true
    bg.Enabled = espActive

    local tl = bg:FindFirstChild("TextLabel") or Instance.new("TextLabel", bg)
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = color
    tl.TextStrokeTransparency = 0
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 13

    spawn(function()
        while model and model:FindFirstChild("HumanoidRootPart") and espActive do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((player.Character.HumanoidRootPart.Position - model.HumanoidRootPart.Position).Magnitude)
                tl.Text = name .. " [" .. dist .. "m]"
            end
            task.wait(0.2)
        end
        if bg then bg:Destroy() end
        if hl then hl:Destroy() end
    end)
end

espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = espActive and "ESP: ACTIVADO" or "ESP Players & NPCs"
    espBtn.BackgroundColor3 = espActive and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(25, 25, 40)
    if espActive then
        spawn(function()
            while espActive do
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character then
                        createESPObj(v.Character, v.Name, Color3.new(1, 0, 0))
                    end
                end
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                        createESPObj(v, v.Name, Color3.new(0, 1, 1))
                    end
                end
                task.wait(2)
            end
        end)
    end
end)

-- ==================== CONTROL DE VELOCIDAD FLOTANTE ====================
local speedValue = 16
local speedActive = false

local speedFrame = Instance.new("Frame", screenGui)
speedFrame.Size = UDim2.new(0, 120, 0, 50)
speedFrame.Position = UDim2.new(0, 20, 0.5, 0)
speedFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
speedFrame.Visible = false
speedFrame.Draggable = true
speedFrame.Active = true
Instance.new("UICorner", speedFrame).CornerRadius = UDim.new(0, 8)

local sLabel = Instance.new("TextLabel", speedFrame)
sLabel.Size = UDim2.new(1, 0, 0, 20)
sLabel.Text = "Vel: 16"
sLabel.TextColor3 = Color3.new(0, 1, 1)
sLabel.BackgroundTransparency = 1
sLabel.Font = Enum.Font.GothamBold

local bM = Instance.new("TextButton", speedFrame)
bM.Size = UDim2.new(0, 40, 0, 20)
bM.Position = UDim2.new(0.1, 0, 0.5, 0)
bM.Text = "-"
bM.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
bM.TextColor3 = Color3.new(1, 1, 1)

local bP = Instance.new("TextButton", speedFrame)
bP.Size = UDim2.new(0, 40, 0, 20)
bP.Position = UDim2.new(0.6, 0, 0.5, 0)
bP.Text = "+"
bP.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
bP.TextColor3 = Color3.new(1, 1, 1)

speedToggleBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedFrame.Visible = speedActive
end)
bP.MouseButton1Click:Connect(function()
    speedValue = math.clamp(speedValue + 20, 16, 350)
    sLabel.Text = "Vel: " .. speedValue
end)
bM.MouseButton1Click:Connect(function()
    speedValue = math.clamp(speedValue - 20, 16, 350)
    sLabel.Text = "Vel: " .. speedValue
end)

RunService.Heartbeat:Connect(function()
    if speedActive and player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            player.Character:TranslateBy(hum.MoveDirection * (speedValue / 45))
        end
    end
end)

-- ==================== NO CLIP ====================
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.BackgroundColor3 = noclip and Color3.new(0.3, 0.3, 0.3) or Color3.fromRGB(25, 25, 40)
end)
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ==================== INFINITE JUMP ====================
local infJump = false
jumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    jumpBtn.BackgroundColor3 = infJump and Color3.new(0, 0.4, 0.8) or Color3.fromRGB(25, 25, 40)
end)
UserInputService.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- ==================== HITBOX 10000 ====================
local hbActive = false
hitBtn.MouseButton1Click:Connect(function()
    hbActive = not hbActive
    hitBtn.Text = hbActive and "Hitbox: 10000 ON" or "Hitbox: 10000 STUDS"
end)

if originalGetWeaponData then
    hookfunction(CombatUtil.GetWeaponData, newcclosure(function(self, name, ...)
        local data = originalGetWeaponData(self, name, ...)
        if hbActive and type(data) == "table" then
            return setmetatable({}, {
                __index = function(_, k)
                    return k == "HitboxMagnitude" and 10000 or data[k]
                end
            })
        end
        return data
    end))
end

-- ==================== TELEPORTS ====================
tpCastleBtn.MouseButton1Click:Connect(function()
    player.Character:PivotTo(CFrame.new(-5085, 315, -3150))
end)
tpBoatBtn.MouseButton1Click:Connect(function()
    player.Character:PivotTo(CFrame.new(923, 125, 32853))
end)

-- ==================== MENÚ TOGGLE ====================
local minimized = true
controlBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame:TweenSize(
        minimized and minimizedSize or normalSize,
        "Out", "Quint", 0.3, true
    )
    scrollFrame.Visible = not minimized
    controlBtn.Text = minimized and "≡" or "×"
end)
