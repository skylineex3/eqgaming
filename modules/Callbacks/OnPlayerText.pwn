public OnPlayerText(playerid, text[])
{
	if(PlayerData[playerid][char_bw] > 0)
	{
	    Info(playerid, "W tej chwili nie mo¿esz korzystaæ z czatów InCharacter.");
	    return 0;
	}

   	new
	   	string[250],
	   	pytajniki = 0,
	   	kropki = 0,
	    wykrzykniki = 0,
		gwiazdki = 0,
		asterisk = -1,
		skip = 0
	;

	if(text[0] == '.')
	{
	    if(PlayerData[playerid][char_block_ooc] != 0)
	    {
	        Info(playerid, "Posiadasz aktywn¹ blokadê czatów OOC.");
	        return 0;
		}

		format(string, sizeof(string), "(( %s [%d]: %s ))", PlayerName(playerid), playerid, text[1]);
 		SendWrappedMessageToPlayerRange(playerid, COLOR_SAY_FADE1, COLOR_SAY_FADE2, COLOR_SAY_FADE3, COLOR_SAY_FADE4, COLOR_SAY_FADE5, string, 10, MAX_LINE);
 		return 0;
	}

    if(text[0] == '?')
	{
		cmd_me(playerid, "robi pyt¹jac¹ minê.");
	    return 0;
	}

	if(text[0] == '*')
	{
	    strdel(text, 0, 1);
	    cmd_me(playerid, text);
	    return 0;
	}

	for (new t=0; t!=strlen(text); t++)
		string[t] = text[t];

 	ReplaceEmoticionsToText(string);

	for(new i = 0; i!=strlen(string); i++)
	{
		if(string[i] == '!') wykrzykniki++;
		if(string[i] == '*') gwiazdki++;
	 	if(string[i] == '.') kropki++;
		if(string[i] == '?') pytajniki++;

		if(string[i] == '*')
		{
			if(asterisk == -1)
			{
				strins(string, "{C2A2DA}", i);
				asterisk = i;
				skip++;
			}
			else
			{
				asterisk = -1;
				if(skip%2 == 0)
				{
					strins(string, "{E6E6E6}", i+1);
				}
			}
		}
	}

    // Pierwsza litera zawsze z duzej litery.
	string[0] = toupper(string[0]);

	if(wykrzykniki >= 2)
	{
		format(string, sizeof string, "%s krzyczy: %s%s", PlayerName(playerid), string, ((kropki+pytajniki+wykrzykniki == 0 ? (".") : (""))) );
		SendWrappedMessageToPlayerRange(playerid, COLOR_SAY_FADE1, COLOR_SAY_FADE2, COLOR_SAY_FADE3, COLOR_SAY_FADE4, COLOR_SAY_FADE5, string, 10, MAX_LINE);
	}
	else
	{
		format(string, sizeof string, "%s mówi: %s%s", PlayerName(playerid), string, ((kropki+pytajniki+wykrzykniki == 0 ? (".") : (""))) );
		SendWrappedMessageToPlayerRange(playerid, COLOR_SAY_FADE1, COLOR_SAY_FADE2, COLOR_SAY_FADE3, COLOR_SAY_FADE4, COLOR_SAY_FADE5, string, 10, MAX_LINE);
	}
	return 0;
}
