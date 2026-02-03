-- [[ RUJXMOD SUPREME V4 - MASTER EDITION ]] --
-- Credits: RUJSHOP & AI COLLABORATION
-- Optimized for Mobile Executors (Delta, Fluxus, Arceus, etc.)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- === [ 1. CONFIGURATION SYSTEM ] ===
_G.RUJ_Config = {
    Lang = "TH",
    Combat = {
        Aimbot = false,
        Smooth = 5,
        HitChance = 100,
        AimPart = "Head",
        ShowFOV = false,
        FOVSize = 100
    },
    Visuals = {
        Box = false,
        Name = false,
        Tracer = false,
        TracerOrigin = "Bottom", -- Top, Center, Bottom, Mouse
        TracerThickness = 1.5,
        TracerColor = Color3.fromRGB(0, 255, 255),
        RainbowTracer = false
    },
    Movement = {
        Speed = 16,
        Jump = 50,
        InfJump = false,
        Noclip = false,
        Fly = false
    },
    Misc = {
        AdminCheck = true,
        FPSBoost = false,
        FullBright = false,
        AntiAFK = true
    }
}

-- === [ 2. LANGUAGE DICTIONARY ] ===
local Dictionary = {
    TH = {
        Title = "RUJXMOD SUPREME V4",
        T_Main = "หน้าหลัก", T_Combat = "การต่อสู้", T_Visual = "สายตา", T_Move = "เคลื่อนที่", T_Misc = "ทั่วไป",
        L_Aimbot = "ล็อกเป้าอัตโนมัติ", L_Smooth = "ความสมูท", L_AimPart = "ส่วนที่ล็อก", L_FOV = "แสดงวงกลม FOV",
        L_ESPBox = "กรอบมองทะลุ", L_ESPName = "ชื่อผู้เล่น", L_Tracer = "เส้นโยงศัตรู", L_TracerMode = "ทิศทางเส้น",
        L_Speed = "ความเร็วเดิน", L_Jump = "แรงกระโดด", L_InfJump = "กระโดดไม่จำกัด", L_Noclip = "เดินทะลุกำแพง",
        L_Admin = "ตรวจจับแอดมิน", L_FPS = "แก้แลค/เพิ่ม FPS", L_Bright = "เปิดแสงสว่าง", L_AntiAFK = "กันหลุดเกม",
        L_LangBtn = "English Language", L_Rejoin = "เข้าเซิร์ฟใหม่", L_ServerHop = "เปลี่ยนเซิร์ฟเวอร์",
        WarnAdmin = "⚠️ พบเจ้าหน้าที่ในเซิร์ฟเวอร์: "
    },
    EN = {
        Title = "RUJXMOD SUPREME V4",
        T_Main = "Home", T_Combat = "Combat", T_Visual = "Visuals", T_Move = "Movement", T_Misc = "Misc",
        L_Aimbot = "Aimbot Enabled", L_Smooth = "Smoothness", L_AimPart = "Target Part", L_FOV = "Show FOV Circle",
        L_ESPBox = "ESP Box", L_ESPName = "Player Names", L_Tracer = "Tracer Lines", L_TracerMode = "Tracer Origin",
        L_Speed = "Walk Speed", L_Jump = "Jump Power", L_InfJump = "Infinite Jump", L_Noclip = "Noclip (V)",
        L_Admin = "Admin Checker", L_FPS = "FPS Booster", L_Bright = "Full Brightness", L_AntiAFK = "Anti-AFK",
        L_LangBtn = "ภาษาไทย", L_Rejoin = "Rejoin Game", L_ServerHop = "Server Hop",
        WarnAdmin = "⚠️ Admin Detected: "
    }
}

-- === [ 3. UI ENGINE ELEMENTS ] ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUJ_SUPREME_MASTER"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Icon (Floating Button)
local Icon = Instance.new("TextButton")
Icon.Size = UDim2.new(0, 65, 0, 65)
Icon.Position = UDim2.new(0, 15, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Icon.Text = "RX"
Icon.TextColor3 = Color3.fromRGB(0, 255, 255)
Icon.Font = Enum.Font.GothamBlack
Icon.TextSize = 22
Icon.Parent = ScreenGui
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", Icon)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 3

-- Main Window
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 380)
Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 40, 50)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 15)

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, -80)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 0, 1.2, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Sidebar
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.HorizontalAlignment = "Center"
TabList.Padding = UDim.new(0, 8)

-- Content Area
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -160, 1, -70)
Container.Position = UDim2.new(0, 150, 0, 60)
Container.BackgroundTransparency = 1
Container.Parent = Main

-- Language Switcher Button (At the bottom of sidebar)
local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.new(0.85, 0, 0, 40)
LangBtn.Position = UDim2.new(0.07, 0, 1, -50)
LangBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.TextSize = 12
LangBtn.Parent = Sidebar
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 8)

-- === [ 4. UI BUILDER FUNCTIONS ] ===
local Pages = {}
local TabButtons = {}

local function CreateTab(id, iconText)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.Parent = TabContainer
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Page.Parent = Container
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    
    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabButtons) do b.TextColor3 = Color3.fromRGB(200, 200, 200); b.BackgroundColor3 = Color3.fromRGB(25, 25, 35) end
        Page.Visible = true
        Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    end)
    
    Pages[id] = Page
    TabButtons[id] = Btn
    return Page
end

