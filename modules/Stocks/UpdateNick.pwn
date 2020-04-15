stock UpdateNick(playerid)
{
    new reason[64], weapname[32];
    if(PlayerData[playerid][char_last_damaged_weapon] == -1)
    {
    	reason = "upadek";
	}
 	else if(PlayerData[playerid][char_last_damaged_weapon] == 0)
  	{
   		if(PlayerData[playerid][char_sex] == SEX_MALE) reason = "pobity";
     	else reason = "pobita";
	}
	else
	{
 		GetWeaponName(PlayerData[playerid][char_last_damaged_weapon], weapname, sizeof(weapname));
   		reason = weapname;
	}

    if(IsPlayerAdmin(playerid) || PlayerData[playerid][char_admin_level] > 6)
	{
     	if(PlayerData[playerid][char_premium] > gettime())
     	{
 			if(PlayerData[playerid][char_bw] != 0)
   			{
				new strr[128];
 				format(strr, sizeof(strr), "(( %d. %s ))\n{FFD700}( %dj, %s - %s )", playerid, PlayerName(playerid), PlayerData[playerid][char_strength], (PlayerData[playerid][char_sex] == SEX_MALE) ? ("nieprzytomny") : ("nieprzytomna"), reason);
   				UpdateDynamic3DTextLabelText(PlayerData[playerid][char_name_tag], 0xA9C4E4FF, strr);
			}
			else
			{
  				new strr[128];
   				format(strr, sizeof(strr), "(( %d. %s ))\n{FFD700}( %dj )", playerid, PlayerName(playerid), PlayerData[playerid][char_strength]);
     			UpdateDynamic3DTextLabelText(PlayerData[playerid][char_name_tag], 0xA9C4E4FF, strr);
			}
		}
		else
		{
		    if(PlayerData[playerid][char_bw] != 0)
   			{
				new strr[128];
 				format(strr, sizeof(strr), "(( %d. %s ))\n( %dj, %s - %s )", playerid, PlayerName(playerid), PlayerData[playerid][char_strength], (PlayerData[playerid][char_sex] == SEX_MALE) ? ("nieprzytomny") : ("nieprzytomna"), reason);
   				UpdateDynamic3DTextLabelText(PlayerData[playerid][char_name_tag], 0xA9C4E4FF, strr);
			}
			else
			{
  				new strr[128];
   				format(strr, sizeof(strr), "(( %d. %s ))\n( %dj )", playerid, PlayerName(playerid), PlayerData[playerid][char_strength]);
     			UpdateDynamic3DTextLabelText(PlayerData[playerid][char_name_tag], 0xA9C4E4FF, strr);
			}
		}
	}
	else
	{
	    if(PlayerData[playerid][char_premium] > gettime())
	    {
 			if(PlayerData[playerid][char_bw] != 0)
   			{
				new strr[128];
  				format(strr, sizeof(strr), "(( %d. %s ))\n( %dj, %s - %s )", playerid, PlayerName(playerid), PlayerData[playerid][char_strength], (PlayerData[playerid][char_sex] == SEX_MALE) ? ("nieprzytomny") : ("nieprzytomna"), reason);
    			UpdateDynamic3DTextLabelText(PlayerData[playerid][char_name_tag], 0xFFD70080, strr);
			}
			else
			{
  				new strr[128];
    			format(strr, sizeof(strr), "(( %d. %s ))\n( %dj )", playerid, PlayerName(playerid), PlayerData[playerid][char_strength]);
	    		UpdateDynamic3DTextLabelText(PlayerData[playerid][char_name_tag], 0xFFD70080, strr);
			}
		}
		else
		{
		    if(PlayerData[playerid][char_bw] != 0)
   			{
				new strr[128];
  				format(strr, sizeof(strr), "(( %d. %s ))\n( %dj, %s - %s )", playerid, PlayerName(playerid), PlayerData[playerid][char_strength], (PlayerData[playerid][char_sex] == SEX_MALE) ? ("nieprzytomny") : ("nieprzytomna"), reason);
    			UpdateDynamic3DTextLabelText(PlayerData[playerid][char_name_tag], 0xFFFFFF80, strr);
			}
			else
			{
  				new strr[128];
    			format(strr, sizeof(strr), "(( %d. %s ))\n( %dj )", playerid, PlayerName(playerid), PlayerData[playerid][char_strength]);
	    		UpdateDynamic3DTextLabelText(PlayerData[playerid][char_name_tag], 0xFFFFFF80, strr);
			}
		}
	}
	return 1;
}
