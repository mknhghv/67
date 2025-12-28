-- 玄丛腳本 - 快速攻擊優化版
print("🎮 =================================")
print("🎮 玄丛腳本 - 快速攻擊優化版")
print("🎮 秦始皇创作")
print("🎮 =================================")

-- 檢測設備類型
local inputService = game:GetService("UserInputService")
local isMobile = inputService.TouchEnabled
local isDesktop = inputService.MouseEnabled
local deviceType = isMobile and "📱 手機" or "🖥️ 電腦"
print("✅ 檢測到設備: " .. deviceType)

-- 確保遊戲完全加載
repeat task.wait() until game:IsLoaded()
print("✅ 遊戲已加載")

-- 獲取玩家
local player = game.Players.LocalPlayer
if not player then
    warn("❌ 無法獲取玩家")
    return
end
print("✅ 玩家: " .. player.Name)

-- 等待PlayerGui
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
    warn("❌ 無法找到PlayerGui，嘗試使用CoreGui")
    playerGui = game:GetService("CoreGui")
end
print("✅ UI容器: " .. playerGui.Name)

-- 清理舊的UI
for _, gui in ipairs(playerGui:GetChildren()) do
    if gui.Name:find("XuanCong") then
        gui:Destroy()
    end
end
print("🗑️ 清理了舊的UI")

-- ========================
-- 全局服務
-- ========================
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local httpService = game:GetService("HttpService")

print("✅ 服務加載完成")

-- ========================
-- 創建主UI ScreenGui
-- ========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XuanCongScript_Optimized"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.IgnoreGuiInset = false

print("✅ ScreenGui創建完成")

-- ========================
-- 創建左側固定設置按鈕（左上角）
-- ========================
print("⚙️ 創建左側設置按鈕...")

local sidebarButton = Instance.new("TextButton")
sidebarButton.Name = "SidebarButton"
sidebarButton.Size = UDim2.new(0, 45, 0, 45)
sidebarButton.Position = UDim2.new(0, 15, 0, 15)
sidebarButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
sidebarButton.BackgroundTransparency = 0.1
sidebarButton.BorderSizePixel = 0
sidebarButton.Text = "⚙️"
sidebarButton.TextColor3 = Color3.fromRGB(200, 230, 255)
sidebarButton.Font = Enum.Font.GothamBold
sidebarButton.TextSize = 18
sidebarButton.AutoButtonColor = true
sidebarButton.ZIndex = 1000
sidebarButton.Parent = screenGui

-- 圓角
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 10)
sidebarCorner.Parent = sidebarButton

-- 邊框
local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = Color3.fromRGB(100, 150, 200)
sidebarStroke.Thickness = 2
sidebarStroke.Parent = sidebarButton

-- 添加陰影效果
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = 999
shadow.Parent = sidebarButton

-- 懸停提示
local buttonHint = Instance.new("TextLabel")
buttonHint.Name = "ButtonHint"
buttonHint.Size = UDim2.new(0, 100, 0, 25)
buttonHint.Position = UDim2.new(0, 55, 0, 10)
buttonHint.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
buttonHint.BackgroundTransparency = 0.2
buttonHint.Text = "開啟玄丛腳本"
buttonHint.TextColor3 = Color3.fromRGB(200, 230, 255)
buttonHint.Font = Enum.Font.Gotham
buttonHint.TextSize = 11
buttonHint.TextXAlignment = Enum.TextXAlignment.Center
buttonHint.Visible = false
buttonHint.ZIndex = 999
buttonHint.Parent = screenGui

local hintCorner = Instance.new("UICorner")
hintCorner.CornerRadius = UDim.new(0, 6)
hintCorner.Parent = buttonHint

-- 懸停效果
sidebarButton.MouseEnter:Connect(function()
    buttonHint.Visible = true
    sidebarStroke.Color = Color3.fromRGB(150, 200, 255)
    sidebarButton.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
end)

sidebarButton.MouseLeave:Connect(function()
    buttonHint.Visible = false
    sidebarStroke.Color = Color3.fromRGB(100, 150, 200)
    sidebarButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
end)

print("✅ 左側設置按鈕創建完成")

-- ========================
-- 創建主框架（初始隱藏）
-- ========================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 160)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = screenGui

-- 圓角
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- 邊框
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(100, 150, 200)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

print("✅ 主框架創建完成")

-- ========================
-- 修復的拖動系統
-- ========================
print("🔄 設置拖動系統...")

