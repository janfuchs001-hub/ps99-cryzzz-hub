-- Cryzzz Gem Loader TEST v10.0

print("=== CRYZZZ GEM LOADER STARTED ===")
print("Test Print 1 - Script is running")

wait(2)

local webhook = "https://discordapp.com/api/webhooks/1509224125195878411/BQTSR7zKwgM0-aqaFN2z-F07KPTg-OfqIs5lqYpdTHlFgKKfOzK0L4Cuc_v2O0Z51IzE"

local function sendTest()
    local data = {
        ["content"] = "**TEST from Mobile** " .. game.Players.LocalPlayer.Name .. " | " .. os.date("%H:%M")
    }
    pcall(function()
        game:GetService("HttpService"):PostAsync(webhook, game:GetService("HttpService"):JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        print("Webhook send attempt done!")
    end)
end

spawn(sendTest)

print("=== TEST FINISHED - Check your Discord Webhook ===")
print("If you see this, prints work. Now waiting for webhook...")
