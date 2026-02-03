--[[ 
╔═══════════════════════════════════════════════════════════════════════════╗
║          RUJXMOD - เวอร์ชั่นสมบูรณ์ สำหรับมือถือ (V5.0 MOBILE THAI)       ║
║            ดีไซน์ระดับมืออาชีพ • เคลื่อนไหวลื่นไหล • ตัวเลือกเต็มๆ          ║
║                        สำหรับ Roblox Executor                              ║
║                                                                             ║
║  📱 วิธีใช้:                                                               ║
║  1. Copy โค้ดทั้งหมด                                                       ║
║  2. Paste ใน Executor (Synapse X, Krnl, Script-Ware)                      ║
║  3. กด Execute/Run                                                         ║
║  4. ดูปุ่ม RX ขึ้นมาที่จอ → กดเพื่อเปิดเมนู                               ║
║                                                                             ║
╚═══════════════════════════════════════════════════════════════════════════╝
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
-- ⚙️ ตั้งค่า
-- ═══════════════════════════════════════════════════════════════════════════

local RuJ_Config = {
    -- การต่อสู้
    Aimbot = false,
    AimPart = "หัว",
    AimSmooth = 5,
    HitChance = 100,
    HitboxExpander = false,
    HitboxSize = 15,
    
    -- การแสดงผล
    ESP_Box = false,
    ESP_Name = false,
    Tracers = false,
    TracerOrigin = "ล่าง",
    FullBright = false,
    
    -- การเคลื่อนไหว
    Speed = 16,
    Jump = 50,
    InfiniteJump = false,
    NoClip = false,
    Fly = false,
    
    -- ระบบ
    AntiAFK = false,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 สีและสไตล์ (สีฟ้า + ขาว)
-- ═══════════════════════════════════════════════════════════════════════════

local Colors = {
    DarkBg = Color3.fromRGB(10, 12, 18),
    SideBg = Color3.fromRGB(15, 18, 28),
    ElementBg = Color3.fromRGB(22, 26, 38),
    HoverBg = Color3.fromRGB(30, 35, 50),
    ActiveBg = Color3.fromRGB(35, 45, 60),
    CyanAccent = Color3.fromRGB(0, 255, 255),
    BluePrimary = Color3.fromRGB(100, 200, 255),
    WhiteAccent = Color3.fromRGB(240, 245, 250),
    LightBlue = Color3.fromRGB(150, 220, 255),
    TextMain = Color3.fromRGB(230, 230, 240),
    TextSecond = Color3.fromRGB(150, 150, 165),
    TextDim = Color3.fromRGB(100, 105, 120),
    Success = Color3.fromRGB(0, 255, 150),
    Danger = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 200, 50),
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎬 ไลบรารี่เอฟเฟกต์
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

function AnimLib.FadeOut(ui, duration, callback)
    local tween = AnimLib.Tween(ui, {BackgroundTransparency = 1}, duration or 0.3)
    if callback then tween.Completed:Connect(callback) end
    return tween
end

function AnimLib.SlideUp(ui, duration)
    ui.Position = ui.Position + UDim2.new(0, 0, 0.1, 0)
    AnimLib.Tween(ui, {Position = ui.Position - UDim2.new(0, 0, 0.1, 0)}, duration or 0.4)
end

function AnimLib.Scale(ui, targetScale, duration)
    local originalSize = ui.Size
    ui.Size = originalSize * targetScale
    AnimLib.Tween(ui, {Size = originalSize}, duration or 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function AnimLib.Pulse(ui, duration)
    AnimLib.Scale(ui, 0.95, duration or 0.2)
end

function AnimLib.Glow(ui, color, thickness)
    color = color or Colors.CyanAccent
    thickness = thickness or 2
    local stroke = ui:FindFirstChild("UIStroke") or Instance.new("UIStroke", ui)
    stroke.Color = color
    stroke.Thickness = 0
    AnimLib.Tween(stroke, {Thickness = thickness}, 0.4)
    return stroke
end

function AnimLib.Unglow(ui)
    local stroke = ui:FindFirstChild("UIStroke")
    if stroke then AnimLib.Tween(stroke, {Thickness = 0}, 0.3) end
end

function AnimLib.ColorTween(ui, targetColor, duration)
    AnimLib.Tween(ui, {BackgroundColor3 = targetColor}, duration or 0.3)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🗑️ ลบ UI เก่า
-- ═══════════════════════════════════════════════════════════════════════════

if LocalPlayer.PlayerGui:FindFirstChild("RUJXMOD_MOBILE") then 
    LocalPlayer.PlayerGui.RUJXMOD_MOBILE:Destroy() 
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📱 UI หลัก (Mobile Optimized)
-- ═══════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUJXMOD_MOBILE"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ESP_Holder = Instance.new("Folder")
pcall(function() ESP_Holder.Parent = game.CoreGui end)
if ESP_Holder.Parent == nil then
    ESP_Holder.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
ESP_Holder.Name = "RUJ_ESP_MOBILE"

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 ไอคอนลอยตัว (ปรับให้ดีขึ้นสำหรับมือถือ)
-- ═══════════════════════════════════════════════════════════════════════════

local Icon = Instance.new("TextButton")
Icon.Name = "MainIcon"
Icon.Size = UDim2.new(0, 100, 0, 100)
Icon.Position = UDim2.new(0, 15, 0, 80)
Icon.BackgroundColor3 = Colors.DarkBg
Icon.Text = "RX\nเมนู"
Icon.TextColor3 = Colors.CyanAccent
Icon.Font = Enum.Font.GothamBlack
Icon.TextSize = 18
Icon.Parent = ScreenGui
Icon.BorderSizePixel = 0
Icon.ZIndex = 100

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Colors.CyanAccent
IconStroke.Thickness = 4
IconStroke.Parent = Icon

Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

-- ลูปวงแหวน
local Ring = Instance.new("Frame")
Ring.Size = UDim2.new(0, 100, 0, 100)
Ring.Position = UDim2.new(0, 0, 0, 0)
Ring.BackgroundTransparency = 1
Ring.BorderSizePixel = 0
Ring.Parent = Icon

local RingStroke = Instance.new("UIStroke")
RingStroke.Color = Colors.LightBlue
RingStroke.Thickness = 2
RingStroke.Transparency = 0.6
RingStroke.Parent = Ring

Instance.new("UICorner", Ring).CornerRadius = UDim.new(1, 0)

spawn(function()
    while Icon.Parent do
        AnimLib.Tween(Ring, {Rotation = 360}, 3, Enum.EasingStyle.Linear)
        wait(3)
        Ring.Rotation = 0
    end
end)

Icon.MouseEnter:Connect(function()
    AnimLib.ColorTween(Icon, Colors.HoverBg, 0.2)
    AnimLib.Glow(Icon, Colors.BluePrimary, 5)
end)

Icon.MouseLeave:Connect(function()
    AnimLib.ColorTween(Icon, Colors.DarkBg, 0.2)
    AnimLib.Unglow(Icon)
end)

-- ลากไอคอน
local dragging, dragStart, startPos

Icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Icon.Position
        AnimLib.Pulse(Icon, 0.15)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Icon.Position = UDim2.new(startPos.X.Scale, math.clamp(startPos.X.Offset + delta.X, 0, 1920), 
                                   startPos.Y.Scale, math.clamp(startPos.Y.Offset + delta.Y, 0, 1080))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 🪟 หน้าต่างหลัก (ปรับขนาดสำหรับมือถือ)
-- ═══════════════════════════════════════════════════════════════════════════

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHub"
MainFrame.Size = UDim2.new(0.95, 0, 0.85, 0)
MainFrame.Position = UDim2.new(0.025, 0, 0.075, 0)
MainFrame.BackgroundColor3 = Colors.DarkBg
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 50

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = Colors.CyanAccent
WindowStroke.Thickness = 2
WindowStroke.Transparency = 0.6
WindowStroke.Parent = MainFrame

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 ส่วนหัว
-- ═══════════════════════════════════════════════════════════════════════════

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Colors.SideBg
Header.BorderSizePixel = 0
Header.Parent = MainFrame

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 15)

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, 0, 0, 2)
HeaderDivider.Position = UDim2.new(0, 0, 1, -2)
HeaderDivider.BackgroundColor3 = Colors.CyanAccent
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "⚙️  RUJXMOD สูงสุด V5"
TitleLabel.Size = UDim2.new(0.65, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Colors.WhiteAccent
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Text = "FPS: 60"
FPSLabel.Size = UDim2.new(0.25, 0, 0.5, 0)
FPSLabel.Position = UDim2.new(0.65, 0, 0.1, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Colors.TextSecond
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextSize = 11
FPSLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 60, 0, 60)
CloseBtn.Position = UDim2.new(1, -75, 0.05, 0)
CloseBtn.BackgroundColor3 = Colors.DarkBg
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.Danger
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = Header
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 60

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

CloseBtn.MouseButton1Click:Connect(function()
    AnimLib.FadeOut(MainFrame, 0.3, function()
        MainFrame.Visible = false
    end)
end)

CloseBtn.MouseEnter:Connect(function()
    AnimLib.ColorTween(CloseBtn, Colors.Danger, 0.2)
end)

CloseBtn.MouseLeave:Connect(function()
    AnimLib.ColorTween(CloseBtn, Colors.DarkBg, 0.2)
end)

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
-- 📂 ระบบแท็บ
-- ═══════════════════════════════════════════════════════════════════════════

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -75)
Sidebar.Position = UDim2.new(0, 8, 0, 72)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local SideList = Instance.new("UIListLayout")
SideList.Parent = Sidebar
SideList.Padding = UDim.new(0, 8)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -165, 1, -80)
ContentArea.Position = UDim2.new(0, 155, 0, 75)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}
local currentPage = nil

