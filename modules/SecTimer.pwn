forward SecTimer();
public SecTimer()
{
	new year, month, day;
	getdate(year, month, day);
	new str[144];
	format(str, sizeof(str), "~r~~h~e~w~Quality~r~~h~G~w~aming~n~%d/%02d/%d", day, month, year);
	TextDrawSetString(ForGame, str);

	new hour, minute, second;
	gettime(hour, minute, second);
	if(minute == 0 && second == 0)
	{
	    new text[64];
	    if(hour == 0) format(text, sizeof(text), "* Dzwony w ratuszu bij¹ 24 razy. *");
	    else format(text, sizeof(text), "* Dzwony w ratuszu bij¹ %d razy. *", hour);
		SendClientMessageToAll(COLOR_DO, text);

		SetWorldTime(hour);
	}

	if(NewsTimer != 0)
	{
	    NewsTimer --;
	    if(NewsTimer == 0)
	    {
    		format(str, sizeof(str), "~r~~h~LS News: ~w~W tej chwili nikt nie nadaje.");
    		TextDrawSetString(LSNews[1], str);
		}
	}

	for(new i=0; i<GetMaxPlayers(); i++)
	{
	    if(IsPlayerConnected(i) && PlayerData[i][char_logged])
	    {
			ResetPlayerMoney(i);
			GivePlayerMoney(i, PlayerData[i][char_cash]);

			PlayerData[i][char_online] ++;
			if(!(PlayerData[i][char_online] % 3600))
	        {
	            if(PlayerData[i][char_premium] > gettime())
	            {
	                PlayerData[i][char_score] += 14;
				}
				else
				{
					PlayerData[i][char_score] += 10;
				}
	        }

			SetPlayerScore(i, PlayerData[i][char_score]);

			if(PlayerData[i][char_vehicle_info_timer] != 0)
			{
			    PlayerData[i][char_vehicle_info_timer] --;
			    if(PlayerData[i][char_vehicle_info_timer] == 0)
                    TextDrawHideForPlayer(i, VehicleInfo[i]);
			}

			if(PlayerData[i][char_info_timer] != 0)
			{
			    PlayerData[i][char_info_timer] --;
			    if(PlayerData[i][char_info_timer] == 0)
			        TextDrawHideForPlayer(i, PlayerData[i][char_info]);
			}
			//0 - Torso, 1 - Groin, 2 - Left arm, 3 - Right arm, 4 - Left leg, 5 - Right leg, 6 - Head
			if(PlayerData[i][char_body_part_damaged][2] != 0 && PlayerData[i][char_body_part_damaged][3] != 0)
			{
			    PlayerData[i][char_body_part_damaged][2] --;
			    PlayerData[i][char_body_part_damaged][3] --;
			}

			if(PlayerData[i][char_body_part_damaged][4] != 0 && PlayerData[i][char_body_part_damaged][5] != 0)
			{
			    PlayerData[i][char_body_part_damaged][4] --;
			    PlayerData[i][char_body_part_damaged][5] --;
			}

   			if(GetPlayerCameraMode(i) == 53 && PlayerData[i][char_body_part_damaged][2] != 0 && PlayerData[i][char_body_part_damaged][3] != 0)
	    	{
				SetPlayerDrunkLevel(i, 9999);
			}
			else
			{
			    SetPlayerDrunkLevel(i, 0);
			}

			if(GetPlayerSpeed(i) >= 14 && PlayerData[i][char_body_part_damaged][4] != 0 && PlayerData[i][char_body_part_damaged][5] != 0)
			{
			    TogglePlayerControllable(i, 0);
			    InfoTD(i, "Nie mozesz teraz biegac poniewaz zostales zraniony w noge.");

			    PlayerData[i][char_info_timer] = 8;

			    SetTimerEx("UnfreezePlayer", 5000, false, "d", i);
			}

			if(PlayerData[i][char_health] <= 0 && PlayerData[i][char_bw] == 0)
			{
  				GetPlayerPos(i, PlayerData[i][char_last_pos][0], PlayerData[i][char_last_pos][1], PlayerData[i][char_last_pos][2]);
	    		PlayerData[i][char_bw] = 180;
		    	SetPlayerHealthEx(i, 9.0);
			}

			if(PlayerData[i][char_bw] != 0)
   			{
         		PlayerData[i][char_bw] --;
         		if(PlayerData[i][char_bw] == 0)
         		{
             		SetPlayerHealthEx(i, 9);
             		SetCameraBehindPlayer(i);
           			TogglePlayerControllable(i, true);

           			UpdateNick(i);
				}
				else
				{
	    			new String[64];
      				format(String, sizeof(String), "~g~BW~w~: %d sec.", PlayerData[i][char_bw]);
 					GameTextForPlayer(i, String, 1000, 1);
  					TogglePlayerControllable(i, false);
 		    		new Float:Pos[3];
   					GetPlayerPos(i, Pos[0], Pos[1], Pos[2]);
   					SetPlayerCameraPos(i, Pos[0], Pos[1]+2, Pos[2]+12);
					SetPlayerCameraLookAt(i, Pos[0], Pos[1], Pos[2]);
 					ApplyAnimation(i, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0);

 					UpdateNick(i);
				}
			}

			if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleSeat(i) == 0)
			{
			    new vehid = GetPlayerVehicleID(i), Float:ST[4];
			    new uid = GetVehicleUID(vehid);
			    new Float:Health;
			    GetVehicleHealth(vehid, Health);
			    Vehicle[uid][veh_health] = Health;

			    new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);
				if(engine == VEHICLE_PARAMS_ON)
				{
				    GetVehicleVelocity(vehid,ST[0],ST[1],ST[2]);
					ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
					Vehicle[uid][veh_mileage] += ST[3]/4000;

				    Vehicle[uid][veh_fuel] -= 0.01;

				    if(Vehicle[uid][veh_fuel] < 0.1)
				    {
				        SetVehicleParamsEx(vehid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);

				        Vehicle[uid][veh_fuel] = 0.0;

				        new strr[128];
				        format(strr, sizeof(strr), "W pojeŸdzie %s koñczy siê paliwo.", VehicleNames[GetVehicleModel(vehid) - 400]);
				        cmd_do(i, strr);
					}
				}
			}
		}
	}
	return 1;
}
