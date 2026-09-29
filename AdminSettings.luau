-- MultiTool Admin
-- Version 1.0.0
-- 
-- Created by Setyaa (Oreosforlife404)

print("MULTITOOL SETTINGS :: LOADING SETTINGS")

local AdminSettings = {}

-- /!\ EVERYTHING EDITABLE STARTS AT LINE 274 /!\ --

local MultiToolData = Datastore:GetDatastore("MultiToolServiceData")
local sucess, pbanlist = pcall(function()
	return MultiToolData:GetAsync("PermanentBans")
end)
if success and pbanlist ~= nil then
	print("MULTITOOL SETTINGS :: LOADED PERMBAN LIST")
else
	print("MULTITOOL SETTINGS :: CREATED PERMBAN LIST")
	sbanlist = {}
	local success = pcall(function()
		ds:SetAsync("PermanentBans", pbanlist)
	end)
	if success then
		print("MULTITOOL SETTINGS :: SAVED PERMBAN LIST")
	else
		print("MULTITOOL SETTINGS :: UNABLE TO CONNECT TO DATASTORE")
	end
end

AdminSettings.ServerBans = {}

AdminSettings.IsServerLocked = false

-- Error Codes
AdminSettings.ResponseCodes = {
	-- 0XX : NIL
	-- 1XX : NIL
	-- 2XX : SUCCESS
	[200] = "Success",				-- Command issued successfully
	-- 3XX : NIL
	-- 4XX : CLIENT
	[400] = "Bad Request",		-- Client error happened somewhere
	[401] = "Forbidden",			-- Permission level invalid
	[402] = "No Client",			-- You messed up BAD
	-- 5XX : SERVER
	[500] = "Server Error",		-- Server error happened somewhere
	[501] = "Unresponsive",		-- Server unresponsive
	-- 6XX : SYSTEM
	[600] = "MultiTool Error",	-- MultiTool system error happened somewhere
	[601] = "Invalid Command",	-- Command is invalid
	[602] = "Argument Mismatch",-- Arguments do not match
	-- 7XX : LUL
	-- 8XX : WORLD
	[800] = "Invalid Item",		-- Item does not exist
	[801] = "Invalid Player",	-- Player not found
	-- 9XX : NIL
}

-- COMMANDS --
-- Do not edit past this point unless you know what you're doing
-- NO REFUNDS!!!

-- COMMAND STRUCTURE
-- Sender: Player who sent the command. Not always used, but required for commands to function
-- Targets: Players the command is target at.

function ProcessTargets(targets, sender)
	local proctargs = {}
	targets = string.split(targets, ",")
	for i,j in targets do
		j = string.gsub(j, " ", "")
		-- all statement
		if j == "@a" then
			for l,m in game["Players"]:GetChildren() do
				table.insert(proctargs, m.Name)
			end
		-- others statement
		elseif j == "@o" then
			for l,m in game["Players"]:GetChildren() do
				if m.Name ~= sender then
					table.insert(proctargs, m.Name)
				end
			end
		-- self statement
		elseif j == "@s" then
			table.insert(proctargs, sender)
		-- team statement
		elseif string.split(j, ":")[1] == "@t" then
			for n,o in game["Players"]:GetChildren() do
				if o.Team == game["Teams"][string.split(j, ":")[2]] then
					--print("ADDING TEAM PLAYER " .. o.Name .. " FROM TEAM " .. o.Team.Name)
					table.insert(proctargs, o.Name)
				end
			end
		-- normal players
		else
			table.insert(proctargs, j)
		end
	end
	return proctargs
end

