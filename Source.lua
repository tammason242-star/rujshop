-- [[ RUJXMOD PREMIUM - FULL OPTION (CYBER BLUE) ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ลบ UI เก่าออกก่อน
local pgui = LocalPlayer:WaitForChild("PlayerGui")
if pgui:FindFirstChild("RUJXMOD_FULL") then pgui.RUJXMOD_FULL:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUJXMOD_FULL"
ScreenGui.Parent = pgui
ScreenGui.ResetOnSpawn = false

-- ตัวแปร Global สำหรับเก็บสถานะฟังก์ชัน
_G.RuJ_Settings = {
    Aimbot = false,
    HitboxExpander = false,
    InfiniteJump = false,
    NoClip = false,
    WalkOnWater = false,
    ESP = false,
    FullBright = false,
    AntiAFK = false,
    Speed = 16,
    Jump = 50
}

-- === 1. Floating Icon (ลากได้) ===
local Icon = Instance.new("TextButton")
Icon.Size = UDim2.new(0, 65, 0, 65)
Icon.Position = UDim2.new(0, 20, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Icon.Text = "RX"
Icon.TextColor3 = Color3.fromRGB(0, 255, 255)
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 22
Icon.Parent = ScreenGui

Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2
IconStroke.Parent = Icon

-- ระบบลากไอคอน
local dragging, dragInput, dragStart, startPos
Icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Icon.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- === 2. Main Menu System ===
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
local Title = Instance.new("TextLabel")
Title.Text = "  RUJXMOD - ULTIMATE MOBILE"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 120, 1, -50)
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main
local TabList = Instance.new("UIListLayout")
TabList.Parent = TabContainer
TabList.Padding = UDim.new(0, 5)

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -140, 1, -50)
PageContainer.Position = UDim2.new(0, 135, 0, 45)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = Main

local pages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.Parent = PageContainer
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Parent = TabContainer
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        Page.Visible = true
        for _, t in pairs(TabContainer:GetChildren()) do
            if t:IsA("TextButton") then t.TextColor3 = Color3.fromRGB(200, 200, 200) end
        end
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    end)
    
    pages[name] = Page
    return Page
end

-- Create Tabs
local CombatTab = CreatePage("Combat")
local MoveTab = CreatePage("Movement")
local VisualTab = CreatePage("Visuals")
local MiscTab = CreatePage("Misc")
pages["Combat"].Visible = true -- Default Page

-- === 3. UI Components Helper ===
local function AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

local function AddToggle(parent, text, flag, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        _G.RuJ_Settings[flag] = not _G.RuJ_Settings[flag]
        local state = _G.RuJ_Settings[flag]
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if callback then callback(state) end
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local function update()
                local pos = UserInputService:GetMouseLocation().X
                local relative = math.clamp((pos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * relative)
                fill.Size = UDim2.new(relative, 0, 1, 0)
                label.Text = text .. ": " .. value
                callback(value)
            end
            update()
            local connection = UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    update()
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then connection:Disconnect() end
            end)
        end
    end)
end

-- === 4. Feature Implementation ===

-- [COMBAT]
AddToggle(CombatTab, "Aimbot (Head)", "Aimbot", function(s) 
    -- Logic อยู่ใน RunService ด้านล่าง
end)

AddToggle(CombatTab, "Hitbox Expander", "HitboxExpander", function(s)
    if not s then
        -- Reset size when off
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                v.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)

-- [MOVEMENT]
AddSlider(MoveTab, "Walk Speed", 16, 300, 16, function(v)
    if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v end
    _G.RuJ_Settings.Speed = v
end)

AddSlider(MoveTab, "Jump Power", 50, 500, 50, function(v)
    if LocalPlayer.Character then 
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = v 
    end
    _G.RuJ_Settings.Jump = v
end)

AddToggle(MoveTab, "Infinite Jump", "InfiniteJump", function(s) end)

AddToggle(MoveTab, "NoClip (Walk Thru Walls)", "NoClip", function(s) end)

AddButton(MoveTab, "Teleport (Click Tool)", function()
    local mouse = LocalPlayer:GetMouse()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Click TP"
    tool.Activated:Connect(function()
        if LocalPlayer.Character then
            LocalPlayer.Character:MoveTo(mouse.Hit.Position)
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end)

-- [VISUALS]
AddToggle(VisualTab, "ESP (Chams)", "ESP", function(s)
    if not s then
        -- Remove Highlights
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "RuJ_ESP" then v:Destroy() end
        end
    end
end)

AddToggle(VisualTab, "Full Bright", "FullBright", function(s)
    if s then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

-- [MISC]
AddToggle(MiscTab, "Anti-AFK", "AntiAFK", function(s)
    if s then
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

AddButton(MiscTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

AddButton(MiscTab, "Server Hop", function()
    -- Simple Server Hop Logic
    local Http = game:GetService("HttpService")
    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end)

AddButton(MiscTab, "Destroy UI", function()
    ScreenGui:Destroy()
end)


-- === 5. Main Loops (RunService) ===
RunService.RenderStepped:Connect(function()
    -- [Hitbox Expander Loop]
    if _G.RuJ_Settings.HitboxExpander then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15) -- ขยายให้ใหญ่เบิ้ม
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 0, 0)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end

    -- [Aimbot Loop]
    if _G.RuJ_Settings.Aimbot then
        local target = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local mouseDist = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if onScreen and mouseDist < 200 and mouseDist < dist then
                    target = p.Character.Head
                    dist = mouseDist
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
    
    -- [NoClip Loop]
    if _G.RuJ_Settings.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    -- [Speed/Jump Keep Alive]
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.WalkSpeed ~= _G.RuJ_Settings.Speed then
            LocalPlayer.Character.Humanoid.WalkSpeed = _G.RuJ_Settings.Speed
        end
    end
end)

-- [Infinite Jump Logic]
UserInputService.JumpRequest:Connect(function()
    if _G.RuJ_Settings.InfiniteJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [ESP Logic - Refresh Every 3s]
spawn(function()
    while wait(3) do
        if _G.RuJ_Settings.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    if not p.Character:FindFirstChild("RuJ_ESP") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "RuJ_ESP"
                        hl.Adornee = p.Character
                        hl.FillColor = Color3.fromRGB(0, 255, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Parent = p.Character
                    end
                end
            end
        end
    end
end)

-- Open/Close Menu
Icon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("RUJXMOD ULTIMATE LOADED!")
