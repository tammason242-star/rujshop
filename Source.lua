-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Content = Instance.new("ScrollingFrame")
local IconBtn = Instance.new("ImageButton")
local UICorner_Icon = Instance.new("UICorner")
local UIGridLayout = Instance.new("UIGridLayout")

-- ตั้งค่า ScreenGui
ScreenGui.Name = "TestScriptUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 1. สร้างปุ่มไอคอน (วงกลมแดงทางซ้าย)
IconBtn.Name = "ScriptIcon"
IconBtn.Parent = ScreenGui
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
IconBtn.Position = UDim2.new(0, 20, 0.5, -30)
IconBtn.Size = UDim2.new(0, 60, 0, 60)
IconBtn.Image = "rbxassetid://123456789" -- ใส่ ID รูปภาพของคุณตรงนี้
IconBtn.BorderSizePixel = 2
IconBtn.BorderColor3 = Color3.fromRGB(255, 75, 75)

UICorner_Icon.CornerRadius = UDim.new(1, 0)
UICorner_Icon.Parent = IconBtn

-- 2. สร้างเมนูหลัก (Main Window)
MainFrame.Name = "MainWindow"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
MainFrame.Position = UDim2.new(0, 100, 0.5, -160)
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- ปิดไว้ก่อน

-- แถบสีแดงด้านข้าง
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 5, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

-- ส่วนหัว (Header)
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Header.Size = UDim2.new(1, 0, 0, 50)

Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Font = Enum.Font.Kanit
Title.Text = "🔴 ระบบสคริปทดลอง 0.0"
Title.TextColor3 = Color3.fromRGB(255, 75, 75)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ส่วนเนื้อหา (Content) พร้อมปุ่ม
Content.Parent = MainFrame
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 20, 0, 70)
Content.Size = UDim2.new(1, -40, 1, -90)
Content.ScrollBarThickness = 2

UIGridLayout.Parent = Content
UIGridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
UIGridLayout.CellSize = UDim2.new(0, 190, 0, 50)

-- ฟังก์ชันสร้างปุ่ม "ทดลอง"
local function createButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    btn.TextColor3 = Color3.fromRGB(239, 239, 239)
    btn.Font = Enum.Font.Kanit
    btn.TextSize = 14
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        print("เปิดใช้งาน: " .. name)
        btn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
        wait(0.2)
        btn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    end)
end

-- สร้างปุ่ม 6 ปุ่มตาม HTML
for i = 1, 6 do
    createButton("ทดลอง " .. i)
end

-- 3. ระบบเปิด/ปิดเมนู
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

