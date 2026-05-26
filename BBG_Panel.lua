--[[
    BBG Panel | AUTOMATION UPDATE
    Developer: BBG
    Architecture: Clean & Optimized
--]]

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =========================================================
-- [0] BYPASSES AND PROTECTIONS
-- =========================================================
pcall(function()
    local util = ReplicatedStorage:WaitForChild("Util", 3)
    if util and util:FindFirstChild("CameraShaker") then
        local ss = require(util.CameraShaker.Main)
        local xx = function() return nil end
        ss.StartShake = xx; ss.ShakeOnce = xx; ss.ShakeSustain = xx; ss.CamerShakeInstance = xx; ss.Shake = xx; ss.Start = xx
    end

    local TeleportService = game:GetService("TeleportService")
    local GuiService = game:GetService("GuiService")

    local function Rejoin()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, lp)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        end
    end

    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
        local Method = getnamecallmethod()
        if (Method == "Kick" or Method == "kick") and Self == lp then
            task.spawn(Rejoin)
            return nil
        end
        return OldNamecall(Self, ...)
    end))

    GuiService.ErrorMessageChanged:Connect(function()
        if GuiService:GetErrorMessage() ~= "" then Rejoin() end
    end)
end)

-- =========================================================
-- [1] ESP SYSTEM
-- =========================================================
getgenv().ESP_Enabled = false
getgenv().ESP_MaxDistance = 9999999
local ESP_Objects = {}

local function CreateESP(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(0, 162, 255)
    Box.Thickness = 1.5
    Box.Filled = false

    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.new(1, 1, 1)
    Name.Size = 14
    Name.Center = true

    local Health = Drawing.new("Text")
    Health.Visible = false
    Health.Color = Color3.fromRGB(0, 255, 100)
    Health.Size = 12
    Health.Center = true

    ESP_Objects[player] = {Box = Box, Name = Name, Health = Health}
end

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p == lp or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then continue end
        if not ESP_Objects[p] then CreateESP(p) end

        local d = ESP_Objects[p]
        local hrp = p.Character.HumanoidRootPart
        local hum = p.Character:FindFirstChild("Humanoid")

        if getgenv().ESP_Enabled and (hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude <= getgenv().ESP_MaxDistance then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                d.Box.Visible = true
                d.Box.Size = Vector2.new(50, 80)
                d.Box.Position = Vector2.new(pos.X - 25, pos.Y - 40)
                d.Name.Visible = true
                d.Name.Text = p.Name
                d.Name.Position = Vector2.new(pos.X, pos.Y - 58)
                if hum then
                    d.Health.Visible = true
                    d.Health.Text = "HP: " .. math.floor(hum.Health)
                    d.Health.Position = Vector2.new(pos.X, pos.Y + 44)
                end
            else
                d.Box.Visible = false
                d.Name.Visible = false
                d.Health.Visible = false
            end
        else
            d.Box.Visible = false
            d.Name.Visible = false
            d.Health.Visible = false
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if ESP_Objects[p] then
        ESP_Objects[p].Box:Remove()
        ESP_Objects[p].Name:Remove()
        ESP_Objects[p].Health:Remove()
        ESP_Objects[p] = nil
    end
end)

-- =========================================================
-- [2] LOADING SCREEN
-- =========================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "BBG Panel Loading"
LoadingGui.Parent = CoreGui
LoadingGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = LoadingGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 500, 0, 50)
Title.Position = UDim2.new(0.5, -250, 0.5, -30)
Title.BackgroundTransparency = 1
Title.Text = "TOP 1 BUDDHA PANEL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 28
Title.TextTransparency = 1
Title.Parent = MainFrame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 200, 0, 30)
Subtitle.Position = UDim2.new(0.5, -100, 0.5, 20)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "By BBG"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 14
Subtitle.TextTransparency = 1
Subtitle.Parent = MainFrame

