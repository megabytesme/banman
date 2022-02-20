-- Change this to 'true' to allow guests
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
	local msgKick = string.match(message, " /kick")
	local msgNum = string.match(message, "%d+")

	if senderName == permsMatch then

		--=================================--
		if message == msgKick then
			return true
		end
		if message == getPlayerList then
			return true
		end
		--=================================--

		if getPlayerList then
			local count = tonumber(msgNum)
			while count >= 0 do
				local playerName = GetPlayerName(count)
				if playerName == nil then
					local missingID = "Did not find player with ID " .. count
					SendChatMessage(playerID, missingID)
				else
					playerName = count .. " - " .. GetPlayerName(count)
					SendChatMessage(playerID, playerName)
				end
				count = count - 1
			end
			return -1
		end

		if msgKick then
			if msgNum == nil then
				return "Invalid argument"
			else
				DropPlayer(msgNum)
				print("Kicked player with ID " .. msgNum)
				return -1
			end
		end
	end

	f:close()
end