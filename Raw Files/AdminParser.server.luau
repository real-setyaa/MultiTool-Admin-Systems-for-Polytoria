-- IT IS RECOMMENDED THAT YOU DO NOT EDIT ANYTHING IN THIS FILE
-- IF YOU NEED TO CHANGE ANYTHING, GO TO "AdminSettings" INSTEAD

print("MULTITOOL PARSER :: PARSER LOADED")

local SETTINGS = require(game["ScriptService"]["AdminSettings"])

print("MULTITOOL PARSER :: SETTINGS FETCHED")

Chat:BroadcastMessage("MULTITOOL INITIALIZED")

Chat.NewChatMessage:Connect(function(sender, message)
	print("MULTITOOL PARSER :: MESSAGE CAUGHT")
	if message == SETTINGS.Prefix .. "help" then
		for i,j in SETTINGS.Commands do
			print(j["desc"])
		end
		return
	end
	-- check if the message is a command
	if string.split(message, "")[1] == SETTINGS.Prefix then
		-- split command into parts: command, target, args
		local command = string.gsub(string.split(message, " ")[1], SETTINGS.Prefix, "")
		--local targets = string.split(string.split(message, " ")[2], ",")
		local arguments = {}
		for i,j in string.split(" ") do
			if i > 1 then
				table.insert(arguments, j)
			end
		end
		-- check if the command is valid
		if SETTINGS.Commands[command] then
			-- process player permission level
			local permlevel = 0
			if SETTINGS.PlayerPermissions[sender.Name] then
				permlevel = SETTINGS.PlayerPermissions[sender.Name]
			end
			-- check if the user has the proper permission levels
			if tonumber(tonumber(SETTINGS.Commands[command]["permissionlevel"])) <= tonumber(permlevel) then
				-- process arguments
				for i,j in string.split(message, " ") do
					if i > 1 then
						table.insert(arguments, j)
					end
				end
				local procargs = {}
				local iter = 0
				for i in SETTINGS.Commands[command]["arguments"] do
					table.insert(procargs, arguments[i])
					iter += 1
				end
				print("final iter " .. iter)
				local lastarg = ""
				for i,j in arguments do
					print("[" .. i .. "]: " .. j)
					if i > iter-1 then
						lastarg = lastarg .. " " .. j
					end
				end
				--table.insert(procargs, lastarg)
				procargs[iter] = lastarg
				
				-- run command
				---print(SETTINGS.Commands[command]["command"])
				print(command)
				print(SETTINGS.Commands[command])
				--print(SETTINGS.Commands[command]["command"].Name)
				local respcode = SETTINGS.Commands[command]["command"](sender.Name, procargs)
				-- parse return code
				print(respcode)
			else
				-- player does not have permissions
				print("MULTITOOL PARSER :: ERROR 401 FORBIDDEN")
			end
		else
			-- command does not exist
			print("MULTITOOL PARSER :: ERROR 601 COMMAND '" .. string.gsub(string.split(message, " ")[1], SETTINGS.Prefix, "") .. "' INVALID")
		end
	else
		print("MULTITOOL PARSER :: MESSAGE NOT A COMMAND, RELEASED")
	end
end)

game["Players"].PlayerAdded:Connect(function(player)
	if SETTINGS.ServerBans[player.UserID] then
		player:Kick("You have been banned from this server for:\n" .. SETTINGS.ServerBans[player.UserID])
	elseif SETTINGS.IsServerLocked then
		player:Kick("This server has been locked at the request of an administrator.")
	else
	if not SETTINGS.PlayerPermissions[player.Name] then
		SETTINGS.PlayerPermissions[player.Name] = "000"
	end
	--print(player.Name)
	--print(SETTINGS.PermissionLevels[tonumber("000")])
	--print(SETTINGS.PermissionLevels[tonumber(SETTINGS.PlayerPermissions[player.Name])])
	--print(SETTINGS.PlayerPermissions[player.Name])
	print("Welcome, " .. player.Name .. ". Your permission level is '" .. SETTINGS.PermissionLevels[tonumber(SETTINGS.PlayerPermissions[player.Name])] .. "' [" .. SETTINGS.PlayerPermissions[player.Name] .. "]")
	Chat:UnicastMessage("Welcome, " .. player.Name .. ". Your permission level is '" .. SETTINGS.PermissionLevels[tonumber(SETTINGS.PlayerPermissions[player.Name])] .. "' [" .. SETTINGS.PlayerPermissions[player.Name] .. "]", game["Players"][player.Name])
	--Chat:UnicastMessage("hello cro", player)
	end
end)