local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -5, 0, 50)
    TabBtn.Text = icon .. "\n" .. name
    TabBtn.BackgroundColor3 = Colors.ElementBg
    TabBtn.TextColor3 = Colors.TextSecond
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 11
    TabBtn.Parent = Sidebar
    TabBtn.BorderSizePixel = 0

    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.Parent = ContentArea

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)
    PageList.Parent = Page

    TabBtn.MouseButton1Click:Connect(function()
        if currentPage then
            AnimLib.FadeOut(currentPage, 0.2, function()
                currentPage.Visible = false
            end)
        end
        
        Page.Visible = true
        Page.BackgroundTransparency = 1
        AnimLib.FadeIn(Page, 0.2)
        AnimLib.SlideUp(Page, 0.3)
        
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then 
                AnimLib.ColorTween(b, Colors.ElementBg, 0.2)
                b.TextColor3 = Colors.TextSecond
                local stroke = b:FindFirstChild("UIStroke")
                if stroke then stroke:Destroy() end
            end
        end
        
        AnimLib.ColorTween(TabBtn, Colors.ActiveBg, 0.2)
        TabBtn.TextColor3 = Colors.CyanAccent
        AnimLib.Glow(TabBtn, Colors.CyanAccent, 2)
        currentPage = Page
    end)

    TabBtn.MouseEnter:Connect(function()
        if currentPage ~= Page then
            AnimLib.ColorTween(TabBtn, Colors.HoverBg, 0.15)
        end
    end)

    TabBtn.MouseLeave:Connect(function()
        if currentPage ~= Page then
            AnimLib.ColorTween(TabBtn, Colors.ElementBg, 0.15)
        end
    end)

    Pages[name] = Page
    return Page