local function StartLoading()
    TweenService:Create(Title, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    task.wait(0.5)
    TweenService:Create(Subtitle, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    task.wait(2.5)
    TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(Subtitle, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1)
    TweenService:Create(MainFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    task.wait(1)
    LoadingGui:Destroy()
end

task.spawn(StartLoading)
task.wait(4)

-- =========================================================
-- [3] GLOBAL VARIABLES
-- =========================================================
getgenv().FastAttackEnabled = false
getgenv().FastAttackRange = 2000
getgenv().HitboxActive = false
getgenv().HitboxSize = 0
getgenv().FruitAttack = false
getgenv().InfiniteJumpEnabled = false
getgenv().WalkOnWaterEnabled = false
getgenv().SmartAutoV4 = false
getgenv().WalkSpeedEnabled = false
getgenv().WalkSpeedValue = 40
getgenv().MasterEnabled = false
getgenv().AutoSkillEnabled = false
getgenv().MaxDistance = 500
getgenv().FOV_Radius = 150
getgenv().AutoBountyRexActive = false
getgenv().NoclipEnabled = false
getgenv().PowerJumpEnabled = false
getgenv().PowerJumpValue = 50

-- Tween / InstaTP globals
getgenv().TweenTarget = nil
getgenv().IsTweening = false
getgenv().TweenSpeed = 200
getgenv().TweenYOffset = 0
getgenv().InstaTpEnabled = false
getgenv().InstaTpYOffset = 0

-- Silent Aim globals
getgenv().SilentAimEnabled = false
Playersaimbot  = nil
PlayersPosition = nil

local isRexAttacking = false
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local FastAttackConnection = nil
local FruitAttackConnection = nil
local TweenConnection = nil
local InstaTpConnection = nil
local ActiveTween = nil
local NoclipConnection = nil

-- =========================================================
-- [4] HELPER FUNCTIONS
-- =========================================================
local function PressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.01)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function EquipArmorHaki()
    pcall(function()
        local char = lp.Character
        if not char then return end
        if not char:FindFirstChild("HasBuso") then
            local hakiRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if hakiRemote then
                hakiRemote:InvokeServer("Buso")
                task.wait(0.1)
            end
            if not char:FindFirstChild("HasBuso") then
                PressKey(Enum.KeyCode.J)
                task.wait(0.1)
            end
        end
    end)
end

local function AttackMultipleTargets(targets)
    pcall(function()
        if not targets or #targets == 0 then return end
        local allTargets = {}
        for _, targetChar in pairs(targets) do
            local head = targetChar:FindFirstChild("Head")
            if head then table.insert(allTargets, {targetChar, head}) end
        end
        if #allTargets == 0 then return end
        RegisterAttack:FireServer(0)
        RegisterHit:FireServer(allTargets[1][2], allTargets)
    end)
end

local function GetNearestPlayer()
    local nearest, dist = nil, math.huge
    local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (myHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; nearest = v end
        end
    end
    return nearest
end

local function FireEquippedFruit(direction, char)
    pcall(function()
        if not char then return end
        local dir = vector.create(direction.X, direction.Y, direction.Z)
        local fruits = {
            {"Pain-Pain",       function(r) for i=1,5 do r:FireServer(dir,1,true) end end},
            {"Dragon-Dragon",   function(r) for i=1,5 do r:FireServer(dir,1)      end end},
            {"Tiger-Tiger",     function(r) for i=1,5 do r:FireServer(dir,3)      end end},
            {"T-Rex-T-Rex",     function(r) for i=1,5 do r:FireServer(dir,1)      end end},
            {"Kitsune-Kitsune", function(r) for i=1,5 do r:FireServer(direction,1,true) end end},
        }
        for _, entry in ipairs(fruits) do
            local fruitModel = char:FindFirstChild(entry[1])
            if fruitModel then
                local remote = fruitModel:FindFirstChild("LeftClickRemote")
                if remote then entry[2](remote) end
                return
            end
        end
    end)
end

local function SetNoCollide(v)
    pcall(function()
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not v end
        end
    end)
end

local function GetPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then table.insert(list, p.Name) end
    end
    return #list == 0 and {"None"} or list
end

-- =========================================================
-- [5] SILENT AIM ENGINE
-- =========================================================
spawn(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        if not getgenv().SilentAimEnabled
           or tostring(method) ~= "FireServer"
           or tostring(args[1]) ~= "RemoteEvent"
           or tostring(args[2]) == "true"
           or tostring(args[2]) == "false"
           or Playersaimbot == nil then
            return oldNamecall(...)
        end
        if type(args[2]) ~= "vector" then
            args[2] = CFrame.new(PlayersPosition)
        else
            args[2] = PlayersPosition
        end
        return oldNamecall(unpack(args))
    end)
end)

-- Nearest target selection loop
spawn(function()
    pcall(function()
        while task.wait() do
            if getgenv().SilentAimEnabled then
                local myChar = lp.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local myHrp = myChar.HumanoidRootPart
                    local bestDist, bestName, bestPos = math.huge, nil, nil
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            local dist = (p.Character.HumanoidRootPart.Position - myHrp.Position).Magnitude
                            if dist < bestDist then
                                bestDist = dist
                                bestName = p.Name
                                bestPos  = p.Character.HumanoidRootPart.Position
                            end
                        end
                    end
                    Playersaimbot   = bestName
                    PlayersPosition = bestPos
                end
            else
                Playersaimbot   = nil
                PlayersPosition = nil
            end
        end
    end)
end)

-- Real-time position update
spawn(function()
    while task.wait() do
        if Playersaimbot ~= nil then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Name == Playersaimbot and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    PlayersPosition = p.Character.HumanoidRootPart.Position
                end
            end
        end
    end
end)

-- Anti-bug on death
local function WatchSilentAimDeath(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.Died:Connect(function()
        local was = getgenv().SilentAimEnabled
        getgenv().SilentAimEnabled = false
        Playersaimbot   = nil
        PlayersPosition = nil
        task.wait(3)
        if was then getgenv().SilentAimEnabled = true end
    end)
end
lp.CharacterAdded:Connect(WatchSilentAimDeath)
if lp.Character then WatchSilentAimDeath(lp.Character) end

-- =========================================================
-- [6] NOCLIP ENGINE
-- =========================================================
local function SetNoclip(state)
    getgenv().NoclipEnabled = state
    if state then
        NoclipConnection = RunService.Stepped:Connect(function()
            local char = lp.Character
            if char and getgenv().NoclipEnabled then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        local char = lp.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Restore noclip after respawn
lp.CharacterAdded:Connect(function(newChar)
    if getgenv().NoclipEnabled then
        task.wait(0.5)
        SetNoclip(true)
    end
end)

-- =========================================================
-- [7] TWEEN TP ENGINE
-- =========================================================
local function StartTweenTP()
    if TweenConnection then TweenConnection:Disconnect() end
    TweenConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().IsTweening or not getgenv().TweenTarget then return end
        pcall(function()
            local target = Players:FindFirstChild(getgenv().TweenTarget)
            local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if not (target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and myHRP) then return end
            if lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid:ChangeState(11)
            end
            local targetHRP = target.Character.HumanoidRootPart
            local targetPos = targetHRP.Position + Vector3.new(0, getgenv().TweenYOffset, 0)
            local dist = (myHRP.Position - targetPos).Magnitude
            if dist > 3 then
                SetNoCollide(true)
                local time = dist / getgenv().TweenSpeed
                if ActiveTween then ActiveTween:Cancel() end
                ActiveTween = TweenService:Create(myHRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {
                    CFrame = CFrame.new(targetPos)
                })
                ActiveTween:Play()
            end
        end)
    end)
end

local function StopTweenTP()
    getgenv().IsTweening = false
    if TweenConnection then TweenConnection:Disconnect() TweenConnection = nil end
    if ActiveTween then ActiveTween:Cancel() ActiveTween = nil end
    SetNoCollide(false)
end

-- =========================================================
-- [8] INSTA TP ENGINE
-- =========================================================
local function StartInstaTp()
    if InstaTpConnection then InstaTpConnection:Disconnect() end
    InstaTpConnection = RunService.Stepped:Connect(function()
        if not getgenv().InstaTpEnabled or not getgenv().TweenTarget then return end
        pcall(function()
            local target = Players:FindFirstChild(getgenv().TweenTarget)
            local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if not (target and target.Character and myHRP) then return end
            local targetTorso = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("HumanoidRootPart")
            if targetTorso then
                myHRP.CFrame = targetTorso.CFrame * CFrame.new(0, getgenv().InstaTpYOffset, 0.2)
                myHRP.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end)
end

local function StopInstaTp()
    getgenv().InstaTpEnabled = false
    if InstaTpConnection then InstaTpConnection:Disconnect() InstaTpConnection = nil end
end

-- =========================================================
-- [9] FAST ATTACK
-- =========================================================
local function StartFastAttack()
    if FastAttackConnection then task.cancel(FastAttackConnection) end
    FastAttackConnection = task.spawn(function()
        while getgenv().FastAttackEnabled do
            task.wait(0.01)
            local myChar = lp.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then continue end
            local targetsInRange = {}
            local currentRange = getgenv().FastAttackRange
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= lp and player.Character then
                    local hum = player.Character:FindFirstChild("Humanoid")
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 then
                        if (hrp.Position - myHRP.Position).Magnitude <= currentRange then
                            table.insert(targetsInRange, player.Character)
                        end
                    end
                end
            end
            local enemiesFolder = workspace:FindFirstChild("Enemies")
            if enemiesFolder then
                for _, npc in pairs(enemiesFolder:GetChildren()) do
                    local hum = npc:FindFirstChild("Humanoid")
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 then
                        if (hrp.Position - myHRP.Position).Magnitude <= currentRange then
                            table.insert(targetsInRange, npc)
                        end
                    end
                end
            end
            if #targetsInRange > 0 then AttackMultipleTargets(targetsInRange) end
        end
    end)
end

local function StopFastAttack()
    if FastAttackConnection then task.cancel(FastAttackConnection) FastAttackConnection = nil end
end

-- =========================================================
-- [10] FAST ATTACK FRUIT
-- =========================================================
local function StartFruitAttack()
    if FruitAttackConnection then FruitAttackConnection:Disconnect() end
    FruitAttackConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().FruitAttack then
            FruitAttackConnection:Disconnect()
            FruitAttackConnection = nil
            return
        end
        pcall(function()
            local targetPlayer = GetNearestPlayer()
            if not (targetPlayer and targetPlayer.Character) then return end
            local char = lp.Character
            local myHRP = char and char:FindFirstChild("HumanoidRootPart")
            local tHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local tHum = targetPlayer.Character:FindFirstChild("Humanoid")
            if not (myHRP and tHRP and tHum and tHum.Health > 0) then return end
            local direction = (tHRP.Position - myHRP.Position).Unit
            FireEquippedFruit(direction, char)
            local head = targetPlayer.Character:FindFirstChild("Head")
            if head then
                RegisterAttack:FireServer(0)
                RegisterHit:FireServer(head, {{targetPlayer.Character, head}})
            end
        end)
    end)
end

local function StopFruitAttack()
    if FruitAttackConnection then
        FruitAttackConnection:Disconnect()
        FruitAttackConnection = nil
    end
end

-- =========================================================
-- [11] AUTO BOUNTY REX HUB
-- =========================================================
local function ExecuteRexBounty()
    if not getgenv().AutoBountyRexActive or isRexAttacking then return end
    isRexAttacking = true
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if hrp and hum and hum.Health > 0 then
        if not char:FindFirstChildOfClass("Tool") then
            PressKey(Enum.KeyCode.One)
            task.wait(0.15)
        end
        EquipArmorHaki()
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 500, 0)
        task.wait(0.05)
        local targetPos = CFrame.new(923.2, 3000000000000000000000, 32852.8)
        hrp.Anchored = true
        hrp.CFrame = targetPos
        workspace.CurrentCamera.CFrame = targetPos
        task.wait(0.12)
        PressKey(Enum.KeyCode.Z)
        task.spawn(function()
            task.wait(0.45)
            if getgenv().AutoBountyRexActive and hum and hum.Health > 0 then
                hum.Health = 0
            end
        end)
        local s = tick()
        while tick() - s < 0.6 do RunService.Heartbeat:Wait() end
    end
    isRexAttacking = false
end

local function StartRexBountyLoop()
    while getgenv().AutoBountyRexActive do
        if not isRexAttacking then ExecuteRexBounty() end
        task.wait(0.1)
    end
end

lp.CharacterAdded:Connect(function(newChar)
    if getgenv().AutoBountyRexActive then
        newChar:WaitForChild("HumanoidRootPart", 10)
        newChar:WaitForChild("Humanoid", 10)
        task.wait(0.6)
        task.spawn(StartRexBountyLoop)
    end
end)

-- =========================================================
-- [12] AIMBOT
-- =========================================================
local function GetClosestPlayerForLock()
    local Target, ShortestDistance = nil, getgenv().FOV_Radius
    local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            if (myHRP.Position - hrp.Position).Magnitude <= getgenv().MaxDistance then
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

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if getgenv().AutoSkillEnabled and input.KeyCode == Enum.KeyCode.R then
        task.spawn(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game) task.wait(0.1)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().MasterEnabled then
        local target = GetClosestPlayerForLock()
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

-- =========================================================
-- [13] PASSIVES AND EXTRA MECHANICS
-- =========================================================
RunService.RenderStepped:Connect(function()
    if getgenv().WalkSpeedEnabled then
        pcall(function()
            local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = getgenv().WalkSpeedValue end
        end)
    end
end)

-- Power Jump
RunService.RenderStepped:Connect(function()
    if getgenv().PowerJumpEnabled then
        pcall(function()
            local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = getgenv().PowerJumpValue end
        end)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().InfiniteJumpEnabled then
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then hrp.Velocity = Vector3.new(hrp.Velocity.X, hum.JumpPower, hrp.Velocity.Z) end
    end
end)

local SpaceHeld = false
UserInputService.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == Enum.KeyCode.Space then SpaceHeld = true end end)
UserInputService.InputEnded:Connect(function(input) if input.KeyCode == Enum.KeyCode.Space then SpaceHeld = false end end)
RunService.Heartbeat:Connect(function()
    if getgenv().InfiniteJumpEnabled and SpaceHeld then
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z) end
    end
end)

