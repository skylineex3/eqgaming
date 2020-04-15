public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_FIRE)
	{
	    if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)
	    {
	        new vehid = GetPlayerVehicleID(playerid);
	        new engine,lights,alarm,doors,bonnet,boot,objective;
    		GetVehicleParamsEx(vehid,engine,lights,alarm,doors,bonnet,boot,objective);
    		if(lights == 1)
    			SetVehicleParamsEx(vehid,engine,0,alarm,doors,bonnet,boot,objective);
			else
			    SetVehicleParamsEx(vehid,engine,1,alarm,doors,bonnet,boot,objective);
		}

	    if(PlayerData[playerid][char_edit_object] != -1)
	    {
			if(!PlayerData[playerid][char_editing])
			{
				ApplyAnimation(playerid,"BEACH","bather",4.1,0,0,0,1,0);
				PlayerData[playerid][char_editing] = true;

				PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_POS;
			}
			else
			{
		    	ClearAnimations(playerid);
				PlayerData[playerid][char_editing] = false;

				PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_NONE;
			}
		}
	}

	if(newkeys & KEY_AIM)
	{
	    if(PlayerData[playerid][char_edit_object] == -1 && PlayerData[playerid][char_edit_stage] != STAGE_OBJECT_NONE) return 1;

	    if(PlayerData[playerid][char_edit_stage] == STAGE_OBJECT_POS)
	    {
	        PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_ROT;
		}
		else
		{
		    PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_POS;
		}
	}

	if(newkeys & KEY_SPRINT && PlayerData[playerid][char_spectate_id] != -1 && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    new id = GetNextPlayerID(playerid, PlayerData[playerid][char_spectate_id]);
	    if(id == INVALID_PLAYER_ID) id = GetLowestID(playerid);

        if(IsPlayerInAnyVehicle(id))
		    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
		else
        	PlayerSpectatePlayer(playerid, id);

		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));

		PlayerData[playerid][char_spectate_id] = id;
	}
	if(newkeys & KEY_WALK && PlayerData[playerid][char_spectate_id] != -1 && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    new id = GetPreviousPlayerID(playerid, PlayerData[playerid][char_spectate_id]);
	    if(id == INVALID_PLAYER_ID) id = GetPlayerPoolSize();

	    if(IsPlayerInAnyVehicle(id))
		    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
		else
        	PlayerSpectatePlayer(playerid, id);

		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));

		PlayerData[playerid][char_spectate_id] = id;
	}

	if(newkeys & KEY_ACTION && GetPlayerVehicleSeat(playerid) == 0)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        new vehid = GetPlayerVehicleID(playerid);
		    new engine,lights,alarm,doors,bonnet,boot,objective;
    		GetVehicleParamsEx(vehid,engine,lights,alarm,doors,bonnet,boot,objective);
    		if(engine == 0)
    			SetTimerEx("EngineStart", 3000, false, "d", playerid), GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~g~TRWA ODPALANIE SILNIKA...", 3500, 3);
			else
			    SetVehicleParamsEx(vehid,0,lights,alarm,doors,bonnet,boot,objective);
		}
	}

	if(newkeys & KEY_YES)
	{
	    if(PlayerData[playerid][char_stage] == STAGE_ZONE_SET_X)
	    {
	        new uid = FreeID[playerid], Float:X, Float:Y, Float:Z;
	        GetPlayerPos(playerid, X, Y, Z);
	    	Zone[uid][z_min][0] = X;
	    	Zone[uid][z_min][1] = Y;

	    	new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_minx` = %f, `z_miny` = %f WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_min][0], Zone[uid][z_min][1], uid);
			mysql_query(DB_Query);

	    	PlayerData[playerid][char_stage] = STAGE_ZONE_SET_Y;

	    	new str[128];
			format(str, sizeof(str), "~y~Strefa ~w~%s ~y~UID: ~w~%d~n~~y~Teraz idz do punktu ~w~North East ~y~i kliknij ~w~Y ~y~aby zaznaczyc pozycje.", Zone[uid][z_name], Zone[uid][z_uid]);
			InfoTD(playerid, str);

	    	Tip(playerid, "Pozycja zosta³a zapisana.");
		}
		else if(PlayerData[playerid][char_stage] == STAGE_ZONE_SET_Y)
		{
		    new uid = FreeID[playerid], Float:X, Float:Y, Float:Z;
	        GetPlayerPos(playerid, X, Y, Z);
	        Zone[uid][z_max][0] = X;
	        Zone[uid][z_max][1] = Y;

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_maxx` = %f, `z_maxy` = %f WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_max][0], Zone[uid][z_max][1], uid);
			mysql_query(DB_Query);

	        PlayerData[playerid][char_stage] = STAGE_ZONE_SAVE;

	        new str[128];
			format(str, sizeof(str), "~y~Strefa ~w~%s ~y~UID: ~w~%d~n~~y~Aby zapisac strefe kliknij ~w~H~y~.", Zone[uid][z_name], Zone[uid][z_uid]);
			InfoTD(playerid, str);

			PlayerData[playerid][char_info_timer] = 8;

	        Tip(playerid, "Pozycja zosta³a zapisana.");
		}

		if(GetNearestObject(playerid, 3.0) != -1)
		{
		    if(PlayerData[playerid][char_bw] != 0)
			{
				Info(playerid, "Nie mo¿esz teraz skorzystaæ z tej komendy.");
				return 1;
			}
			new objectid = GetNearestObject(playerid, 3.0);
			new uid = GetObjectUID(objectid);
			if(Object[uid][object_model] == 2942 || Object[uid][object_model] == 2754)
			{
			    new StrinG[500];
				format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
			}
		}
	}

	if(newkeys & KEY_CTRL_BACK)
	{
	    if(PlayerData[playerid][char_stage] == STAGE_ZONE_SAVE)
	    {
	        new uid = FreeID[playerid];
	        PlayerData[playerid][char_stage] = STAGE_ZONE_NONE;
	        FreeID[playerid] = -1;

	        Zone[uid][z_sampid] = GangZoneCreate(Zone[uid][z_min][0], Zone[uid][z_min][1], Zone[uid][z_max][0], Zone[uid][z_max][1]);

            new str[128];
			format(str, sizeof(str), "~y~Strefa ~w~%s ~y~UID: ~w~%d~n~~y~Strefa zostala zapisana.~n~~n~~y~SampID: ~w~%d", Zone[uid][z_name], Zone[uid][z_uid], Zone[uid][z_sampid]);
			InfoTD(playerid, str);

			PlayerData[playerid][char_info_timer] = 8;

	        Tip(playerid, "Strefa zosta³a zapisana w bazie danych.");
		}
	}

	if(HOLDING(KEY_WALK | KEY_SPRINT))
	{
	    new i = GetNearestDoors(playerid, 2.0);

	    if(GetPlayerVirtualWorld(playerid) == Doors[i][EnterVW])
	    {
	        if(Doors[i][Locked]) return GameTextForPlayer(playerid, "~r~DRZWI ZAMKNIETE!", 5000, 4);

	    	SetPlayerPos(playerid, Doors[i][ExitX], Doors[i][ExitY], Doors[i][ExitZ]);
	    	SetPlayerFacingAngle(playerid, Doors[i][ExitA]);

	    	SetPlayerVirtualWorld(playerid, Doors[i][ExitVW]);
	    	SetPlayerInterior(playerid, Doors[i][ExitInterior]);

	    	PlayerData[playerid][char_inside_doors] = i;
		}
		else if(GetPlayerVirtualWorld(playerid) == Doors[i][ExitVW])
		{
		    if(Doors[i][Locked]) return GameTextForPlayer(playerid, "~r~DRZWI ZAMKNIETE!", 5000, 4);

		    SetPlayerPos(playerid, Doors[i][EnterX], Doors[i][EnterY], Doors[i][EnterZ]);
		    SetPlayerFacingAngle(playerid, Doors[i][EnterA]);

		    SetPlayerVirtualWorld(playerid, Doors[i][EnterVW]);
		    SetPlayerInterior(playerid, Doors[i][EnterInterior]);

			PlayerData[playerid][char_inside_doors] = 0;
		}
	}
	return 1;
}
