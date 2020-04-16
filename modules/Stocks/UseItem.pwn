stock UseItem(playerid, uid)
{
	if(Item[uid][Type] == 0)
	{
	    Tip(playerid, "Ten przedmiot nie posiada �adnej funkcji skryptowej.");
	}
    else if(Item[uid][Type] == 1)
	{
	    for(new i=0; i<MAX_ITEMS; i++)
    	{
    	    if(Item[i][Type] == Item[uid][Type] && Item[i][Owner] == PlayerData[playerid][char_uid])
    	    {
    			if(!Item[uid][Active] && Item[i][Active])
				{
  					Tip(playerid, "Mo�esz mie� tylko jedn� bro� aktywn�.");
	    			return 1;
				}
			}
		}

 		if(Item[uid][Active])
   		{
     		new weapid, ammo;
       		GetPlayerWeaponData(playerid, GetWeaponSlot(Item[uid][Var][0]), weapid, ammo);
	        Item[uid][Var][1] = ammo;

			ResetPlayerWeapons(playerid);
			Item[uid][Active] = false;

			new string[64];
			format(string, sizeof(string), "chowa przedmiot %s.", Item[uid][Name]);
			cmd_me(playerid, string);
		}
		else
		{
 			GivePlayerWeapon(playerid, Item[uid][Var][0], Item[uid][Var][1]);
   			Item[uid][Active] = true;

   			new string[64];
			format(string, sizeof(string), "wyjmuje przedmiot %s.", Item[uid][Name]);
			cmd_me(playerid, string);
		}
	}
	else if(Item[uid][Type] == 2)
	{
        new string[64];
		format(string, sizeof(string), "realizuje kupon %s na %d$.", Item[uid][Name], Item[uid][Var][0]);
		cmd_me(playerid, string);

		new DB_Query[256];
		format(DB_Query, sizeof(DB_Query), "UPDATE `rp_items` SET `item_owner` = 0 WHERE `item_uid` = %d LIMIT 1", uid);
		mysql_query(DB_Query);

		PlayerData[playerid][char_cash] += Item[uid][Var][0];
		Item[uid][UID] = -1;
		Item[uid][Owner] = 0;
	}
	else if(Item[uid][Type] == 3)
	{
	    new bool:found = false;
	    for(new i=1; i<MAX_ITEMS; i++)
	    {
	        if(Item[i][Type] == 6 && Item[i][Active] && Item[i][Owner] == PlayerData[playerid][char_uid])
			{
				found = true;
				break;
			}
			else
			{
			    found = false;
			}
		}

	    if(!Item[uid][Active])
	    {
	        if(!found) return InfoTD(playerid, "Nie posiadasz przy sobie przedmiotu MP4 lub nie jest wlaczone."), PlayerData[playerid][char_info_timer] = 5;
	    	PlayAudioStreamForPlayer(playerid, Item[uid][Desc]);
	    	Item[uid][Active] = true;
		}
		else
		{
		    StopAudioStreamForPlayer(playerid);
		    Item[uid][Active] = false;
		}
	}
	else if(Item[uid][Type] == 4)
	{
	    FreeID[playerid] = uid;
	    ShowPlayerDialog(playerid, D_ITEM_DISC, DIALOG_STYLE_INPUT, "Tworzenie p�yty � Nazwa", "Wprowad� nazw� p�yty aby przej�� dalej (Bez 'P�yta CD:'):", "Zatwierd�", "Zamknij");
	}
	else if(Item[uid][Type] == 5)
	{
		PlayerData[playerid][char_health] += Item[uid][Var][0];

		new DB_Query[128];
		format(DB_Query, sizeof(DB_Query), "UPDATE `rp_items` SET `item_owner` = 0 WHERE `item_uid` = %d LIMIT 1", uid);
		mysql_query(DB_Query);

		new string[64];
		format(string, sizeof(string), "spo�ywa %s.", Item[uid][Name]);
		cmd_me(playerid, string);

		Item[uid][UID] = -1;
		Item[uid][Owner] = 0;
	}
	else if(Item[uid][Type] == 6)
	{
	    if(Item[uid][Active])
	    {
	        Item[uid][Active] = false;
	        InfoTD(playerid, "~w~MP4 zostalo ~r~wylaczone~w~.");
	        PlayerData[playerid][char_info_timer] = 5;
		}
		else
		{
		    Item[uid][Active] = true;
		    InfoTD(playerid, "~w~MP4 zostalo ~g~wlaczone~w~.");
		    PlayerData[playerid][char_info_timer] = 5;
		}
	}
	else if(Item[uid][Type] == 7)
	{
		PlayerData[playerid][char_premium] += Item[uid][Var][0] * 24 * 60 * 60;

	    Item[uid][Owner] = 0;

	    new DB_Query[128];
		format(DB_Query, sizeof(DB_Query), "DELETE FROM `rp_items` WHERE `item_uid` = %d LIMIT 1", uid);
		mysql_query(DB_Query);

	    SaveCharacter(playerid);
	    SaveItem(playerid);
	    TryLogin(playerid);
	}
	return 1;
}
