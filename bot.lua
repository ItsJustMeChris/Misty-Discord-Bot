local discordia = require('discordia')
local utf8 = require('utf8_simple')
local LIP = require 'LIP';
local servername = "SERVER NAME"


local client = discordia.Client()

client:on('ready', function()
    print('Logged in as '.. client.user.username)
end)

local savedusers = {
    users = {
    }
}

local savedusers = LIP.load('test.ini')




local badword = {
    [1] = "fag",
    [2] = "nigger",
    [3] = "nigga",
    [4] = "cunt",
    [5] = "dick",
    [6] = "fuck",
    [7] = "shit",
    [8] = "asshole",
    [9] = "retard",
    [10] = "cum",
    [11] = "slut",
    [12] = "tuanha",
    [13] = "winifix",
    [14] = "soapbox",
    [15] = "n1gg4",
    [16] = "n1gg3r",
    [17] = "fatass",
}



local prevauthor
local prevmsg
local sent
local this




client:on('messageCreate', function(message)
    if message.guild and message.guild.name == "WaterHack" then
        local msg = string.lower(message.content)


        if msg == prevmsg then
            if (message.author.id == "210152605467410434" or message.author.id == "210615876766924801" or message.author.id == "174158345073065984" or message.author.id == "127837881917112321" or message.author.id == "165658644493369345") then else
                message:delete()
                print("Anti spam, removed "..message.author.name.."\'s message as it was the same as a previous")
            end
        end
        for i=1, #badword do
            if string.find(utf8.strip(msg), string.lower(badword[i])) then
                if (message.author.id == "210152605467410434" or message.author.id == "210615876766924801" or message.author.id == "174158345073065984" or message.author.id == "127837881917112321" or message.author.id == "165658644493369345") then else
                    message:delete()
                    message.channel:sendMessage("Please do not swear, "..message.author.name.." ( "..message.author.username.." )".."!")
                    print(message.author.name.." Just Swore!")
                end
            end
        end


        local channel = message.channel.name
        if channel == "bot" and msg == "!misty" then
            message.channel:sendMessage("I\'m Misty!\nI was created to keep WaterHack safe (:")
        end
        if msg == '!invite' then
            message.author:sendMessage("2zn5qcC")
        end
        if channel == "bot" and msg == '!hello' then
            message:delete()
            print("Message: "..message.id.." Deleted")
            print("Message Author: "..message.author.name)
            print("~~~~~~~~~~\n")
            message.channel:sendMessage('Hi, Im Misty, how can I help you?')
            print("Someone said hello!")
            return
        end
        if msg == '!classes' or msg == '!rotations' then
            message:delete()
            print("Message: "..message.id.." Deleted")
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
        if msg == '!download' then
            message:delete()
            print("Message: "..message.id.." Deleted")
            print("Message Author: "..message.author.name)
            print("~~~~~~~~~~\n")
            message.author:sendMessage("https://waterhack.co/forumdisplay.php?fid=9")
            print("Sent download message to: "..message.author.name)
            return
        end
        if msg == "!help" then
            message:delete()
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
        if channel == "bot" and  msg == "!debug" then
            message.channel:sendMessage("Channel Name: "..message.channel.name)
            message.channel:sendMessage("Server Name: "..message.guild.name)
            message.channel:sendMessage("Text Channel Count: "..message.guild.textChannelCount)
            message.channel:sendMessage("Voice Channel Count: "..message.guild.voiceChannelCount)
            print("Printed Debug\n")
        end
        if msg == "!whoami" then
            message:delete()
            message.author:sendMessage("You're a snowflake, here\'s your identifier: "..message.author.id)
            print(message.author.name.." Asked who he was, he\'s: "..message.author.id)
        end
        if channel == "bot" and msg == "!stats" then
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
        if (message.author.id == "210152605467410434" or message.author.id == "210615876766924801" or message.author.id == "174158345073065984" or message.author.id == "127837881917112321" or message.author.id == "165658644493369345") and msg == "!prune" then
            message.channel:bulkDelete(10)
            message.channel:sendMessage("Delete the 10 most recent message :)")
            print(message.author.name.." PRUNED MESSAGES!")
        end
        if (message.author.id == "210152605467410434" or message.author.id == "210615876766924801" or message.author.id == "174158345073065984" or message.author.id == "127837881917112321" or message.author.id == "165658644493369345") and string.find(msg, "!whois") then
            for user in message.mentionedUsers do
                message.author:sendMessage(user.name.."\'s snowflake is: "..user.id)
            end
            message:delete()
        end

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
        if msg == prevmsg then
            print(message.guild.name)
            message:delete()
            message.author:sendMessage("Please do not post the same message as other users!")
        end

        if string.find(msg, "!quote") then
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

        --if string.find(msg, "[react]") then
        --    message:addReaction("🇲")
        --    message:addReaction("🇮")
        --    message:addReaction("🇸")
        --    message:addReaction("🇹")
        --    message:addReaction("🇾")
        --    message:addReaction("🌁")
        --end

        prevauthor = message.author.name
        prevmsg = msg
        print(prevmsg)
    end

end)

client:on('memberJoin', function(member)

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

client:run('KEY')
