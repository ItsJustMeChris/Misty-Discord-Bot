--Requires
local discordia = require('discordia')
local utf8 = require('utf8_simple')
local LIP = require 'LIP';
local servername = "WaterHack"
local botChannel = "bot"
localbotkey = "key"
--Log function (Log messages to file)
local function log(message)
    file = io.open("log.txt", "a")
    file:write(message.."\n")
    file:close()
end


--Declare discord client
local client = discordia.Client()

--Initialize bot
client:on('ready', function()
    print('Logged in as '.. client.user.username)
    client:setGameName("WaterHack")
    log(">>>>> BOT LOGIN <<<<<")
end)

--User table for nothing yet.. TODO: User saving/stuffs
local savedusers = {
    users = {
    }
}

--Load saved users file.
local savedusers = LIP.load('test.ini')

--Admin table
local admin = {
    [210152605467410434] = true,
    [210615876766924801] = true,
    [174158345073065984] = true,
    [127837881917112321] = true,
    [165658644493369345] = true,
    [117337445833506821] = true,
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
local downloadLink = "https://waterhack.co/forumdisplay.php?fid=9"
local prevauthor
local prevmsg
local sent
local this
local word = {}

--Message listening event (The real bot)
client:on('messageCreate', function(message)
    if message.guild and message.guild.name == servername then
        local msg = utf8.strip(string.lower(message.content))
        local channel = message.channel.name

        log(msg)
        
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

        --Anti spam filter
        if modules["antispam"] and msg == prevmsg and not admin[tonumber(message.author.id)] then
            message:delete()
            message.author:sendMessage("Please do not post the same message as other users!")
            log("> Deleted a repeat: "..msg)
        end
        
        --Pings a user
        if modules["ping"] and admin[tonumber(message.author.id)] and word[1] == "!ping" then
            message:delete()
            for user in message.mentionedUsers do
                user:sendMessage(message.author.username.." just pinged you!")
            end
        end
        
        --Anti swearing filter
        if modules["swearfilter"] and not admin[tonumber(message.author.id)] then
            for i=1, #word do
                if badword[word[i]] then
                    message:delete()
                    message.author:sendMessage("Please do not swear!")
                    print(msg)
                    log("> Deleted a swear: "..msg)
                    break
                end
            end
        end

        --Displays information about the bot.
        if channel == botChannel and msg == "!misty" then
            message.channel:sendMessage("I\'m Misty!\nI was created to keep WaterHack safe (:")
            log(">>>>> !misty called <<<<<")
        end
        
        --Sends an invite code to the user that requested it
        if msg == '!invite' then
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
        if msg == '!classes' or msg == '!rotations' then
            message:delete()
            print("Message: "..message.id.." Deleted")
            log("> Sent classes to "..message.author.username)
            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Death knight",
                    fields = {
                        {name = "Blood", value = "Dungeon Ready.", inline = true},
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
                        {name = "Havoc", value = "Dungeon Ready.", inline = true},
                        {name = "Vengeance", value = "Dungeon Ready.", inline = true},
                    },
                    color = discordia.Color(163, 48, 201).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Druid",
                    fields = {
                        {name = "Balance", value = "Not started.", inline = true},
                        {name = "Feral", value = "Not started.", inline = true},
                        {name = "Guardian", value = "Dungeon Ready.", inline = true},
                        {name = "Restoration", value = "Dungeon Ready.", inline = true},

                    },
                    color = discordia.Color(255, 125, 10).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Hunter",
                    fields = {
                        {name = "Beast Mastery", value = "Dungeon Ready.", inline = true},
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
                        {name = "Frost", value = "Dungeon Ready.", inline = true},
                        {name = "Fire", value = "Dungeon Ready.", inline = true},
                        {name = "Arcane", value = "Dungeon Ready.", inline = true},

                    },
                    color = discordia.Color(105, 204, 240).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Monk",
                    fields = {
                        {name = "Brew Master", value = "Dungeon Ready.", inline = true},
                        {name = "Mist Weaver", value = "Dungeon Ready.", inline = true},
                        {name = "Wind Walker", value = "Dungeon Ready.", inline = true},

                    },
                    color = discordia.Color(0, 255, 150).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Paladin",
                    fields = {
                        {name = "Holy", value = "Not started.", inline = true},
                        {name = "Protection", value = "Dungeon Ready.", inline = true},
                        {name = "Retribution", value = "Dungeon Readyish.", inline = true},

                    },
                    color = discordia.Color(145, 140, 186).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Priest",
                    fields = {
                        {name = "Holy", value = "Not started.", inline = true},
                        {name = "Discipline", value = "Not started.", inline = true},
                        {name = "Shadow", value = "Dungeon Readyish.", inline = true},

                    },
                    color = discordia.Color(255, 255, 255).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Rogue",
                    fields = {
                        {name = "Assassination", value = "Dungeon Ready.", inline = true},
                        {name = "Subtlety", value = "Dungeon Ready.", inline = true},
                        {name = "Combat", value = "Dungeon Ready.", inline = true},

                    },
                    color = discordia.Color(255, 245, 105).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Shaman",
                    fields = {
                        {name = "Elemental", value = "Dungeon Readyish.", inline = true},
                        {name = "Enhancement", value = "Dungeon Ready.", inline = true},
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
                        {name = "Affliction", value = "Single Target.", inline = true},
                        {name = "Demonology", value = "Single Target.", inline = true},
                        {name = "Destruction", value = "Single Target.", inline = true},

                    },
                    color = discordia.Color(148, 130, 201).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            message.author:sendMessage {
                embed = {
                    title = "WaterHack | Warrior",
                    fields = {
                        {name = "Arms", value = "Dungeon Ready.", inline = true},
                        {name = "Fury", value = "Dungeon Ready.", inline = true},
                        {name = "Protection", value = "Dungeon Ready.", inline = true},

                    },
                    color = discordia.Color(199, 156, 110).value,
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }

            print("Sent classes message to: "..message.author.name)
            return
        end
        
        --Sends the user a download link
        if msg == '!download' then
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
        if msg == "!help" then
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
                        {name = "!prune | (ADMIN)", value = "Deletes 10 messages from the channel!", inline = true},
                        {name = "!whois | (ADMIN)", value = "Who is (unit)!", inline = true},

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
        if msg == "!whoami" then
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
        if modules["prune"] and admin[tonumber(message.author.id)] and string.find(msg, "!prune") then
            if tonumber(word[2]) == nil then
                message.channel:sendMessage("Error, enter a number silly!")
            elseif math.floor(tonumber(word[2])) >= 1 and math.floor(tonumber(word[2])) <= 100 then
                message.channel:bulkDelete(math.floor(tonumber(string.sub(msg, 7))))
                message.channel:sendMessage("Deleted the "..math.floor(tonumber(word[2])).." most recent message(s) :)")
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
        if msg == "!saveme" then
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
        print(prevmsg)
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
            end
        end
    end
end)

client:run(botkey)
