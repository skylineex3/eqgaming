CMD:news(playerid, cmdtext[])
{
    if(PlayerData[playerid][char_bw] != 0)
	{
		Info(playerid, "Nie mo¿esz teraz skorzystaæ z tej komendy.");
		return 1;
	}

	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 1) return 0;

	new czas, tresc[128];
	if(sscanf(cmdtext, "is[128]", czas, tresc)) return Tip(playerid, "Tip: /news [czas] [treœæ]");

	if(czas == 0 && !strcmp(tresc, "0", true))
	{
	    new str[144];
	    format(str, sizeof(str), "~r~~h~LS News: ~w~W tej chwili nikt nie nadaje.");
	    TextDrawSetString(LSNews[1], str);

	    NewsTimer = 0;
	}
	else
	{
	    new str[144];
	    format(str, sizeof(str), "~r~~h~LS News: ~w~%s", tresc);
	    TextDrawSetString(LSNews[1], str);

		NewsTimer = czas;
	}
	return 1;
}

CMD:drzwi(playerid, cmdtext[])
{
		new type[32], next[64];
		if(sscanf(cmdtext, "s[32]S()[64]", type, next))
		{
		    new i = GetNearestDoors(playerid, 5.0), uid = GetPlayerZone(playerid);

		    if(i != -1)
		    {
		        Tip(playerid, "Ta funkcja jest aktualnie niedostêpna.");
			}
			else
			{
			    new str[128];
			    if(uid != 0)
			    {
			        if(Zone[uid][z_house_cost] != 0 && Zone[uid][z_buis_cost] != 0)
			    		format(str, sizeof(str), "Stwórz nowy budynek (Dom: $%d/m2, min %dm2 | Biznes: $%d/m2, min %dm2)", Zone[uid][z_house_cost], Zone[uid][z_size], Zone[uid][z_buis_cost], Zone[uid][z_size]);
					else if(Zone[uid][z_house_cost] == 0 && Zone[uid][z_buis_cost] != 0)
					    format(str, sizeof(str), "Stwórz nowy budynek (Biznes: $%d/m2, min %dm2)", Zone[uid][z_buis_cost], Zone[uid][z_size]);
					else if(Zone[uid][z_house_cost] != 0 && Zone[uid][z_buis_cost] == 0)
					    format(str, sizeof(str), "Stwórz nowy budynek (Dom: $%d/m2, min %dm2)", Zone[uid][z_house_cost], Zone[uid][z_size]);
					else if(Zone[uid][z_house_cost] == 0 && Zone[uid][z_buis_cost] == 0)
					    format(str, sizeof(str), "Stwórz nowy budynek (Niemo¿liwe na tej strefie)");
				}
				else
				{
				    format(str, sizeof(str), "Stwórz nowy budynek (Niemo¿liwe na tej strefie)");
				}
				ShowPlayerDialog(playerid, D_DOORS, DIALOG_STYLE_LIST, "Tworzenie drzwi", str, "Stwórz", "Anuluj");
			}
		}
		else
		{
			if(!strcmp(type, "stworz", true))
			{
	    		new typee, name[24], doorid, Float:X, Float:Y, Float:Z, Float:A;
	    		if(sscanf(next, "is[24]", typee, name)) return SendClientMessage(playerid, 0xCCCCCCFF, "Tip: /drzwi stworz [typ 0 - wejœcie | 1 - przejœcie] [nazwa]");

				GetPlayerPos(playerid, X, Y, Z);
				GetPlayerFacingAngle(playerid, A);

				new DB_Query[500];
				format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_doors` (door_name, door_model, door_type, door_enterx, door_entery, door_enterz, door_entera, door_entervw, door_enterinterior,\
				    door_exitx, door_exity, door_exitz, door_exita, door_exitvw, door_exitinterior, door_owner, door_locked) VALUES ('%s', %d, %d, %f, %f, %f, %f, %d, %d, %f, %f, %f, %f, %d, %d, %d, %d)",
				        name, 1559, typee, X, Y, Z, A, 0, 0, X, Y, Z, A, 10000, 0, PlayerData[playerid][char_uid], 1);
				mysql_query(DB_Query);

				doorid = mysql_insert_id();

				format(DB_Query, sizeof(DB_Query), "UPDATE `rp_doors` SET `door_exitvw` = %d WHERE `door_uid` = %d LIMIT 1", 10000 + doorid, doorid);
				mysql_query(DB_Query);

		        Doors[doorid][Model] = 1559;
		        Doors[doorid][Type] = typee;
				Doors[doorid][EnterX] = X;
				Doors[doorid][EnterY] = Y;
				Doors[doorid][EnterZ] = Z;
				Doors[doorid][EnterA] = A;
				Doors[doorid][EnterVW] = 0;
				Doors[doorid][EnterInterior] = 0;
				Doors[doorid][ExitX] = X;
				Doors[doorid][ExitY] = Y;
				Doors[doorid][ExitZ] = Z;
				Doors[doorid][ExitA] = A;
				Doors[doorid][ExitInterior] = 0;
				Doors[doorid][ExitVW] = 10000 + doorid;
				Doors[doorid][Owner] = PlayerData[playerid][char_uid];
				Doors[doorid][Locked] = 1;
				format(Doors[doorid][Name], 24, "%s", name);

				Doors[doorid][samp_id] = CreateDynamicPickup(Doors[doorid][Model], 1, Doors[doorid][EnterX], Doors[doorid][EnterY], Doors[doorid][EnterZ], Doors[doorid][EnterVW]);
			}
			else if(!strcmp(type, "usun", true))
			{
			    new i = -1;
				for(new g=0; g<MAX_DOORS; g++)
				{
	    			if(IsPlayerInRangeOfPoint(playerid, 3.0, Doors[g][EnterX], Doors[g][EnterY], Doors[g][EnterZ]) || IsPlayerInRangeOfPoint(playerid, 3.0, Doors[g][ExitX], Doors[g][ExitY], Doors[g][ExitZ]))
   					{
     					i = Doors[g][UID];
					}
				}

	    		if(i != -1)
	    		{
	        		new DB_Query[128];
	        		format(DB_Query, sizeof(DB_Query), "DELETE FROM `rp_doors` WHERE `door_uid` = %d LIMIT 1", i);
	        		mysql_query(DB_Query);

	        		mysql_free_result();

					i = GetNearestDoors(playerid, 3.0);

	        		DestroyDynamicPickup(Doors[i][samp_id]);

	        		Doors[i][Model] = -1;
	        		Doors[i][Type] = 0;
	        		Doors[i][EnterX] = 0.0;
	        		Doors[i][EnterY] = 0.0;
	        		Doors[i][EnterZ] = 0.0;
	        		Doors[i][EnterA] = 0.0;
	        		Doors[i][EnterVW] = -1;
	        		Doors[i][EnterInterior] = 0;
	        		Doors[i][ExitX] = 0.0;
	        		Doors[i][ExitY] = 0.0;
	        		Doors[i][ExitZ] = 0.0;
	        		Doors[i][ExitA] = 0.0;
	        		Doors[i][ExitVW] = -1;
	        		Doors[i][ExitInterior] = 0;
	        		Doors[i][UID] = -1;
	        		Doors[i][Owner] = -1;
	        		Doors[i][Locked] = 0;
					format(Doors[i][Name], 24, " ");
				}
			}
		}
		return 1;
}

CMD:zamknij(playerid, cmdtext[])
{
    new i = GetNearestDoors(playerid, 5.0);
	if(i != -1 && Doors[i][Owner] != PlayerData[playerid][char_uid]) return Tip(playerid, "Nie posiadasz kluczy do tych drzwi.");

	if(i != -1)
	{
		if(Doors[i][Locked] == 1)
		{
			Doors[i][Locked] = 0;
 			cmd_me(playerid, "otwiera drzwi u¿ywaj¹c klucza.");

 			ApplyAnimation(playerid,"INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else
		{
			Doors[i][Locked] = 1;
 			cmd_me(playerid, "zamyka drzwi na klucz.");

 			ApplyAnimation(playerid,"INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	else
	{
	    Tip(playerid, "Nie znaleziono ¿adnych drzwi w pobli¿u.");
	}
	return 1;
}

CMD:crime(playerid, cmdtext[])
{
	new id, dzwiek;
	if(sscanf(cmdtext, "ii", id, dzwiek)) return Tip(playerid, "Tip: /crime [id] [id dŸwiêku]");

	PlayCrimeReportForPlayer(playerid, id, dzwiek);
	return 1;
}

CMD:opis(playerid, params[])
{
    if(PlayerData[playerid][char_bw] != 0)
	{
		Info(playerid, "Nie mo¿esz teraz skorzystaæ z tej komendy.");
		return 1;
	}

	new desc[128], String[256];
	if(sscanf(params, "s[128]", desc))
	{
	    Tip(playerid, "Tip: /opis [treœæ | usun - usuwa opis]");
		return 1;
	}
	if(!strcmp(desc, "usun", true))
	{
 		UpdateDynamic3DTextLabelText(Text3D:PlayerData[playerid][char_desc_text], 0xC2A2DAFF, " ");
		Info(playerid, "Opis zosta³ pomyœlnie usuniêty.");
	    return 1;
	}

	if(strlen(desc) > 128 || strlen(desc) < 24) return Info(playerid, "Treœæ opisu powinna zawieraæ od 24 do 128 znaków.");
 	EscapePL(desc);
	new givenString[128];
	format(givenString, sizeof(givenString), "%s", desc);
	if(!CheckCharacters(givenString)) return Info(playerid, "Opis, który chcesz ustawiæ zawiera niedozwolone znaki.");

	if(PlayerData[playerid][char_premium] > gettime())
	{
		strreplace(givenString, "(", "{");
		strreplace(givenString, ")", "}");
	}

	UpdateDynamic3DTextLabelText(Text3D:PlayerData[playerid][char_desc_text], 0xC2A2DAFF, WordWrap(givenString, 5));
	format(String, 256, "Twój nowy opis to: {FFFFFF}%s", givenString);
	Tip(playerid, String);

	new str[144];
 	format(str, sizeof(str), "%s new desc: %s", PlayerName(playerid), givenString);
	Log("desc", str);
	return 1;
}

CMD:stats(playerid, cmdtext[])
{
	new id;
	if(sscanf(cmdtext, "i", id))
	{
	    ShowPlayerStats(playerid, playerid);
	}
	else
	{
	    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 3) return ShowPlayerStats(playerid, playerid);
	    if(!IsPlayerConnected(id) || !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

		ShowPlayerStats(playerid, id);
	}
	return 1;
}

CMD:w(playerid, params[])
{
    if(PlayerData[playerid][char_block_ooc] != 0)
    {
    	Info(playerid, "Posiadasz aktywn¹ blokadê czatów OOC.");
     	return 0;
	}

	new id, text[128];
	if(sscanf(params, "us[128]", id, text)) return Tip(playerid, "Tip: /w [id gracza] [treœæ]");
	if(!IsPlayerConnected(id) || !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");
	if(PlayerData[id][char_block_ooc] != 0) return Tip(playerid, "Ten gracz posiada aktywn¹ blokadê czatów OOC, nie mo¿esz do niego napisaæ.");

	new str[256];
	format(str, sizeof(str), "(( %s(ID: %d): %s ))", PlayerName(playerid), playerid, text);
	SendClientMessage(id, 0xE39B2FFF, str);

	format(str, sizeof(str), "(( > %s(ID: %d): %s ))", PlayerName(id), id, text);
	SendClientMessage(playerid, 0xECBB6DFF, str);

	PlayerData[id][char_last_pm] = playerid;

	format(str, sizeof(str), "%s » %s: %s", PlayerName(playerid), PlayerName(id), text);
	Log("priv", str);
	return 1;
}

CMD:pm(playerid, cmdtext[])
	return cmd_w(playerid, cmdtext);

CMD:re(playerid, cmdtext[])
{
    if(PlayerData[playerid][char_block_ooc] != 0)
    {
    	Info(playerid, "Posiadasz aktywn¹ blokadê czatów OOC.");
     	return 0;
	}

	new text[128], id = PlayerData[playerid][char_last_pm];
	if(sscanf(cmdtext, "s[128]", text)) return Tip(playerid, "Tip: /re [treœæ]");
	if(id == -1) return Tip(playerid, "Nikt do Ciebie nie pisa³ od ostatniego logowania.");
	if(!IsPlayerConnected(id) || !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");
	if(PlayerData[id][char_block_ooc] != 0) return Tip(playerid, "Ten gracz posiada aktywn¹ blokadê czatów OOC, nie mo¿esz do niego napisaæ.");

	new str[256];
	format(str, sizeof(str), "(( %s(ID: %d): %s ))", PlayerName(playerid), playerid, text);
	SendClientMessage(id, 0xE39B2FFF, str);

	format(str, sizeof(str), "(( > %s(ID: %d): %s ))", PlayerName(id), id, text);
	SendClientMessage(playerid, 0xECBB6DFF, str);

	PlayerData[id][char_last_pm] = playerid;

	format(str, sizeof(str), "%s » %s: %s", PlayerName(playerid), PlayerName(id), text);
	Log("priv", str);
	return 1;
}

CMD:id(playerid, cmdtext[])
{
	new nick[64];
	if(sscanf(cmdtext, "s[64]", nick))
	{
	    if(GetNearestPlayer(playerid, 20.0) == INVALID_PLAYER_ID) return Info(playerid, "W pobli¿u nie ma ¿adnych graczy.");

	    new id = GetNearestPlayer(playerid, 20.0);

		new str[128];
 		format(str, sizeof(str), "Najbli¿szy gracz to: %s(ID: %d)", PlayerName(id), id);
  		Tip(playerid, str);
	}
	else
	{
		new string[128];
		string = "ID\tNick";
		format(string, sizeof(string), "%s\n%d\t%s", string, GetPlayerID(nick), PlayerName(GetPlayerID(nick)));
		if(GetPlayerID(nick) == INVALID_PLAYER_ID) format(string, sizeof(string), "ID\tNick\nNie znaleziono ¿adnych graczy.");

		ShowPlayerDialog(playerid, D_ID, DIALOG_STYLE_TABLIST_HEADERS, "Lista graczy", string, "PW", "Zamknij");
	}
	return 1;
}

CMD:pay(playerid, cmdtext[])
	return cmd_plac(playerid, cmdtext);

CMD:plac(playerid, cmdtext[])
{
    if(PlayerData[playerid][char_bw] != 0)
	{
		Info(playerid, "Nie mo¿esz teraz skorzystaæ z tej komendy.");
		return 1;
	}

	new id, cash;
	if(sscanf(cmdtext, "ii", id, cash)) return Tip(playerid, "Tip: /plac [id gracza] [iloœæ($)]");
	if(!IsPlayerConnected(id)) return Tip(playerid, "Ten gracz nie jest po³¹czony.");
	if(id == playerid) return Tip(playerid, "Nie mo¿esz sobie tej oferty zaoferowaæ.");
	if(GetNearestPlayer(playerid, 5.0) != id) return Tip(playerid, "Ten gracz nie znajdujê siê w Twoim otoczeniu.");
	if(PlayerData[playerid][char_cash] < cash) return Tip(playerid, "Nie masz przy sobie tyle gotówki.");

	PlayerData[id][char_cash] += cash;
	PlayerData[playerid][char_cash] -= cash;

	new str[64];
	format(str, sizeof(str), "podaje trochê gotówki %s.", PlayerName(id));
	cmd_me(playerid, str);

	format(str, sizeof(str), "%s pays %s cash %d$", PlayerName(playerid), PlayerName(id), cash);
	Log("pay", str);
	return 1;
}

CMD:v(playerid, cmdtext[])
{
    if(PlayerData[playerid][char_bw] != 0)
	{
		Info(playerid, "Nie mo¿esz teraz skorzystaæ z tej komendy.");
		return 1;
	}

	new type[64], next[64];
	if(sscanf(cmdtext, "s[64]S()[64]", type, next))
	{
	    if(!IsPlayerInAnyVehicle(playerid) || (IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) != 0) || (IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0 && Vehicle[GetVehicleUID(GetPlayerVehicleID(playerid))][veh_owner] != PlayerData[playerid][char_uid]))
	    {
			new string[500], vehicles = 0;
			format(string, sizeof(string), "UID\tPojazd\tStan Pojazdu\tPaliwo");

			for(new i=0; i<MAX_VEHICLES; i++)
			{
	    		if(Vehicle[i][veh_owner] == PlayerData[playerid][char_uid])
	    		{
	        		if(Vehicle[i][veh_spawned])
	        		{
						format(string, sizeof(string), "%s\n%d\t%s*\t%.1f\t%.1f", string, Vehicle[i][veh_uid], VehicleNames[Vehicle[i][veh_model] - 400], Vehicle[i][veh_health], Vehicle[i][veh_fuel]);
					}
					else
					{
			    		format(string, sizeof(string), "%s\n%d\t%s\t%.1f\t%.1f", string, Vehicle[i][veh_uid], VehicleNames[Vehicle[i][veh_model] - 400], Vehicle[i][veh_health], Vehicle[i][veh_fuel]);
					}
					vehicles++;
				}
			}

			if(vehicles > 0)
				ShowPlayerDialog(playerid, D_VEHICLES, DIALOG_STYLE_TABLIST_HEADERS, "Twoje pojazdy (* zespawnowany )", string, "(Un)spawn", "Anuluj");
			else
		    	Info(playerid, "Twoja postaæ nie posiada ¿adnych pojazdów.");
		}
		else if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)
		{
		    new vehicleid = GetPlayerVehicleID(playerid);
		    new uid = GetVehicleUID(vehicleid);

		    if(Vehicle[uid][veh_owner] != PlayerData[playerid][char_uid]) return 1;

			new strcap[64];
			format(strcap, sizeof(strcap), "%s (UID: %d)", VehicleNames[GetVehicleModel(vehicleid) - 400], uid);

			new str[500];
			format(str, sizeof(str), "0\tOtwórz/Zamknij maskê\n1\tOtwórz/Zamknij baga¿nik\n2\tW³¹cz/Zgaœ œwiat³a\n3\tOtwórz/Zamknij szyby\n---------------------------\n5\tSprzedaj pojazd\n6\tOddaj pojazd za darmo\n7\tWymieñ siê pojazdem");

		    ShowPlayerDialog(playerid, D_VEHICLE_INFO, DIALOG_STYLE_TABLIST, strcap, str, "Wybierz", "Anuluj");
		}
	}
	else
	{
	    if(!strcmp(type, "z", true) || !strcmp(type, "zamknij", true))
	    {
			new sampid = GetNearestVehicle(playerid, 4.0);
			new uid = GetVehicleUID(sampid);

			if(GetNearestVehicle(playerid, 4.0) == -1) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

			if(Vehicle[uid][veh_spawned] && Vehicle[uid][veh_owner] == PlayerData[playerid][char_uid] || IsPlayerAdmin(playerid) || PlayerData[playerid][char_admin_level] > 6)
			{
				if(Vehicle[uid][veh_locked])
				{
			    	new str[64];
				    format(str, sizeof(str), "otwiera pojazd %s.", VehicleNames[Vehicle[uid][veh_model] - 400]);
			    	cmd_me(playerid, str);
			    	Vehicle[uid][veh_locked] = false;

			    	new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, 0, bonnet, boot, objective);

					ApplyAnimation(playerid,"INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				}
				else
				{
				    new str[64];
				    format(str, sizeof(str), "zamyka pojazd %s.", VehicleNames[Vehicle[uid][veh_model] - 400]);
			    	cmd_me(playerid, str);
			    	Vehicle[uid][veh_locked] = true;

			    	new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, 1, bonnet, boot, objective);

					ApplyAnimation(playerid,"INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
			else
			{
			    Info(playerid, "Ten pojazd nie jest Twój.");
			}
		}
		else if(!strcmp(type, "zaparkuj", true))
		{
		    if(IsPlayerInAnyVehicle(playerid))
		    {
		        new vehicleid = GetPlayerVehicleID(playerid);
		        new uid = GetVehicleUID(vehicleid);
		        if(Vehicle[uid][veh_spawned] && Vehicle[uid][veh_owner] == PlayerData[playerid][char_uid])
		        {
		    		new Float:X, Float:Y, Float:Z, Float:A;
		    		GetVehiclePos(vehicleid, X, Y, Z);
		    		GetVehicleZAngle(vehicleid, A);

		    		Vehicle[uid][veh_pos][0] = X;
		    		Vehicle[uid][veh_pos][1] = Y;
		    		Vehicle[uid][veh_pos][2] = Z;
		    		Vehicle[uid][veh_pos][3] = A;

		    		SaveVehicle(uid);

		    		Tip(playerid, "Pojazd zosta³ zaparkowany.");
				}
				else
				{
				    Tip(playerid, "To nie jest Twój pojazd.");
				}
			}
		}
		else if(!strcmp(type, "info", true))
		{
		    new sampid = GetNearestVehicle(playerid, 4.0);
			new uid = GetVehicleUID(sampid), Float:X, Float:Y, Float:Z;

			if(GetNearestVehicle(playerid, 4.0) == -1 || !Vehicle[uid][veh_spawned]) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

			GetVehiclePos(sampid, X, Y, Z);

			new string[500];
			format(string, sizeof(string), "~y~Marka: ~w~%s ~y~UID: ~w~%d ~y~Owner: ~w~%d ~y~Kolor: ~w~%d:%d ~y~Model: ~w~%d~n~~y~Pozycja X: ~w~%.1f ~y~Pozycja Y: ~w~%.1f ~y~Pozycja Z: ~w~%.1f~n~~p~Paliwo: ~w~%.1f ~p~Przebieg: ~w~%.1f ~p~HP: ~w~%.1f",
	    		VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_uid], Vehicle[uid][veh_owner], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_model], X, Y, Z, Vehicle[uid][veh_fuel], Vehicle[uid][veh_mileage], Vehicle[uid][veh_health]);

		    InfoVehicle(playerid, string);

		    PlayerData[playerid][char_vehicle_info_timer] = 10;
		}
		else if(!strcmp(type, "fix", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

		    new sampid = GetNearestVehicle(playerid, 5.0);
			new uid = GetVehicleUID(sampid);

			if(GetNearestVehicle(playerid, 5.0) == -1 || !Vehicle[uid][veh_spawned]) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

			RepairVehicle(sampid);
			Vehicle[uid][veh_health] = 1000.0;
			Vehicle[uid][veh_panels] = 0;
			Vehicle[uid][veh_lights] = 0;
			Vehicle[uid][veh_doors] = 0;
			Vehicle[uid][veh_tires] = 0;

			SaveVehicle(uid);

            new str[128];
			format(str, sizeof(str), "%s naprawi³ pojazd %s(UID: %d)", PlayerName(playerid), VehicleNames[Vehicle[uid][veh_model] - 400], uid);
			TeamMessage(0xFFFA8EFF, str);
		}
		else if(!strcmp(type, "spawn", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

		    new uid;
		    if(sscanf(next, "i", uid)) return Tip(playerid, "Tip: /v spawn [uid]");

		    if(Vehicle[uid][veh_spawned])
		    {
		        if(IsVehicleOccupied(Vehicle[uid][samp_id]))
			        return GameTextForPlayer(playerid, "~r~NIE MOZESZ TEGO TERAZ ZROBIC!", 3000, 4);

			    DestroyVehicle(Vehicle[uid][samp_id]);
			    Vehicle[uid][veh_spawned] = false;
			    SaveVehicle(uid);
			}
			else
			{
		    	Vehicle[uid][samp_id] = CreateVehicle(Vehicle[uid][veh_model], Vehicle[uid][veh_pos][0], Vehicle[uid][veh_pos][1], Vehicle[uid][veh_pos][2], Vehicle[uid][veh_pos][3], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], -1, 0);
				ChangeVehiclePaintjob(Vehicle[uid][samp_id], Vehicle[uid][veh_paintjob]);
				SetVehicleHealth(Vehicle[uid][samp_id], Vehicle[uid][veh_health]);
				Vehicle[uid][veh_spawned] = true;
				Vehicle[uid][veh_locked] = true;

				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, doors, bonnet, boot, objective);

				SetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, 1, bonnet, boot, objective);

				UpdateVehicleDamageStatus(Vehicle[uid][samp_id], Vehicle[uid][veh_panels], Vehicle[uid][veh_doors], Vehicle[uid][veh_lights], Vehicle[uid][veh_tires]);
			}
		}
		else if(!strcmp(type, "enter", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

		    new uid;
		    if(sscanf(next, "i", uid))
		    {
		        new sampid = GetNearestVehicle(playerid, 5.0);
		        uid = GetVehicleUID(sampid);

		        if(GetNearestVehicle(playerid, 5.0) == -1 || !Vehicle[uid][veh_spawned]) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

		        PutPlayerInVehicle(playerid, Vehicle[uid][samp_id], 0);
			}
			else
			{
			    if(!Vehicle[uid][veh_spawned]) return Info(playerid, "Pojazd nie jest zespawnowany.");

			    PutPlayerInVehicle(playerid, Vehicle[uid][samp_id], 0);
			}
		}
		else if(!strcmp(type, "fuel", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

		    new Float:fuel;
		    if(sscanf(next, "f", fuel)) return Tip(playerid, "Tip: /v fuel [iloœæ np. 100.0]");
		    if(fuel < 0.0 || fuel > 100.0) return Tip(playerid, "Niepoprawna iloœæ paliwa.");

			new sampid = GetNearestVehicle(playerid, 5.0);
   			new uid = GetVehicleUID(sampid);

   			if(GetNearestVehicle(playerid, 5.0) == -1 || !Vehicle[uid][veh_spawned]) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

      		Vehicle[uid][veh_fuel] = fuel;

      		new str[128];
			format(str, sizeof(str), "%s ustawi³ paliwo w pojeŸdzie %s(UID: %d) na %.1f", PlayerName(playerid), VehicleNames[Vehicle[uid][veh_model] - 400], uid, fuel);
			TeamMessage(0xFFFA8EFF, str);
		}
		else if(!strcmp(type, "hp", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

		    new Float:health;
		    if(sscanf(next, "f", health)) return Tip(playerid, "Tip: /v hp [iloœæ np. 1000.0]");
		    if(health < 0.0 || health > 1000.0) return Tip(playerid, "Niepoprawna iloœæ HP.");

      		new sampid = GetNearestVehicle(playerid, 5.0);
        	new uid = GetVehicleUID(sampid);

            if(GetNearestVehicle(playerid, 5.0) == -1 || !Vehicle[uid][veh_spawned]) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

			Vehicle[uid][veh_health] = health;
			SetVehicleHealth(sampid, health);

			new str[128];
			format(str, sizeof(str), "%s ustawi³ hp w pojeŸdzie %s(UID: %d) na %.1f", PlayerName(playerid), VehicleNames[Vehicle[uid][veh_model] - 400], uid, health);
			TeamMessage(0xFFFA8EFF, str);
		}
		else if(!strcmp(type, "owner", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

		    new puid;
		    if(sscanf(next, "ii", puid)) return Tip(playerid, "Tip: /v owner [uid postaci]");

		    new sampid = GetNearestVehicle(playerid, 5.0);
			new vuid = GetVehicleUID(sampid);

			if(GetNearestVehicle(playerid, 5.0) == -1 || !Vehicle[vuid][veh_spawned]) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

		    Vehicle[vuid][veh_owner] = puid;
	    	SaveVehicle(vuid);

            new str[256];
			format(str, sizeof(str), "%s ustawi³ w³aœciciela pojazdu %s(UID: %d) na UID postaci: %d", PlayerName(playerid), VehicleNames[Vehicle[vuid][veh_model] - 400], vuid, puid);
			TeamMessage(0xFFFA8EFF, str);
		}
		else if(!strcmp(type, "kolor", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

		    new kolor[2];
		    if(sscanf(next, "ii", kolor[0], kolor[1])) return Tip(playerid, "Tip: /v kolor [kolor(1)] [kolor(2)]");

		    new sampid = GetNearestVehicle(playerid, 5.0);
			new vuid = GetVehicleUID(sampid);

			if(GetNearestVehicle(playerid, 5.0) == -1 || !Vehicle[vuid][veh_spawned]) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

			Vehicle[vuid][veh_color][0] = kolor[0];
			Vehicle[vuid][veh_color][1] = kolor[1];
			SaveVehicle(vuid);

			ChangeVehicleColor(sampid, kolor[0], kolor[1]);

			new str[256];
			format(str, sizeof(str), "%s zmieni³ kolory pojazdu %s(UID: %d) na %d:%d", PlayerName(playerid), VehicleNames[Vehicle[vuid][veh_model] - 400], vuid, kolor[0], kolor[1]);
			TeamMessage(0xFFFA8EFF, str);
		}
		else if(!strcmp(type, "pj", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

		    new pj;
		    if(sscanf(next, "i", pj)) return Tip(playerid, "Tip: /v pj [0-2] (3 - usuwa paintjob)");
		    if(pj < 0 || pj > 3) return Info(playerid, "Paintjob nie mo¿e byæ mniejszy ni¿ 0 lub wiêkszy ni¿ 2.\n3 - usuwa paintjob.");

		    new sampid = GetNearestVehicle(playerid, 5.0);
			new vuid = GetVehicleUID(sampid);

			if(GetNearestVehicle(playerid, 5.0) == -1 || !Vehicle[vuid][veh_spawned]) return Info(playerid, "W pobli¿u nie znajduje siê ¿aden pojazd.");

			Vehicle[vuid][veh_paintjob] = pj;
			SaveVehicle(vuid);

			ChangeVehiclePaintjob(sampid, pj);

			if(pj == 3)
			{
			    new str[256];
				format(str, sizeof(str), "%s usun¹³ paintjob z pojazdu %s(UID: %d)", PlayerName(playerid), VehicleNames[Vehicle[vuid][veh_model] - 400], vuid);
				TeamMessage(0xFFFA8EFF, str);
			}
			else
			{
			    new str[256];
				format(str, sizeof(str), "%s zmieni³ paintjob pojazdu %s(UID: %d) na %d", PlayerName(playerid), VehicleNames[Vehicle[vuid][veh_model] - 400], vuid, pj);
				TeamMessage(0xFFFA8EFF, str);
			}
		}
	}
	return 1;
}

CMD:p(playerid, cmdtext[])
{
    if(PlayerData[playerid][char_bw] != 0)
	{
		Info(playerid, "Nie mo¿esz teraz skorzystaæ z tej komendy.");
		return 1;
	}

	new nazwa[64];
	if(sscanf(cmdtext, "s[64]", nazwa))
	{
		new items = 0, string[2500];
		format(string, sizeof(string), "UID\tNazwa\tWartoœci\nTwoje przedmioty:");

		for(new i=0; i<MAX_ITEMS; i++)
		{
	    	if(Item[i][UID] != -1 && Item[i][Owner] == PlayerData[playerid][char_uid])
	    	{
	        	if(Item[i][Active])
	        		format(string, sizeof(string), "{CCCCCC}%s\n{CCCCCC}%d\t{A9C4E4}%s\t{000000}%d (%d, %d, %d, %d, %d, %d)", string, Item[i][UID], Item[i][Name], Item[i][Type], Item[i][Var][0], Item[i][Var][1], Item[i][Var][2], Item[i][Var][3], Item[i][Var][4], Item[i][Var][5]);
				else
			    	format(string, sizeof(string), "{CCCCCC}%s\n{CCCCCC}%d\t{CCCCCC}%s\t{000000}%d (%d, %d, %d, %d, %d, %d)", string, Item[i][UID], Item[i][Name], Item[i][Type], Item[i][Var][0], Item[i][Var][1], Item[i][Var][2], Item[i][Var][3], Item[i][Var][4], Item[i][Var][5]);
				items++;
			}
		}

		if(items > 0)
			ShowPlayerDialog(playerid, D_ITEMS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty", string, "Wybierz", "Opcje");
		else
		    Info(playerid, "Nie posiadasz ¿adnych przedmiotów przy sobie.");
	}
	else
	{
	    if(!strcmp(nazwa, "podnies", true))
	    {
	        new strr[32] = "UID\tNazwa", string[500], count = 0;
			for(new i=0; i<MAX_ITEMS; i++)
	        {
	            if(IsPlayerInRangeOfPoint(playerid, 3.0, Item[i][item_pos][0], Item[i][item_pos][1], Item[i][item_pos][2]) && !IsPlayerInAnyVehicle(playerid))
	            {
	                format(string, sizeof(string), "%s\n%d\t%s", string, Item[i][UID], Item[i][Name]);
	                count++;
				}
				else if(IsPlayerInAnyVehicle(playerid))
				{
				    new uid = GetVehicleUID(GetPlayerVehicleID(playerid));
				    if(Item[i][in_vehicle] == uid)
				    {
				        format(string, sizeof(string), "%s\n%d\t%s", string, Item[i][UID], Item[i][Name]);
				        count++;
					}
				}
			}

			strcat(strr, string);

			if(count > 0)
			{
			    ShowPlayerDialog(playerid, D_NEAREST_ITEMS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty w pobli¿u", strr, "Podnies", "Anuluj");
			}
			else
			{
			    InfoTD(playerid, "Nie znaleziono zadnych przedmiotow w poblizu.");
			    PlayerData[playerid][char_info_timer] = 8;
			}
		}
		else
		{
		    new count = 0;
	    	for(new i=0; i<MAX_ITEMS; i++)
	    	{
	        	if(!strfind(Item[i][Name], nazwa, true) && Item[i][UID] != -1 && Item[i][Owner] == PlayerData[playerid][char_uid])
	        	{
	            	UseItem(playerid, i);
	            	count++;
	            	break;
				}
			}

			if(count == 0)
			{
  				new str[128];
	    		format(str, sizeof(str), "Nie posiadasz przedmiotu o nazwie %s", nazwa);
		    	InfoTD(playerid, str);
		    	PlayerData[playerid][char_info_timer] = 8;
			}
		}
	}
	return 1;
}

CMD:ja(playerid, params[]) return cmd_me(playerid, params);
CMD:me(playerid, params[])
{
	if(PlayerData[playerid][char_bw] != 0)
	{
		Info(playerid, "Nie mo¿esz teraz skorzystaæ z tej komendy.");
		return 1;
	}

    new string[250];
	if(sscanf(params, "s[144]", string))
	{
		Tip(playerid, "Tip: /me [Opis czynnoœci] - Komenda s³u¿y do opisywania czynnoœci któr¹ wykonuje twoja postaæ.");
		Tip(playerid, "Przyk³ad: /me Wyci¹gn¹³/a z kieszeni notes, a nastêpnie otworzy³/a go.");
		return 1;
	}
	format(string, sizeof(string), "** %s %s", PlayerName(playerid), string);

	SendWrappedMessageToPlayerRange(playerid, COLOR_PURPLE, COLOR_PURPLE2, COLOR_PURPLE3, COLOR_PURPLE4, COLOR_PURPLE5, string, 10, MAX_LINE);
	return 1;
}

CMD:do(playerid, cmdtext[])
{
	new string[250];
	if(sscanf(cmdtext, "s[144]", string))
	{
	    Tip(playerid, "Tip: /do [Opis otoczenia] - Komenda s³u¿y do opisywania otoczenia.");
	    Tip(playerid, "Przyk³ad: /do Podczas uderzenia mo¿na zauwa¿yæ zniszczenie pojazdu, kierowca nieprzytomny.");
	    return 1;
	}
	string[0] = toupper(string[0]);
	format(string, sizeof(string), "* %s (( %s ))", string, PlayerName(playerid));

	new Float:pos[3], Float:range = 10.0;
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

	for(new i=0; i<GetMaxPlayers(); i++)
	{
	    if(IsPlayerInRangeOfPoint(i, range/16, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, COLOR_DO, string);
		else if(IsPlayerInRangeOfPoint(i, range/8, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, COLOR_DO2, string);
		else if(IsPlayerInRangeOfPoint(i, range/4, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, COLOR_DO3, string);
		else if(IsPlayerInRangeOfPoint(i, range/2, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, COLOR_DO4, string);
		else if(IsPlayerInRangeOfPoint(i, range, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, COLOR_DO5, string);
	}
	return 1;
}

CMD:area(playerid, cmdtext[])
{
	new type[32], next[64];
	if(sscanf(cmdtext, "s[32]S()[64]", type, next))
	{
		if(GetPlayerZone(playerid) != 0)
		{
			new str[64], string[256], uid = GetPlayerZone(playerid);
			FreeID[playerid] = uid;
			string = "Ustawienia\tWartoœci";

			format(str, sizeof(str), "Strefa %s (UID: %d) (SampID: %d)", Zone[uid][z_name], Zone[uid][z_uid], Zone[uid][z_sampid]);
			format(string, sizeof(string), "%s\nPrzejmij strefê", string);
			if(IsPlayerAdmin(playerid) || PlayerData[playerid][char_admin_level] > 6) format(string, sizeof(string), "%s\n-------------------------\nW³aœciciel:\t%d\nBudynek mieszkalny:\t%d$\nBudynek biznesowy:\t%d$\nMinimalny metra¿:\t%dm2", string, Zone[uid][z_owner], Zone[uid][z_house_cost], Zone[uid][z_buis_cost], Zone[uid][z_size]);

			ShowPlayerDialog(playerid, D_AREA, DIALOG_STYLE_TABLIST_HEADERS, str, string, "Wybierz", "Anuluj");
		}
		else
		{
	    	Tip(playerid, "Nie znajdujesz siê na ¿adnej strefie.");
		}
	}
	else
	{
	    if(!strcmp(type, "stworz", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

			new nazwa[32];
			if(sscanf(next, "s[32]", nazwa)) return Tip(playerid, "Tip: /area stworz [nazwa strefy]");

			new DB_Query[500];
			format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_zones` (z_name, z_minx, z_miny, z_maxx, z_maxy, z_owner, z_house_cost, z_buis_cost, z_size) VALUES ('%s', 0.0, 0.0, 0.0, 0.0, 1, 0, 0, 0)", nazwa);
			mysql_query(DB_Query);

			new uid = mysql_insert_id();
			Zone[uid][z_uid] = uid;
			format(Zone[uid][z_name], 32, "%s", nazwa);
			Zone[uid][z_owner] = PlayerData[playerid][char_uid];
			Zone[uid][z_house_cost] = 0;
			Zone[uid][z_buis_cost] = 0;
			Zone[uid][z_size] = 0;

			FreeID[playerid] = uid;

			PlayerData[playerid][char_stage] = STAGE_ZONE_SET_X;

			new str[128];
			format(str, sizeof(str), "~y~Strefa ~w~%s ~y~UID: ~w~%d~n~~y~Idz do punktu ~w~South West ~y~i kliknij ~w~Y ~y~aby zaznaczyc pozycje.", Zone[uid][z_name], Zone[uid][z_uid]);
			InfoTD(playerid, str);

			Tip(playerid, "Rozpoczêto tworzenie strefy.");
		}
		else if(!strcmp(type, "usun", true))
		{
		    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

			if(GetPlayerZone(playerid) == 0) return Tip(playerid, "Nie jesteœ na ¿adnej strefie.");

			new uid = GetPlayerZone(playerid);

			new DB_Query[128];
			format(DB_Query, sizeof(DB_Query), "DELETE FROM `rp_zones` WHERE `z_uid` = %d LIMIT 1", uid);
			mysql_query(DB_Query);

			PlayerData[playerid][char_stage] = STAGE_ZONE_NONE;

			Zone[uid][z_uid] = 0;
	    	format(Zone[uid][z_name], 32, " ");
	    	Zone[uid][z_min][0] = 0.0;
	    	Zone[uid][z_min][1] = 0.0;
	    	Zone[uid][z_max][0] = 0.0;
	    	Zone[uid][z_max][1] = 0.0;
	    	Zone[uid][z_owner] = 0;
	    	Zone[uid][z_house_cost] = 0;
	    	Zone[uid][z_buis_cost] = 0;
	    	Zone[uid][z_size] = 0;
		}
	}
	return 1;
}