function AdminSettings.Goto(sender, args)
	targets = ProcessTargets(args[1], sender)
	local origin = sender
	local destination = targets
	for i,j in destination do
		if game["Players"][origin] then
			if game["Players"][j] then
				local originplayer = game["Players"][origin]
				local destinationplayer = game["Players"][j]
				originplayer.Position = destinationplayer.Position
			else return AdminSettings.ResponseCodes[801], j end
		else return AdminSettings.ResponseCodes[402], origin end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Bring(sender, args)
	targets = ProcessTargets(args[1], sender)
	local origin = sender
	local destination = targets
	for i,j in destination do
		if game["Players"][origin] then
			if game["Players"][j] then
				local originplayer = game["Players"][origin]
				local destinationplayer = game["Players"][j]
				destinationplayer.Position = originplayer.Position
			else return AdminSettings.ResponseCodes[801], j end
		else return AdminSettings.ResponseCodes[402], origin end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Kill(sender, args)
	targets = ProcessTargets(args[1], sender)
	for i,j in targets do
		if game["Players"][j] then
			game["Players"][j].Health = 0
		else
			return AdminSettings.ResponseCodes[801]
		end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Heal(sender, args)
	targets = ProcessTargets(args[1], sender)
	for i,j in targets do
		if game["Players"][j] then
			game["Players"][j].Health = game["Players"][j].MaxHealth
		else
			return AdminSettings.ResponseCodes[801]
		end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Damage(sender, args)
	targets = ProcessTargets(args[1], sender)
	for i,j in targets do
		if game["Players"][j] then
			game["Players"][j].Health = game["Players"][j].Health - args[2]
		else
			return AdminSettings.ResponseCodes[801]
		end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.SetTeam(sender, args)
	targets = ProcessTargets(args[1], sender)
	local desteam = string.gsub(args[2], " ", "")
	for i,j in targets do
		if game["Players"][j] then
			if game["Teams"][desteam] then
				game["Players"][j].Team = game["Teams"][desteam]
			else
				return AdminSettings.ResponseCodes[800]
			end
		else
			return AdminSettings.ResponseCodes[801]
		end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Kick(sender, args)
	targets = ProcessTargets(args[1], sender)
	for i,j in targets do
		if game["Players"][j] then
				game["Players"][j]:Kick("You have been kicked from this server for:\n" .. args[2])
		else
			return AdminSettings.ResponseCodes[801]
		end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Ban(sender, args)
	targets = ProcessTargets(args[1], sender)
	for i,j in targets do
		if game["Players"][j] then
				game["Players"][j]:Kick("You have been banned from this server for:\n" .. args[2])
				AdminSettings.ServerBans[game["Players"][j].UserID] = args[1]
		else
			return AdminSettings.ResponseCodes[801]
		end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Unban(sender, args)
	targets = ProcessTargets(args[1], sender)
	for i,j in targets do
		if game["Players"][j] then
			for k,l in ipairs(AdminSettings.ServerBans) do
				if l == j.UserID then
					table.remove(AdminSettings.ServerBans, k)
				end
			end
		else
			return AdminSettings.ResponseCodes[801]
		end
	end
	return AdminSettings.ResponseCodes[200]
end

-- DOES NOT WORK
function AdminSettings.PermaBan(sender, args)
	for i,j in target do
		if game["Players"][j] then
				game["Players"][j]:Kick(args[1])
		else
			return AdminSettings.ResponseCodes[801]
		end
	end
	return AdminSettings.ResponseCodes[200]
end

function ShowHelp(sender, args)
	for i,j in AdminSettings.Commands do
		print(j["desc"])
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.CmdMessage(sender, args)
	Chat:BroadcastMessage("[color=##e22d46]MULTITOOL: [/color]" .. args[1])
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.CmdAlert(sender, args)
	Chat:BroadcastMessage("[color=#FF0000]MULTITOOL: " .. args[1].."[/color]")
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.PrivateMessage(sender, args)
	targets = ProcessTargets(args[1], sender)
		for i,j in targets do
			if game["Players"][j] then
				Chat:UnicastMessage("[color=##e22d46][PM FROM " .. sender .. "] " .. args[2] .."[/color]", game["Players"][j])
			else
				return AdminSettings.ResponseCodes[801]
			end
		end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Shutdown(sender, args)
	Chat:BroadcastMessage("[color=#FF0000]MULTITOOL: SHUTTING SERVER DOWN [/color]")
	for i,j in game["Players"]:GetChildren() do
		j:Kick("MultiTool has shut this server down at the request of an administrator.")
	end
	AdminSettings.IsServerLocked = true
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.WaitShutdown(sender, args)
	Chat:BroadcastMessage("[color=#FF0000]MULTITOOL: SHUTTING SERVER DOWN IN 10 SECONDS [/color]")
	wait(10)
	for i,j in game["Players"]:GetChildren() do
		j:Kick("MultiTool has shut this server down at the request of an administrator.")
	end
	AdminSettings.IsServerLocked = true
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.ServerLock(sender, args)
	Chat:BroadcastMessage("[color=##e22d46]MULTITOOL: [/color]SERVER LOCKED")
	AdminSettings.IsServerLocked = true
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.ServerUnlock(sender, args)
	Chat:BroadcastMessage("[color=##e22d46]MULTITOOL: [/color]SERVER UNLOCKED")
	AdminSettings.IsServerLocked = false
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.SetPerms(sender, args)
	targets = ProcessTargets(args[1], sender)
	local execperms = 0
	if AdminSettings.PermissionLevels[sender] then
		execperms = AdminSettings.PermissionLevels[sender]
	end
	for i,j in targets do
		if tonumber(string.gsub(j, " ", "")) < execperms then
			AdminSettings.PermissionLevels[args[1]] = string.gsub(j, " ", "")
		end
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.Clone(sender, args)
	targets = ProcessTargets(args[1], sender)
	for i,j in targets do
		local npc = Insert:DefaultNPC()
		local char = game["Players"][j]["Character"]:Clone()
		char.Parent = npc
		--npc.Character = char
		npc.DisplayName = j
		npc.Position = game["Players"][sender].Position
	end
	return AdminSettings.ResponseCodes[200]
