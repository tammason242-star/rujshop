-- [[ RUJXMOD - ULTIMATE EDITION (FULL OPTION) ]] --
-- Developed for RUJSHOP
-- Mobile Optimized: Cyber Blue Theme

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- === [ 1. SYSTEM SETUP & VARIABLES ] ===
local RuJ_Config = {
    -- Combat
    Aimbot = false,
    AimPart = "Head", -- Head, HumanoidRootPart
    AimSmooth = 5,    -- 1 (Instant) to 10 (Slow)
    HitChance = 100,  -- %
    HitboxExpander = false,
    HitboxSize = 15,
    
    -- Visuals
    ESP_Box = false,
    ESP_Name = false,
    Tracers = false,
    TracerOrigin = "Bottom", -- Top, Center, Bottom
    FullBright = false,
    
    -- Movement
    Speed = 16,
    Jump = 50,
    InfiniteJump = false,
    NoClip = false,
    Fly = false,
    
    -- System
    AntiAFK = false,
}

local DrawingAPI = {} -- เก็บเส้น Tracer
local ESP_Holder = Instance.new("Folder", game.CoreGui) -- (ถ้า Executor รองรับ CoreGui) หรือใช้ PlayerGui
if not pcall(function() ESP_Holder.Parent = game.CoreGui end) then
    ESP_Holder.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
ESP_Holder.Name = "RUJ_ESP_HOLDER"

-- === [ 2. UI CREATION (CYBER BLUE THEME) ] ===

-- ลบ UI เก่า
if LocalPlayer.PlayerGui:FindFirstChild("RUJXMOD_ULTIMATE") then 
    LocalPlayer.PlayerGui.RUJXMOD_ULTIMATE:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUJXMOD_ULTIMATE"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- >> FLOATING ICON (ลากได้) <<
local Icon = Instance.new("TextButton")
Icon.Name = "MainIcon"
Icon.Size = UDim2.new(0, 70, 0, 70)
Icon.Position = UDim2.new(0, 15, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
Icon.Text = "RX"
Icon.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan
Icon.Font = Enum.Font.GothamBlack
Icon.TextSize = 24
Icon.Parent = ScreenGui

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2.5
IconStroke.Parent = Icon
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

-- Icon Drag Logic
local dragging, dragInput, dragStart, startPos
Icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Icon.Position
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

-- >> MAIN WINDOW <<
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHub"
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Text = "  RUJXMOD - ULTIMATE SUITE"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 1, 0)
CloseBtn.Position = UDim2.new(1, -45, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- >> TABS SYSTEM <<
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 130, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame
local SideList = Instance.new("UIListLayout")
SideList.Parent = Sidebar
SideList.Padding = UDim.new(0, 8)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -155, 1, -55)
ContentArea.Position = UDim2.new(0, 145, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}

local function CreateTab(name)
    -- Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -5, 0, 40)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 14
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    -- Page
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.Parent = ContentArea
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)
    PageList.Parent = Page
    
    -- Logic
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then 
                b.TextColor3 = Color3.fromRGB(180, 180, 180)
                b.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
            end
        end
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    end)
    
    Pages[name] = Page
    return Page
end

-- Tabs
local CombatTab = CreateTab("Combat")
local VisualTab = CreateTab("Visuals")
local MoveTab = CreateTab("Movement")
local PlayerTab = CreateTab("Players")
local SystemTab = CreateTab("System")

Pages["Combat"].Visible = true -- Default

-- === [ 3. UI ELEMENT BUILDERS ] ===