CMD:set(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

	new type[64], next[32];
	if(sscanf(cmdtext, "s[64]S()[32]", type, next)) return Tip(playerid, "Tip: /set [strength/hp/premium/time/weather/skin] [...]");

	if(!strcmp(type, "strength", true))
	{
	    new id, ilosc;
	    if(sscanf(next, "ii", id, ilosc)) return Tip(playerid, "Tip: /set strength [id gracza] [iloœæ jednostek]");
	    if(!IsPlayerConnected(id) && !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

	    PlayerData[id][char_strength] = ilosc;

	    new str[128];
		format(str, sizeof(str), "%s ustawi³ si³ê gracza %s(ID: %d) na %dj", PlayerName(playerid), PlayerName(id), id, PlayerData[id][char_strength]);
		TeamMessage(0xFFFA8EFF, str);

		UpdateNick(id);
	}
	else if(!strcmp(type, "hp", true))
	{
	    new id, Float:ilosc;
	    if(sscanf(next, "if", id, ilosc)) return Tip(playerid, "Tip: /set hp [id gracza] [iloœæ HP np. 100.0]");
	    if(!IsPlayerConnected(id) && !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

	    SetPlayerHealthEx(id, ilosc);

	    new str[128];
		format(str, sizeof(str), "%s ustawi³ HP gracza %s(ID: %d) na %.1f", PlayerName(playerid), PlayerName(id), id, PlayerData[id][char_health]);
		TeamMessage(0xFFFA8EFF, str);
	}
	else if(!strcmp(type, "premium", true))
	{
	    new id, dni;
	    if(sscanf(next, "ii", id, dni)) return Tip(playerid, "Tip: /set premium [id gracza] [iloœæ dni np. 30]");
	    if(!IsPlayerConnected(id) && !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");
	    if(dni < 0 || dni > 60) return Info(playerid, "Iloœæ dni nie mo¿e przekraczaæ 60 dni.");

	    PlayerData[id][char_premium] = (dni * 24 * 60 * 60) + gettime();

	    new DB_Query[128];
		format(DB_Query, sizeof(DB_Query), "UPDATE `rp_chars` SET `char_premium` = %d WHERE `char_name` = '%s' LIMIT 1", PlayerData[id][char_premium], PlayerData[id][char_name]);
		mysql_query(DB_Query);

	    new str[128];
		format(str, sizeof(str), "%s ustawi³ premium gracza %s(ID: %d) na %d dni", PlayerName(playerid), PlayerName(id), id, dni);
		TeamMessage(0xFFFA8EFF, str);
	}
	else if(!strcmp(type, "time", true))
	{
	    new time;
	    if(sscanf(next, "i", time)) return Tip(playerid, "Tip: /set time [0-24]");
	    if(time < 0 || time > 24) return Tip(playerid, "Wpisano b³êdn¹ godzinê.");

	    SetWorldTime(time);

	    new str[128];
		format(str, sizeof(str), "%s ustawi³ godzinê na %d:00", PlayerName(playerid), time);
		TeamMessage(0xFFFA8EFF, str);
	}
	else if(!strcmp(type, "weather", true))
	{
	    new weather;
	    if(sscanf(next, "i", weather)) return Tip(playerid, "Tip: /set weather [pogoda]");

	    SetWeather(weather);

	    new str[128];
		format(str, sizeof(str), "%s ustawi³ pogodê na %d", PlayerName(playerid), weather);
		TeamMessage(0xFFFA8EFF, str);
	}
	else if(!strcmp(type, "skin", true))
	{
	    new id, idskina;
	    if(sscanf(next, "ii", id, idskina)) return Tip(playerid, "Tip: /set skin [id gracza] [id skina]");
		if(!IsPlayerConnected(id) && !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

		SetPlayerSkin(id, idskina);

		new str[128];
		format(str, sizeof(str), "%s zmieni³ ID skina tymczasowego, gracza %s(ID: %d) na %d", PlayerName(playerid), PlayerName(id), id, idskina);
		TeamMessage(0xFFFA8EFF, str);
	}
	return 1;
}

CMD:hp(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

	new id;
	if(sscanf(cmdtext, "i", id))
	{
	    SetPlayerHealthEx(playerid, 100.0);

	    new str[128];
		format(str, sizeof(str), "%s ustawi³ HP gracza %s(ID: %d) na 100.0", PlayerName(playerid), PlayerName(playerid), playerid);
		TeamMessage(0xFFFA8EFF, str);
	}
	else
	{
	    if(!IsPlayerConnected(id) || !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

	    SetPlayerHealthEx(id, 100.0);

	    new str[128];
		format(str, sizeof(str), "%s ustawi³ HP gracza %s(ID: %d) na 100.0", PlayerName(playerid), PlayerName(id), id);
		TeamMessage(0xFFFA8EFF, str);
	}
	return 1;
}

CMD:cid(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

	new id;
	if(sscanf(cmdtext, "i", id)) return Tip(playerid, "Tip: /cid [id gracza]");
	if(!IsPlayerConnected(id)) return Tip(playerid, "Ten gracz nie jest po³¹czony");

	new serial[128];
	gpci(id, serial, sizeof(serial));

	new str[256];
	format(str, sizeof(str), "Serial %s to: %s", PlayerName(id), serial);
	Tip(playerid, str);
	return 1;
}

CMD:ado(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

	new text[128];
	if(sscanf(cmdtext, "s[128]", text)) return Tip(playerid, "Tip: /ado [treœæ]");

	new str[144];
	format(str, sizeof(str), "* %s *", text);
	SendClientMessageToAll(COLOR_DO, str);
	return 1;
}

CMD:glob(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

    new text[128];
    if(sscanf(cmdtext, "s[128]", text)) return Tip(playerid, "Tip: /glob [treœæ]");

    new str[144];
    format(str, sizeof(str), "%s: %s", PlayerName(playerid), text);
    SendClientMessageToAll(COLOR_GLOB, str);
    return 1;
}

CMD:gm(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 1) return 0;

    new text[128];
	if(sscanf(cmdtext, "s[128]", text)) return Tip(playerid, "Tip: /gm [treœæ]");

	new str[144];
	format(str, sizeof(str), "< (%d) %s: %s >", playerid, PlayerName(playerid), text);
	TeamMessage(0x00FFFFFF, str);
	return 1;
}

CMD:a(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return cmd_admins(playerid, "");

    new text[128];
	if(sscanf(cmdtext, "s[128]", text)) return Tip(playerid, "Tip: /a [treœæ]");

	new str[144];
	format(str, sizeof(str), "< (%d) %s: %s >", playerid, PlayerName(playerid), text);
	AdminMessage(0x990000FF, str);
	return 1;
}

CMD:admins(playerid, cmdtext[])
{
	new str[2500], strl[64], a = 0;

	str = "ID\t\tNick\t\tUprawnienia";

	for(new i=0; i<GetMaxPlayers(); i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if((IsPlayerAdmin(i) || PlayerData[i][char_admin_level] > 6))
	            format(str, sizeof(str), "%s\n%d\t\t%s\t\t{FF0000}Administrator", str, i, PlayerName(i)), a++;
			else if((PlayerData[i][char_admin_level] > 0 && PlayerData[i][char_admin_level] < 7))
			    format(str, sizeof(str), "%s\n%d\t\t%s\t\t{FFCC00}GML %d", str, i, PlayerName(i), PlayerData[i][char_admin_level]), a++;
		}
	}

	format(strl, sizeof(strl), "Liczba online: %d", a);

	ShowPlayerDialog(playerid, D_ADMINS, DIALOG_STYLE_TABLIST_HEADERS, strl, str, "Zamknij", "");
	return 1;
}

CMD:login(playerid, cmdtext[])
{
	new id;
	if(sscanf(cmdtext, "i", id))
	{
		SaveCharacter(playerid);
		SaveItem(playerid);
		TryLogin(playerid);
	}
	else
	{
	    SaveCharacter(id);
		SaveItem(id);
	    TryLogin(id);
	}
	return 1;
}

CMD:bw(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 1) return 0;

	new id;
	if(sscanf(cmdtext, "i", id))
	{
	    if(PlayerData[playerid][char_bw] != 0)
		{
	    	PlayerData[playerid][char_bw] = 0;
	    	ClearAnimations(playerid);
	    	SetCameraBehindPlayer(playerid);
			SetPlayerHealthEx(playerid, 100.0);
			PlayerData[playerid][char_last_damaged_weapon] = -1;
			TogglePlayerControllable(playerid, true);

			new str[128];
			format(str, sizeof(str), "%s zdj¹³ BW dla gracza %s", PlayerName(playerid), PlayerName(playerid));
			TeamMessage(0xFFFA8EFF, str);

			UpdateNick(playerid);
		}
		else
		{
		    GetPlayerPos(playerid, PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2]);
	    	PlayerData[playerid][char_bw] = 180;
	    	SetPlayerHealthEx(playerid, 9.0);

	    	PlayerData[playerid][char_last_damaged_weapon] = -1;

	    	new str[128];
			format(str, sizeof(str), "%s nada³ BW dla gracza %s", PlayerName(playerid), PlayerName(playerid));
			TeamMessage(0xFFFA8EFF, str);

			UpdateNick(playerid);
		}
	}
	else
	{
	    if(!IsPlayerConnected(id) || !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

	    if(PlayerData[id][char_bw] != 0)
	    {
	    	PlayerData[id][char_bw] = 0;
	    	ClearAnimations(id);
	    	SetCameraBehindPlayer(id);
			SetPlayerHealthEx(id, 100.0);
			TogglePlayerControllable(id, true);

			PlayerData[id][char_last_damaged_weapon] = -1;

			new str[128];
			format(str, sizeof(str), "%s zdj¹³ BW dla gracza %s", PlayerName(playerid), PlayerName(id));
			TeamMessage(0xFFFA8EFF, str);

			UpdateNick(id);
		}
		else
		{
		    GetPlayerPos(id, PlayerData[id][char_last_pos][0], PlayerData[id][char_last_pos][1], PlayerData[id][char_last_pos][2]);
	    	PlayerData[id][char_bw] = 180;
	    	SetPlayerHealthEx(id, 9.0);

	    	PlayerData[id][char_last_damaged_weapon] = -1;

	    	new str[128];
			format(str, sizeof(str), "%s nada³ BW dla gracza %s", PlayerName(playerid), PlayerName(id));
			TeamMessage(0xFFFA8EFF, str);

			UpdateNick(id);
		}
	}
	return 1;
}

CMD:to(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 1) return 0;

	new id;
	if(sscanf(cmdtext, "i", id)) return Tip(playerid, "Tip: /to [id gracza]");
	if(!IsPlayerConnected(id) && !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)
	{
		new Float:X, Float:Y, Float:Z, vehicleid = GetPlayerVehicleID(playerid);
		GetPlayerPos(id, X, Y, Z);
		SetPlayerPos(playerid, X, Y, Z);
		SetVehiclePos(vehicleid, X, Y, Z);
		PutPlayerInVehicle(playerid, vehicleid, 0);
	}
	else
	{
	    new Float:X, Float:Y, Float:Z;
		GetPlayerPos(id, X, Y, Z);
		SetPlayerPos(playerid, X, Y, Z);
	}
	return 1;
}

CMD:tm(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 1) return 0;

	new id;
	if(sscanf(cmdtext, "i", id)) return Tip(playerid, "Tip: /tm [id gracza]");
	if(!IsPlayerConnected(id) && !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

	if(IsPlayerInAnyVehicle(id) && GetPlayerVehicleSeat(id) == 0)
	{
		new Float:X, Float:Y, Float:Z, vehicleid = GetPlayerVehicleID(id);
		GetPlayerPos(playerid, X, Y, Z);
		SetPlayerPos(id, X, Y, Z);
		SetVehiclePos(vehicleid, X, Y, Z);
		PutPlayerInVehicle(id, vehicleid, 0);
	}
	else
	{
	    new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		SetPlayerPos(id, X, Y, Z);
	}
	return 1;
}

CMD:przebierz(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 1) return 0;

    new skinid;
    if(sscanf(cmdtext, "i", skinid)) return Tip(playerid, "Tip: /przebierz [id skina]");
    if((skinid < 1 || skinid > 299) && (skinid < 20001 || skinid > 20022)) return Tip(playerid, "Tip: /przebierz [id skina]");

    SetPlayerSkin(playerid, skinid);
    PlayerData[playerid][char_skin] = skinid;
    return 1;
}