task.spawn(function()
    local WaterPlatform = Instance.new("Part")
    WaterPlatform.Size = Vector3.new(200, 1, 200)
    WaterPlatform.Transparency = 1
    WaterPlatform.Anchored = true
    WaterPlatform.CanCollide = false
    WaterPlatform.Name = "SasingWaterBlock"
    WaterPlatform.Parent = workspace
    while true do
        task.wait(0.05)
        if getgenv().WalkOnWaterEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lp.Character.HumanoidRootPart
            WaterPlatform.Position = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
            WaterPlatform.CanCollide = true
        else
            WaterPlatform.CanCollide = false
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().SmartAutoV4 then
            pcall(function()
                if lp.Character and lp.Character:GetAttribute("RaceEnergy") and lp.Character:GetAttribute("RaceEnergy") >= 100 then
                    lp.Backpack.Awakening.RemoteFunction:InvokeServer(true)
                elseif lp.Backpack:FindFirstChild("Awakening") then
                    lp.Backpack.Awakening.RemoteFunction:InvokeServer(true)
                end
            end)
        end
    end
end)

-- =========================================================
-- [14] RAYFIELD GUI
-- =========================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "BBG Panel",
    LoadingTitle = "BBG Panel",
    LoadingSubtitle = "by BBG",
    Theme = "Dark",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

