-- selectway gui thing
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local gui = plr:WaitForChild("PlayerGui")

local remote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("SelectWay")

local sel = nil
local running = false
local autoloop
local cycling = false
local cycleloop

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SelectWayGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = gui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 185)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Path Select"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.SourceSansBold
titleText.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Selection buttons container
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(1, -20, 0, 40)
buttonsFrame.Position = UDim2.new(0, 10, 0, 40)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Create selection buttons (1-4)
local buttons = {}
for i = 1, 4 do
    local button = Instance.new("TextButton")
    button.Name = "Button" .. i
    button.Size = UDim2.new(0, 40, 0, 35)
    button.Position = UDim2.new(0, (i-1) * 45, 0, 0)
    button.BackgroundColor3 = i == sel and Color3.fromRGB(85, 170, 85) or Color3.fromRGB(85, 85, 85)
    button.BorderSizePixel = 0
    button.Text = tostring(i)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = buttonsFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    buttons[i] = button
end

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Selected: None | Status: Stopped"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = mainFrame

-- Start/Stop button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(1, -20, 0, 25)
toggleButton.Position = UDim2.new(0, 10, 0, 120)
toggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "START AUTO"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Cycle button
local cycleButton = Instance.new("TextButton")
cycleButton.Name = "CycleButton"
cycleButton.Size = UDim2.new(1, -20, 0, 25)
cycleButton.Position = UDim2.new(0, 10, 0, 150)
cycleButton.BackgroundColor3 = Color3.fromRGB(85, 85, 170)
cycleButton.BorderSizePixel = 0
cycleButton.Text = "START CYCLE"
cycleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cycleButton.TextScaled = true
cycleButton.Font = Enum.Font.SourceSansBold
cycleButton.Parent = mainFrame

local cycleCorner = Instance.new("UICorner")
cycleCorner.CornerRadius = UDim.new(0, 6)
cycleCorner.Parent = cycleButton

local function updateColors()
    for i = 1, 4 do
        if sel == i then
            buttons[i].BackgroundColor3 = Color3.fromRGB(85, 170, 85)
        else
            buttons[i].BackgroundColor3 = Color3.fromRGB(85, 85, 85)
        end
    end
end

local function updateStatus()
    local selText = sel and tostring(sel) or "None"
    statusLabel.Text = "Selected: " .. selText .. " | Status: " .. (running and "Running" or cycling and "Cycling" or "Stopped")
end

local function shoot()
    if not sel then return end
    local args = {
        sel,
        false
    }
    remote:FireServer(unpack(args))
    print("shot selectway:", sel)
end

local function startAuto()
    if autoloop then
        autoloop:Disconnect()
    end
    
    running = true
    toggleButton.Text = "STOP AUTO"
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    updateStatus()
    
    shoot()
    
    autoloop = task.spawn(function()
        while running do
            task.wait(2)
            if running then
                shoot()
            end
        end
    end)
end

local function stopAuto()
    running = false
    if autoloop then
        task.cancel(autoloop)
        autoloop = nil
    end
    
    toggleButton.Text = "START AUTO"
    toggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
    updateStatus()
end

local function doCycle()
    if running then
        stopAuto()
    end
    
    if cycleloop then
        task.cancel(cycleloop)
    end
    
    cycling = true
    cycleButton.Text = "STOP CYCLE"
    cycleButton.BackgroundColor3 = Color3.fromRGB(170, 85, 170)
    updateStatus()
    
    cycleloop = task.spawn(function()
        local idx = 1
        while cycling do
            sel = idx
            updateColors()
            updateStatus()
            shoot()
            
            -- rainbow colors
            local cols = {
                Color3.fromRGB(255, 85, 85),
                Color3.fromRGB(255, 170, 85), 
                Color3.fromRGB(255, 255, 85),
                Color3.fromRGB(85, 255, 85),
                Color3.fromRGB(85, 255, 255),
                Color3.fromRGB(85, 85, 255),
                Color3.fromRGB(170, 85, 255),
                Color3.fromRGB(255, 85, 170)
            }
            
            if cycling then
                local colIdx = ((idx - 1) % #cols) + 1
                local tween = TweenService:Create(
                    cycleButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {BackgroundColor3 = cols[colIdx]}
                )
                tween:Play()
                
                local pulse = TweenService:Create(
                    cycleButton,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(1, -15, 0, 30)}
                )
                pulse:Play()
                
                pulse.Completed:Connect(function()
                    if cycling then
                        local back = TweenService:Create(
                            cycleButton,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Size = UDim2.new(1, -20, 0, 25)}
                        )
                        back:Play()
                    end
                end)
            end
            
            print("cycle:", sel)
            
            idx = (idx % 4) + 1
            
            task.wait(1)
        end
    end)
end

local function stopCycle()
    cycling = false
    if cycleloop then
        task.cancel(cycleloop)
        cycleloop = nil
    end
    
    cycleButton.Text = "START CYCLE"
    cycleButton.BackgroundColor3 = Color3.fromRGB(85, 85, 170)
    cycleButton.Size = UDim2.new(1, -20, 0, 25)
    updateStatus()
end

-- connections
cycleButton.MouseButton1Click:Connect(function()
    if cycling then
        stopCycle()
    else
        doCycle()
    end
end)

for i = 1, 4 do
    buttons[i].MouseButton1Click:Connect(function()
        if cycling then
            stopCycle()
        end
        if sel == i then
            sel = nil
        else
            sel = i
        end
        updateColors()
        updateStatus()
        print("picked:", sel)
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    if running then
        stopAuto()
    else
        startAuto()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    stopAuto()
    screenGui:Destroy()
end)

updateStatus()

print("gui loaded")