CMD:vc(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

	FreeID[playerid] = GetFreeVehicleID();
	new uid = FreeID[playerid];
	Vehicle[uid][veh_model] = 400;

	new StrinG[1000];
	format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
		VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

	ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
	return 1;
}

CMD:item(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

	FreeID[playerid] = GetFreeItemID();
	new uid = FreeID[playerid];
	format(Item[uid][Name], 64, "Brak");

	new StrinG[1000];
	format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
		Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

	ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
	return 1;
}

CMD:gmx(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

	new time;
	if(sscanf(cmdtext, "i", time)) return Tip(playerid, "Tip: /gmx [czas w sekundach]");

	for(new i=0; i<GetPlayerPoolSize(); i++)
	{
	    if(IsPlayerConnected(i) && PlayerData[i][char_logged])
	    {
	        SaveCharacter(i);
		}
	}

	new str[128];
	format(str, sizeof(str), "%s uruchomi³ procedurê restartu serwera.", PlayerName(playerid));
	TeamMessage(0xFFFA8EFF, str);

	SetTimer("GMXTimer", time * 1000, false);
	return 1;
}

forward GMXTimer();
public GMXTimer()
{
	SendRconCommand("gmx");
	return 1;
}

CMD:rc(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7) return 0;

	new id;
	if(sscanf(cmdtext, "i", id))
	{
	    if(PlayerData[playerid][char_spectate_id] != -1)
	    {
	    	TogglePlayerSpectating(playerid, 0);
			PlayerData[playerid][char_spectate_id] = -1;

			//Powrót na pozycjê zapisan¹ przed wpisaniem /rc [id], interior, world
			SetPlayerPos(playerid, PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2]);
			SetPlayerFacingAngle(playerid, PlayerData[playerid][char_last_pos][3]);
			SetPlayerInterior(playerid, PlayerData[playerid][char_interior]);
			SetPlayerVirtualWorld(playerid, PlayerData[playerid][char_virtual_world]);
		}
	}
	else
	{
	    if(id == playerid) return Tip(playerid, "Nie mo¿esz podgl¹daæ samego siebie.");

	    if(!IsPlayerConnected(id)) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

		if(PlayerData[id][char_spectate_id] != -1)
		{
		    new str[64];
		    format(str, sizeof(str), "Ta osoba podgl¹da %s(ID: %d)", PlayerName(PlayerData[id][char_spectate_id]), PlayerData[id][char_spectate_id]);
		    Tip(playerid, str);
		    return 1;
		}

		if(PlayerData[playerid][char_spectate_id] != -1)
		{
		    new str[128];
		    format(str, sizeof(str), "Aktualnie podgl¹dasz ju¿ jak¹œ osobê, u¿yj ~k~~PED_SPRINT~ lub ~k~~SNEAK_ABOUT~ aby przegl¹daæ graczy.");
			Tip(playerid, str);
			return 1;
		}

		if(PlayerData[id][char_admin_level] > 0 && PlayerData[playerid][char_admin_level] < 7) return Tip(playerid, "Nie mo¿esz podgl¹daæ Administratorów.");

		GetPlayerPos(playerid, PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2]);
		GetPlayerFacingAngle(playerid, PlayerData[playerid][char_last_pos][3]);
		PlayerData[playerid][char_interior] = GetPlayerInterior(playerid);
		PlayerData[playerid][char_virtual_world] = GetPlayerVirtualWorld(playerid);

        TogglePlayerSpectating(playerid, 1);
		if(IsPlayerInAnyVehicle(id))
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
		else
			PlayerSpectatePlayer(playerid, id);
		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));

		PlayerData[playerid][char_spectate_id] = id;
	}
	return 1;
}

