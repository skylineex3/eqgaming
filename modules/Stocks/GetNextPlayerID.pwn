stock GetNextPlayerID(playerid, id)
{
    for(new i = (id + 1), j = GetPlayerPoolSize(); i <= j; i ++)
    {
        if(!IsPlayerConnected(i) || i == playerid || (PlayerData[i][char_admin_level] > 6 && PlayerData[playerid][char_admin_level] < 7) || !PlayerData[playerid][char_logged])
        {
            continue;
        }

        return i;
    }
    return INVALID_PLAYER_ID;
}
