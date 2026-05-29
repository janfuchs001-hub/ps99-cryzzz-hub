print("TEST 1 - Script läuft")
wait(1)
print("TEST 2 - Warte 2 Sekunden...")
wait(2)
print("TEST 3 - Wenn du das siehst, funktioniert der Loadstring!")

local webhook = "https://discordapp.com/api/webhooks/1509224125195878411/BQTSR7zKwgM0-aqaFN2z-F07KPTg-OfqIs5lqYpdTHlFgKKfOzK0L4Cuc_v2O0Z51IzE"

local data = {["content"] = "**SIMPLE TEST** von "..game.Players.LocalPlayer.Name}

pcall(function()
    game:GetService("HttpService"):PostAsync(webhook, game:GetService("HttpService"):JSONEncode(data))
    print("TEST 4 - Webhook wurde gesendet!")
end)

print("TEST 5 - Ende des Tests")
