-- Script to redeem all codes in Player_Data.hotwheelergirler.Code
-- Place as a LocalScript or run in an executor

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local codeRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Lobby"):WaitForChild("Code")

-- Collect all unique codes from every player's Player_Data folder
local allCodes = {}
local codeSet = {}

local playerDataFolder = ReplicatedStorage:WaitForChild("Player_Data")
for _, playerFolder in ipairs(playerDataFolder:GetChildren()) do
    local codeFolder = playerFolder:FindFirstChild("Code")
    if codeFolder then
        for _, codeObj in ipairs(codeFolder:GetChildren()) do
            if (codeObj:IsA("StringValue") or codeObj:IsA("ValueBase")) and codeObj.Value and codeObj.Value ~= "" then
                local code = codeObj.Value
                if not codeSet[code] then
                    codeSet[code] = true
                    table.insert(allCodes, code)
                end
            end
        end
    end
end

for _, code in ipairs(allCodes) do
    local args = {code}
    pcall(function()
        codeRemote:FireServer(unpack(args))
    end)
    wait(0.1)
end

print("[CodeRedeem] All unique codes attempted from all players.")
