-- Change this to 'true' to allow guests
local allowGuests = false

function onInit()
    print("BanManager 1.3.1 Loaded")
    MP.RegisterEvent("onPlayerAuth","playerAuthHandler")
	MP.RegisterEvent("onChatMessage", "chatMessageHandler")
end

function playerAuthHandler(name, role, isGuest)

	if isGuest and not allowGuests then
		return "You must be signed in to join this server!"
	end

	local f = assert(io.open("../banlist", "r"))
	local t = f:read ("*all")
	
	print("BanManager: Checking banlist for " .. name)
	
	if string.match(t, name) then
		return "You have been banned from the server."
	else
		print("BanManager: All good, user clear to join.")
	end
	
	f:close()

end

function chatMessageHandler(playerID, senderName, message)

	-- Initialize files
	local f = assert(io.open("../perms", "r"))
	local t = f:read ("*all")
	local f2 = assert(io.open("../banlist", "r+"))
	local t2 = f2:read ("*all")

	local permsMatch = string.match(t, senderName)
	local msgTxt = string.match(message, "%s(.*)")
	local msgNumR = string.match(message, "%d+")
	local msgNum = tonumber(msgNumR)

	-- Intialize commands
	local getPlayerList = string.match(message, "/idmatch")
	local msgKick = string.match(message, "/kick")
	local msgBan = string.match(message, "/ban")
	local msgBkick = string.match(message, "/bkick")

	if senderName == permsMatch then

		if getPlayerList then
			local count = 9
			while count >= 0 do
				local playerName = MP.GetPlayerName(count)
				if playerName == nil then
					MP.SendChatMessage(playerID, "Did not find player with ID" .. count)
				else
					playerName = count .. " - " .. MP.GetPlayerName(count)
					MP.SendChatMessage(playerID, playerName)
				end
				count = count - 1
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

		if msgBkick then
			if msgNum == nil then
				MP.SendChatMessage(playerID, "No ID given")
			else
				local bKickID = MP.GetPlayerName(msgNum)
				MP.DropPlayer(msgNum)
				f2:write("\n" .. bKickID)
				MP.SendChatMessage(playerID, "Banned user " .. msgTxt)
			end
			return -1
		end

		if msgBan then
			if msgTxt == nil then
				MP.SendChatMessage(playerID, "Missing username")
			else
				f2:write("\n" .. msgTxt)
				MP.SendChatMessage(playerID, "Banned user " .. msgTxt)
			end
			return -1
		end
	end

	f:close()
	f2:close()

end