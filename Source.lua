--[[ 
╔══════════════════════════════════════════════════════════════════════════╗
║         RUJXMOD - ULTIMATE EDITION UPGRADED (WITH SOUND & EFFECTS)       ║
║                    Enhanced Features • Better Animations                  ║
║                  Mobile Optimized: Cyber Blue Theme                       ║
╚══════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════════════════════════
-- ⚙️ CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════

local RuJ_Config = {
    -- Combat
    Aimbot = false,
    AimPart = "Head",
    AimSmooth = 5,
    HitChance = 100,
    HitboxExpander = false,
    HitboxSize = 15,
    
    -- Visuals
    ESP_Box = false,
    ESP_Name = false,
    Tracers = false,
    TracerOrigin = "Bottom",
    FullBright = false,
    
    -- Movement
    Speed = 16,
    Jump = 50,
    InfiniteJump = false,
    NoClip = false,
    Fly = false,
    
    -- System
    AntiAFK = false,
    SoundEnabled = true,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔊 SOUND EFFECTS LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════

local SoundLib = {}

function SoundLib.PlaySound(soundId, volume, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound.Parent = parent or LocalPlayer.Character or Workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, sound.TimeLength + 0.5)
    return sound
end

function SoundLib.Click()
    if RuJ_Config.SoundEnabled then
        SoundLib.PlaySound("rbxassetid://12221967", 0.4)
    end
end

function SoundLib.Toggle()
    if RuJ_Config.SoundEnabled then
        SoundLib.PlaySound("rbxassetid://6895490539", 0.5)
    end
end

function SoundLib.Success()
    if RuJ_Config.SoundEnabled then
        SoundLib.PlaySound("rbxassetid://9125611834", 0.6)
    end
end

function SoundLib.Error()
    if RuJ_Config.SoundEnabled then
        SoundLib.PlaySound("rbxassetid://9125611834", 0.3)
    end
end

function SoundLib.Notification()
    if RuJ_Config.SoundEnabled then
        SoundLib.PlaySound("rbxassetid://6895480898", 0.4)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎬 ADVANCED ANIMATION LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════

local AnimLib = {}

function AnimLib.Tween(object, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function AnimLib.FadeIn(ui, duration)
    ui.BackgroundTransparency = 1
    AnimLib.Tween(ui, {BackgroundTransparency = 0}, duration or 0.3)
end

function AnimLib.FadeOut(ui, duration)
    AnimLib.Tween(ui, {BackgroundTransparency = 1}, duration or 0.3)
end

function AnimLib.SlideIn(ui, duration)
    ui.Position = ui.Position + UDim2.new(0.1, 0, 0, 0)
    AnimLib.Tween(ui, {Position = ui.Position - UDim2.new(0.1, 0, 0, 0)}, duration or 0.4)
end

function AnimLib.Scale(ui, targetScale, duration)
    local originalSize = ui.Size
    ui.Size = originalSize * targetScale
    AnimLib.Tween(ui, {Size = originalSize}, duration or 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function AnimLib.ColorTween(ui, targetColor, duration)
    AnimLib.Tween(ui, {BackgroundColor3 = targetColor}, duration or 0.2)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🗑️ CLEANUP
-- ═══════════════════════════════════════════════════════════════════════════

if LocalPlayer.PlayerGui:FindFirstChild("RUJXMOD_ULTIMATE") then 
    LocalPlayer.PlayerGui.RUJXMOD_ULTIMATE:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUJXMOD_ULTIMATE"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ESP_Holder = Instance.new("Folder", game.CoreGui)
if not pcall(function() ESP_Holder.Parent = game.CoreGui end) then
    ESP_Holder.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
ESP_Holder.Name = "RUJ_ESP_HOLDER"

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 FLOATING ICON (WITH SOUND & ANIMATIONS)
-- ═══════════════════════════════════════════════════════════════════════════

local Icon = Instance.new("TextButton")
Icon.Name = "MainIcon"
Icon.Size = UDim2.new(0, 80, 0, 80)
Icon.Position = UDim2.new(0, 15, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
Icon.Text = "RX"
Icon.TextColor3 = Color3.fromRGB(0, 255, 255)
Icon.Font = Enum.Font.GothamBlack
Icon.TextSize = 28
Icon.Parent = ScreenGui
Icon.BorderSizePixel = 0

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 3
IconStroke.Parent = Icon
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

-- Icon Animations
Icon.MouseEnter:Connect(function()
    AnimLib.ColorTween(Icon, Color3.fromRGB(20, 35, 50), 0.2)
    AnimLib.Scale(Icon, 1.1, 0.2)
    SoundLib.Notification()
end)

Icon.MouseLeave:Connect(function()
    AnimLib.ColorTween(Icon, Color3.fromRGB(10, 15, 25), 0.2)
    AnimLib.Scale(Icon, 1.0, 0.2)
end)

-- Icon Drag
local dragging, dragStart, startPos
Icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Icon.Position
        AnimLib.Scale(Icon, 0.9, 0.15)
        SoundLib.Click()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 🪟 MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════════════════

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHub"
MainFrame.Size = UDim2.new(0, 550, 0, 420)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = Color3.fromRGB(0, 255, 255)
WindowStroke.Thickness = 2
WindowStroke.Transparency = 0.5
WindowStroke.Parent = MainFrame

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 HEADER
-- ═══════════════════════════════════════════════════════════════════════════

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Text = "  ⚙️ RUJXMOD ULTIMATE"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Text = "FPS: 60"
FPSLabel.Size = UDim2.new(0.2, 0, 1, 0)
FPSLabel.Position = UDim2.new(0.65, 0, 0, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextSize = 12
FPSLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(1, -50, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    AnimLib.FadeOut(MainFrame, 0.3)
    MainFrame.Visible = false
    SoundLib.Click()
end)

CloseBtn.MouseEnter:Connect(function()
    AnimLib.ColorTween(CloseBtn, Color3.fromRGB(200, 50, 50), 0.2)
end)

CloseBtn.MouseLeave:Connect(function()
    AnimLib.ColorTween(CloseBtn, Color3.fromRGB(255, 50, 50), 0.2)
end)

-- FPS Counter
local frameCounter = 0
RunService.RenderStepped:Connect(function()
    frameCounter = frameCounter + 1
    if frameCounter >= 10 then
        local fps = math.round(1 / game:GetService("RunService").RenderStepped:Wait())
        FPSLabel.Text = "FPS: " .. fps
        frameCounter = 0
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 📂 TABS
-- ═══════════════════════════════════════════════════════════════════════════

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 55)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local SideList = Instance.new("UIListLayout")
SideList.Parent = Sidebar
SideList.Padding = UDim.new(0, 8)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -160, 1, -65)
ContentArea.Position = UDim2.new(0, 150, 0, 55)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -5, 0, 45)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 12
    TabBtn.Parent = Sidebar
    TabBtn.BorderSizePixel = 0
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.Parent = ContentArea
    
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)
    PageList.Parent = Page
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        AnimLib.SlideIn(Page, 0.3)
        
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then 
                AnimLib.ColorTween(b, Color3.fromRGB(25, 30, 40), 0.2)
                b.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
        
        AnimLib.ColorTween(TabBtn, Color3.fromRGB(35, 45, 60), 0.2)
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        SoundLib.Click()
    end)
    
    TabBtn.MouseEnter:Connect(function()
        AnimLib.ColorTween(TabBtn, Color3.fromRGB(30, 35, 50), 0.15)
    end)
    
    TabBtn.MouseLeave:Connect(function()
        if Page.Visible == false then
            AnimLib.ColorTween(TabBtn, Color3.fromRGB(25, 30, 40), 0.15)
        end
    end)
    
    Pages[name] = Page
    return Page
end

local CombatTab = CreateTab("Combat")
local VisualTab = CreateTab("Visuals")
local MoveTab = CreateTab("Movement")
local PlayerTab = CreateTab("Players")
local SystemTab = CreateTab("System")

Pages["Combat"].Visible = true

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔧 UI BUILDERS
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateSection(page, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 28)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(100, 100, 100)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = page
end

local function CreateToggle(page, text, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local Status = Instance.new("TextButton")
    Status.Size = UDim2.new(0, 45, 0, 28)
    Status.Position = UDim2.new(1, -55, 0.5, -14)
    Status.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Status.Text = ""
    Status.Parent = Frame
    Status.BorderSizePixel = 0
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)
    
    local function Update()
        local state = RuJ_Config[configKey]
        if state then
            AnimLib.ColorTween(Status, Color3.fromRGB(0, 255, 150), 0.2)
        else
            AnimLib.ColorTween(Status, Color3.fromRGB(40, 40, 40), 0.2)
        end
        if callback then callback(state) end
    end
    
    Status.MouseButton1Click:Connect(function()
        RuJ_Config[configKey] = not RuJ_Config[configKey]
        AnimLib.Scale(Status, 0.85, 0.12)
        Update()
        SoundLib.Toggle()
    end)
    
    Status.MouseEnter:Connect(function()
        AnimLib.Scale(Status, 1.1, 0.1)
    end)
    
    Status.MouseLeave:Connect(function()
        AnimLib.Scale(Status, 1.0, 0.1)
    end)
    
    Update()
end

local function CreateSlider(page, text, min, max, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -15, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 5)
    Label.Text = text .. ": " .. RuJ_Config[configKey]
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -24, 0, 8)
    Bar.Position = UDim2.new(0, 12, 0, 32)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Bar.Parent = Frame
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
    
    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.Parent = Bar
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    
    local function Update(input)
        local pos = input.Position.X
        local per = math.clamp((pos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * per)
        RuJ_Config[configKey] = val
        Label.Text = text .. ": " .. val
        Fill.Size = UDim2.new(per, 0, 1, 0)
        if callback then callback(val) end
    end
    
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local conn = UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    Update(inp)
                end
            end)
            Update(input)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then conn:Disconnect() end
            end)
        end
    end)
    
    local startPer = (RuJ_Config[configKey] - min) / (max - min)
    Fill.Size = UDim2.new(startPer, 0, 1, 0)
