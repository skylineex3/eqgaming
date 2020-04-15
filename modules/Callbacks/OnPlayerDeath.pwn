public OnPlayerDeath(playerid, killerid, reason)
{
	for(new i=0; i<MAX_ITEMS; i++)
	    if(Item[i][Owner] == PlayerData[playerid][char_uid])
	        if(Item[i][Active])
	            Item[i][Active] = false;

	Info(playerid, "Twoja postac stracila przytomnosc. Ten stan potrwa okolo 3 minuty.");
	GetPlayerPos(playerid, PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2]);
 	PlayerData[playerid][char_bw] = 180;
  	SetPlayerHealthEx(playerid, 9);

	UpdateNick(playerid);
	return 1;
}