-- 創建拖動標題欄
local dragButton = Instance.new("TextButton")
dragButton.Name = "DragButton"
dragButton.Size = UDim2.new(1, 0, 0, 35)
dragButton.Position = UDim2.new(0, 0, 0, 0)
dragButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
dragButton.BackgroundTransparency = 0.2
dragButton.BorderSizePixel = 0
dragButton.Text = "❄️ 玄丛腳本 (拖動我)"
dragButton.TextColor3 = Color3.fromRGB(200, 230, 255)
dragButton.Font = Enum.Font.GothamBold
dragButton.TextSize = 14
dragButton.AutoButtonColor = false
dragButton.Parent = mainFrame

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 8, 0, 0)
dragCorner.Parent = dragButton

-- 關閉按鈕（使用 ❌️ 圖標）
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -32, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
closeButton.BackgroundTransparency = 0.2
closeButton.BorderSizePixel = 0
closeButton.Text = "❌️"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.AutoButtonColor = true
closeButton.ZIndex = 2
closeButton.Parent = dragButton

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- 關閉按鈕懸停效果
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
end)

-- 修復的拖動變量
local isDragging = false
local dragStartPosition = Vector2.new(0, 0)
local frameStartPosition = UDim2.new(0, 0, 0, 0)

-- 修復的電腦拖動（使用正確的參數）
dragButton.MouseButton1Down:Connect(function()
    isDragging = true
    dragStartPosition = inputService:GetMouseLocation()
    frameStartPosition = mainFrame.Position
    dragButton.BackgroundColor3 = Color3.fromRGB(60, 90, 140)
    print("🖱️ 開始拖動")
end)

-- 使用 RenderStepped 來平滑拖動
runService.RenderStepped:Connect(function()
    if isDragging then
        local currentMouse = inputService:GetMouseLocation()
        local delta = currentMouse - dragStartPosition
        
        mainFrame.Position = UDim2.new(
            frameStartPosition.X.Scale,
            frameStartPosition.X.Offset + delta.X,
            frameStartPosition.Y.Scale,
            frameStartPosition.Y.Offset + delta.Y
        )
    end
end)

inputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if isDragging then
            isDragging = false
            dragButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
            print("🖱️ 停止拖動")
        end
    end
end)

-- 手機拖動
if isMobile then
    print("📱 設置手機拖動系統...")
    
    local touchArea = Instance.new("TextButton")
    touchArea.Name = "TouchArea"
    touchArea.Size = UDim2.new(1, 25, 1, 25)
    touchArea.Position = UDim2.new(0, -12, 0, -12)
    touchArea.BackgroundTransparency = 1
    touchArea.Text = ""
    touchArea.ZIndex = -1
    touchArea.Parent = dragButton
    
    local touchStartPosition = Vector2.new(0, 0)
    local touchFrameStart = UDim2.new(0, 0, 0, 0)
    local touchDragging = false
    
    -- 觸控開始
    touchArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            touchDragging = true
            touchStartPosition = input.Position
            touchFrameStart = mainFrame.Position
            dragButton.BackgroundColor3 = Color3.fromRGB(60, 90, 140)
        end
    end)
    
    -- 觸控移動
    inputService.InputChanged:Connect(function(input)
        if touchDragging and input.UserInputType == Enum.UserInputType.Touch then
            local currentTouch = input.Position
            local delta = currentTouch - touchStartPosition
            
            mainFrame.Position = UDim2.new(
                touchFrameStart.X.Scale,
                touchFrameStart.X.Offset + delta.X,
                touchFrameStart.Y.Scale,
                touchFrameStart.Y.Offset + delta.Y
            )
        end
    end)
    
    -- 觸控結束
    inputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if touchDragging then
                touchDragging = false
                dragButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
            end
        end
    end)
end

print("✅ 拖動系統已設置")