end

function AdminSettings.NewTeam(sender, args)
	local newteam = Team.New()
	newteam.Name = args[1]
	newteam.Color = Color.FromHex((string.gsub(args[2], " ", "")))
	newteam.Parent = game["Teams"]
end

function AdminSettings.DelTeam(sender, args)
	if game["Teams"][(string.gsub(args[1], " ", ""))] then
		game["Teams"][(string.gsub(args[1], " ", ""))]:Destroy()
	end
end

-- EDITABLE VARIABLES --

AdminSettings.Prefix 				= ";"		-- Prefix used by the system
AdminSettings.IsFunAllowed 	= true	-- toggles if fun commands are allowed

-- Permission levels
AdminSettings.PermissionLevels = {
	[255] = "Owner",
	[250] = "Administrator",
	[225] = "Game Moderator",
	[200] = "Server Owner",
	[100] = "Head Moderator",
	[050] = "Moderator",
	[000] = "Guest"
}

-- Players with a preset permission level, and that level
AdminSettings.PlayerPermissions = {
		-- POLYTOPS STAFF DO NOT EDIT --
		-- PolyTops Ownership
		["Oreosforlife404"] = 255, -- supreme god empress of multitool. also polytops creator
		["Player1"] 				= 255, -- TEST PLAYERS REMOVE IF NOT NEEDED
		["Player2"] 				= 255, -- TEST PLAYERS REMOVE IF NOT NEEDED
		["Player3"] 				= 255, -- TEST PLAYERS REMOVE IF NOT NEEDED
		["Player4"] 				= 255,  -- TEST PLAYERS REMOVE IF NOT NEEDED
		-- PolyTops Administrators
		-- ADD LATER --
		-- PolyTops Game Moderators
		-- ADD LATER --
		
		-- Server Staff (EDIT THIS ONE) --
		-- Server Owner
		--["MyUsername"] = 200,
		-- Server H. Mods
		-- ["CoolGuy"] = 100,
		-- Server Mods
		-- ["JohnDoe"] = 050,
		-- ["JaneDoe"] = 050,
		-- ["FooBar"] = 050
}



