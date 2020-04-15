stock GetPlayerID(const parte_nome[])
{
    for(new i; i <= GetMaxPlayers(); i++)
	{
        if(!IsPlayerConnected(i)) continue;

        new ni[MAX_PLAYER_NAME];
        GetPlayerName(i, ni, sizeof(ni));
        if(strfind(ni, parte_nome, true) > -1)
            return i;
    }
    return INVALID_PLAYER_ID;
}