Rayfield:Notify({
    Title = "BBG Panel Loaded!",
    Content = "SYSTEM STARTED CORRECTLY",
    Duration = 5,
    Image = 4483362458,
})

-- =========================================================
-- TAB: COMBAT 
-- =========================================================
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateSection("Attack Modifiers")

CombatTab:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = false,
    Flag = "Toggle_FastAttack",
    Callback = function(Value)
        getgenv().FastAttackEnabled = Value
        if Value then
            StartFastAttack()
            Rayfield:Notify({Title = " Fast Attack", Content = "Fast Attack enabled", Duration = 3, Image = 4483362458})
        else
            StopFastAttack()
            Rayfield:Notify({Title = " Fast Attack", Content = "Fast Attack disabled", Duration = 2, Image = 4483362458})
        end
    end,
})

CombatTab:CreateSlider({
    Name = "Fast Attack Range",
    Range = {0, 10000},
    Increment = 50,
    CurrentValue = 2000,
    Flag = "Slider_FastAttack",
    Callback = function(Value) getgenv().FastAttackRange = Value end,
})

CombatTab:CreateToggle({
    Name = "Fast Attack Fruit",
    CurrentValue = false,
    Flag = "Toggle_FruitAttack",
    Callback = function(Value)
        getgenv().FruitAttack = Value
        if Value then
            StartFruitAttack()
            Rayfield:Notify({Title = "Fruit Attack", Content = "Fast Attack Fruit enabled", Duration = 3, Image = 4483362458})
        else
            StopFruitAttack()
            Rayfield:Notify({Title = "Fruit Attack", Content = "Fast Attack Fruit disabled", Duration = 2, Image = 4483362458})
        end
    end,
})