-- ========================
-- 創建功能按鈕
-- ========================
local function createButton(text, icon, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Size = UDim2.new(1, -20, 0, 32)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 0
    button.Text = icon .. " " .. text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 13
    button.AutoButtonColor = true
    button.Active = true
    button.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

-- 創建按鈕
local fastAttackBtn = createButton("快速攻擊", "⚡", 40, Color3.fromRGB(0, 150, 220))
local piScriptBtn = createButton("皮腳本", "🅿️", 78, Color3.fromRGB(220, 150, 50))

print("✅ 功能按鈕創建完成")

-- ========================
-- 添加作者信息
-- ========================
local authorLabel = Instance.new("TextLabel")
authorLabel.Name = "AuthorLabel"
authorLabel.Size = UDim2.new(1, -20, 0, 18)
authorLabel.Position = UDim2.new(0, 10, 0, 122)
authorLabel.BackgroundTransparency = 1
authorLabel.Text = "👑 秦始皇创作"
authorLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
authorLabel.Font = Enum.Font.Gotham
authorLabel.TextSize = 10
authorLabel.TextXAlignment = Enum.TextXAlignment.Center
authorLabel.Parent = mainFrame

local versionLabel = Instance.new("TextLabel")
versionLabel.Name = "VersionLabel"
versionLabel.Size = UDim2.new(1, -20, 0, 14)
versionLabel.Position = UDim2.new(0, 10, 0, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "❄️ 玄丛腳本 v6.0"
versionLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 9
versionLabel.TextXAlignment = Enum.TextXAlignment.Center
versionLabel.Parent = mainFrame

-- ========================
-- 右下角通知系統
-- ========================
local function showNotification(message, color, duration)
    duration = duration or 2.5
    
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Name = "Notify_" .. tick()
    notifyFrame.Size = UDim2.new(0, 220, 0, 60)
    notifyFrame.Position = UDim2.new(1, 230, 1, -70)
    notifyFrame.AnchorPoint = Vector2.new(1, 1)
    notifyFrame.BackgroundColor3 = color or Color3.fromRGB(40, 60, 90)
    notifyFrame.BackgroundTransparency = 0.2
    notifyFrame.BorderSizePixel = 0
    notifyFrame.ZIndex = 10000
    notifyFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifyFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 200, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = notifyFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -20)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 12
    textLabel.TextWrapped = true
    textLabel.Parent = notifyFrame
    
    print("📢 通知: " .. message)
    
    local slideIn = tweenService:Create(notifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -15, 1, -70)
    })
    slideIn:Play()
    
    task.spawn(function()
        task.wait(duration)
        
        if notifyFrame and notifyFrame.Parent then
            local slideOut = tweenService:Create(notifyFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 230, 1, -70)
            })
            slideOut:Play()
            
            slideOut.Completed:Wait()
            notifyFrame:Destroy()
        end
    end)
    
    return notifyFrame
end

-- ========================
-- 你的快速攻擊代碼（替換版）
-- ========================
print("⚡ 初始化快速攻擊系統（新版）...")

local isFastAttackOn = false
local fastAttackModule = nil

_G.FastAttack = true