CMD:mc(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] != -1)
	    return Tip(playerid, "Aktualnie edytujesz ju¿ jakiœ obiekt.");

	new objectid;
	if(sscanf(cmdtext, "d", objectid)) return Tip(playerid, "Tip: /mc [id obiektu]");

	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	PlayerData[playerid][char_edit_object] = CreateDynamicObject(objectid, X, Y + 2, Z, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 500.0, 1000.0);

	new DB_Query[500];
	format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_objects` (object_model, object_pos_x, object_pos_y, object_pos_z, object_rot_x, object_rot_y, object_rot_z, object_world, object_interior) VALUES (%d, %f, %f, %f, %f, %f, %f, %d, %d)",
	    objectid, X, Y+2.0, Z, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	mysql_query(DB_Query);

	new uid = mysql_insert_id();

	Object[uid][object_sampid] = PlayerData[playerid][char_edit_object];
	Object[uid][object_model] = objectid;
	Object[uid][object_uid] = uid;
	Object[uid][object_pos][0] = X;
	Object[uid][object_pos][1] = Y+2.0;
	Object[uid][object_pos][2] = Z;
	Object[uid][object_pos][3] = 0.0;
	Object[uid][object_pos][4] = 0.0;
	Object[uid][object_pos][5] = 0.0;
	Object[uid][object_world] = GetPlayerVirtualWorld(playerid);
	Object[uid][object_interior] = GetPlayerInterior(playerid);

	for(new i=0; i<16; i++)
	{
		format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_object_mmat` (object_uid, object_type, object_index, object_material_color, object_modelid, object_txdname, object_texturename, object_matsize, object_fontsize, object_fontcolor, object_backcolor, object_bold, object_align, object_font, object_text) VALUES (%d, -1, %d, 0, 0, ' ', ' ', 0, 0, 0, 0, 0, 0, ' ', ' ')", uid, i);
		mysql_query(DB_Query);
	}

	Tip(playerid, "Pomyœlnie utworzono obiekt.");
	return 1;
}

