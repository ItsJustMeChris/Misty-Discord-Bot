--Requires
local discordia = require('discordia')
local utf8 = require('utf8_simple')
local LIP = require 'LIP';
local servername = "WaterHack"
local botChannel = "bot"
local botVersion = "3.0.0.3"
--log function (log messages to file)
local function log(message)
    file = io.open("log.txt", "a")
    file:write("["..os.date('!%Y-%m-%dT%H:%M:%S').."]"..message,"\n")
    file:close()
end


--Declare discord client
local client = discordia.Client()

--Initialize bot
client:on('ready', function()
    print('logged in as '.. client.user.username.." Bot Version: "..botVersion)
    client:setGameName("WaterHack")
    log(">>>>> BOT LOGIN <<<<<")
end)

--User table for nothing yet.. TODO: User saving/stuffs

--Load saved users file.

--Admin table
local admin = {
    [210152605467410434] = true,
    [210615876766924801] = true,
    [174158345073065984] = true,
    [127837881917112321] = true,
    [165658644493369345] = true,
    [117337445833506821] = true,
    [289462788127195147] = true,
}

local exception = {
    [220211444929527809] = true,
}
--Words we don't want users to say
local badword = require('swears')

--Our modules
local modules = {
    ["prune"] = {toggle = true, name = "Prune", key = "prune"},
    ["antispam"] = {toggle = true, name = "Anti Spam", key = "antispam"},
    ["swearfilter"] = {toggle = true, name = "Swear Filter", key = "swearfilter"},
    ["ping"] = {toggle = true, name = "Ping", key = "ping"},
}

--Local variables
local downloadLink = "https://waterhack.co/forum/misc.php?page=download"
local prevauthor = "nil"
local prevmsg = "nil"
local sent = "nil"
local this = "nil"
local lastMessageTime = 1000
local antiSpamStrength = .7
local word

function string_simil (fx, fy)
  local n = string.len(fx)
  local m = string.len(fy)
  local ssnc = 0

  if n > m then
    fx, fy = fy, fx
    n, m = m, n
  end

  for i = n, 1, -1 do
    if i <= string.len(fx) then
    for j = 1, n-i+1, 1 do
        local pattern = string.sub(fx, j, j+i-1)
        if string.len(pattern) == 0 then break end
        local found_at = string.find(fy, pattern)
        if found_at ~= nil then
          ssnc = ssnc + (2*i)^2
          fx = string.sub(fx, 0, j-1) .. string.sub(fx, j+i)
          fy = string.sub(fy, 0, found_at-1) .. string.sub(fy, found_at+i)
          break
        end
      end
    end
  end

  return (ssnc/((n+m)^2))^(1/2)

end