-- Commands and their aliases 
AdminSettings.Commands = {
	["to"] 				= {["command"] = AdminSettings.Goto, 						["permissionlevel"] = 050, ["arguments"] = {"target"}, 						["flags"] = {}, ["desc"] = "[;to {target}] - Teleports the user to the target player."},
	["bring"] 		= {["command"] = AdminSettings.Bring, 					["permissionlevel"] = 050, ["arguments"] = {"target"}, 						["flags"] = {}, ["desc"] = "[;bring {target}] - Teleports all target users to the player."},
	["kill"] 			= {["command"] = AdminSettings.Kill, 						["permissionlevel"] = 050, ["arguments"] = {"target"}, 						["flags"] = {}, ["desc"] = "[;kill {target}] - Sets the health of all target users to 0."},
	["heal"] 			= {["command"] = AdminSettings.Heal, 						["permissionlevel"] = 050, ["arguments"] = {"target"}, 						["flags"] = {}, ["desc"] = "[;heal {target}] - Sets the health of all users to their max health."},
	["damage"] 		= {["command"] = AdminSettings.Damage, 					["permissionlevel"] = 050, ["arguments"] = {"target","ammount"}, 	["flags"] = {}, ["desc"] = "[;damage {target} {ammount}] - Subtracts ammount from each of the target player's health."},
	["team"] 			= {["command"] = AdminSettings.SetTeam, 				["permissionlevel"] = 050, ["arguments"] = {"target","team"}, 		["flags"] = {}, ["desc"] = "[;team {target} {team name}] - Changes all target users team to the selected team."},
	["kick"] 			= {["command"] = AdminSettings.Kick, 						["permissionlevel"] = 050, ["arguments"] = {"target","reason"}, 	["flags"] = {}, ["desc"] = "[;kick {target} {reason}] - Kicks target users from the server, displaying the reason."},
	["ban"] 			= {["command"] = AdminSettings.Ban, 						["permissionlevel"] = 050, ["arguments"] = {"target","reason"}, 	["flags"] = {}, ["desc"] = "[;ban {target} {reason}] - Bans the target users FROM THE SERVER ONLY. Displays the reason and kicks upon rejoining."},
	["unban"]			= {["command"] = AdminSettings.Unban, 					["permissionlevel"] = 050, ["arguments"] = {"target"},	 					["flags"] = {}, ["desc"] = "[;unban {target}] - Unbans the target users FROM THE SERVER ONLY."},
	["clone"]			= {["command"] = AdminSettings.Clone, 					["permissionlevel"] = 050, ["arguments"] = {"target"},	 					["flags"] = {}, ["desc"] = "[;clone {target}] - Clones the target user."},
	--["setperms"]	= {["command"] = AdminSettings.SetPerms, 				["permissionlevel"] = 000, ["arguments"] = {"target","level"}, 		["flags"] = {}, ["desc"] = "[;setperms {target} {level}] - Sets the {target}'s permission level to {level}. Cannot set a level higher than or equal to your own."},
	["help"] 			= {["command"] = AdminSettings.ShowHelp, 				["permissionlevel"] = 000, ["arguments"] = {}, 										["flags"] = {}, ["desc"] = "[;help {target (REQUIRED BUT DOESNT DO ANYTHING)}] - Shows this help screen."},
	["chat"] 			= {["command"] = AdminSettings.CmdMessage, 			["permissionlevel"] = 050, ["arguments"] = {"message"}, 					["flags"] = {}, ["desc"] = "[;chat {message}] - Sends a chat mesage."},
	["alert"] 		= {["command"] = AdminSettings.CmdAlert, 				["permissionlevel"] = 050, ["arguments"] = {"message"}, 					["flags"] = {}, ["desc"] = "[;alert {message}] - Sends a MultiTool alert."},
	["pm"] 				= {["command"] = AdminSettings.PrivateMessage, 	["permissionlevel"] = 000, ["arguments"] = {"target", "message"}, ["flags"] = {}, ["desc"] = "[;pm {target} {message}] - Sends a chat mesage only to a specific person."},
	["addteam"] 	= {["command"] = AdminSettings.NewTeam, 				["permissionlevel"] = 050, ["arguments"] = {"name", "hexcolor"}, 	["flags"] = {}, ["desc"] = "[;addteam {name} {HEX code}] - Creates a new team."},
	["delteam"] 	= {["command"] = AdminSettings.DelTeam, 				["permissionlevel"] = 050, ["arguments"] = {"name"}, 							["flags"] = {}, ["desc"] = "[;delteam {name}] - Deletes a team."},
	["slock"] 		= {["command"] = AdminSettings.ServerLock, 			["permissionlevel"] = 050, ["arguments"] = {}, 										["flags"] = {}, ["desc"] = "[;slock] - Locks the server so no one can join."},
	["sunlock"] 	= {["command"] = AdminSettings.ServerUnlock, 		["permissionlevel"] = 050, ["arguments"] = {}, 										["flags"] = {}, ["desc"] = "[;sunlock] - Unlocks the server."},
	["shutdown"] 	= {["command"] = AdminSettings.Shutdown, 				["permissionlevel"] = 100, ["arguments"] = {}, 										["flags"] = {}, ["desc"] = "[;shutdown] - Shuts the server down, kicking all players and setting a lock."},
	["wshutdown"] = {["command"] = AdminSettings.WaitShutdown, 		["permissionlevel"] = 100, ["arguments"] = {}, 										["flags"] = {}, ["desc"] = "[;wshutdown] - Same as ;shutdown but after 10 seconds."}
}

-- Perfix used by the system
print("MULTITOOL SETTINGS :: SETTINGS LOADED")
print("MULTITOOL SETTINGS :: SENDING TO PARSER")
return AdminSettings