CMD:msel(playerid, cmdtext[])
{
	if(GetNearestObject(playerid, 50.0) == -1) return Tip(playerid, "Nie ma ¿adnych obiektów w pobli¿u.");

	PlayerData[playerid][char_edit_object] = GetNearestObject(playerid, 50.0);
	return 1;
}

CMD:md(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

	DestroyDynamicObject(PlayerData[playerid][char_edit_object]);

	new uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
	Object[uid][object_uid] = 0;
	Object[uid][object_model] = 0;
	Object[uid][object_sampid] = -1;
	Object[uid][object_pos][0] = 0.0;
	Object[uid][object_pos][1] = 0.0;
	Object[uid][object_pos][2] = 0.0;
	Object[uid][object_pos][3] = 0.0;
	Object[uid][object_pos][4] = 0.0;
	Object[uid][object_pos][5] = 0.0;
	Object[uid][object_world] = -1;
	Object[uid][object_interior] = -1;

	new DB_Query[256];
	format(DB_Query, sizeof(DB_Query), "DELETE FROM `rp_objects` WHERE `object_uid` = %d LIMIT 1", uid);
	mysql_query(DB_Query);

	format(DB_Query, sizeof(DB_Query), "DELETE FROM `rp_object_mmat` WHERE `object_uid` = %d", uid);
	mysql_query(DB_Query);

	PlayerData[playerid][char_edit_object] = -1;
	PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_NONE;
	ClearAnimations(playerid);

	Tip(playerid, "Pomyœlnie usuniêto obiekt.");
	return 1;
}

