stock TeamMessage(color, text[])
{
	for(new i=0; i<GetMaxPlayers(); i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlayerAdmin(i) || PlayerData[i][char_admin_level] > 0)
	        {
	            SendClientMessage(i, color, text);
			}
		}
	}
}
