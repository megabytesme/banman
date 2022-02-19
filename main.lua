local allowGuests = false

function onInit()
    print("BanMan-Lite Ready")
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
	local messageDrop = string.match(message, " /kick")
	local messageID = string.match(message, "%d+")
	local messageBan = string.match(message, " /ban")
	-- local playerName = string.match(message, "%s(.*)")

	if senderName == permsMatch then

		if message == messageDrop then
			return true
		end

		if message == messageBan then
			return true
		end

		if messageDrop then
			if messageID == nil then
				return "Invalid argument"
			else
				DropPlayer(messageID)
				print("Kicked player with ID " .. messageID)
				return -1
			end
		-- Todo ban command
		elseif messageBan then
			return -1
		end
	end

	f:close()

end