CMD:msave(playerid, cmdtext[])
{
	if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

	new uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
	SaveObject(uid);

	PlayerData[playerid][char_edit_object] = -1;
	PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_NONE;
	ClearAnimations(playerid);

	Tip(playerid, "Pomyœlnie zapisano obiekt.");
	return 1;
}

CMD:rx(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

	new Float:rX;
	if(sscanf(cmdtext, "f", rX)) return Tip(playerid, "Tip: /rx [pozycja]");

	new Float:X, Float:Y, Float:Z, uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
	GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
	SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X + rX, Y, Z);

	Object[uid][object_pos][3] += rX;
	return 1;
}

CMD:ry(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

    new Float:rY;
	if(sscanf(cmdtext, "f", rY)) return Tip(playerid, "Tip: /ry [pozycja]");

    new Float:X, Float:Y, Float:Z, uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
	GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
	SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y + rY, Z);

	Object[uid][object_pos][4] += rY;
	return 1;
}

CMD:rz(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

    new Float:rZ;
	if(sscanf(cmdtext, "f", rZ)) return Tip(playerid, "Tip: /rz [pozycja]");

    new Float:X, Float:Y, Float:Z, uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
	GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
	SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z + rZ);

	Object[uid][object_pos][5] += rZ;
	return 1;
}

