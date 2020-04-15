public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success)
		InfoTD(playerid, "~w~Nie mozesz skorzystac z takiej komendy. Uzyj ~y~/pomoc~w~, jezeli szukasz pomocy."), PlayerData[playerid][char_info_timer] = 5;
	return 1;
}
