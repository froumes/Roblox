-- Path Select GUI Script
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local selectWayRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("SelectWay")

local selectedPath = nil
local isAutoRunning = false
local autoLoop
local isCycling = false
local cycleLoop

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SelectWayGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 220)
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
local pathButtons = {}
for i = 1, 4 do
    local btn = Instance.new("TextButton")
    btn.Name = "Button" .. i
    btn.Size = UDim2.new(0, 40, 0, 35)
    btn.Position = UDim2.new(0, (i-1) * 45, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
    btn.BorderSizePixel = 0
    btn.Text = tostring(i)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = buttonsFrame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    pathButtons[i] = btn
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


local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(1, -20, 0, 25)
speedButton.Position = UDim2.new(0, 10, 0, 180)
speedButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
speedButton.BorderSizePixel = 0
speedButton.Text = "SPEED: OFF"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextScaled = true
speedButton.Font = Enum.Font.SourceSansBold
speedButton.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedButton

local speedRunning = false
local speedLoop
local function has3xGamepass()
    local plrName = Players.LocalPlayer.Name
    local data = game:GetService("ReplicatedStorage").Player_Data:FindFirstChild(plrName)
    if data and data:FindFirstChild("Gamepass") and data.Gamepass:FindFirstChild("3x Game Speed") then
        return data.Gamepass["3x Game Speed"].Value == true
    end
    return false
end

local function setSpeed(speed)
    local args = {speed}
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SpeedGamepass"):FireServer(unpack(args))
    print("Tried to set speed to:", speed)
end

local function startSpeed()
    speedRunning = true
    speedButton.Text = "SPEED: ON"
    speedButton.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    speedLoop = task.spawn(function()
        while speedRunning do
            if has3xGamepass() then
                setSpeed(3)
            else
                setSpeed(2)
            end
            task.wait(1)
        end
    end)
end

local function stopSpeed()
    speedRunning = false
    if speedLoop then
        task.cancel(speedLoop)
        speedLoop = nil
    end
    speedButton.Text = "SPEED: OFF"
    speedButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
end
speedButton.MouseButton1Click:Connect(function()
    if speedRunning then
        stopSpeed()
    else
        startSpeed()
    end
end)

local function updatePathButtonColors()
    for i = 1, 4 do
        if selectedPath == i then
            pathButtons[i].BackgroundColor3 = Color3.fromRGB(85, 170, 85)
        else
            pathButtons[i].BackgroundColor3 = Color3.fromRGB(85, 85, 85)
        end
    end
end

local function updateStatus()
    local selText = selectedPath and tostring(selectedPath) or "None"
    local status = isAutoRunning and "Running" or isCycling and "Cycling" or "Stopped"
    statusLabel.Text = "Selected: " .. selText .. " | Status: " .. status
end

local function firePathRemote()
    if not selectedPath then return end
    local args = { selectedPath, false }
    selectWayRemote:FireServer(unpack(args))
    print("Fired path remote:", selectedPath)
end

local function startAuto()
    if autoLoop then autoLoop:Disconnect() end
    isAutoRunning = true
    toggleButton.Text = "STOP AUTO"
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    updateStatus()
    firePathRemote()
    autoLoop = task.spawn(function()
        while isAutoRunning do
            task.wait(2)
            if isAutoRunning then
                firePathRemote()
            end
        end
    end)
end

local function stopAuto()
    isAutoRunning = false
    if autoLoop then
        task.cancel(autoLoop)
        autoLoop = nil
    end
    toggleButton.Text = "START AUTO"
    toggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
    updateStatus()
end

local function doCycle()
    if isAutoRunning then stopAuto() end
    if cycleLoop then task.cancel(cycleLoop) end
    isCycling = true
    cycleButton.Text = "STOP CYCLE"
    cycleButton.BackgroundColor3 = Color3.fromRGB(170, 85, 170)
    updateStatus()
    cycleLoop = task.spawn(function()
        local idx = 1
        while isCycling do
            selectedPath = idx
            updatePathButtonColors()
            updateStatus()
            firePathRemote()
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
            if isCycling then
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
                    if isCycling then
                        local back = TweenService:Create(
                            cycleButton,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Size = UDim2.new(1, -20, 0, 25)}
                        )
                        back:Play()
                    end
                end)
            end
            print("cycle:", selectedPath)
            idx = (idx % 4) + 1
            task.wait(1)
        end
    end)
end

local function stopCycle()
    isCycling = false
    if cycleLoop then
        task.cancel(cycleLoop)
        cycleLoop = nil
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
    pathButtons[i].MouseButton1Click:Connect(function()
        if isCycling then stopCycle() end
        if selectedPath == i then
            selectedPath = nil
        else
            selectedPath = i
        end
        updatePathButtonColors()
        updateStatus()
        print("picked:", selectedPath)
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    if isAutoRunning then
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
