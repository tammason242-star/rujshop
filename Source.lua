-- [[ RUJXMOD - PROFESSIONAL VERSION ]] --
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- ลบ UI เก่าออกก่อนเพื่อป้องกันการรันซ้ำ
if pgui:FindFirstChild("RUJXMOD_UI") then pgui.RUJXMOD_UI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUJXMOD_UI"
ScreenGui.Parent = pgui
ScreenGui.ResetOnSpawn = false

-- === 1. ระบบไอคอน RUJXMOD (ลากได้อิสระ) ===
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

-- ระบบลากไอคอน (Drag System)
local UIS = game:GetService("UserInputService")
local dragIcon, dragStart, startPos
Icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon = true
        dragStart = input.Position
        startPos = Icon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragIcon = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- === 2. หน้าต่างเมนูหลัก (Professional Layout) ===
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 350, 0, 380)
Main.Position = UDim2.new(0.5, -175, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Parent = Main
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "  RUJXMOD - PREMIUM HUB"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.Parent = Main
local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 12)

-- === 3. ฟังก์ชันสร้าง Slider ปรับค่า ===
local function AddSlider(name, min, max, default, callback)
    local SFrame = Instance.new("Frame")
    SFrame.Size = UDim2.new(1, 0, 0, 50)
    SFrame.BackgroundTransparency = 1
    SFrame.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Text = name .. ": " .. default
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.Parent = SFrame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -10, 0, 6)
    Bar.Position = UDim2.new(0, 5, 0, 30)
    Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Bar.Parent = SFrame
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Fill.Parent = Bar

    SFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local function Upd()
                local per = math.clamp((UIS:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * per)
                Fill.Size = UDim2.new(per, 0, 1, 0)
                Label.Text = name .. ": " .. val
                callback(val)
            end
            Upd()
            local conn = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then Upd() end
            end)
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then conn:Disconnect() end end)
        end
    end)
end

-- === 4. ใส่ฟังก์ชันการโกง ===

-- ปรับวิ่งเร็ว
AddSlider("Walk Speed", 16, 300, 16, function(v)
    player.Character.Humanoid.WalkSpeed = v
end)

-- ปรับกระโดดสูง
AddSlider("Jump Power", 50, 500, 50, function(v)
    player.Character.Humanoid.UseJumpPower = true
    player.Character.Humanoid.JumpPower = v
end)

-- ระบบบิน (Fly)
local Flying = false
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(1, 0, 0, 40)
FlyBtn.Text = "FLY: OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.Parent = Container
FlyBtn.MouseButton1Click:Connect(function()
    Flying = not Flying
    FlyBtn.Text = "FLY: " .. (Flying and "ON" or "OFF")
    FlyBtn.BackgroundColor3 = Flying and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 40, 40)
    
    if Flying then
        local bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while Flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- เปิด/ปิดเมนู
Icon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("RUJXMOD Premium Loaded!")
