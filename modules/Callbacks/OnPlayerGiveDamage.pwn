public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	switch(weaponid)
	{
	    case 0..1:
		{
			new Float:ilosc = PlayerData[playerid][char_strength] * 0.0002;

            PlayerData[damagedid][char_last_damaged_weapon] = 0;

			GivePlayerHealth(damagedid, -ilosc);

			new str[128];
			format(str, sizeof(str), "%s gives damage to %s for %.1f (weapon: %d, ping: %d) HP: %.1f", PlayerData[playerid][char_name], PlayerData[damagedid][char_name], ilosc, weaponid, GetPlayerPing(playerid), PlayerData[damagedid][char_health]);
			Log("dmg", str);
		}
	    case 24:
		{
			PlayerData[damagedid][char_last_damaged_weapon] = 24;
			GivePlayerHealth(damagedid, -25.0);

			new str[128];
			format(str, sizeof(str), "%s gives damage to %s for %.1f (weapon: %d, ping: %d) HP: %.1f", PlayerData[playerid][char_name], PlayerData[damagedid][char_name], 25.0, weaponid, GetPlayerPing(playerid), PlayerData[damagedid][char_health]);
			Log("dmg", str);
		}
	    case 31:
		{
			PlayerData[damagedid][char_last_damaged_weapon] = 31;
			GivePlayerHealth(damagedid, -5.0);

			new str[128];
			format(str, sizeof(str), "%s gives damage to %s for %.1f (weapon: %d, ping: %d) HP: %.1f", PlayerData[playerid][char_name], PlayerData[damagedid][char_name], 5.0, weaponid, GetPlayerPing(playerid), PlayerData[damagedid][char_health]);
			Log("dmg", str);
		}
	    case 38:
		{
		    PlayerData[damagedid][char_last_damaged_weapon] = 38;
			GivePlayerHealth(damagedid, -50.0);

			new str[128];
			format(str, sizeof(str), "%s gives damage to %s for %.1f (weapon: %d, ping: %d) HP: %.1f", PlayerData[playerid][char_name], PlayerData[damagedid][char_name], 50.0, weaponid, GetPlayerPing(playerid), PlayerData[damagedid][char_health]);
			Log("dmg", str);
		}
	}

	switch(bodypart)
	{
	    case 0..2: { }
	    case 3: //Torso
	    {
	        //kod
	    }
	    case 4: //Groin
		{
		    //kod
		}
		case 5..6: //Left arm, right arm
		{
		    PlayerData[damagedid][char_body_part_damaged][2] = 30;
		    PlayerData[damagedid][char_body_part_damaged][3] = 30;
		}
		case 7..8: //Left leg, right leg
		{
		    PlayerData[damagedid][char_body_part_damaged][4] = 30;
			PlayerData[damagedid][char_body_part_damaged][5] = 30;
		}
		case 9: //Head
		{
		    //kod
		}
	}
	return 1;
}
