public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == D_LOGIN)
	{
	    if(!response)
	    {
			ShowLoginDialog(playerid, 3);
		}
		else
		{
		    new names[24];
		    GetPlayerName(playerid, names, sizeof(names));

		    new DB_Query[1000], data[1000], password[64], salt[11];
			format(DB_Query, sizeof(DB_Query), "SELECT `members_pass_hash`, `members_pass_salt` FROM `members` WHERE `member_id` = %d LIMIT 1", PlayerData[playerid][char_guid]);
			mysql_query(DB_Query);

			mysql_store_result();

			if(mysql_fetch_row_format(data, "|"))
			{
			    sscanf(data, "p<|>s[64]s[11]", password, salt);
			}

			mysql_free_result();

		    if(!strcmp(HashPassword(inputtext, salt), password, true) && strlen(inputtext) != 0)
		    {
		        format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_chars` WHERE `char_name` = '%s' LIMIT 1", names);
				mysql_query(DB_Query);

		        mysql_store_result();

				if(mysql_fetch_row_format(data, "|"))
				{
				    sscanf(data, "p<|>dds[24]dfffffdddddddddddddddddddddddddd",
						PlayerData[playerid][char_uid],
						PlayerData[playerid][char_guid],
						PlayerData[playerid][char_name],
						PlayerData[playerid][char_admin_level],
						PlayerData[playerid][char_health],
						PlayerData[playerid][char_last_pos][0],
						PlayerData[playerid][char_last_pos][1],
						PlayerData[playerid][char_last_pos][2],
						PlayerData[playerid][char_last_pos][3],
						PlayerData[playerid][char_interior],
						PlayerData[playerid][char_virtual_world],
						PlayerData[playerid][char_cash],
						PlayerData[playerid][char_bank],
						PlayerData[playerid][char_skin],
						PlayerData[playerid][char_strength],
						PlayerData[playerid][char_sex],
						PlayerData[playerid][char_bw],
						PlayerData[playerid][char_premium],
						PlayerData[playerid][char_online],
						PlayerData[playerid][char_score],
						PlayerData[playerid][char_last_damaged_weapon],
						PlayerData[playerid][char_body_part_damaged][0],
						PlayerData[playerid][char_body_part_damaged][1],
						PlayerData[playerid][char_body_part_damaged][2],
						PlayerData[playerid][char_body_part_damaged][3],
						PlayerData[playerid][char_body_part_damaged][4],
						PlayerData[playerid][char_body_part_damaged][5],
						PlayerData[playerid][char_body_part_damaged][6],
						PlayerData[playerid][char_debt],
						PlayerData[playerid][char_bank_number],
						PlayerData[playerid][char_weight],
						PlayerData[playerid][char_height],
						PlayerData[playerid][char_age],
						PlayerData[playerid][char_ingame],
						PlayerData[playerid][char_lastonline]);
				}
				mysql_free_result();
				PlayerData[playerid][char_bank_number] += PlayerData[playerid][char_uid];

				SetPlayerName(playerid, PlayerData[playerid][char_name]);

				PlayerData[playerid][char_logged] = true;
				PlayerData[playerid][char_ingame] = 1;

				if(PlayerData[playerid][char_premium] > gettime())
				{
					new String[128];
					format(String, sizeof(String), "Witaj, %s (GUID: %d, UID: %d, ID: %d). {FFD700}Posiadasz konto premium. Ekipa Forgame ¿yczy mi³ej gry!", PlayerName(playerid), PlayerData[playerid][char_guid], PlayerData[playerid][char_uid], playerid);
    				SendClientMessage(playerid, 0xC32F1AFF, String);

    				SetPlayerColor(playerid, 0xFFD700FF);

    				UpdateNick(playerid);
				}
				else
				{
				    new String[128];
					format(String, sizeof(String), "Witaj, %s (GUID: %d, UID: %d, ID: %d). Ekipa Forgame ¿yczy mi³ej gry!", PlayerName(playerid), PlayerData[playerid][char_guid], PlayerData[playerid][char_uid], playerid);
    				SendClientMessage(playerid, 0xC32F1AFF, String);

    				SetPlayerColor(playerid, 0xFFFFFF00);

    				UpdateNick(playerid);
				}

				format(DB_Query, sizeof(DB_Query), "UPDATE `rp_chars` SET `char_ingame` = 1 WHERE `global_id` = %d LIMIT 1", PlayerData[playerid][char_guid]);
				mysql_query(DB_Query);

				SetSpawnInfo(playerid, 255, PlayerData[playerid][char_skin], PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2], PlayerData[playerid][char_last_pos][3], 0, 0, 0, 0, 0, 0);
                TogglePlayerSpectating(playerid, 0);
				TogglePlayerControllable(playerid, 1);
			}
			else
			{
			    ShowLoginDialog(playerid, 1);
		        GameTextForPlayer(playerid, "~r~BLEDNE HASLO!", 5000, 4);
				return 1;
			}
		}
	}
	if(dialogid == D_LOGIN_CN)
	{
	    if(response)
	    {
	        if(strlen(inputtext) == 0)
				return ShowLoginDialog(playerid, 2);

			new name[24];
			format(name, sizeof(name), "%s", inputtext);
			strreplace(name, " ", "_");
	        SetPlayerName(playerid, name);

	        new DB_Query[128];
			format(DB_Query, sizeof(DB_Query), "SELECT `global_id` FROM `rp_chars` WHERE `char_name` = '%s' LIMIT 1", name);
			mysql_query(DB_Query);

			mysql_store_result();

			if(mysql_num_rows() != 0)
			{
				PlayerData[playerid][char_guid] = mysql_fetch_int();
				ShowLoginDialog(playerid, 1);
			}
			else
			{
	    		ShowLoginDialog(playerid, 2);
			}

			mysql_free_result();
		}
		else
		{
		    Kick(playerid);
		}
	}
	if(dialogid == D_ITEMS)
	{
		if(response)
		{
			switch(listitem)
			{
			    case 0:{ return cmd_p(playerid, ""); }
			    case 1:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 2:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 3:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 4:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 5:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 6:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 7:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 8:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 9:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 10:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 11:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 12:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 13:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 14:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 15:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 16:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 17:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 18:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 19:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 20:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
			}
		}
		else if(!response)
		{
			switch(listitem)
			{
			    case 0:{ /*nothing*/ }
			    case 1:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 2:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 3:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 4:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 5:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 6:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 7:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 8:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 9:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 10:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 11:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 12:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 13:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 14:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 15:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 16:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 17:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 18:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 19:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 20:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
			}
		}
	}

	if(dialogid == D_ITEM_OPTIONS)
	{
		if(!response)
		{
		    return cmd_p(playerid, "");
		}
		else
		{
		    switch(listitem)
		    {
		        case 0:
		        {
		            new uid = FreeID[playerid];

		            if(Item[uid][Active]) return Info(playerid, "Ten przedmiot nie mo¿e byæ aktywny.");

		            if(IsPlayerInAnyVehicle(playerid))
		            {
		                Item[uid][Owner] = 0;
		                Item[uid][in_vehicle] = GetVehicleUID(GetPlayerVehicleID(playerid));

						FreeID[playerid] = -1;

						cmd_me(playerid, "odk³ada jakiœ przedmiot w pojeŸdzie.");
						return 1;
					}

		            new Float:X, Float:Y, Float:Z;
		            GetPlayerPos(playerid, X, Y, Z);

		            Item[uid][Owner] = 0;
		            Item[uid][item_pos][0] = X;
		            Item[uid][item_pos][1] = Y;
		            Item[uid][item_pos][2] = Z;

		            FreeID[playerid] = -1;

		            cmd_me(playerid, "odk³ada jakiœ przedmiot.");
				}
			}
		}
	}

	if(dialogid == D_NEAREST_ITEMS)
	{
	    if(response)
	    {
			new uid = strval(inputtext[0]);

			if(Item[uid][Owner] != 0 && Item[uid][Owner] != PlayerData[playerid][char_uid]) return Info(playerid, "Nie mo¿esz podnieœæ tego przedmiotu.");

			if(Item[uid][in_vehicle] != 0 && IsPlayerInAnyVehicle(playerid))
			{
   				Item[uid][Owner] = PlayerData[playerid][char_uid];
			    Item[uid][in_vehicle] = 0;

			    cmd_me(playerid, "podnosi jakiœ przedmiot ze schowka w pojeŸdzie.");
			    return 1;
			}

			Item[uid][Owner] = PlayerData[playerid][char_uid];
			Item[uid][item_pos][0] = 0;
			Item[uid][item_pos][1] = 0;
			Item[uid][item_pos][2] = 0;

			cmd_me(playerid, "podnosi jakiœ przedmiot z ziemi.");
		}
	}

	if(dialogid == D_CREATE_ITEM)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0:{ ShowPlayerDialog(playerid, D_CT_CHANGE_NAME, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana nazwy", "Podaj now¹ nazwê przedmiotu:", "Zmieñ", "Cofnij"); }
			    case 1:{ ShowPlayerDialog(playerid, D_CT_CHANGE_TYPE, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana typu", "Podaj typ przedmiotu:", "Zmieñ", "Cofnij"); }
			    case 2:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_1, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (1)", "Podaj now¹ wartoœæ (1):", "Zmieñ", "Cofnij"); }
			    case 3:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_2, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (2)", "Podaj now¹ wartoœæ (2):", "Zmieñ", "Cofnij"); }
			    case 4:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_3, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (3)", "Podaj now¹ wartoœæ (3):", "Zmieñ", "Cofnij"); }
			    case 5:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_4, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (4)", "Podaj now¹ wartoœæ (4):", "Zmieñ", "Cofnij"); }
			    case 6:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_5, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (5)", "Podaj now¹ wartoœæ (5):", "Zmieñ", "Cofnij"); }
			    case 7:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_6, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (6)", "Podaj now¹ wartoœæ (6):", "Zmieñ", "Cofnij"); }
				case 8:{ ShowPlayerDialog(playerid, D_CT_CHANGE_OWNER, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana ownera", "Podaj UID postaci aby nadaæ ownera:", "Zmieñ", "Cofnij"); }
				case 9:
				{
				    new uid = FreeID[playerid];
				    Item[uid][UID] = uid;

					new DB_Query[500];
					format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_items` (item_name, item_owner, item_type, item_var1, item_var2, item_var3, item_var4, item_var5, item_var6) VALUES ('%s', %d, %d, %d, %d, %d, %d, %d, %d)",
						Item[uid][Name], Item[uid][Owner], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5]);
					mysql_query(DB_Query);

				    FreeID[playerid] = -1;

				    Tip(playerid, "Przedmiot zosta³ utworzony.");
				}
			}
		}
	}

	if(dialogid == D_CT_CHANGE_NAME)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    format(Item[uid][Name], 64, "%s", inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_TYPE)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Type] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_1)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][0] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_2)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][1] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_3)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][2] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_4)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][3] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_5)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][4] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_6)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][5] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_OWNER)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Owner] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLES)
	{
	    if(response)
	    {
			new uid = strval(inputtext[0]);
			if(Vehicle[uid][veh_spawned])
			{
			    if(IsVehicleOccupied(Vehicle[uid][samp_id]))
			        return GameTextForPlayer(playerid, "~r~NIE MOZESZ TEGO TERAZ ZROBIC!", 3000, 4);

			    DestroyVehicle(Vehicle[uid][samp_id]);
			    Vehicle[uid][veh_spawned] = false;
			    SaveVehicle(uid);
			    //Vehicle[uid][veh_pos][0] = 0.0;
			    //Vehicle[uid][veh_pos][1] = 0.0;
			    //Vehicle[uid][veh_pos][2] = 0.0;
			    return cmd_v(playerid, "");
			}
			else
			{
			    new bool:found = false;
			    for(new i=0; i<MAX_VEHICLES; i++)
			    {
			        new uid2 = GetVehicleUID(i);
			        if(GetVehicleDistanceFromPoint(i, Vehicle[uid2][veh_pos][0], Vehicle[uid2][veh_pos][1], Vehicle[uid2][veh_pos][2]) <= 3.0 && Vehicle[uid2][veh_spawned])
			        {
						found = true;
						break;
					}
				}
				if(found) return InfoTD(playerid, "Miejsce zajete, odczekaj chwile lub uzyj /v reset."), PlayerData[playerid][char_info_timer] = 8;

                Vehicle[uid][samp_id] = CreateVehicle(Vehicle[uid][veh_model], Vehicle[uid][veh_pos][0], Vehicle[uid][veh_pos][1], Vehicle[uid][veh_pos][2], Vehicle[uid][veh_pos][3], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], -1, 0);
				ChangeVehiclePaintjob(Vehicle[uid][samp_id], Vehicle[uid][veh_paintjob]);
				SetVehicleHealth(Vehicle[uid][samp_id], Vehicle[uid][veh_health]);
				Vehicle[uid][veh_spawned] = true;
				Vehicle[uid][veh_locked] = true;

				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, doors, bonnet, boot, objective);

				SetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, 1, bonnet, boot, objective);

				UpdateVehicleDamageStatus(Vehicle[uid][samp_id], Vehicle[uid][veh_panels], Vehicle[uid][veh_doors], Vehicle[uid][veh_lights], Vehicle[uid][veh_tires]);

				return cmd_v(playerid, "");
			}
		}
	}

	if(dialogid == D_CREATE_VEHICLE)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:{ ShowPlayerDialog(playerid, D_VEHICLE_CN, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana pojazdu", "Podaj now¹ nazwê pojazdu:", "Zmieñ", "Cofnij"); }
	            case 1:{ ShowPlayerDialog(playerid, D_VEHICLE_CHP, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana HP", "Podaj now¹ wartoœæ HP pojazdu:", "Zmieñ", "Cofnij"); }
	            case 2:{ ShowPlayerDialog(playerid, D_VEHICLE_CK1, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana koloru (1)", "Podaj nowy kolor pojazdu (1):", "Zmieñ", "Cofnij"); }
	            case 3:{ ShowPlayerDialog(playerid, D_VEHICLE_CK2, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana koloru (2)", "Podaj nowy kolor pojazdu (2):", "Zmieñ", "Cofnij"); }
	            case 4:{ ShowPlayerDialog(playerid, D_VEHICLE_CO, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana ownera", "Podaj UID postaci która ma byæ w³aœcicielem pojazdu:", "Zmieñ", "Cofnij"); }
	            case 5:
	            {
	                new uid = FreeID[playerid];
	                Vehicle[uid][veh_uid] = uid;
	                Vehicle[uid][veh_fuel] = 100.0;
	                Vehicle[uid][veh_mileage] = 0.0;
					Vehicle[uid][veh_pos][0] = 872.5438;
					Vehicle[uid][veh_pos][1] = -1259.9264;
					Vehicle[uid][veh_pos][2] = 14.9351;
					Vehicle[uid][veh_pos][3] = 349.0438;
					Vehicle[uid][veh_paintjob] = 3;

					new DB_Query[500];
					format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_vehicles` (`veh_model`, `veh_health`, `veh_pos_x`, `veh_pos_y`, `veh_pos_z`, `veh_pos_a`, `veh_color1`, `veh_color2`, `veh_tires`, `veh_doors`, `veh_panels`, `veh_lights`, `veh_world`, `veh_interior`, `veh_fuel`, `veh_mileage`, `veh_owner`) VALUES (%d, %f, 872.5438, -1259.9264, 14.9351, 349.0438, %d, %d, 0, 0, 0, 0, 0, 0, 100.0, 0.0, %d)",
						Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);
	                mysql_query(DB_Query);

	                FreeID[playerid] = -1;
	            }
			}
		}
	}

	if(dialogid == D_VEHICLE_CN)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

		if(response)
		{
		    new uid = FreeID[playerid];
		    Vehicle[uid][veh_model] = GetVehicleModelIDFromName(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_CHP)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Vehicle[uid][veh_health] = strval(inputtext);

	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_CK1)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Vehicle[uid][veh_color][0] = strval(inputtext);

	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_CK2)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Vehicle[uid][veh_color][1] = strval(inputtext);

	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_CO)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Vehicle[uid][veh_owner] = strval(inputtext);

	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_ITEM_DISC)
	{
	    if(response)
		{
			new uid = FreeID[playerid];
			format(Item[uid][Name], 64, "P³yta CD: %s", inputtext);

		    ShowPlayerDialog(playerid, D_ITEM_DISC2, DIALOG_STYLE_INPUT, "Tworzenie p³yty » Link", "WprowadŸ link do audio streama by nagraæ p³ytê:", "Stwórz", "Zamknij");
		}
	}

	if(dialogid == D_ITEM_DISC2)
	{
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Item[uid][Type] = 3;
			format(Item[uid][Desc], 256, "%s", inputtext);

			FreeID[playerid] = -1;

			Tip(playerid, "P³yta zosta³a stworzona.");
		}
	}

	if(dialogid == D_AREA)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:{ return cmd_area(playerid, ""); }
	            case 1:{ return cmd_area(playerid, ""); }
	            case 2:{ ShowPlayerDialog(playerid, D_AREA_CHANGE_OWNER, DIALOG_STYLE_INPUT, "Strefa » Zmiana w³aœciciela", "WprowadŸ UID postaci która ma byæ nowym w³aœcicielem:", "ZatwierdŸ", "Cofnij"); }
				case 3:{ ShowPlayerDialog(playerid, D_AREA_CHANGE_HOUSE_COST, DIALOG_STYLE_INPUT, "Strefa » Zmiana ceny budynku mieszkalnego", "WprowadŸ cenê (bez $) dla budynków mieszkalnych:", "ZatwierdŸ", "Cofnij"); }
				case 4:{ ShowPlayerDialog(playerid, D_AREA_CHANGE_BUISNESS_COST, DIALOG_STYLE_INPUT, "Strefa » Zmiana ceny budynku biznesowego", "WprowadŸ cenê (bez $) dla budynków biznesowych:", "ZatwierdŸ", "Cofnij"); }
				case 5:{ ShowPlayerDialog(playerid, D_AREA_CHANGE_SIZE, DIALOG_STYLE_INPUT, "Strefa » Zmiana metra¿u dla budynków", "WprowadŸ nowy metra¿ który bêdzie minimalnym metra¿em dla budynków:", "ZatwierdŸ", "Cofnij"); }
			}
		}
		else
		{
		    FreeID[playerid] = -1;
		}
	}

	if(dialogid == D_AREA_CHANGE_OWNER)
	{
	    if(!response) return cmd_area(playerid, "");
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Zone[uid][z_owner] = strval(inputtext);

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_owner` = %d WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_owner], uid);
			mysql_query(DB_Query);

			cmd_area(playerid, "");
		}
	}

	if(dialogid == D_AREA_CHANGE_HOUSE_COST)
	{
	    if(!response) return cmd_area(playerid, "");
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Zone[uid][z_house_cost] = strval(inputtext);

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_house_cost` = %d WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_house_cost], uid);
			mysql_query(DB_Query);

			cmd_area(playerid, "");
		}
	}

	if(dialogid == D_AREA_CHANGE_BUISNESS_COST)
	{
	    if(!response) return cmd_area(playerid, "");
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Zone[uid][z_buis_cost] = strval(inputtext);

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_buis_cost` = %d WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_buis_cost], uid);
			mysql_query(DB_Query);

			cmd_area(playerid, "");
		}
	}

	if(dialogid == D_AREA_CHANGE_SIZE)
	{
	    if(!response) return cmd_area(playerid, "");
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Zone[uid][z_size] = strval(inputtext);

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_size` = %d WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_size], uid);
			mysql_query(DB_Query);

			cmd_area(playerid, "");
		}
	}

	if(dialogid == D_BANK)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0:
			    {
			        new StrinG[500];
					format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    	ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
				}
				case 1:{ ShowPlayerDialog(playerid, D_BANK_WPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wp³aciæ na swoje konto bankowe:", "ZatwierdŸ", "Cofnij"); }
				case 2:
				{
				    if(PlayerData[playerid][char_debt] != 0)
				    {
				        Tip(playerid, "Konto zablokowane. Najpierw sp³aæ swoje nale¿noœci!");
				        new StrinG[500];
						format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    		ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
						return 1;
					}
					ShowPlayerDialog(playerid, D_BANK_WYPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wyp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wyp³aciæ z bankomatu:", "ZatwierdŸ", "Cofnij");
				}
				case 3:
				{
				    if(PlayerData[playerid][char_debt] != 0)
				    {
				        Tip(playerid, "Konto zablokowane. Najpierw sp³aæ swoje nale¿noœci!");
				        new StrinG[500];
						format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    		ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
						return 1;
					}
					ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
				}
				case 4:
				{
				    if(PlayerData[playerid][char_debt] == 0)
				    {
				        Tip(playerid, "Nie posiadasz ¿adnych nale¿noœci.");
				        new StrinG[500];
						format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    		ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
						return 1;
					}
					ShowPlayerDialog(playerid, D_BANK_DEBT, DIALOG_STYLE_LIST, "Bankomat » Sp³ata nale¿noœci", "test", "ZatwierdŸ", "Cofnij");
				}
			}
		}
	}

	if(dialogid == D_BANK_WPLAC)
	{
	    if(response)
	    {
	        if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, D_BANK_WPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wp³aciæ na swoje konto bankowe:", "ZatwierdŸ", "Cofnij");
	        if(PlayerData[playerid][char_cash] < strval(inputtext))
	        {
	            Tip(playerid, "Nie posiadasz wystarczaj¹cej iloœci gotówki przy sobie.");

	            ShowPlayerDialog(playerid, D_BANK_WPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wp³aciæ na swoje konto bankowe:", "ZatwierdŸ", "Cofnij");
	            return 1;
			}

			if(strval(inputtext) < 0 || strval(inputtext) > 1500000)
			{
			    Tip(playerid, "Wpisano niepoprawn¹ kwotê.");

			    ShowPlayerDialog(playerid, D_BANK_WPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wp³aciæ na swoje konto bankowe:", "ZatwierdŸ", "Cofnij");
			    return 1;
			}

	        PlayerData[playerid][char_cash] -= strval(inputtext);
	        PlayerData[playerid][char_bank] += strval(inputtext);

	        new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
		else
		{
		    new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
	}

	if(dialogid == D_BANK_WYPLAC)
	{
	    if(response)
	    {
	        if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, D_BANK_WYPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wyp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wyp³aciæ z bankomatu:", "ZatwierdŸ", "Cofnij");
            if(PlayerData[playerid][char_bank] < strval(inputtext))
	        {
	            Tip(playerid, "Nie posiadasz wystarczaj¹cej iloœci gotówki na koncie.");

	            ShowPlayerDialog(playerid, D_BANK_WYPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wyp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wyp³aciæ z bankomatu:", "ZatwierdŸ", "Cofnij");
	            return 1;
			}

			if(strval(inputtext) < 0 || strval(inputtext) > 1500000)
			{
			    Tip(playerid, "Wpisano niepoprawn¹ kwotê.");

			    ShowPlayerDialog(playerid, D_BANK_WYPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wyp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wyp³aciæ z bankomatu:", "ZatwierdŸ", "Cofnij");
			    return 1;
			}

	        PlayerData[playerid][char_cash] += strval(inputtext);
	        PlayerData[playerid][char_bank] -= strval(inputtext);

	        new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
		else
		{
		    new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
	}

	if(dialogid == D_BANK_PRZELEW)
	{
	    if(response)
	    {
	        new acnum, amount;
			if(sscanf(inputtext, "p< >dd", acnum, amount))
			{
			    ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
			    return 1;
			}
			else
			{
	        	new player = INVALID_PLAYER_ID;
	        	for(new i=0; i<GetMaxPlayers(); i++)
	        	{
	            	if(IsPlayerConnected(i))
	            	{
	                	if(PlayerData[i][char_bank_number] == acnum)
	                	{
	                    	player = i;
	                    	break;
						}
					}
				}

				if(player == INVALID_PLAYER_ID)
				{
			    	Tip(playerid, "Podany numer konta bankowego nie istnieje.");

			    	ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
  					return 1;
				}

				if(PlayerData[playerid][char_bank] < amount)
	        	{
	            	Tip(playerid, "Nie posiadasz wystarczaj¹cej iloœci gotówki na koncie.");

	            	ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
	            	return 1;
				}

				if(amount < 0 || amount > 1500000)
				{
			    	Tip(playerid, "Wpisano niepoprawn¹ kwotê.");

			    	ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
			    	return 1;
				}

				PlayerData[playerid][char_bank] -= amount;
				PlayerData[player][char_bank] += amount;

				new str[128];
				format(str, sizeof(str), "Otrzyma³eœ przelew z numeru konta %d. Dostêpne œrodki: $%d", PlayerData[playerid][char_bank_number], PlayerData[player][char_bank]);
				Tip(player, str);

         		new StrinG[500];
				format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  				ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
			}
		}
		else
		{
		    new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
	}

	if(dialogid == D_BANK_DEBT)
	{
	    if(response)
	    {
	        //do zrobienia
	        new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
		else
		{
		    new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_INFO)
	{
	    if(response)
	    {
	        new engine, lights, alarm, doors, bonnet, boot, objective, vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	        switch(listitem)
	        {
	            case 0:
	            {
					if(bonnet == VEHICLE_PARAMS_ON)
					{
					    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);

					    new str[64];
					    format(str, sizeof(str), "zamyka maskê w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
					}
					else
					{
					    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);

					    new str[64];
					    format(str, sizeof(str), "otwiera maskê w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
					}
	            }
	            case 1:
	            {
	                if(boot == VEHICLE_PARAMS_ON)
	                {
	                    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);

					    new str[64];
					    format(str, sizeof(str), "zamyka baga¿nik w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
					}
					else
					{
						SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);

					    new str[64];
					    format(str, sizeof(str), "otwiera baga¿nik w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
					}
				}
				case 2:
				{
				    if(lights == VEHICLE_PARAMS_ON)
				    {
				        SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
					}
					else
					{
					    SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
					}
				}
				case 3:
				{
					new driver, passenger, backleft, backright;
				    GetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);
				    if(driver == 0 && passenger == 0)
				    {
				        SetVehicleParamsCarWindows(vehicleid, 1, 1, 1, 1);

				        new str[64];
					    format(str, sizeof(str), "zamyka szyby w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
				    }
				    else if(driver == 1 && passenger == 1)
				    {
				        SetVehicleParamsCarWindows(vehicleid, 0, 0, 1, 1);

				        new str[64];
					    format(str, sizeof(str), "otwiera szyby w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
				    }
				}
				case 4:
				{
				    return cmd_v(playerid, "");
				}
				case 5:
				{
				    new list_players[256];
				    for(new i=0; i<GetMaxPlayers(); i++)
				    {
				        if(IsPlayerConnected(i) && PlayerData[i][char_logged] && i != playerid)
				        {
				            if(PlayerToPlayer(5.0, playerid, i))
				            {
				            	format(list_players, sizeof(list_players), "%s\n%d\t%s", list_players, i, PlayerData[i][char_name]);
							}
						}
					}

					if(!strlen(list_players))
					    Info(playerid, "W pobli¿u Twojej postaci nie znaleziono ¿adnych graczy.");
				    else
				    	ShowPlayerDialog(playerid, D_VEHICLE_SELL, DIALOG_STYLE_LIST, "Lista osób w pobli¿u", list_players, "Wybierz", "Cofnij");
				}
				case 6:
				{
				    new list_players[256];
				    for(new i=0; i<GetMaxPlayers(); i++)
				    {
				        if(IsPlayerConnected(i) && PlayerData[i][char_logged] && i != playerid)
				        {
				            if(PlayerToPlayer(5.0, playerid, i))
				            {
				            	format(list_players, sizeof(list_players), "%s\n%d\t%s", list_players, i, PlayerData[i][char_name]);
							}
						}
					}

					if(!strlen(list_players))
					    Info(playerid, "W pobli¿u Twojej postaci nie znaleziono ¿adnych graczy.");
					else
					    ShowPlayerDialog(playerid, D_VEHICLE_GIVE, DIALOG_STYLE_LIST, "Lista osób w pobli¿u", list_players, "Wybierz", "Cofnij");
				}
			}
		}
	}

	if(dialogid == D_VEHICLE_SELL)
	{
	    if(response)
	    {
	        new vehicleid = GetPlayerVehicleID(playerid);
	        new uid = GetVehicleUID(vehicleid);
	        new id = strval(inputtext[0]);

	        new str[500];
	        format(str, sizeof(str), "Oferta sprzeda¿y pojazdu\nKupuj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\n\nWpisz kwotê za któr¹ chcesz sprzedaæ pojazd i kliknij \"Sprzedaj\".", PlayerData[id][char_name], id, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel]);

	        PlayerData[playerid][char_offer_id] = id;

			ShowPlayerDialog(playerid, D_VEHICLE_SELL2, DIALOG_STYLE_INPUT, "Sprzeda¿ pojazdu", str, "Sprzedaj", "Anuluj");
		}

		if(!response)
		{
			return cmd_v(playerid, "");
		}
	}

	if(dialogid == D_VEHICLE_SELL2)
	{
	    if(response)
	    {
	        new vehicleid = GetPlayerVehicleID(playerid);
	        new uid = GetVehicleUID(vehicleid);
	        new id = PlayerData[playerid][char_offer_id];

			GameTextForPlayer(playerid, "~g~Oferta zostala wyslana!", 5000, 4);

			new str[500];
	        format(str, sizeof(str), "Oferta kupno pojazdu\nSprzedaj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\nCena: $%d\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ kupno pojazdu.", PlayerData[playerid][char_name], playerid, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel], strval(inputtext[0]));

			ShowPlayerDialog(PlayerData[playerid][char_offer_id], D_VEHICLE_SELL3, DIALOG_STYLE_INPUT, "Kupno pojazdu", str, "Kup", "Anuluj");

			PlayerData[id][char_offer_id] = playerid;
			PlayerData[playerid][char_offer_value] = strval(inputtext[0]);
		}
	}

	if(dialogid == D_VEHICLE_SELL3)
	{
	    new id = PlayerData[playerid][char_offer_id];
	    new vehicleid = GetPlayerVehicleID(id);
    	new uid = GetVehicleUID(vehicleid);

	    if(response)
	    {
	        if(!strcmp(inputtext[0], "potwierdzam", true))
	        {
	        	if(PlayerData[playerid][char_cash] < PlayerData[id][char_offer_value])
	        	{
	        	    new str[500];
	        		format(str, sizeof(str), "Oferta kupno pojazdu\nSprzedaj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\nCena: $%d\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ kupno pojazdu.\n\n{FF0000}Nie posiadasz wystarczaj¹cej kwoty pieniêdzy przy sobie.", PlayerData[id][char_name], id, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel], PlayerData[id][char_offer_value]);

					ShowPlayerDialog(playerid, D_VEHICLE_SELL3, DIALOG_STYLE_INPUT, "Kupno pojazdu", str, "Kup", "Anuluj");
					return 1;
				}

	        	PlayerData[playerid][char_cash] -= PlayerData[id][char_offer_value];
	        	PlayerData[id][char_cash] += PlayerData[id][char_offer_value];
	        	Vehicle[uid][veh_owner] = PlayerData[playerid][char_uid];
	        	SaveVehicle(uid);

	        	GameTextForPlayer(playerid, "~g~Oferta zaakceptowana!", 5000, 4);
	        	GameTextForPlayer(id, "~g~Gracz zaakceptowal oferte!", 5000, 4);

	        	RemovePlayerFromVehicle(id);

	        	PlayerData[id][char_offer_id] = -1;
	        	PlayerData[playerid][char_offer_id] = -1;
	        	PlayerData[id][char_offer_value] = 0;
			}
			else
			{
			    new str[500];
	        	format(str, sizeof(str), "Oferta kupno pojazdu\nSprzedaj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\nCena: $%d\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ kupno pojazdu.\n\n{FF0000}Nie wpisano w okienku \"potwierdzam\".", PlayerData[id][char_name], id, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel], PlayerData[id][char_offer_value]);

				ShowPlayerDialog(playerid, D_VEHICLE_SELL3, DIALOG_STYLE_INPUT, "Kupno pojazdu", str, "Kup", "Anuluj");
			}
		}

		if(!response)
		{
		    PlayerData[playerid][char_offer_id] = -1;
			PlayerData[id][char_offer_id] = -1;
		}
	}

	if(dialogid == D_VEHICLE_GIVE)
	{
	    if(!response)
	    {
	        return cmd_v(playerid, "");
		}

		if(response)
		{
			new str[500], id = strval(inputtext[0]), vehicleid = GetPlayerVehicleID(playerid), uid = GetVehicleUID(vehicleid);
 			format(str, sizeof(str), "Oferta przekazania pojazdu\nPrzekazuj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ przekazanie pojazdu.", PlayerData[playerid][char_name], playerid, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel]);

			ShowPlayerDialog(id, D_VEHICLE_GIVE2, DIALOG_STYLE_INPUT, "Przekazanie pojazdu", str, "Odbierz", "Anuluj");

			PlayerData[id][char_offer_id] = playerid;

			GameTextForPlayer(playerid, "~g~Oferta zostala wyslana!", 5000, 4);
		}
	}

	if(dialogid == D_VEHICLE_GIVE2)
	{
	    if(response)
	    {
	        if(!strcmp(inputtext[0], "potwierdzam", true))
	        {
	            new id = PlayerData[playerid][char_offer_id];
	            new vehicleid = GetPlayerVehicleID(id);
	            new uid = GetVehicleUID(vehicleid);

	            Vehicle[uid][veh_owner] = PlayerData[playerid][char_uid];
	            SaveVehicle(uid);

	            GameTextForPlayer(playerid, "~g~Oferta zaakceptowana!", 5000, 4);
	        	GameTextForPlayer(id, "~g~Gracz zaakceptowal oferte!", 5000, 4);

	        	RemovePlayerFromVehicle(id);

	        	PlayerData[id][char_offer_id] = -1;
	        	PlayerData[playerid][char_offer_id] = -1;
			}
			else
			{
			    new str[500], vehicleid = GetPlayerVehicleID(playerid), uid = GetVehicleUID(vehicleid);
 				format(str, sizeof(str), "Oferta przekazania pojazdu\nPrzekazuj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ przekazanie pojazdu.\n\n{FF0000}Nie wpisano w okienku \"potwierdzam\".", PlayerData[playerid][char_name], playerid, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel]);

				ShowPlayerDialog(playerid, D_VEHICLE_GIVE2, DIALOG_STYLE_INPUT, "Przekazanie pojazdu", str, "Odbierz", "Anuluj");
			}
		}
	}
	return 1;
}