CombatTab:CreateSection("Movement Settings")

CombatTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "Toggle_InfJump",
    Callback = function(Value) getgenv().InfiniteJumpEnabled = Value end
})

CombatTab:CreateToggle({
    Name = "Walk On Water",
    CurrentValue = false,
    Flag = "Toggle_WalkWater",
    Callback = function(Value) getgenv().WalkOnWaterEnabled = Value end
})

-- NOCLIP in Combat
CombatTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Toggle_Noclip",
    Callback = function(Value)
        SetNoclip(Value)
        Rayfield:Notify({Title = "Noclip", Content = Value and "Noclip enabled" or "Noclip disabled", Duration = 2, Image = 4483362458})
    end
})

CombatTab:CreateSection("Advanced Customization")

CombatTab:CreateToggle({
    Name = "Smart Auto V4",
    CurrentValue = false,
    Flag = "Toggle_SmartV4",
    Callback = function(Value) getgenv().SmartAutoV4 = Value end
})

CombatTab:CreateToggle({
    Name = "Enable Invisible Hitbox",
    CurrentValue = false,
    Flag = "Toggle_Hitbox",
    Callback = function(Value) getgenv().HitboxActive = Value end
})

CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {0, 2000},
    Increment = 20,
    CurrentValue = 0,
    Flag = "Slider_Hitbox",
    Callback = function(Value) getgenv().HitboxSize = Value > 0 and (Value / 2000) * 150 or 0 end,
})

