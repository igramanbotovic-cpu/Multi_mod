-- Colin's Compact Panel (2026)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Переменные состояний
local speedEnabled = false
local noclipEnabled = false
local godEnabled = false
local currentSpeed = 16
local originalSpeed = 16

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ColinPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 90)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
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
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = contentFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = scrollFrame

-- === Функция обновления скорости ===
local function applySpeed()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and speedEnabled then
        humanoid.WalkSpeed = currentSpeed
    elseif humanoid and not speedEnabled then
        humanoid.WalkSpeed = originalSpeed
    end
end

-- === 1. Настройка скорости ===
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, 0, 0, 70)
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = scrollFrame

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0, 100, 0, 30)
speedToggle.Position = UDim2.new(0, 5, 0, 5)
speedToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
speedToggle.Text = "Speed ❌"
speedToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
speedToggle.TextSize = 13
speedToggle.Font = Enum.Font.Gotham
speedToggle.BorderSizePixel = 0
speedToggle.Parent = speedFrame

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(0, 20, 0, 20)
speedSlider.Position = UDim2.new(0, 115, 0, 10)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
speedSlider.Text = "<"
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.TextSize = 14
speedSlider.Font = Enum.Font.Gotham
speedSlider.BorderSizePixel = 0
speedSlider.Parent = speedFrame

local speedValue = Instance.new("TextBox")
speedValue.Size = UDim2.new(0, 60, 0, 25)
speedValue.Position = UDim2.new(0, 145, 0, 7)
speedValue.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
speedValue.Text = "70"
speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValue.TextSize = 12
speedValue.Font = Enum.Font.Gotham
speedValue.BorderSizePixel = 0
speedValue.Parent = speedFrame

local speedPlus = Instance.new("TextButton")
speedPlus.Size = UDim2.new(0, 20, 0, 20)
speedPlus.Position = UDim2.new(0, 215, 0, 10)
speedPlus.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
speedPlus.Text = ">"
speedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
speedPlus.TextSize = 14
speedPlus.Font = Enum.Font.Gotham
speedPlus.BorderSizePixel = 0
speedPlus.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 60, 0, 20)
speedLabel.Position = UDim2.new(0, 250, 0, 12)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "(1-300)"
speedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
speedLabel.TextSize = 10
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = speedFrame

-- Управление скоростью
local function updateSpeedValue()
    speedValue.Text = tostring(currentSpeed)
    if speedEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = currentSpeed end
    end
end

speedSlider.MouseButton1Click:Connect(function()
    currentSpeed = math.max(1, currentSpeed - 5)
    updateSpeedValue()
end)

speedPlus.MouseButton1Click:Connect(function()
    currentSpeed = math.min(300, currentSpeed + 5)
    updateSpeedValue()
end)

speedValue.FocusLost:Connect(function()
    local num = tonumber(speedValue.Text)
    if num then
        currentSpeed = math.clamp(num, 1, 300)
        updateSpeedValue()
    else
        updateSpeedValue()
    end
end)

local function toggleSpeed()
    speedEnabled = not speedEnabled
    speedToggle.Text = speedEnabled and "Speed ✅" or "Speed ❌"
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        if speedEnabled then
            originalSpeed = hum.WalkSpeed
            hum.WalkSpeed = currentSpeed
        else
            hum.WalkSpeed = originalSpeed
        end
    end
end

speedToggle.MouseButton1Click:Connect(toggleSpeed)

-- === 2. Noclip ===
local noclipFrame = Instance.new("Frame")
noclipFrame.Size = UDim2.new(1, 0, 0, 40)
noclipFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
noclipFrame.BorderSizePixel = 0
noclipFrame.Parent = scrollFrame

local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, 200, 0, 30)
noclipToggle.Position = UDim2.new(0, 5, 0, 5)
noclipToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
noclipToggle.Text = "Noclip ❌"
noclipToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
noclipToggle.TextSize = 13
noclipToggle.Font = Enum.Font.Gotham
noclipToggle.BorderSizePixel = 0
noclipToggle.Parent = noclipFrame

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    noclipToggle.Text = noclipEnabled and "Noclip ✅" or "Noclip ❌"
    
    if noclipEnabled then
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
end

noclipToggle.MouseButton1Click:Connect(toggleNoclip)

-- === 3. Бессмертие ===
local godFrame = Instance.new("Frame")
godFrame.Size = UDim2.new(1, 0, 0, 40)
godFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
godFrame.BorderSizePixel = 0
godFrame.Parent = scrollFrame

local godToggle = Instance.new("TextButton")
godToggle.Size = UDim2.new(0, 200, 0, 30)
godToggle.Position = UDim2.new(0, 5, 0, 5)
godToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
godToggle.Text = "God ❌"
godToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
godToggle.TextSize = 13
godToggle.Font = Enum.Font.Gotham
godToggle.BorderSizePixel = 0
godToggle.Parent = godFrame

local function toggleGod()
    godEnabled = not godEnabled
    godToggle.Text = godEnabled and "God ✅" or "God ❌"
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        if godEnabled then
            humanoid.BreakJointsOnDeath = false
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            
            -- Следим за здоровьем
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
end

godToggle.MouseButton1Click:Connect(toggleGod)

-- === 4. Телепорт к людям (сворачиваемое меню) ===
local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(1, 0, 0, 40)
teleportFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
teleportFrame.BorderSizePixel = 0
teleportFrame.Parent = scrollFrame

local teleportHeader = Instance.new("TextButton")
teleportHeader.Size = UDim2.new(1, -10, 0, 30)
teleportHeader.Position = UDim2.new(0, 5, 0, 5)
teleportHeader.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
teleportHeader.Text = "Люди ▼"
teleportHeader.TextColor3 = Color3.fromRGB(220, 220, 220)
teleportHeader.TextSize = 13
teleportHeader.Font = Enum.Font.Gotham
teleportHeader.BorderSizePixel = 0
teleportHeader.Parent = teleportFrame

local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1, 0, 0, 120)
playerListFrame.Position = UDim2.new(0, 0, 0, 40)
playerListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
playerListFrame.BorderSizePixel = 0
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListFrame.ScrollBarThickness = 4
playerListFrame.Visible = false
playerListFrame.Parent = teleportFrame

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 3)
playerListLayout.Parent = playerListFrame

local isOpen = false
teleportHeader.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    playerListFrame.Visible = isOpen
    teleportHeader.Text = isOpen and "Люди ▲" or "Люди ▼"
    
    if isOpen then
        -- Обновляем список игроков
        for _, child in pairs(playerListFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local players = game.Players:GetPlayers()
        for _, plr in pairs(players) do
            if plr ~= player then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, 0)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                btn.Text = plr.Name
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                btn.BorderSizePixel = 0
                btn.Parent = playerListFrame
                
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
        playerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y)
        playerListFrame.CanvasPosition = Vector2.new(0, 0)
    end
end)

-- Обновляем размер Canvas
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 250)

-- Закрытие панели
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    if speedEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
    if noclipEnabled then
        runService:UnbindFromRenderStep("Noclip")
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    if godEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.BreakJointsOnDeath = true
            hum.MaxHealth = 100
        end
    end
end)

-- Обновление персонажа
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    if speedEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = currentSpeed end
    end
    if godEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.BreakJointsOnDeath = false
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end
    if noclipEnabled then
        task.wait(0.5)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

print("Colin Panel v2 загружена. Настройка скорости 1-300, Noclip, God, сворачиваемое меню игроков.")
