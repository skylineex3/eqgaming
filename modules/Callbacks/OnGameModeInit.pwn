public OnGameModeInit()
{
	#if DEBUG_MODE == 1

    mysql_connect(SQL_HOST2, SQL_USER2, SQL_DB2, SQL_PASS2);

	if(mysql_ping() == 1)
	{
	    print("Polaczono z baza danych.");
	}
	else
	{
		print("Nie mozna polaczyc sie z baza danych, zamykam serwer.");

		SendRconCommand("exit");
		return 1;
	}

	mysql_debug(1);

	#else

	mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);

	mysql_connect(SQL_HOST2, SQL_USER2, SQL_DB2, SQL_PASS2);

	if(mysql_ping() == 1)
	{
	    print("Polaczono z baza danych.");
	}
	else
	{
		print("Nie mozna polaczyc sie z baza danych, zamykam serwer.");

		SendRconCommand("exit");
		return 1;
	}

	#endif

	mysql_query("UPDATE `rp_chars` SET `char_ingame` = 0");

	SetTimer("SecTimer", 1000, true);

	SetGameModeText("eQuality Gaming • v0.1 - DEV");

	AllowInteriorWeapons(false);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);
	ShowPlayerMarkers(false);
	ShowNameTags(false);
	SetNameTagDrawDistance(0.0);
	LimitGlobalChatRadius(1.0);
	ManualVehicleEngineAndLights();

	for(new i=0; i<GetMaxPlayers(); i++)
	{
	    PlayerData[i][char_name_tag]	= CreateDynamic3DTextLabel(" ", 0xFFFFFF80, 0.0, 0.0, 0.2, 20.0, i, INVALID_VEHICLE_ID, 1);
	    PlayerData[i][char_desc_text]	= CreateDynamic3DTextLabel(" ", 0xC2A2DAFF, 0.0, 0.0, -0.6, 20.0, i, INVALID_VEHICLE_ID, 1);

		PlayerData[i][char_info] = TextDrawCreate(512.000000, 280.000000, "~w~Nie mozesz skorzystac z takiej komendy. Uzyj ~y~/pomoc~w~, jezeli szukasz pomocy.");
		TextDrawAlignment(PlayerData[i][char_info], 2);
		TextDrawBackgroundColor(PlayerData[i][char_info], 96);
		TextDrawFont(PlayerData[i][char_info], 1);
		TextDrawLetterSize(PlayerData[i][char_info], 0.329998, 1.299999);
		TextDrawColor(PlayerData[i][char_info], -1);
		TextDrawSetOutline(PlayerData[i][char_info], 1);
		TextDrawSetProportional(PlayerData[i][char_info], 1);
		TextDrawUseBox(PlayerData[i][char_info], 1);
		TextDrawBoxColor(PlayerData[i][char_info], 128);
		TextDrawTextSize(PlayerData[i][char_info], 593.000000, 190.000000);
		TextDrawTextSize(PlayerData[i][char_info], 593.000000, 190.000000);

		VehicleInfo[i] = TextDrawCreate(323.000000, 360.000000, "~y~Marka: ~w~Sultan ~y~UID: ~w~12 ~y~Owner: ~w~1 ~y~Kolor: ~w~1:1 ~y~Model: ~w~560~n~~y~Pozycja X: ~w~0.0 ~y~Pozycja Y: ~w~0.0 ~y~Pozycja Z: ~w~0.0~n~~p~Paliwo: ~w~100.0 ~p~Przebieg: ~w~5.0 ~p~HP: ~w~1000.0");
		TextDrawAlignment(VehicleInfo[i], 2);
		TextDrawBackgroundColor(VehicleInfo[i], 96);
		TextDrawFont(VehicleInfo[i], 1);
		TextDrawLetterSize(VehicleInfo[i], 0.300000, 1.100000);
		TextDrawColor(VehicleInfo[i], -1);
		TextDrawSetOutline(VehicleInfo[i], 1);
		TextDrawSetProportional(VehicleInfo[i], 1);
		TextDrawSetProportional(VehicleInfo[i], 1);
	}

	LSNews[0] = TextDrawCreate(-10.000000, 431.000000, "_");
	TextDrawBackgroundColor(LSNews[0], 255);
	TextDrawFont(LSNews[0], 1);
	TextDrawLetterSize(LSNews[0], 0.500000, 2.000000);
	TextDrawColor(LSNews[0], -1);
	TextDrawSetOutline(LSNews[0], 0);
	TextDrawSetProportional(LSNews[0], 1);
	TextDrawSetShadow(LSNews[0], 1);
	TextDrawUseBox(LSNews[0], 1);
	TextDrawBoxColor(LSNews[0], 144);
	TextDrawTextSize(LSNews[0], 650.000000, 0.000000);
	TextDrawTextSize(LSNews[0], 650.000000, 0.000000);

	LSNews[1] = TextDrawCreate(7.000000, 433.000000, "~r~~h~LS News: ~w~W tej chwili nikt nie nadaje.");
	TextDrawBackgroundColor(LSNews[1], 128);
	TextDrawFont(LSNews[1], 1);
	TextDrawLetterSize(LSNews[1], 0.209999, 1.000000);
	TextDrawColor(LSNews[1], -1);
	TextDrawSetOutline(LSNews[1], 1);
	TextDrawSetProportional(LSNews[1], 1);
	TextDrawSetProportional(LSNews[1], 1);

	ForGame = TextDrawCreate(580.000000, 396.000000, "~r~~h~F~w~or~r~~h~G~w~ame~n~22/22/3030");
	TextDrawAlignment(ForGame, 2);
	TextDrawBackgroundColor(ForGame, 128);
	TextDrawFont(ForGame, 1);
	TextDrawLetterSize(ForGame, 0.330000, 1.100000);
	TextDrawColor(ForGame, -1);
	TextDrawSetOutline(ForGame, 1);
	TextDrawSetProportional(ForGame, 1);
	TextDrawSetProportional(ForGame, 1);

	LoadItems();
	LoadVehicles();
	LoadObjects();
	LoadObjectMmat();
	LoadZones();
	LoadDoors();
	return 1;
}