-- =========================================================
-- TAB: TWEEN
-- =========================================================
local TweenTab = Window:CreateTab("Tween", 4483362458)
TweenTab:CreateSection("Player Target")

local function GetPlayerNames()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then table.insert(names, p.Name) end
    end
    return #names == 0 and {"None"} or names
end

local TweenDropdown = TweenTab:CreateDropdown({
    Name = "Select Player",
    Options = GetPlayerNames(),
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "Tween_PlayerSelect",
    Callback = function(opt)
        if type(opt) == "table" then opt = opt[1] end
        getgenv().TweenTarget = (opt ~= "None") and opt or nil
    end,
})

TweenTab:CreateButton({
    Name = "Refresh List",
    Callback = function()
        TweenDropdown:Refresh(GetPlayerNames(), true)
        Rayfield:Notify({Title = "Lista", Content = "List updated", Duration = 2, Image = 4483362458})
    end,
})

TweenTab:CreateSection("Tween TP")

TweenTab:CreateToggle({
    Name = "Tween TP",
    CurrentValue = false,
    Flag = "Toggle_TweenTP",
    Callback = function(Value)
        getgenv().IsTweening = Value
        if Value then
            if not getgenv().TweenTarget then
                Rayfield:Notify({Title = "Tween TP", Content = "Select a player first", Duration = 3, Image = 4483362458})
                getgenv().IsTweening = false
                return
            end
            StartTweenTP()
            Rayfield:Notify({Title = "Tween TP", Content = "Enabled -> " .. (getgenv().TweenTarget or "?"), Duration = 3, Image = 4483362458})
        else
            StopTweenTP()
            Rayfield:Notify({Title = "Tween TP", Content = "Disabled", Duration = 2, Image = 4483362458})
        end
    end,
})

TweenTab:CreateSlider({
    Name = "Tween Speed",
    Range = {50, 1000},
    Increment = 10,
    CurrentValue = 200,
    Flag = "Slider_TweenSpeed",
    Callback = function(Value) getgenv().TweenSpeed = Value end,
})

TweenTab:CreateSlider({
    Name = "Tween Height (Y Offset)",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = 0,
    Flag = "Slider_TweenYOffset",
    Callback = function(Value) getgenv().TweenYOffset = Value end,
})

TweenTab:CreateSection("Insta TP")

TweenTab:CreateToggle({
    Name = "Insta TP",
    CurrentValue = false,
    Flag = "Toggle_InstaTp",
    Callback = function(Value)
        getgenv().InstaTpEnabled = Value
        if Value then
            if not getgenv().TweenTarget then
                Rayfield:Notify({Title = "Insta TP", Content = "Select a player first", Duration = 3, Image = 4483362458})
                getgenv().InstaTpEnabled = false
                return
            end
            StartInstaTp()
            Rayfield:Notify({Title = "Insta TP", Content = "Enabled -> " .. (getgenv().TweenTarget or "?"), Duration = 3, Image = 4483362458})
        else
            StopInstaTp()
            Rayfield:Notify({Title = "Insta TP", Content = "Disabled", Duration = 2, Image = 4483362458})
        end
    end,
})

