# Ban Manager
A BeamMP plugin for banning and kicking on BeamMP servers. Supports multiple servers with one file.

#### Set up:
To install just move the banman folder into `/Resources/Server/`. Banlist and perms files need to be moved one directory up from where the BeamMP-server executable is located.

To block guest accounts from joining, change allowGuests in main.lua to true/false. To set the car limit, set carLimit in main.lua to the desired number (cars and peds both count as vehicles, so for example 2 cars + 1 ped = 3).

To add bans/permissions, just add the names to the appropriate file on separate lines. The banlist and perms list are case sensitive.

#### Commands:
To kick a player <br>
`/kick (id)` 

To see usernames and ID's (configured for 10 players, wont show all players if player limit is above 10)<br>
`/idmatch`

To ban a player <br>
`/ban (username)`

To ban and kick simultaneously <br>
`/kban (id)`
