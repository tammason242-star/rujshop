-- [[ RUJSHOP SOURCE - FINAL VERSION ]] --
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- ลบ UI เก่าออกก่อนรันใหม่
if pgui:FindFirstChild("RUJSHOP_UI") then
    pgui.RUJSHOP_UI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RUJSHOP_UI"
ScreenGui.Parent = pgui
ScreenGui.ResetOnSpawn = false

-- 1. ปุ่มไอคอนวงกลม (แดง-ดำ)
local IconBtn = Instance.new("TextButton")
IconBtn.Name = "MainIcon"
IconBtn.Parent = ScreenGui
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- สีดำ
IconBtn.Position = UDim2.new(0, 20, 0.5, -30)
IconBtn.Size = UDim2.new(0, 60, 0, 60)
IconBtn.Text = "RUJ" -- ชื่อร้านคุณ
IconBtn.TextColor3 = Color3.fromRGB(255, 75, 75) -- สีแดง
IconBtn.Font = Enum.Font.GothamBold
IconBtn.TextSize = 14
IconBtn.BorderSizePixel = 0

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0) -- ทำให้กลม
IconCorner.Parent = IconBtn

local IconStroke = Instance.new("UIStroke") -- เพิ่มขอบเรืองแสง
IconStroke.Color = Color3.fromRGB(255, 75, 75)
IconStroke.Thickness = 2
IconStroke.Parent = IconBtn

-- 2. หน้าต่างเมนูหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
MainFrame.Position = UDim2.new(0, 100, 0.5, -160)
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- ปิดไว้รอเปิด

local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 5, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
SideBar.Parent = MainFrame

-- ส่วนหัว (Header)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "🔴 RUJSHOP - VERSION 0.0"
Title.TextColor3 = Color3.fromRGB(255, 75, 75)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- ส่วนเนื้อหาสำหรับใส่ปุ่ม
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -30, 1, -80)
Content.Position = UDim2.new(0, 15, 0, 65)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
Content.Parent = MainFrame

local Layout = Instance.new("UIGridLayout")
Layout.CellSize = UDim2.new(0, 195, 0, 45)
Layout.CellPadding = UDim2.new(0, 10, 0, 10)
Layout.Parent = Content

-- ฟังก์ชันสร้างปุ่มทดลอง
local function AddButton(txt, callback)
    local btn = Instance.new("TextButton")
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- เพิ่มปุ่มทดลอง
AddButton("Speed (วิ่งเร็ว)", function()
    player.Character.Humanoid.WalkSpeed = 100
end)

AddButton("Infinite Jump", function()
    -- ใส่โค้ดกระโดดไม่จำกัดตรงนี้
    print("Enabled Infinite Jump")
end)

-- ระบบเปิด/ปิด
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("RUJSHOP UI Loaded!")
