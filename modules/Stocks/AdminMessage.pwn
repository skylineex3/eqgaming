stock AdminMessage(color, text[])
{
	for(new i=0; i<GetMaxPlayers(); i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlayerAdmin(i) || PlayerData[i][char_admin_level] > 6)
	        {
	            SendClientMessage(i, color, text);
			}
		}
	}
}
