local allowGuests = false
local carLimit = 3
local playerLimit = 10

function onInit()
	print("BanManager 1.4.1 Loaded")
	MP.RegisterEvent("onPlayerAuth","playerAuthHandler")
	MP.RegisterEvent("onChatMessage", "chatMessageHandler")
	MP.RegisterEvent("onVehicleSpawn", "spawnLimitHandler")
end

function playerAuthHandler(name, role, isGuest)

	playersCurrent = (MP.GetPlayerCount() - 1)

	if isGuest and not allowGuests then
		return "You must be signed in to join this server!"
	end

	local banFile = assert(io.open("../banlist", "r"))
	local banlist = banFile:read ("*all")
	banFile:close()

	local authFile = assert(io.open("../perms", "r"))
	local authRead = authFile:read("*all")
	authFile:close()

    pattern = {"%-"}
    patternout = {"%%-"}
    for i = 1, # pattern do
        name = name:gsub(pattern[i], patternout[i])
    end

	if playersCurrent == playerLimit then
		if string.match(authRead, name) ~= true then
			return "The server is full."
		end
	end
	
	print("BanManager: Checking banlist for " .. name)
	   
	if string.match(banlist, name) then
		return "You have been banned from the server."
	else
		print("BanManager: All good, user clear to join.")
	end
end

function chatMessageHandler(playerID, senderName, message)

	-- Initialize files
	local authFile = assert(io.open("../perms", "r"))
	local authStore = authFile:read ("*all")
	local banlist = assert(io.open("../banlist", "a+"))

	local authMatch = string.match(authStore, senderName)
	local msgTxt = string.match(message, "%s(.*)")
	local msgNum = tonumber(string.match(message, "%d+"))

	authFile:close()

	-- Intialize commands
	local getPlayerList = string.match(message, "/idmatch")
	local msgKick = string.match(message, "/kick")
	local msgBan = string.match(message, "/ban")
	local msgKban = string.match(message, "/kban")
	local msgCountdown = string.match(message, "/countdown")

	-- Start parsing commands
	if msgCountdown then
		local i = 3
		while i > 0 do
			MP.SendChatMessage(-1, "Countdown: " .. i)
			i = i - 1
			MP.Sleep(1000)
		end
		MP.SendChatMessage(-1, "Go!")
		return -1
	end

	if senderName == permsMatch then
		if getPlayerList then
			local i = 9
			while i >= 0 do
				local playerName = MP.GetPlayerName(i)
				if playerName == nil then
					MP.SendChatMessage(playerID, "Did not find player with ID" .. i)
				else
					playerName = i .. " - " .. MP.GetPlayerName(i)
					MP.SendChatMessage(playerID, playerName)
				end
				i = i - 1
			end
			return -1
		end

		if msgKick then
			if msgNum == nil then
				MP.SendChatMessage(playerID, "No ID given")
			else
				MP.DropPlayer(msgNum)
				MP.SendChatMessage(playerID, "Kicked player " .. MP.GetPlayerName(msgNum))
			end
			return -1
		end

		if msgKban then
			if msgNum == nil then
				MP.SendChatMessage(playerID, "No ID given")
			else
				local KbanID = MP.GetPlayerName(msgNum)
				banlist:write("\n" .. KbanID)
				banlist:flush()
				banlist:close()
				MP.DropPlayer(msgNum)
				MP.SendChatMessage(playerID, "Banned user " .. KbanID)
			end
			return -1
		end

		if msgBan then
			if msgTxt == nil then
				MP.SendChatMessage(playerID, "Missing username")
			else
				banlist:write("\n" .. msgTxt)
				banlist:flush()
				banlist:close()
				MP.SendChatMessage(playerID, "Banned user " .. msgTxt)
			end
			return -1
		end
	end
end

function spawnLimitHandler(playerID)
	local playerVehicles = MP.GetPlayerVehicles(playerID)
	local playerCarCount = 0

	-- Check for nil table and loop through player cars
	if playerVehicles ~= nil then
		for _ in pairs(playerVehicles) do playerCarCount = playerCarCount + 1 end
	end

	if (playerCarCount + 1) > carLimit then
		MP.DropPlayer(playerID)
		MP.SendChatMessage(-1, "Player " .. MP.GetPlayerName(playerID) .. " was kicked for spawning more than " .. carLimit .. " cars.")
		print("BanManager: Player " .. MP.GetPlayerName(playerID) .. " was kicked for spawning too many cars.")
	end
end
