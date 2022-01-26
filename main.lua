function onInit()
    print("BanMan-Lite Ready")
    RegisterEvent("onPlayerAuth","onPlayerAuth")
end

function onPlayerAuth(name)

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