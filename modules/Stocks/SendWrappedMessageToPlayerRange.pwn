stock SendWrappedMessageToPlayerRange(playerid, colour, colour1, colour2, colour3, colour4, msg[], range = 20, maxlength = 120, bool:echo = false)
{
	new length = strlen(msg), gwiazdki;
	if(length <= maxlength)
	{
		SendClientMessageEx(range, playerid, msg, colour, colour1, colour2, colour3, colour4, echo);
		return 1;
	}
	new string[150], idx;
	for(new i, space, plen; i < length; i++)
	{
		if(i - idx + plen >= maxlength)
		{
			if(idx == space || i - space >= 25)
			{
				strmid(string, msg, idx, i);
				idx = i;
			}
			else
			{
				strmid(string, msg, idx, space);
				idx = space + 1;
			}
			format(string, sizeof(string), "%s", string);

			for(new g = 0; g!=strlen(string); g++)
				if(string[g] == '*') gwiazdki++;

			toupper(string[0]);
			SendClientMessageEx(range, playerid, string, colour, colour1, colour2, colour3, colour4, echo);
		}
		else if(msg[i] == ' ')
		{
			space = i;
		}
	}
	if(idx < length)
	{
		strmid(string, msg, idx, length);
		if(gwiazdki%2)
		{
			strins(string, "{C2A2DA}", 0);
		}
		SendClientMessageEx(range, playerid, string, colour, colour1, colour2, colour3, colour4, echo);
	}
	return 1;
}