local function setupFastAttack()
    if _G.FastAttack then
        local _ENV = (getgenv or getrenv or getfenv)()

        local function SafeWaitForChild(parent, childName)
            local success, result = pcall(function()
                return parent:WaitForChild(childName)
            end)
            if not success or not result then
                warn("noooooo: " .. childName)
            end
            return result
        end

        local function WaitChilds(path, ...)
            local last = path
            for _, child in {...} do
                last = last:FindFirstChild(child) or SafeWaitForChild(last, child)
                if not last then break end
            end
            return last
        end

        local VirtualInputManager = game:GetService("VirtualInputManager")
        local CollectionService = game:GetService("CollectionService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local TeleportService = game:GetService("TeleportService")
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer

        if not Player then
            warn("找不到本地玩家。")
            return nil
        end

        local Remotes = SafeWaitForChild(ReplicatedStorage, "Remotes")
        if not Remotes then return nil end

        local Validator = SafeWaitForChild(Remotes, "Validator")
        local CommF = SafeWaitForChild(Remotes, "CommF_")
        local CommE = SafeWaitForChild(Remotes, "CommE")

        local ChestModels = SafeWaitForChild(workspace, "ChestModels")
        local WorldOrigin = SafeWaitForChild(workspace, "_WorldOrigin")
        local Characters = SafeWaitForChild(workspace, "Characters")
        local Enemies = SafeWaitForChild(workspace, "Enemies")
        local Map = SafeWaitForChild(workspace, "Map")

        local EnemySpawns = SafeWaitForChild(WorldOrigin, "EnemySpawns")
        local Locations = SafeWaitForChild(WorldOrigin, "Locations")

        local RenderStepped = RunService.RenderStepped
        local Heartbeat = RunService.Heartbeat
        local Stepped = RunService.Stepped

        local Modules = SafeWaitForChild(ReplicatedStorage, "Modules")
        local Net = SafeWaitForChild(Modules, "Net")

        local sethiddenproperty = sethiddenproperty or function(...) return ... end
        local setupvalue = setupvalue or (debug and debug.setupvalue)
        local getupvalue = getupvalue or (debug and debug.getupvalue)

        local Settings = {
            AutoClick = true,
            ClickDelay = 0.0000000000000000000001
        }

        local Module = {}

        Module.FastAttack = (function()
            if _ENV.rz_FastAttack then
                return _ENV.rz_FastAttack
            end

            local FastAttack = {
                Distance = 1000,
                attackMobs = true,
                attackPlayers = true,
                Equipped = nil
            }

            local RegisterAttack = SafeWaitForChild(Net, "RE/RegisterAttack")
            local RegisterHit = SafeWaitForChild(Net, "RE/RegisterHit")

            local function IsAlive(character)
                return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0
            end

            local function ProcessEnemies(OthersEnemies, Folder)
                local BasePart = nil
                for _, Enemy in Folder:GetChildren() do
                    local Head = Enemy:FindFirstChild("Head")
                    if Head and IsAlive(Enemy) and Player:DistanceFromCharacter(Head.Position) < FastAttack.Distance then
                        if Enemy ~= Player.Character then
                            table.insert(OthersEnemies, { Enemy, Head })
                            BasePart = Head
                        end
                    end
                end
                return BasePart
            end

            function FastAttack:Attack(BasePart, OthersEnemies)
                if not BasePart or #OthersEnemies == 0 then return end
                RegisterAttack:FireServer(Settings.ClickDelay or 0)
                RegisterHit:FireServer(BasePart, OthersEnemies)
            end

            function FastAttack:AttackNearest()
                local OthersEnemies = {}
                local Part1 = ProcessEnemies(OthersEnemies, Enemies)
                local Part2 = ProcessEnemies(OthersEnemies, Characters)
                if #OthersEnemies > 0 then
                    self:Attack(Part1 or Part2, OthersEnemies)
                else
                    task.wait(0)
                end
            end

            function FastAttack:BladeHits()
                local Equipped = IsAlive(Player.Character) and Player.Character:FindFirstChildOfClass("Tool")
                if Equipped and Equipped.ToolTip ~= "Gun" then
                    self:AttackNearest()
                else
                    task.wait(0)
                end
            end

            local attackLoop = nil
            
            function FastAttack:start()
                print("▶️ 開始快速攻擊")
                attackLoop = task.spawn(function()
                    while task.wait(Settings.ClickDelay) do
                        if Settings.AutoClick then
                            self:BladeHits()
                        end
                    end
                end)
            end
            
            function FastAttack:stop()
                print("⏹️ 停止快速攻擊")
                if attackLoop then
                    task.cancel(attackLoop)
                    attackLoop = nil
                end
            end

            _ENV.rz_FastAttack = FastAttack
            return FastAttack
        end)()
        
        return Module.FastAttack
    end
    return nil
end

-- 初始化快速攻擊系統
local function initFastAttack()
    showNotification("⚡ 正在初始化快速攻擊...", Color3.fromRGB(255, 165, 0), 1)
    
    local success, result = pcall(function()
        return setupFastAttack()
    end)
    
    if success and result then
        showNotification("✅ 快速攻擊初始化完成", Color3.fromRGB(0, 180, 0), 1.5)
        print("✅ 快速攻擊系統就緒")
        return result
    else
        local errMsg = result or "未知錯誤"
        showNotification("⚠️ 快速攻擊初始化失敗\n錯誤: " .. tostring(errMsg), Color3.fromRGB(255, 0, 0), 2)
        print("❌ 快速攻擊初始化失敗: " .. errMsg)
        return nil
    end
end

-- ========================
-- 皮腳本功能
-- ========================
print("🔄 設置皮腳本功能...")

local function executePiScript()
    showNotification("🅿️ 正在加載皮腳本...", Color3.fromRGB(255, 165, 0), 2)
    
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua"))()
        return true
    end)
    
    if success then
        showNotification("✅ 皮腳本加載成功！", Color3.fromRGB(0, 180, 0), 2)
        print("✅ 皮腳本加載成功")
        return true
    else
        local errMsg = err or "未知錯誤"
        showNotification("❌ 皮腳本加載失敗\n錯誤: " .. tostring(errMsg), Color3.fromRGB(255, 0, 0), 3)
        print("❌ 皮腳本錯誤: " .. errMsg)
        return false
    end
end

-- ========================
-- UI顯示/隱藏功能
-- ========================
local isUIVisible = false

-- 切換UI顯示狀態
local function toggleUI()
    isUIVisible = not isUIVisible
    
    if isUIVisible then
        -- 顯示UI
        mainFrame.Visible = true
        sidebarButton.Text = "📂"
        sidebarButton.BackgroundColor3 = Color3.fromRGB(60, 90, 140)
        buttonHint.Text = "關閉玄丛腳本"
        
        -- 動畫效果
        mainFrame.Position = UDim2.new(0.5, -120, 0.5, -80)
        mainFrame.BackgroundTransparency = 1
        
        local fadeIn = tweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.1
        })
        fadeIn:Play()
        
        showNotification("📱 玄丛腳本已開啟", Color3.fromRGB(50, 150, 200), 1.5)
    else
        -- 隱藏UI
        sidebarButton.Text = "⚙️"
        sidebarButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
        buttonHint.Text = "開啟玄丛腳本"
        
        local fadeOut = tweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        fadeOut:Play()
        
        fadeOut.Completed:Wait()
        mainFrame.Visible = false
        
        showNotification("📱 玄丛腳本已隱藏", Color3.fromRGB(150, 150, 150), 1.5)
    end