TweenTab:CreateSlider({
    Name = "Insta TP Height (Y Offset)",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = 0,
    Flag = "Slider_InstaTpYOffset",
    Callback = function(Value) getgenv().InstaTpYOffset = Value end,
})

-- =========================================================
-- TAB: AIMBOT
-- =========================================================
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
    Name = "Aimbot Auto-Lock",
    CurrentValue = false,
    Flag = "Aimbot_Master",
    Callback = function(Value) getgenv().MasterEnabled = Value end
})

AimbotTab:CreateToggle({
    Name = "Macro XZ (Key: R)",
    CurrentValue = false,
    Flag = "Aimbot_MacroXZ",
    Callback = function(Value) getgenv().AutoSkillEnabled = Value end
})

-- SILENT AIM in Aimbot
AimbotTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "Toggle_SilentAim",
    Callback = function(Value)
        getgenv().SilentAimEnabled = Value
        if not Value then
            Playersaimbot   = nil
            PlayersPosition = nil
        end
        Rayfield:Notify({
            Title = "Silent Aim",
            Content = Value and "Silent Aim enabled - targets nearest player" or "Silent Aim disabled",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

AimbotTab:CreateSlider({ Name = "Max Distance", Range = {50, 1500}, Increment = 50, CurrentValue = 500, Flag = "Aimbot_MaxDist", Callback = function(Value) getgenv().MaxDistance = Value end })
AimbotTab:CreateSlider({ Name = "FOV Radius", Range = {50, 800}, Increment = 10, CurrentValue = 150, Flag = "Aimbot_FOV", Callback = function(Value) getgenv().FOV_Radius = Value end })

-- =========================================================
-- TAB: INF RANGE
-- =========================================================
local InfRangeTab = Window:CreateTab("Inf Range", 4483362458)
InfRangeTab:CreateToggle({
    Name = "Auto Bounty (Rex Hub)",
    CurrentValue = false,
    Flag = "Toggle_RexBountyCore",
    Callback = function(Value)
        getgenv().AutoBountyRexActive = Value
        if Value then task.spawn(StartRexBountyLoop) end
    end,
})

-- =========================================================
-- TAB: ESP
-- =========================================================
local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Flag = "Toggle_ESP_Enable", Callback = function(Value) getgenv().ESP_Enabled = Value end })
ESPTab:CreateSlider({ Name = "ESP Max Distance", Range = {100, 9999999}, Increment = 1000, CurrentValue = 9999999, Flag = "Slider_ESP_Distance", Callback = function(Value) getgenv().ESP_MaxDistance = Value end })

-- =========================================================
-- TAB: MISC
-- =========================================================
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Flag = "Toggle_WalkSpeed",
    Callback = function(Value) getgenv().WalkSpeedEnabled = Value end
})

MiscTab:CreateSlider({
    Name = "MOD WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 40,
    Flag = "Slider_WalkSpeed",
    Callback = function(Value) getgenv().WalkSpeedValue = Value end
})

-- Power Jump en Misc
MiscTab:CreateToggle({
    Name = "Power Jump",
    CurrentValue = false,
    Flag = "Toggle_PowerJump",
    Callback = function(Value)
        getgenv().PowerJumpEnabled = Value
        if not Value then
            pcall(function()
                local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.JumpPower = 50 end -- restore default value
            end)
        end
        Rayfield:Notify({Title = "Power Jump", Content = Value and "Power Jump enabled" or "Power Jump disabled", Duration = 2, Image = 4483362458})
    end
})

MiscTab:CreateSlider({
    Name = "MOD Jump Power",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Flag = "Slider_PowerJump",
    Callback = function(Value) getgenv().PowerJumpValue = Value end
})

MiscTab:CreateButton({
    Name = "Fix Camera",
    Callback = function()
        pcall(function()
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid
                if lp.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.Anchored = false
                end
            end
        end)
        Rayfield:Notify({Title = "Fix Camera", Content = "Camera reset", Duration = 2, Image = 4483362458})
    end,
})

-- =========================================================
-- HITBOX LOOP
-- =========================================================
RunService.RenderStepped:Connect(function()
    if getgenv().HitboxActive and getgenv().HitboxSize > 0 then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                end)
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end)
            end
        end
    end
end)

Rayfield:LoadConfiguration()