--Message listening event (The real bot)
client:on('messageCreate', function(message)
    word = {}
    if message.guild and message.guild.name == servername then
        local msg = utf8.strip(string.lower(message.content))
        local channel = message.channel.name

        --Anti spam filter
        if modules["antispam"].toggle and string_simil(prevmsg,msg) > antiSpamStrength and not admin[tonumber(message.author.id)] then
            message:delete()
        end


        log("["..channel.."]".."["..message.author.username.."]"..msg)

        for i in string.gmatch(msg, "%S+") do
            table.insert(word, i)
        end



        --Module management
        if admin[tonumber(message.author.id)] and word[1] == "!module" then
            message:delete()
            if word[2] == "status" then
                if modules[word[3]] == nil then
                    message.channel:sendMessage("Module not found "..word[3]..".")
                elseif not modules[word[3]].toggle then
                    message.channel:sendMessage("Module "..word[3].." disabled.")
                elseif modules[word[3]].toggle then
                    message.channel:sendMessage("Module "..word[3].." enabled.")
                end
            elseif word[2] == "toggle" then
                if modules[word[3]] == nil then
                    message.channel:sendMessage("Module not found "..word[3]..".")
                elseif modules[word[3]].toggle then
                    modules[word[3]].toggle = false
                    message.channel:sendMessage("Module "..word[3].." disabled.")
                elseif not modules[word[3]].toggle then
                    modules[word[3]].toggle = true
                    message.channel:sendMessage("Module "..word[3].." enabled.")
                end
            elseif word[2] == "list" then
                message.channel:sendMessage("Modules List")
                for k,v in pairs(modules) do
                    message.channel:sendMessage("Module: "..modules[k].name.." Key: "..modules[k].key)
                end
            else

                message.channel:sendMessage("Module Commands: status; toggle; list")

            end
        end

        if word[1] == "!zygor" then
            message:delete()
            message.channel:sendMessage("https://waterhack.co/premiumscripts/zygor/release.zip\nhttps://waterhack.co/premiumscripts/zygor/beta/release.zip")
        end

        if admin[tonumber(message.author.id)] and word[1] == "goodnight" then
            message.channel:sendMessage("Good night, my beloved. ")
        end

        if word[1] == "!dugi" then
            message:delete()
            message.channel:sendMessage("https://waterhack.co/premiumscripts/dugi/release.zip")
        end

        if word[1] == "!bananas" then
            message:delete()
            message.channel:sendMessage("This shit is bananas, B-A-N-A-NAS!")
        end

        if word[1] == "!music" then
            message:delete()
            message.channel:sendMessage("https://www.youtube.com/watch?v=CJLdB7jP3CM")
        end

        if word[1] == "!ping" then
            message:delete()
            message.channel:sendMessage("Message recieved in: "..math.random().."s")
        end

        if word[1] == "!rank" then
            if word[2] == "deathknight" then
                for role in client.roles do
                    if string.find(role.name, "DeathKnight") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Death Knight rank!")
                end
            end
            if word[2] == "demonhunter" then
                for role in client.roles do
                    if string.find(role.name, "DemonHunter") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Demon Hunter rank!")
                end
            end
            if word[2] == "druid" then
                for role in client.roles do
                    if string.find(role.name, "Druid") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Druid rank!")
                end
            end
            if word[2] == "hunter" then
                for role in client.roles do
                    if string.find(role.name, "Hunter") and not string.find(role.name, "Demon") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Hunter rank!")
                end
            end
            if word[2] == "mage" then
                for role in client.roles do
                    if string.find(role.name, "Mage") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Mage rank!")
                end
            end
            if word[2] == "monkn" then
                for role in client.roles do
                    if string.find(role.name, "Monk") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Monk rank!")
                end
            end
            if word[2] == "paladin" then
                for role in client.roles do
                    if string.find(role.name, "Paladin") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Paladin rank!")
                end
            end
            if word[2] == "priest" then
                for role in client.roles do
                    if string.find(role.name, "Priest") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Priest rank!")
                end
            end
            if word[2] == "rogue" then
                for role in client.roles do
                    if string.find(role.name, "Rogue") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Rogue rank!")
                end
            end
            if word[2] == "shaman" then
                for role in client.roles do
                    if string.find(role.name, "Shaman") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Shaman rank!")
                end
            end
            if word[2] == "warlock" then
                for role in client.roles do
                    if string.find(role.name, "Warlock") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Warlock rank!")
                end
            end
            if word[2] == "warrior" then
                for role in client.roles do
                    if string.find(role.name, "Warrior") then
                        this = role
                    end
                end
                if message.member:hasRole(this) then
                    message:delete()
                    message.author:sendMessage("You already have that rank!")
                else
                    message:delete()
                    message.member:addRole(this)
                    message.author:sendMessage("You've been added to the Warrior rank!")
                end
            end
        end

        if word[1] == "!install" then
            message:delete()
            message.channel:sendMessage("Installation Instructions")
            message.channel:sendMessage("```Un-zip Diesal lib.rar from the release.rar folder.\n"..
                                        "Place diesallib folder into Addons folder in WoW.\n"..
                                        "Start WoW and verifiy that (Lib: Diesal) is ticked.\n"..
                                        "Start WaterHack.exe\n"..
                                        "login with WATERHACK username and password.\n"..
                                        "Enjoy :)\n"..
                                        "* If injecting in game you must /reload after you recieve a lua error. ```")
        end

        if modules["antispam"].toggle and admin[tonumber(message.author.id)] and word[1] == "!panic" then
            message.channel:sendMessage("I'll take care of it!")
            antiSpamStrength = 0
        end

        if modules["antispam"].toggle and admin[tonumber(message.author.id)] and word[1] == "!antispam" then
            if word[3] == nil or tonumber(word[3]) == nil then
                message.channel:sendMessage("Invalid number or no number found.")
            end
            if word[2] == "strength" then
                antiSpamStrength = tonumber(word[3])
                message.channel:sendMessage("Anti Spam strength set to: "..tonumber(word[3]))
            else
                message.channel:sendMessage("Wrong usage, did you mean !antispam strength?")
            end
        end



        --Pings a user
        if modules["ping"].toggle and admin[tonumber(message.author.id)] and word[1] == "!ping" then
            message:delete()
            for user in message.mentionedUsers do
                user:sendMessage(message.author.username.." just pinged you!")
            end
        end




        for i=1, #word do
            if string.find(msg, 'terp') then
                message.channel:sendMessage("TURPIN IT UPPPPPPPP!")
                break
            end
        end


        --Displays information about the bot.
        if channel == botChannel and msg == "!misty" then
            message.channel:sendMessage("I\'m Misty!\nI was created to keep WaterHack safe (:")
            log(">>>>> !misty called <<<<<")
        end

        --Sends an invite code to the user that requested it
        if word[1] == '!invite' then
            message.author:sendMessage("2zn5qcC")
            log("> Sent invite to "..message.author.username)
        end

        --Say hello (:
        if channel == botChannel and msg == '!hello' then
            message:delete()
            print("Message: "..message.id.." Deleted")
            print("Message Author: "..message.author.name)
            print("~~~~~~~~~~\n")
            message.channel:sendMessage('Hi, Im Misty, how can I help you?')
            print("Someone said hello!")
            log("> Said hello")
            return
        end

        --Sends the user the current class list
        if word[1] == '!classes' or msg == '!rotations' then
            message:delete()
            print("Message: "..message.id.." Deleted")
            log("> Sent classes to "..message.author.username)
            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Death knight",
                    fields = {
                        {name = "Blood", value = "Raid Ready.", inline = true},
                        {name = "Frost", value = "Dungeon Ready.", inline = true},
                        {name = "Unholy", value = "Dungeon Ready.", inline = true},
                    },
                    color = discordia.Color(196, 30, 59).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Demon Hunter",
                    fields = {
                        {name = "Havoc", value = "Raid Ready.", inline = true},
                        {name = "Vengeance", value = "Raid Ready.", inline = true},
                    },
                    color = discordia.Color(163, 48, 201).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Druid",
                    fields = {
                        {name = "Balance", value = "Dungeon Ready.", inline = true},
                        {name = "Feral", value = "Not started.", inline = true},
                        {name = "Guardian", value = "Raid Ready.", inline = true},
                        {name = "Restoration", value = "Raid Ready.", inline = true},

                    },
                    color = discordia.Color(255, 125, 10).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Hunter",
                    fields = {
                        {name = "Beast Mastery", value = "Raid Ready.", inline = true},
                        {name = "Marksmanship", value = "Dungeon Ready.", inline = true},
                        {name = "Survival", value = "Dungeon Ready.", inline = true},

                    },
                    color = discordia.Color(171, 212, 115).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Mage",
                    fields = {
                        {name = "Frost", value = "Raid Ready.", inline = true},
                        {name = "Fire", value = "Raid Ready.", inline = true},
                        {name = "Arcane", value = "Raid Ready.", inline = true},

                    },
                    color = discordia.Color(105, 204, 240).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Monk",
                    fields = {
                        {name = "Brew Master", value = "Raid Ready.", inline = true},
                        {name = "Mist Weaver", value = "Dungeon Ready.", inline = true},
                        {name = "Wind Walker", value = "Raid Ready.", inline = true},

                    },
                    color = discordia.Color(0, 255, 150).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Paladin",
                    fields = {
                        {name = "Holy", value = "Dungeon started.", inline = true},
                        {name = "Protection", value = "Raid Ready.", inline = true},
                        {name = "Retribution", value = "Raid Ready.", inline = true},

                    },
                    color = discordia.Color(145, 140, 186).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Priest",
                    fields = {
                        {name = "Holy", value = "Dungeon started.", inline = true},
                        {name = "Discipline", value = "Not started.", inline = true},
                        {name = "Shadow", value = "Raid Ready.", inline = true},

                    },
                    color = discordia.Color(255, 255, 255).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Rogue",
                    fields = {
                        {name = "Assassination", value = "Raid Ready.", inline = true},
                        {name = "Subtlety", value = "Raid Ready.", inline = true},
                        {name = "Combat", value = "Raid Ready.", inline = true},

                    },
                    color = discordia.Color(255, 245, 105).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Shaman",
                    fields = {
                        {name = "Elemental", value = "Raid Ready.", inline = true},
                        {name = "Enhancement", value = "Raid Ready.", inline = true},
                        {name = "Restoration", value = "Dungeon Ready.", inline = true},

                    },
                    color = discordia.Color(0, 112, 222).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Warlock",
                    fields = {
                        {name = "Affliction", value = "Raid Ready.", inline = true},
                        {name = "Demonology", value = "Raid Ready.", inline = true},
                        {name = "Destruction", value = "Dungeon Ready.", inline = true},

                    },
                    color = discordia.Color(148, 130, 201).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Warrior",
                    fields = {
                        {name = "Arms", value = "Raid Ready.", inline = true},
                        {name = "Fury", value = "Raid Ready.", inline = true},
                        {name = "Protection", value = "Raid Ready.", inline = true},

                    },
                    color = discordia.Color(199, 156, 110).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            print("Sent classes message to: "..message.author.name)
            return
        end

        --Sends the user a download link
        if word[1] == '!download' then
            message:delete()
            print("Message: "..message.id.." Deleted")
            print("Message Author: "..message.author.name)
            print("~~~~~~~~~~\n")
            message.author:sendMessage(downloadLink)
            print("Sent download message to: "..message.author.name)
            log("> Sent download to "..message.author.username)
            return
        end

        --Sends the user the help list
        if word[1] == "!help" then
            message:delete()
            log("> Sent help to "..message.author.username)
            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Help",
                    fields = {
                        {name = "!help", value = "Sends the sender the help message.  ", inline = true},
                        {name = "!misty", value = "Misty will reply!", inline = true},
                        {name = "!hello", value = "Say hi to Misty!", inline = true},
                        {name = "!classes | !rotations", value = "List of currently supported rotations!", inline = true},
                        {name = "!download", value = "WaterHack download link!", inline = true},
                        {name = "!debug", value = "Bugs be gone!", inline = true},
                        {name = "!whoami", value = "Tells you who you are!", inline = true},
                        {name = "!install", value = "Sends the installation instructions!", inline = true},
                        {name = "!ping", value = "Pings the server!", inline = true},
                        {name = "!music", value = "Sends a random youtube video!", inline = true},
                        {name = "!rank (classname)", value = "Adds you to the class rank/channel!", inline = true},
                        {name = "!prune <number> | (ADMIN)", value = "Deletes <number> messages from the channel!", inline = true},
                        {name = "!whois | (ADMIN)", value = "Who is (unit)!", inline = true},
                        {name = "!module <toggle|status|list> <module> | (ADMIN)", value = "Toggles, displays information, lists current modules!", inline = true},
                        {name = "!antispam <strength> <0-1> | (ADMIN)", value = "Sets the strength of the anti spam filter. ", inline = true},
                        {name = "!panic | (ADMIN)", value = "Sets the antispam filter strength to 0.", inline = true},


                    },
                    color = discordia.Color(114, 137, 218).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }
            print("Sent help message to: "..message.author.name)
            return
        end

        --Debug statistics about the bot/server
        if channel == botChannel and  msg == "!debug" then
            log("> Someone debugged")
            message.channel:sendMessage("Channel Name: "..message.channel.name)
            message.channel:sendMessage("Server Name: "..message.guild.name)
            message.channel:sendMessage("Text Channel Count: "..message.guild.textChannelCount)
            message.channel:sendMessage("Voice Channel Count: "..message.guild.voiceChannelCount)
            print("Printed Debug\n")
        end

        --Sends the user their snowflake
        if word[1] == "!whoami" then
            message:delete()
            message.author:sendMessage("You're a snowflake, here\'s your identifier: "..message.author.id)
            print(message.author.name.." Asked who he was, he\'s: "..message.author.id)
            log("> Sent snowflake to "..message.author.username)
        end

        --Displays stats about the server
        if channel == botChannel and msg == "!stats" then
            log("> Posted Stats")
            message:delete()
            message.channel:sendMessage {
                embed = {
                    title = "WaterHack Stats",
                    fields = {
                        {name = "Members", value = message.guild.memberCount, inline = true},
                        {name = "Invite", value = "2zn5qcC", inline = true},
                    },
                    color = discordia.Color(114, 137, 218).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }
        end

        --Prune module USAGE: !prune (number)
        if modules["prune"].toggle and admin[tonumber(message.author.id)] and word[1] == "!prune" then
            if tonumber(word[2]) == nil then
                return false
            end
            if tonumber(word[2]) == nil then
                message.channel:sendMessage("Error, enter a number silly!")
            elseif math.floor(tonumber(word[2])) >= 1 and math.floor(tonumber(word[2])) <= 100 then
                message.channel:bulkDelete(math.floor(tonumber(string.sub(msg, 7))))
                message.channel:sendMessage("Pruned :)")
            elseif math.floor(tonumber(word[2])) < 1 or math.floor(tonumber(word[2])) > 100 then
                message.channel:sendMessage("Error, must be >= 1 and <= 100!")
            else
                message.channel:sendMessage("Error!")
            end
            log("> User Pruned: "..message.author.username)
            print(message.author.name.." PRUNED MESSAGES!")
        end

        --Administrator command to get other users snowflakes
        if admin[tonumber(message.author.id)] and string.find(msg, "!whois") then
            for user in message.mentionedUsers do
                message.author:sendMessage(user.name.."\'s snowflake is: "..user.id)
            end
            message:delete()
            log("> Sent a snowflake to "..message.author.username)
        end

        --Save a user to user file
        if word[1] == "!saveme" then
            for i=1, #savedusers.users do
                if savedusers.users[i] == message.author.id then
                    message.channel:sendMessage("You already exist!")
                else
                    table.insert(savedusers.users, message.author.id)
                    message.channel:sendMessage(savedusers.user[i])
                    LIP.save('test.ini', savedusers)
                    message.channel:sendMessage("Saved you!")
                end
            end
        end

--        if word[1] == "!bluearmy" then
--            for user in client.members do
--                for role in client.roles do
--                    if string.find(role.name, "army") then
--                        this = role
--                    end
--                end
--                if not user:hasRole(this) then
--                    message.member.addRole(this)
--                    message.channel:sendMessage("Welcome to the blue army!")
--                end
--            end
--        end

        --Quote the last posted message
        if string.find(msg, "!quote") then
            log("> Quoted")
            message.channel:sendMessage{
                embed = {
                    title = prevauthor,
                    fields = {
                        {name = "Message", value = prevmsg, inline = true},
                    },
                    color = discordia.Color(199, 156, 110).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }
        end





        --Reset or utilize local variables
        prevauthor = message.author.name
        prevmsg = msg
        lastMessageTime = os.clock()
        print(prevmsg)
        --Anti swearing filter
        if modules["swearfilter"].toggle then
            if admin[tonumber(message.author.id)] or exception[tonumber(message.author.id)] then return end
            for i=1, #word do
                if badword[word[i]] then
                    message:delete()
                    print(msg)
                    log("> Deleted a swear: "..msg)
                    break
                end
            end
        end
        word = {}
    end
end)

client:on('memberJoin', function(member)
    log("> "..member.name.." Joined "..servername)
    if member then
        for user in client.members do
            for role in client.roles do
                if string.find(role.name, "Developer") then
                    this = role
                end
            end
            if user:hasRole(this) then
                user:sendMessage(member.name.." Joined "..servername.."!")
                break;
            end
        end
        for user in client.members do
            for role in client.roles do
                if string.find(role.name, "Gucci") then
                    this = role
                end
            end
            if user:hasRole(this) then
                user:sendMessage(member.name.." Joined "..servername.."!")
                break;
            end
        end
    end
end)

client:run('bot-key-goes-here')