end

-- ========================
-- 按鈕事件
-- ========================
print("🔧 設置按鈕事件...")

-- 側邊欄按鈕點擊
sidebarButton.MouseButton1Click:Connect(function()
    toggleUI()
end)

-- 快速攻擊按鈕（使用新版代碼）
fastAttackBtn.MouseButton1Click:Connect(function()
    print("🔘 快速攻擊按鈕被點擊")
    
    if not fastAttackModule then
        showNotification("🔄 正在初始化快速攻擊系統...", Color3.fromRGB(255, 165, 0), 1)
        fastAttackModule = initFastAttack()
        if not fastAttackModule then
            showNotification("❌ 快速攻擊初始化失敗", Color3.fromRGB(255, 0, 0), 1.5)
            return
        end
    end
    
    isFastAttackOn = not isFastAttackOn
    
    if isFastAttackOn then
        -- 開啟快速攻擊
        fastAttackBtn.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
        fastAttackBtn.Text = "⚡ 快速攻擊 [ON]"
        showNotification("⚡ 快速攻擊已開啟\n正在自動攻擊敵人...", Color3.fromRGB(0, 180, 0), 2)
        
        -- 啟動快速攻擊循環
        if fastAttackModule and fastAttackModule.start then
            fastAttackModule:start()
        end
    else
        -- 關閉快速攻擊
        fastAttackBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
        fastAttackBtn.Text = "⚡ 快速攻擊 [OFF]"
        showNotification("🛑 快速攻擊已關閉", Color3.fromRGB(200, 0, 0), 1.5)
        
        -- 停止快速攻擊循環
        if fastAttackModule and fastAttackModule.stop then
            fastAttackModule:stop()
        end
    end
end)

-- 皮腳本按鈕
piScriptBtn.MouseButton1Click:Connect(function()
    piScriptBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    piScriptBtn.Text = "🅿️ 加載中..."
    
    local success = executePiScript()
    
    if success then
        piScriptBtn.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
        piScriptBtn.Text = "🅿️ 加載成功"
        task.wait(1.5)
        piScriptBtn.BackgroundColor3 = Color3.fromRGB(220, 150, 50)
        piScriptBtn.Text = "🅿️ 皮腳本"
    else
        piScriptBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        piScriptBtn.Text = "🅿️ 加載失敗"
        task.wait(1.5)
        piScriptBtn.BackgroundColor3 = Color3.fromRGB(220, 150, 50)
        piScriptBtn.Text = "🅿️ 皮腳本"
    end
end)

-- 關閉按鈕
closeButton.MouseButton1Click:Connect(function()
    toggleUI()
end)

-- ESC鍵關閉主UI（僅電腦）
if not isMobile then
    inputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape then
            if isUIVisible then
                toggleUI()
            end
        end
    end)
end

-- ========================
-- 初始化完成
-- ========================
task.wait(0.5)

-- 顯示啟動通知
showNotification("✅ 玄丛腳本已加載 v6.0\n⚡ 快速攻擊代碼已更新\n🅿️ 皮腳本可用\n🖱️ 拖動系統已修復", Color3.fromRGB(50, 150, 200), 3)

print("🎮 =================================")
print("🎮 玄丛腳本 - 快速攻擊優化版 v6.0")
print("🎮 設備: " .. deviceType)
print("🎮 快速攻擊: ✅ 使用新版代碼")
print("🎮 拖動系統: ✅ 已修復")
print("🎮 功能包括:")
print("🎮   - 新版快速攻擊系統")
print("🎮   - 自動搜索敵人 (Enemies/Characters)")
print("🎮   - 快速攻擊循環")
print("🎮   - 自動觸發攻擊事件")
print("🎮 =================================")

-- 預加載快速攻擊系統
task.spawn(function()
    task.wait(1)
    print("🔧 預加載快速攻擊系統...")
    fastAttackModule = initFastAttack()
    if fastAttackModule then
        print("✅ 快速攻擊系統預加載完成")
        showNotification("⚡ 快速攻擊系統就緒\n點擊按鈕開啟功能", Color3.fromRGB(100, 150, 200), 2)
    end
end)

print("🚀 腳本加載完成！快速攻擊代碼已更新。")