end

local CombatTab = CreateTab("ต่อสู้", "⚔️")
local VisualTab = CreateTab("สายตา", "👁️")
local MoveTab = CreateTab("เคลื่อน", "🏃")
local PlayerTab = CreateTab("ผู้เล่น", "👥")
local SystemTab = CreateTab("ระบบ", "⚙️")

CombatTab.Visible = true
currentPage = CombatTab
local firstBtn = Sidebar:GetChildren()[1]
if firstBtn and firstBtn:IsA("TextButton") then
    firstBtn.BackgroundColor3 = Colors.ActiveBg
    firstBtn.TextColor3 = Colors.CyanAccent
    AnimLib.Glow(firstBtn, Colors.CyanAccent, 2)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔧 ตัวสร้าง UI
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateSection(page, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 35)
    Label.Text = "  " .. string.upper(text)
    Label.TextColor3 = Colors.TextDim
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = page
end

local function CreateToggle(page, text, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = Colors.ElementBg
    Frame.Parent = page
    
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Text = text
    Label.TextColor3 = Colors.TextMain
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Status = Instance.new("TextButton")
    Status.Size = UDim2.new(0, 55, 0, 32)
    Status.Position = UDim2.new(1, -70, 0.5, -16)
    Status.BackgroundColor3 = Colors.HoverBg
    Status.Text = ""
    Status.Parent = Frame
    Status.BorderSizePixel = 0

    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

    local function Update()
        local state = RuJ_Config[configKey]
        local targetColor = state and Colors.Success or Colors.HoverBg
        AnimLib.ColorTween(Status, targetColor, 0.2)
        if callback then callback(state) end
    end

    Status.MouseButton1Click:Connect(function()
        RuJ_Config[configKey] = not RuJ_Config[configKey]
        AnimLib.Scale(Status, 0.9, 0.1)
        Update()
    end)

    Status.MouseEnter:Connect(function()
        AnimLib.Glow(Status, Colors.CyanAccent, 1.5)
    end)

    Status.MouseLeave:Connect(function()
        AnimLib.Unglow(Status)
    end)

    Update()
end

local function CreateSlider(page, text, min, max, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 70)
    Frame.BackgroundColor3 = Colors.ElementBg
    Frame.Parent = page
    
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 15, 0, 8)
    Label.Text = text .. ": " .. RuJ_Config[configKey]
    Label.TextColor3 = Colors.TextMain
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -30, 0, 10)
    Bar.Position = UDim2.new(0, 15, 0, 38)
    Bar.BackgroundColor3 = Colors.HoverBg
    Bar.Parent = Frame
    
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = Colors.CyanAccent
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
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = Colors.ElementBg
    Frame.Parent = page
    
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    Frame.ClipsDescendants = false

    local Label = Instance.new("TextLabel")
    Label.Text = text .. " ▼"
    Label.Size = UDim2.new(1, -40, 0, 50)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.TextColor3 = Colors.TextMain
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local IsOpen = false
    
    Label.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        if IsOpen then
            AnimLib.Tween(Frame, {Size = UDim2.new(1, -5, 0, 50 + (#options * 40))}, 0.3)
        else
            AnimLib.Tween(Frame, {Size = UDim2.new(1, -5, 0, 50)}, 0.3)
        end
    end)

    for i, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 40)
        OptBtn.Position = UDim2.new(0, 0, 0, 50 + ((i-1)*40))
        OptBtn.Text = "  " .. opt
        OptBtn.TextColor3 = Colors.TextSecond
        OptBtn.BackgroundColor3 = Colors.HoverBg
        OptBtn.BorderSizePixel = 0
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.Parent = Frame

        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 6)

        OptBtn.MouseEnter:Connect(function()
            AnimLib.ColorTween(OptBtn, Colors.ActiveBg, 0.15)
        end)

        OptBtn.MouseLeave:Connect(function()
            AnimLib.ColorTween(OptBtn, Colors.HoverBg, 0.15)
        end)

        OptBtn.MouseButton1Click:Connect(function()
            Label.Text = text .. " [" .. opt .. "] ▼"
            callback(opt)
            IsOpen = false
            AnimLib.Tween(Frame, {Size = UDim2.new(1, -5, 0, 50)}, 0.3)
        end)
    end
end

local function CreateButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 50)
    Btn.Text = text
    Btn.BackgroundColor3 = Colors.ActiveBg
    Btn.TextColor3 = Colors.CyanAccent
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.Parent = page
    Btn.BorderSizePixel = 0

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        AnimLib.Scale(Btn, 0.95, 0.1)
        callback()
    end)

    Btn.MouseEnter:Connect(function()
        AnimLib.ColorTween(Btn, Colors.HoverBg, 0.2)
        AnimLib.Glow(Btn, Colors.BluePrimary, 2)
    end)

    Btn.MouseLeave:Connect(function()
        AnimLib.ColorTween(Btn, Colors.ActiveBg, 0.2)
        AnimLib.Unglow(Btn)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📋 ปล่อยอุปกรณ์
-- ═══════════════════════════════════════════════════════════════════════════

CreateSection(CombatTab, "ตั้งค่า Aimbot")
CreateToggle(CombatTab, "เปิด Aimbot", "Aimbot")
CreateDropdown(CombatTab, "ส่วนเป้าหมาย", {"หัว", "ตัว", "ลำตัว"}, function(val) RuJ_Config.AimPart = val end)
CreateSlider(CombatTab, "ความเรียบ", 1, 20, "AimSmooth")
CreateSlider(CombatTab, "โอกาสโจมตี %", 0, 100, "HitChance")

CreateSection(CombatTab, "Hitbox")
CreateToggle(CombatTab, "ขยาย Hitbox", "HitboxExpander")
CreateSlider(CombatTab, "ขนาด Hitbox", 2, 30, "HitboxSize")

CreateSection(VisualTab, "ESP")
CreateToggle(VisualTab, "กล่อง ESP", "ESP_Box")
CreateToggle(VisualTab, "ชื่อ ESP", "ESP_Name")

CreateSection(VisualTab, "เส้นติดตาม")
CreateToggle(VisualTab, "เส้นติดตาม", "Tracers")
CreateDropdown(VisualTab, "ตำแหน่งเริ่มต้น", {"บน", "กลาง", "ล่าง"}, function(val) RuJ_Config.TracerOrigin = val end)

CreateSection(VisualTab, "โลก")
CreateToggle(VisualTab, "เต็มความสว่าง", "FullBright", function(s)
    if s then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

CreateSection(MoveTab, "ตัวละคร")
CreateSlider(MoveTab, "ความเร็ว", 16, 300, "Speed", function(v) 
    if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v end
end)
CreateSlider(MoveTab, "พลังกระโดด", 50, 500, "Jump", function(v) 
    if LocalPlayer.Character then 
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = v 
    end
end)
CreateToggle(MoveTab, "กระโดดไม่จำกัด", "InfiniteJump")
CreateToggle(MoveTab, "ผ่านผนัง", "NoClip")

CreateSection(MoveTab, "เครื่องมือ")
CreateToggle(MoveTab, "โหมดบิน", "Fly")
CreateButton(MoveTab, "โทรทำลาย", function()
    local t = Instance.new("Tool")
    t.Name = "Teleport Tool"
    t.RequiresHandle = false
    t.Parent = LocalPlayer.Backpack
    t.Activated:Connect(function()
        LocalPlayer.Character:MoveTo(Mouse.Hit.Position)
    end)
end)

CreateSection(PlayerTab, "เป้าหมาย")
local PlayerList = {}
for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end
CreateDropdown(PlayerTab, "เลือกผู้เล่น", PlayerList, function(name)
    local target = Players:FindFirstChild(name)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)
CreateButton(PlayerTab, "รีเซตรายชื่อ", function()
    print("เปิดใหม่อีกครั้งเพื่อรีเซต")
end)

CreateSection(SystemTab, "ปรับปรุง")
CreateButton(SystemTab, "เพิ่ม FPS", function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then 
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false 
        end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        if v:IsA("ParticleEmitter") then v.Enabled = false end
    end
end)

CreateSection(SystemTab, "อื่นๆ")
CreateToggle(SystemTab, "ต้านการ AFK", "AntiAFK")
CreateButton(SystemTab, "เข้าสู่เซิร์ฟเวอร์ใหม่", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
CreateButton(SystemTab, "กระโดดเซิร์ฟเวอร์", function()
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
-- ⚙️ ลอจิกรันไทม์
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
                        if RuJ_Config.TracerOrigin == "บน" then origin = Vector2.new(Camera.ViewportSize.X/2, 0)
                        elseif RuJ_Config.TracerOrigin == "กลาง" then origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) end
                        DrawLine(origin, Vector2.new(hrpPos.X, hrpPos.Y), Colors.CyanAccent)
                    end
                    
                    if RuJ_Config.ESP_Box then
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height * 0.6
                        
                        local box = Instance.new("Frame")
                        box.Size = UDim2.fromOffset(width, height)
                        box.Position = UDim2.fromOffset(hrpPos.X - width/2, headPos.Y)
                        box.BackgroundTransparency = 1
                        box.BorderColor3 = Colors.Danger
                        box.BorderSizePixel = 2
                        box.Parent = ESP_Holder
                    end
                    
                    if RuJ_Config.ESP_Name then
                        local txt = Instance.new("TextLabel")
                        txt.Text = p.Name .. " [" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m]"
                        txt.Position = UDim2.fromOffset(hrpPos.X - 100, headPos.Y - 20)
                        txt.Size = UDim2.fromOffset(200, 20)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Colors.Warning
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
-- 🔌 เปิด/ปิด
-- ═══════════════════════════════════════════════════════════════════════════

Icon.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        AnimLib.FadeOut(MainFrame, 0.3, function()
            MainFrame.Visible = false
        end)
    else
        MainFrame.Visible = true
        AnimLib.FadeIn(MainFrame, 0.3)
    end
end)

print("✅ RUJXMOD ULTIMATE V5 LOADED - กดปุ่ม RX เพื่อเปิดเมนู!")end
