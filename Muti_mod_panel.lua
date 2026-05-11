-- Colin's Ultra Panel (2026)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- Переменные состояний
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local godEnabled = false
local originalSpeed = 16
local flyVelocity = nil

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ColinPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 90)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок (отвечает за перетаскивание)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BackgroundTransparency = 0.05
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Colin Panel | Перетащи меня"
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.Gotham
title.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.Gotham
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Создание кнопок (равноудалённые, фиксированные позиции)
local buttons = {}
local buttonNames = {"Speed", "Fly", "Noclip", "God"}
local buttonStatus = {false, false, false, false}

local startY = 10
local gap = 70

for i, name in ipairs(buttonNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 260, 0, 50)
    btn.Position = UDim2.new(0.5, -130, 0, startY + (i-1) * gap)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = name .. " ❌"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = contentFrame
    
    -- Навесной эффект
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)
    
    buttons[name] = btn
end

-- Функция обновления текста кнопок
local function updateButtonUI()
    buttons["Speed"].Text = "Speed " .. (speedEnabled and "✅" or "❌")
    buttons["Fly"].Text = "Fly " .. (flyEnabled and "✅" or "❌")
    buttons["Noclip"].Text = "Noclip " .. (noclipEnabled and "✅" or "❌")
    buttons["God"].Text = "God " .. (godEnabled and "✅" or "❌")
end

-- === 1. Увеличение скорости ===
local function setSpeed(enabled)
    speedEnabled = enabled
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        if enabled then
            originalSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = 70
        else
            humanoid.WalkSpeed = originalSpeed
        end
    end
    updateButtonUI()
end

-- === 2. Умение летать ===
local function setFly(enabled)
    flyEnabled = enabled
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    if enabled then
        humanoid.PlatformStand = true
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        flyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyVelocity.Parent = hrp
        
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(10000, 10000, 10000)
        bg.Parent = hrp
        
        runService:BindToRenderStep("FlyControl", 100, function()
            if not flyEnabled or not hrp or not hrp.Parent then return end
            local move = Vector3.new()
            if userInput:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
            if userInput:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
            if userInput:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
            if userInput:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
            if userInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0, -1, 0) end
            
            local cam = workspace.CurrentCamera
            local forward = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local velocity = (forward * move.Z + right * move.X + Vector3.new(0, move.Y, 0)) * 80
            if flyVelocity then flyVelocity.Velocity = velocity end
        end)
    else
        humanoid.PlatformStand = false
        if flyVelocity then flyVelocity:Destroy() end
        runService:UnbindFromRenderStep("FlyControl")
        local bg = hrp:FindFirstChild("BodyGyro")
        if bg then bg:Destroy() end
    end
    updateButtonUI()
end

-- === 3. Noclip ===
local function setNoclip(enabled)
    noclipEnabled = enabled
    if enabled then
        runService:BindToRenderStep("Noclip", 101, function()
            if not noclipEnabled then return end
            char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        runService:UnbindFromRenderStep("Noclip")
        char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
    updateButtonUI()
end

-- === 4. Бессмертие ===
local function setGod(enabled)
    godEnabled = enabled
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        if enabled then
            humanoid.BreakJointsOnDeath = false
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if godEnabled and humanoid.Health <= 0 then
                    humanoid.Health = 10000
                end
            end)
        else
            humanoid.BreakJointsOnDeath = true
            humanoid.MaxHealth = 100
            if humanoid.Health > 100 then humanoid.Health = 100 end
        end
    end
    updateButtonUI()
end

-- === 5. Телепорт к людям ===
local function createTeleportPanel()
    local teleFrame = Instance.new("Frame")
    teleFrame.Size = UDim2.new(0, 250, 0, 300)
    teleFrame.Position = UDim2.new(1, -260, 0, 50)
    teleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    teleFrame.BackgroundTransparency = 0.05
    teleFrame.BorderSizePixel = 1
    teleFrame.BorderColor3 = Color3.fromRGB(80, 80, 90)
    teleFrame.Parent = screenGui
    
    local teleTitle = Instance.new("TextLabel")
    teleTitle.Size = UDim2.new(1, 0, 0, 25)
    teleTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    teleTitle.Text = "Игроки"
    teleTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    teleTitle.TextSize = 12
    teleTitle.Font = Enum.Font.Gotham
    teleTitle.Parent = teleFrame
    
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -10, 1, -35)
    listFrame.Position = UDim2.new(0, 5, 0, 30)
    listFrame.BackgroundTransparency = 1
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.ScrollBarThickness = 6
    listFrame.Parent = teleFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = listFrame
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 50, 0, 20)
    refreshBtn.Position = UDim2.new(1, -55, 0, 3)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    refreshBtn.Text = "⟳"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextSize = 12
    refreshBtn.Font = Enum.Font.Gotham
    refreshBtn.Parent = teleFrame
    
    local function refreshPlayers()
        for _, child in pairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local players = game.Players:GetPlayers()
        for _, plr in pairs(players) do
            if plr ~= player then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                btn.Text = plr.Name
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                btn.BorderSizePixel = 0
                btn.Parent = listFrame
                
                btn.MouseButton1Click:Connect(function()
                    local targetChar = plr.Character
                    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end)
            end
        end
        listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end
    
    refreshBtn.MouseButton1Click:Connect(refreshPlayers)
    refreshPlayers()
end

-- Назначение действий кнопкам
buttons["Speed"].MouseButton1Click:Connect(function() setSpeed(not speedEnabled) end)
buttons["Fly"].MouseButton1Click:Connect(function() setFly(not flyEnabled) end)
buttons["Noclip"].MouseButton1Click:Connect(function() setNoclip(not noclipEnabled) end)
buttons["God"].MouseButton1Click:Connect(function() setGod(not godEnabled) end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    setSpeed(false)
    setFly(false)
    setNoclip(false)
    setGod(false)
end)

updateButtonUI()
createTeleportPanel()

-- Обновление персонажа при респавне
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    if speedEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 70 end
    end
    if godEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.BreakJointsOnDeath = false
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end
end)

print("Colin Panel загружена. Панель можно перетаскивать за заголовок.")