CMD:ox(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

	new Float:rX;
	if(sscanf(cmdtext, "f", rX)) return Tip(playerid, "Tip: /ox [pozycja]");

	new Float:X, Float:Y, Float:Z, uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X + rX, Y, Z);

	Object[uid][object_pos][0] += rX;
	return 1;
}

CMD:oy(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

    new Float:rY;
	if(sscanf(cmdtext, "f", rY)) return Tip(playerid, "Tip: /oy [pozycja]");

    new Float:X, Float:Y, Float:Z, uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y + rY, Z);

	Object[uid][object_pos][1] += rY;
	return 1;
}

CMD:oz(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

    new Float:rZ;
	if(sscanf(cmdtext, "f", rZ)) return Tip(playerid, "Tip: /oz [pozycja]");

    new Float:X, Float:Y, Float:Z, uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z + rZ);

	Object[uid][object_pos][2] += rZ;
	return 1;
}

CMD:mmat(playerid, cmdtext[])
{
	new door = PlayerData[playerid][char_inside_doors];
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6 && (door == 0 || Doors[door][Owner] != PlayerData[playerid][char_uid])) return 0;

	if(PlayerData[playerid][char_edit_object] == -1)
	    return Tip(playerid, "Aktualnie nie edytujesz ¿adnego obiektu.");

	new type, next[500];
	if(sscanf(cmdtext, "iS()[500]", type, next)) return Tip(playerid, "Tip: /mmat [typ 0 - obiekt, 1 - tekst] [...]");

	if(type == 0)
	{
	    new index, modelid, materialcolor, txdname[64], texturename[64], uid = GetObjectUID(PlayerData[playerid][char_edit_object]), DB_Query[1000];
	    if(sscanf(next, "ihis[64]s[64]", index, materialcolor, modelid, txdname, texturename)) return Tip(playerid, "Tip: /mmat 0 [index] [material color] [modelid] [txdname] [texturename]");

		SetDynamicObjectMaterial(PlayerData[playerid][char_edit_object], index, modelid, txdname, texturename, materialcolor);

		Object[uid][object_mmat_uid] = uid;
		Object[uid][object_mmat_index][index] = index;
		Object[uid][object_mmat_type] = 0;
		Object[uid][object_mmat_color] = materialcolor;
		Object[uid][object_mmat_modelid] = modelid;
		format(Object[uid][object_mmat_txdname], 64, "%s", txdname);
		format(Object[uid][object_mmat_texturename], 128, "%s", texturename);

		format(DB_Query, sizeof(DB_Query), "UPDATE `rp_object_mmat` SET `object_type` = %d, `object_index` = %d, `object_material_color` = %d, `object_modelid` = %d, `object_font` = 'Tahoma', `object_text` = 'tekst', `object_txdname` = '%s', `object_texturename` = '%s' WHERE `object_uid` = %d AND `object_index` = %d LIMIT 1",
			0, index, materialcolor, modelid, txdname, texturename, Object[uid][object_uid], index);
		mysql_query(DB_Query);
	}
	else if(type == 1)
	{
	    new index, matsize, fontsize, fontcolor, backcolor, bold, align, font[64], text[128];
	    if(sscanf(next, "iiihhiis[64]s[128]", index, matsize, fontsize, fontcolor, backcolor, bold, align, font, text)) return Tip(playerid, "Tip: /mmat 1 [index] [matsize (120)] [fontsize (24)] [fontcolor (0xARGB)] [backcolor (0xARGB)] [bold 0-1] [align 0-2] [font] [text]");

		if(strfind(text, "(", true) || strfind(text, ")", true) || strfind(text, "|", true))
		{
			strreplace(text, "(", "{");
			strreplace(text, ")", "}");
			strreplace(text, "|", "\n");
		}

		SetDynamicObjectMaterialText(PlayerData[playerid][char_edit_object], index, text, matsize, font, fontsize, bold, fontcolor, backcolor, align);

		new uid = GetObjectUID(PlayerData[playerid][char_edit_object]);
		Object[uid][object_mmat_type] = 1;
		Object[uid][object_mmat_index][index] = index;
		Object[uid][object_mmat_size] = matsize;
		Object[uid][object_mmat_fontsize] = fontsize;
		Object[uid][object_mmat_fontcolor] = fontcolor;
		Object[uid][object_mmat_backcolor] = backcolor;
		Object[uid][object_mmat_bold] = bold;
		Object[uid][object_mmat_align] = align;
		format(Object[uid][object_mmat_font], 32, "%s", font);
		format(Object[uid][object_mmat_text], 128, "%s", text);

		new DB_Query[1000];
  		format(DB_Query, sizeof(DB_Query), "UPDATE `rp_object_mmat` SET `object_type` = %d, `object_index` = %d, `object_matsize` = %d, `object_fontsize` = %d, `object_fontcolor` = %d, `object_backcolor` = %d, `object_bold` = %d, `object_align` = %d, `object_font` = '%s', `object_text` = '%s' WHERE `object_uid` = %d LIMIT 1",
			1, index, matsize, fontsize, fontcolor, backcolor, bold, align, font, text, Object[uid][object_uid]);
		mysql_query(DB_Query);
	}
	return 1;
}

CMD:mpick(playerid, cmdtext[])
{
    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 6) return 0;

	SelectObject(playerid);
	return 1;
}
