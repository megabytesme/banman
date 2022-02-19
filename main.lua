local allowGuests = false

function onInit()
    print("BanManager Ready")
    RegisterEvent("onPlayerAuth","onPlayerAuth")
	RegisterEvent("onChatMessage", "onChatMessage")
end

function onPlayerAuth(name, role, isGuest)

	if isGuest and not allowGuests then
		return "You must be signed in to join this server!"
	end

	local f = assert(io.open("../banlist", "r"))
	local t = f:read ("*all")
	
	print("Checking banlist for", name)
	
	if string.match(t, name) then
		return "You have been banned from the server."
	else
		print("All good, user clear to join.")
	end
	
	f:close()

end

function onChatMessage(playerID, senderName, message)

	local f = assert(io.open("../perms", "r"))
	local t = f:read ("*all")

	local permsMatch = string.match(t, senderName)
	local getPlayerList = string.match(message, " /idmatch")
	local messageKick = string.match(message, " /kick")
	local messageID = string.match(message, "%d+")

	if senderName == permsMatch then

		if message == messageKick then
			return true
		end
		if message == getPlayerList then
			return true
		end

		if getPlayerList then
			local playerName = GetPlayerName(messageID)
			SendChatMessage(playerID, playerName)
			return -1
		end

		if messageKick then
			if messageID == nil then
				return "Invalid argument"
			else
				DropPlayer(messageID)
				print("Kicked player with ID " .. messageID)
				return -1
			end
		end
	end

	f:close()

end