end

local function CreateDropdown(page, text, options, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    Frame.ClipsDescendants = true
    
    local Label = Instance.new("TextLabel")
    Label.Text = text .. " ▼"
    Label.Size = UDim2.new(1, -45, 0, 45)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Size = UDim2.new(0, 45, 0, 45)
    OpenBtn.Position = UDim2.new(1, -45, 0, 0)
    OpenBtn.Text = "▼"
    OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.Parent = Frame
    
    local IsOpen = false
    OpenBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        if IsOpen then
            AnimLib.Tween(Frame, {Size = UDim2.new(1, -5, 0, 45 + (#options * 35))}, 0.3)
        else
            AnimLib.Tween(Frame, {Size = UDim2.new(1, -5, 0, 45)}, 0.3)
        end
        SoundLib.Click()
    end)
    
    for i, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 35)
        OptBtn.Position = UDim2.new(0, 0, 0, 45 + ((i-1)*35))
        OptBtn.Text = "  " .. opt
        OptBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
        OptBtn.BorderSizePixel = 0
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.Parent = Frame
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 6)
        
        OptBtn.MouseEnter:Connect(function()
            AnimLib.ColorTween(OptBtn, Color3.fromRGB(45, 50, 65), 0.15)
        end)
        
        OptBtn.MouseLeave:Connect(function()
            AnimLib.ColorTween(OptBtn, Color3.fromRGB(35, 38, 45), 0.15)
        end)
        
        OptBtn.MouseButton1Click:Connect(function()
            Label.Text = text .. " [" .. opt .. "] ▼"
            callback(opt)
            IsOpen = false
            AnimLib.Tween(Frame, {Size = UDim2.new(1, -5, 0, 45)}, 0.3)
            SoundLib.Success()
        end)
    end
end

local function CreateButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 45)
    Btn.Text = text
    Btn.BackgroundColor3 = Color3.fromRGB(35, 45, 60)
    Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.Parent = page
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    Btn.MouseButton1Click:Connect(function()
        AnimLib.Scale(Btn, 0.92, 0.12)
        callback()
        SoundLib.Success()
    end)
    
    Btn.MouseEnter:Connect(function()
        AnimLib.ColorTween(Btn, Color3.fromRGB(45, 55, 75), 0.2)
        AnimLib.Scale(Btn, 1.05, 0.1)
    end)
    
    Btn.MouseLeave:Connect(function()
        AnimLib.ColorTween(Btn, Color3.fromRGB(35, 45, 60), 0.2)
        AnimLib.Scale(Btn, 1.0, 0.1)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📋 POPULATE TABS
-- ═══════════════════════════════════════════════════════════════════════════

CreateSection(CombatTab, "AIMBOT SETTINGS")
CreateToggle(CombatTab, "Enable Aimbot", "Aimbot")
CreateDropdown(CombatTab, "Target Part", {"Head", "HumanoidRootPart", "Torso"}, function(val) RuJ_Config.AimPart = val end)
CreateSlider(CombatTab, "Smoothness", 1, 20, "AimSmooth")
CreateSlider(CombatTab, "Hit Chance %", 0, 100, "HitChance")

CreateSection(CombatTab, "HITBOX")
CreateToggle(CombatTab, "Hitbox Expander", "HitboxExpander")
CreateSlider(CombatTab, "Hitbox Size", 2, 30, "HitboxSize")

CreateSection(VisualTab, "ESP")
CreateToggle(VisualTab, "ESP Boxes", "ESP_Box")
CreateToggle(VisualTab, "ESP Names", "ESP_Name")

CreateSection(VisualTab, "TRACERS")
CreateToggle(VisualTab, "Line Tracers", "Tracers")
CreateDropdown(VisualTab, "Origin Position", {"Top", "Center", "Bottom"}, function(val) RuJ_Config.TracerOrigin = val end)

CreateSection(VisualTab, "WORLD")
CreateToggle(VisualTab, "Full Bright", "FullBright", function(s)
    if s then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

CreateSection(MoveTab, "CHARACTER")
CreateSlider(MoveTab, "Walk Speed", 16, 300, "Speed", function(v) 
    if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v end
end)
CreateSlider(MoveTab, "Jump Power", 50, 500, "Jump", function(v) 
    if LocalPlayer.Character then 
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = v 
    end
end)
CreateToggle(MoveTab, "Infinite Jump", "InfiniteJump")
CreateToggle(MoveTab, "NoClip", "NoClip")

CreateSection(MoveTab, "UTILITY")
CreateToggle(MoveTab, "Fly Mode", "Fly")
CreateButton(MoveTab, "Click TP Tool", function()
    local t = Instance.new("Tool")
    t.Name = "Teleport Tool"
    t.RequiresHandle = false
    t.Parent = LocalPlayer.Backpack
    t.Activated:Connect(function()
        LocalPlayer.Character:MoveTo(Mouse.Hit.Position)
    end)
end)

CreateSection(PlayerTab, "TARGET")
local PlayerList = {}
for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end

CreateDropdown(PlayerTab, "Select Player", PlayerList, function(name)
    local target = Players:FindFirstChild(name)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

CreateButton(PlayerTab, "Refresh Player List", function()
    print("Reopen script to refresh")
end)

CreateButton(PlayerTab, "Spectate Selected", function()
    print("Coming soon!")
end)

CreateSection(SystemTab, "OPTIMIZATION")
CreateButton(SystemTab, "FPS Boost", function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        if v:IsA("ParticleEmitter") then v.Enabled = false end
    end
end)

CreateSection(SystemTab, "MISC")
CreateToggle(SystemTab, "Anti-AFK", "AntiAFK")
CreateToggle(SystemTab, "Sound Enabled", "SoundEnabled")
CreateButton(SystemTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(SystemTab, "Server Hop", function()
    local Http = game:GetService("HttpService")
    pcall(function()
        local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in pairs(Servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- ⚙️ RUNTIME LOGIC
-- ═══════════════════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    if RuJ_Config.Aimbot then
        local target = nil
        local dist = math.huge
        local mousePos = UserInputService:GetMouseLocation()
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(RuJ_Config.AimPart) then
                if math.random(1, 100) <= RuJ_Config.HitChance then
                    local part = p.Character[RuJ_Config.AimPart]
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    local mag = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    
                    if onScreen and mag < 200 and mag < dist then
                        target = part
                        dist = mag
                    end
                end
            end
        end
        
        if target then
            local current = Camera.CFrame
            local targetCF = CFrame.new(current.Position, target.Position)
            Camera.CFrame = current:Lerp(targetCF, 1/RuJ_Config.AimSmooth)
        end
    end
    
    if RuJ_Config.HitboxExpander then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(RuJ_Config.HitboxSize, RuJ_Config.HitboxSize, RuJ_Config.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
    
    if RuJ_Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local bv = hrp:FindFirstChild("RuJ_Fly") or Instance.new("BodyVelocity", hrp)
        bv.Name = "RuJ_Fly"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Camera.CFrame.LookVector * 100
    end
    
    if RuJ_Config.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.WalkSpeed ~= RuJ_Config.Speed then
            LocalPlayer.Character.Humanoid.WalkSpeed = RuJ_Config.Speed
        end
    end
end)

local function DrawLine(from, to, color)
    local distance = (to - from).Magnitude
    local angle = math.atan2(to.Y - from.Y, to.X - from.X)
    
    local line = Instance.new("Frame")
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = color
    line.BorderSizePixel = 0
    line.Position = UDim2.fromOffset((from.X + to.X)/2, (from.Y + to.Y)/2)
    line.Rotation = math.deg(angle)
    line.Size = UDim2.fromOffset(distance, 2)
    line.Parent = ESP_Holder
    return line
end

RunService.Heartbeat:Connect(function()
    ESP_Holder:ClearAllChildren()
    
    if RuJ_Config.ESP_Box or RuJ_Config.Tracers or RuJ_Config.ESP_Name then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
                local hrpPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local headPos = Camera:WorldToViewportPoint(p.Character.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                
                if onScreen then
                    if RuJ_Config.Tracers then
                        local origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        if RuJ_Config.TracerOrigin == "Top" then origin = Vector2.new(Camera.ViewportSize.X/2, 0)
                        elseif RuJ_Config.TracerOrigin == "Center" then origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) end
                        DrawLine(origin, Vector2.new(hrpPos.X, hrpPos.Y), Color3.fromRGB(0, 255, 255))
                    end
                    
                    if RuJ_Config.ESP_Box then
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height * 0.6
                        
                        local box = Instance.new("Frame")
                        box.Size = UDim2.fromOffset(width, height)
                        box.Position = UDim2.fromOffset(hrpPos.X - width/2, headPos.Y)
                        box.BackgroundTransparency = 1
                        box.BorderColor3 = Color3.fromRGB(255, 0, 0)
                        box.BorderSizePixel = 2
                        box.Parent = ESP_Holder
                    end
                    
                    if RuJ_Config.ESP_Name then
                        local txt = Instance.new("TextLabel")
                        txt.Text = p.Name .. " [" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m]"
                        txt.Position = UDim2.fromOffset(hrpPos.X - 100, headPos.Y - 20)
                        txt.Size = UDim2.fromOffset(200, 20)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(255, 255, 0)
                        txt.TextStrokeTransparency = 0
                        txt.Font = Enum.Font.Gotham
                        txt.TextSize = 12
                        txt.Parent = ESP_Holder
                    end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if RuJ_Config.InfiniteJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔌 OPEN/CLOSE
-- ═══════════════════════════════════════════════════════════════════════════

Icon.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        AnimLib.FadeOut(MainFrame, 0.3)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        AnimLib.FadeIn(MainFrame, 0.3)
        AnimLib.SlideIn(MainFrame, 0.4)
    end
    SoundLib.Click()
end)

print("✅ RUJXMOD ULTIMATE UPGRADED LOADED!")
print("🔊 Sound Effects: ENABLED")
print("🎬 Smooth Animations: ENABLED")
print("⚙️ All Features: READY")

