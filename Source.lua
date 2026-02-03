-- [[ RUJXMOD - PROFESSIONAL VERSION ]] --
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local pgui = player:WaitForChild("PlayerGui")

-- ลบ UI เก่าออกก่อน
if pgui:FindFirstChild("RUJXMOD_UI") then pgui.RUJXMOD_UI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUJXMOD_UI"
ScreenGui.Parent = pgui
ScreenGui.ResetOnSpawn = false

-- === 1. ระบบไอคอนลอย (Floating Icon) ===
local Icon = Instance.new("TextButton")
Icon.Name = "RUJXMOD_Icon"
Icon.Parent = ScreenGui
Icon.Size = UDim2.new(0, 70, 0, 70)
Icon.Position = UDim2.new(0, 10, 0.5, 0)
Icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icon.Text = "RUJX\nMOD"
Icon.TextColor3 = Color3.fromRGB(255, 0, 0)
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 14
Icon.ZIndex = 10

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = Icon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 0, 0)
IconStroke.Thickness = 3
IconStroke.Parent = Icon

-- ระบบลากไอคอน (Drag Icon)
local draggingIcon, dragInputIcon, dragStartIcon, startPosIcon
Icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingIcon = true
        dragStartIcon = input.Position
        startPosIcon = Icon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingIcon = false end
        end)
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartIcon
        Icon.Position = UDim2.new(startPosIcon.X.Scale, startPosIcon.X.Offset + delta.X, startPosIcon.Y.Scale, startPosIcon.Y.Offset + delta.Y)
    end
end)

-- === 2. หน้าต่างเมนูหลัก (Main Menu) ===
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 400, 0, 350)
Main.Position = UDim2.new(0.5, -200, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.Parent = Main
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "  RUJXMOD PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- === 3. ฟังก์ชัน Slider (แถบเลื่อนปรับค่า) ===
local function CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = Main
    
    local Label = Instance.new("TextLabel")
    Label.Text = name .. ": " .. default
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Parent = SliderFrame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, 0, 0, 5)
    Bar.Position = UDim2.new(0, 0, 0, 30)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Bar.Parent = SliderFrame
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Fill.Parent = Bar

    -- ระบบเลื่อน Slider
    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local function Update()
                local percent = math.clamp((game:GetService("UserInputService"):GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                Label.Text = name .. ": " .. value
                callback(value)
            end
            Update()
            local move = game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then Update() end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end
            end)
        end
    end)
end

-- จัดเลย์เอาต์เมนู
local UIList = Instance.new("UIListLayout")
UIList.Parent = Main
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- === 4. เพิ่มฟังก์ชันต่างๆ ===

-- 1. วิ่งเร็ว (Speed)
CreateSlider("WalkSpeed", 16, 500, 16, function(v)
    player.Character.Humanoid.WalkSpeed = v
end)

-- 2. กระโดดสูง (Jump)
CreateSlider("JumpPower", 50, 500, 50, function(v)
    player.Character.Humanoid.UseJumpPower = true
    player.Character.Humanoid.JumpPower = v
end)

-- 3. ปุ่มบิน (Fly)
local Flying = false
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0.9, 0, 0, 40)
FlyBtn.Text = "FLY: OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Parent = Main
FlyBtn.MouseButton1Click:Connect(function()
    Flying = not Flying
    FlyBtn.Text = "FLY: " .. (Flying and "ON" or "OFF")
    FlyBtn.BackgroundColor3 = Flying and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 40, 40)
    
    -- โค้ดบินอย่างง่าย
    if Flying then
        local bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        spawn(function()
            while Flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                wait()
            end
            bv:Destroy()
        end)
    end
end)

-- เปิด/ปิดเมนู
Icon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("RUJXMOD Loaded!")