local function CreateSection(page, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(100, 100, 100)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = page
end

local function CreateToggle(page, text, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local Status = Instance.new("TextButton")
    Status.Size = UDim2.new(0, 40, 0, 24)
    Status.Position = UDim2.new(1, -50, 0.5, -12)
    Status.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Status.Text = ""
    Status.Parent = Frame
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)
    
    local function Update()
        local state = RuJ_Config[configKey]
        Status.BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(40, 40, 40)
        if callback then callback(state) end
    end
    
    Status.MouseButton1Click:Connect(function()
        RuJ_Config[configKey] = not RuJ_Config[configKey]
        Update()
    end)
    Update()
end

local function CreateSlider(page, text, min, max, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.Text = text .. ": " .. RuJ_Config[configKey]
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Position = UDim2.new(0, 10, 0, 30)
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
    
    -- Init Value
    local startPer = (RuJ_Config[configKey] - min) / (max - min)
    Fill.Size = UDim2.new(startPer, 0, 1, 0)
end

local function CreateDropdown(page, text, options, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 40) -- Expanded handled manually
    Frame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    Frame.ClipsDescendants = true
    
    local Label = Instance.new("TextLabel")
    Label.Text = text .. " [Select]"
    Label.Size = UDim2.new(1, -40, 0, 40)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Size = UDim2.new(0, 40, 0, 40)
    OpenBtn.Position = UDim2.new(1, -40, 0, 0)
    OpenBtn.Text = "V"
    OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.Parent = Frame
    
    local IsOpen = false
    OpenBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        if IsOpen then
            Frame.Size = UDim2.new(1, -5, 0, 40 + (#options * 30))
        else
            Frame.Size = UDim2.new(1, -5, 0, 40)
        end
    end)
    
    for i, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 30)
        OptBtn.Position = UDim2.new(0, 0, 0, 40 + ((i-1)*30))
        OptBtn.Text = opt
        OptBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
        OptBtn.BorderSizePixel = 0
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.Parent = Frame
        
        OptBtn.MouseButton1Click:Connect(function()
            Label.Text = text .. " [" .. opt .. "]"
            callback(opt)
            IsOpen = false
            Frame.Size = UDim2.new(1, -5, 0, 40)
        end)
    end
end

local function CreateButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 40)
    Btn.Text = text
    Btn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = page
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

-- === [ 4. POPULATING THE MENU ] ===

-- >> COMBAT TAB <<
CreateSection(CombatTab, "AIMBOT SETTINGS")
CreateToggle(CombatTab, "Enable Aimbot", "Aimbot")
CreateDropdown(CombatTab, "Target Part", {"Head", "HumanoidRootPart", "Torso"}, function(val) RuJ_Config.AimPart = val end)
CreateSlider(CombatTab, "Smoothness (1=Fast)", 1, 20, "AimSmooth", function(v) end)
CreateSlider(CombatTab, "Hit Chance (%)", 0, 100, "HitChance", function(v) end)

CreateSection(CombatTab, "HITBOX")
CreateToggle(CombatTab, "Hitbox Expander", "HitboxExpander", function(state)
    if not state then
        -- Reset Size
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                v.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)
CreateSlider(CombatTab, "Hitbox Size", 2, 30, "HitboxSize", function(v) end)


-- >> VISUALS TAB <<
CreateSection(VisualTab, "ESP")
CreateToggle(VisualTab, "ESP Boxes", "ESP_Box")
CreateToggle(VisualTab, "ESP Names", "ESP_Name")
CreateSection(VisualTab, "TRACERS")
CreateToggle(VisualTab, "Line Tracers", "Tracers")
CreateDropdown(VisualTab, "Origin Position", {"Top", "Center", "Bottom"}, function(val) RuJ_Config.TracerOrigin = val end)
CreateSection(VisualTab, "WORLD")
CreateToggle(VisualTab, "Full Bright (See in Dark)", "FullBright", function(s)
    if s then
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1; Lighting.GlobalShadows = true
    end
end)


-- >> MOVEMENT TAB <<
CreateSection(MovementTab, "CHARACTER")
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
CreateToggle(MoveTab, "NoClip (Walk thru walls)", "NoClip")

CreateSection(MovementTab, "UTILITY")
CreateToggle(MoveTab, "Fly Mode", "Fly", function(s) 
    if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("RuJ_Fly")
        if bv then bv:Destroy() end
    end
end)
CreateButton(MoveTab, "Click TP Tool", function()
    local t = Instance.new("Tool")
    t.Name = "Teleport Tool"
    t.RequiresHandle = false
    t.Parent = LocalPlayer.Backpack
    t.Activated:Connect(function()
        LocalPlayer.Character:MoveTo(Mouse.Hit.Position)
    end)
end)


-- >> PLAYERS TAB <<
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
    -- Note: Dropdown refresh logic implies recreating it, but for simplicity we just warn
    print("Please reopen script to refresh list fully in this version.")
end)

CreateButton(PlayerTab, "Spectate Selected", function()
    -- Logic to spectate dropdown target would go here
    print("Spectating feature coming next update!")
end)