local function AddToggle(parent, configPath, configKey, tag)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = "Left"
    Label.Name = "Label"
    Label.Parent = Frame
    Label.Attributes["LangTag"] = tag

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 40, 0, 20)
    Indicator.Position = UDim2.new(1, -55, 0.5, -10)
    Indicator.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Indicator.Parent = Frame
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(0, 2, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Dot.Parent = Indicator
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local Click = Instance.new("TextButton")
    Click.Size = UDim2.new(1, 0, 1, 0)
    Click.BackgroundTransparency = 1
    Click.Text = ""
    Click.Parent = Frame

    local function Toggle(state)
        local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(45, 45, 55)
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end

    Click.MouseButton1Click:Connect(function()
        _G.RUJ_Config[configPath][configKey] = not _G.RUJ_Config[configPath][configKey]
        Toggle(_G.RUJ_Config[configPath][configKey])
    end)
end

local function AddButton(parent, tag, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Parent = parent
    Btn.Name = "Button"
    Btn.Attributes["LangTag"] = tag
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(callback)
end

-- === [ 5. INIT PAGES ] ===
local MainPg = CreateTab("Main")
local CombatPg = CreateTab("Combat")
local VisualPg = CreateTab("Visuals")
local MovePg = CreateTab("Movement")
local MiscPg = CreateTab("Misc")

-- Fill Main
AddButton(MainPg, "L_Rejoin", function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
AddButton(MainPg, "L_ServerHop", function() 
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id) break end end
end)

-- Fill Combat
AddToggle(CombatPg, "Combat", "Aimbot", "L_Aimbot")
AddToggle(CombatPg, "Combat", "ShowFOV", "L_FOV")

-- Fill Visuals
AddToggle(VisualPg, "Visuals", "Box", "L_ESPBox")
AddToggle(VisualPg, "Visuals", "Name", "L_ESPName")
AddToggle(VisualPg, "Visuals", "Tracer", "L_Tracer")

-- Fill Movement
AddToggle(MovePg, "Movement", "InfJump", "L_InfJump")
AddToggle(MovePg, "Movement", "Noclip", "L_Noclip")

-- Fill Misc
AddToggle(MiscPg, "Misc", "AdminCheck", "L_Admin")
AddToggle(MiscPg, "Misc", "FPSBoost", "L_FPS")
AddToggle(MiscPg, "Misc", "FullBright", "L_Bright")

-- === [ 6. DYNAMIC LANGUAGE UPDATER ] ===
local function UpdateUI()
    local L = Dictionary[_G.RUJ_Config.Lang]
    Title.Text = L.Title
    LangBtn.Text = L.LangBtn
    
    TabButtons.Main.Text = L.T_Main
    TabButtons.Combat.Text = L.T_Combat
    TabButtons.Visual.Text = L.T_Visual
    TabButtons.Move.Text = L.T_Move
    TabButtons.Misc.Text = L.T_Misc
    
    for _, v in pairs(Main:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextButton")) and v:GetAttribute("LangTag") then
            v.Text = L[v:GetAttribute("LangTag")]
        end
    end
end

LangBtn.MouseButton1Click:Connect(function()
    _G.RUJ_Config.Lang = (_G.RUJ_Config.Lang == "TH") and "EN" or "TH"
    UpdateUI()
end)

-- === [ 7. ADVANCED VISUAL ENGINE ] ===
local TracerFolder = Instance.new("Folder", ScreenGui)

RunService.RenderStepped:Connect(function()
    TracerFolder:ClearAllChildren()
    if _G.RUJ_Config.Visuals.Tracer then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local startPos
                    local mode = _G.RUJ_Config.Visuals.TracerOrigin
                    if mode == "Bottom" then startPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    elseif mode == "Top" then startPos = Vector2.new(Camera.ViewportSize.X/2, 0)
                    elseif mode == "Center" then startPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    else startPos = UserInputService:GetMouseLocation() end
                    
                    local Line = Instance.new("Frame", TracerFolder)
                    Line.BackgroundColor3 = _G.RUJ_Config.Visuals.TracerColor
                    Line.BorderSizePixel = 0
                    local dist = (Vector2.new(pos.X, pos.Y) - startPos).Magnitude
                    Line.Size = UDim2.new(0, dist, 0, _G.RUJ_Config.Visuals.TracerThickness)
                    Line.Position = UDim2.new(0, (startPos.X + pos.X)/2, 0, (startPos.Y + pos.Y)/2)
                    Line.Rotation = math.deg(math.atan2(pos.Y - startPos.Y, pos.X - startPos.X))
                    Line.AnchorPoint = Vector2.new(0.5, 0.5)
                end
            end
        end
    end
    
    -- FPS Boost Logic
    if _G.RUJ_Config.Misc.FPSBoost then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Decal") then v.Transparency = 1 end
        end
    end
end)

-- Admin Checker Logic
Players.PlayerAdded:Connect(function(p)
    if _G.RUJ_Config.Misc.AdminCheck and p:GetRankInGroup(1) > 100 then
        print(Dictionary[_G.RUJ_Config.Lang].WarnAdmin .. p.Name)
    end
end)

-- Draggable Icon Logic
local dragging, dragInput, dragStart, startPos
Icon.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = Icon.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; Icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function() dragging = false end)

Icon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main:TweenSize(UDim2.new(0, 520, 0, 380), "Out", "Back", 0.3, true)
    end
end)

-- Finish Setup
UpdateUI()
Pages.Main.Visible = true
print("RUJXMOD MASTER LOADED - SUCCESS")