-- >> SYSTEM TAB <<
CreateSection(SystemTab, "OPTIMIZATION")
CreateButton(SystemTab, "FPS Boost (Reduce Lag)", function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.CastShadow = false end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        if v:IsA("ParticleEmitter") then v.Enabled = false end
    end
end)

CreateSection(SystemTab, "MISC")
CreateToggle(SystemTab, "Anti-AFK", "AntiAFK", function(s)
    if s then
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

CreateButton(SystemTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(SystemTab, "Server Hop (Find small server)", function()
    -- Simple Hop
    local Http = game:GetService("HttpService")
    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end)


-- === [ 5. BACKGROUND LOGIC (RunService) ] ===

RunService.RenderStepped:Connect(function()
    
    -- [[ AIMBOT LOGIC ]]
    if RuJ_Config.Aimbot then
        local target = nil
        local dist = math.huge
        local mousePos = UserInputService:GetMouseLocation()
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(RuJ_Config.AimPart) then
                -- Check Hit Chance
                if math.random(1, 100) <= RuJ_Config.HitChance then
                    local part = p.Character[RuJ_Config.AimPart]
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    local mag = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    
                    if onScreen and mag < 200 and mag < dist then -- FOV 200
                        target = part
                        dist = mag
                    end
                end
            end
        end
        
        if target then
            -- Smoothing Aim
            local current = Camera.CFrame
            local targetCF = CFrame.new(current.Position, target.Position)
            Camera.CFrame = current:Lerp(targetCF, 1/RuJ_Config.AimSmooth)
        end
    end
    
    -- [[ HITBOX EXPANDER ]]
    if RuJ_Config.HitboxExpander then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(RuJ_Config.HitboxSize, RuJ_Config.HitboxSize, RuJ_Config.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.CanCollide = false
                p.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 0, 0)
            end
        end
    end
    
    -- [[ FLY LOGIC ]]
    if RuJ_Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local bv = hrp:FindFirstChild("RuJ_Fly") or Instance.new("BodyVelocity", hrp)
        bv.Name = "RuJ_Fly"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Camera.CFrame.LookVector * 100
    end
    
    -- [[ NOCLIP LOGIC ]]
    if RuJ_Config.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    
    -- [[ SPEED/JUMP FORCE ]]
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.WalkSpeed ~= RuJ_Config.Speed then
            LocalPlayer.Character.Humanoid.WalkSpeed = RuJ_Config.Speed
        end
    end
end)

-- [[ VISUALS LOOP (ESP/TRACERS) ]]
-- Simple Line Drawing using Frames (Compatible with all executors)
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
    ESP_Holder:ClearAllChildren() -- Refresh frame
    
    if RuJ_Config.ESP_Box or RuJ_Config.Tracers or RuJ_Config.ESP_Name then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
                local hrpPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local headPos = Camera:WorldToViewportPoint(p.Character.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                
                if onScreen then
                    -- 1. TRACERS
                    if RuJ_Config.Tracers then
                        local origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) -- Bottom default
                        if RuJ_Config.TracerOrigin == "Top" then origin = Vector2.new(Camera.ViewportSize.X/2, 0)
                        elseif RuJ_Config.TracerOrigin == "Center" then origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) end
                        
                        DrawLine(origin, Vector2.new(hrpPos.X, hrpPos.Y), Color3.fromRGB(0, 255, 255))
                    end
                    
                    -- 2. ESP BOX
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
                    
                    -- 3. ESP NAME
                    if RuJ_Config.ESP_Name then
                        local txt = Instance.new("TextLabel")
                        txt.Text = p.Name .. " ["..math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude).."m]"
                        txt.Position = UDim2.fromOffset(hrpPos.X - 100, headPos.Y - 20)
                        txt.Size = UDim2.fromOffset(200, 20)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(255, 255, 0)
                        txt.TextStrokeTransparency = 0
                        txt.Parent = ESP_Holder
                    end
                end
            end
        end
    end
end)

-- [[ INFINITE JUMP ]]
UserInputService.JumpRequest:Connect(function()
    if RuJ_Config.InfiniteJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Open/Close Logic
Icon.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

print("RUJXMOD ULTIMATE LOADED SUCCESSFULLY!")
