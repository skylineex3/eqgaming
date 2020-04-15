public OnPlayerUpdate(playerid)
{
    if(PlayerData[playerid][char_spectate_id] != -1)
	{
	    new id = PlayerData[playerid][char_spectate_id];
	    if(GetPlayerVirtualWorld(id) != GetPlayerVirtualWorld(playerid))
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
	}

    if(PlayerData[playerid][char_edit_object] != -1 && PlayerData[playerid][char_editing])
	{
	    new Keys, u, p, Float:X, Float:Y, Float:Z;
		GetPlayerKeys(playerid, Keys, u, p);
		new uid = GetObjectUID(PlayerData[playerid][char_edit_object]);

		if(PlayerData[playerid][char_edit_stage] == STAGE_OBJECT_POS)
		{
			if(u == KEY_UP)
			{
			    if(Keys & KEY_JUMP)
			    {
			        if(Keys & KEY_SPRINT)
			        {
			            GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z+1.0);

    					Object[uid][object_pos][2] += 1.0;
					}
					else if(Keys & KEY_WALK)
					{
					    GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z+0.01);

    					Object[uid][object_pos][2] += 0.01;
					}
					else
					{
					    GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z+0.5);

    					Object[uid][object_pos][2] += 0.5;
					}
				}
		    	else if(Keys & KEY_SPRINT)
		    	{
		        	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
		        	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X+1.0, Y, Z);

		        	Object[uid][object_pos][0] += 1.0;
				}
				else if(Keys & KEY_WALK)
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X+0.01, Y, Z);

			    	Object[uid][object_pos][0] += 0.01;
				}
				else
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X+0.5, Y, Z);

			    	Object[uid][object_pos][0] += 0.5;
				}
			}
			else if(u == KEY_DOWN)
			{
			    if(Keys & KEY_JUMP)
			    {
			        if(Keys & KEY_SPRINT)
			        {
			            GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z-1.0);

    					Object[uid][object_pos][2] -= 1.0;
					}
					else if(Keys & KEY_WALK)
					{
					    GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z-0.01);

    					Object[uid][object_pos][2] -= 0.01;
					}
					else
					{
					    GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z-0.5);

    					Object[uid][object_pos][2] -= 0.5;
					}
				}
		    	else if(Keys == KEY_SPRINT)
		    	{
		        	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
		        	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X-1.0, Y, Z);

		        	Object[uid][object_pos][0] -= 1.0;
				}
				else if(Keys == KEY_WALK)
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X-0.01, Y, Z);

			    	Object[uid][object_pos][0] -= 0.01;
				}
				else
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X-0.5, Y, Z);

			    	Object[uid][object_pos][0] -= 0.5;
				}
			}
			else if(p == KEY_LEFT)
			{
		    	if(Keys & KEY_SPRINT)
		    	{
		        	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
		        	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y+1.0, Z);

		        	Object[uid][object_pos][1] += 1.0;
				}
				else if(Keys & KEY_WALK)
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y+0.01, Z);

			    	Object[uid][object_pos][1] += 0.01;
				}
				else
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y+0.5, Z);

			    	Object[uid][object_pos][1] += 0.5;
				}
			}
			else if(p == KEY_RIGHT)
			{
		    	if(Keys & KEY_SPRINT)
		    	{
		        	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
		        	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y-1.0, Z);

		        	Object[uid][object_pos][1] -= 1.0;
				}
				else if(Keys & KEY_WALK)
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y-0.01, Z);

			    	Object[uid][object_pos][1] -= 0.01;
				}
				else
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y-0.5, Z);

			    	Object[uid][object_pos][1] -= 0.5;
				}
			}
		}
		else if(PlayerData[playerid][char_edit_stage] == STAGE_OBJECT_ROT)
		{
 			if(u == KEY_UP)
 			{
 			    if(Keys & KEY_WALK)
 			    {
 			        GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y+0.1, Z);

					Object[uid][object_pos][4] += 0.1;
				}
				else if(Keys & KEY_SPRINT)
				{
				    GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y+10, Z);

					Object[uid][object_pos][4] += 10.0;
				}
				else
				{
					GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y+5, Z);

					Object[uid][object_pos][4] += 5.0;
				}
			}
			else if(u == KEY_DOWN)
			{
   				if(Keys & KEY_WALK)
 			    {
 			        GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y-0.1, Z);

					Object[uid][object_pos][4] -= 0.1;
				}
				else if(Keys & KEY_SPRINT)
				{
				    GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y-10, Z);

					Object[uid][object_pos][4] -= 10.0;
				}
				else
				{
					GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y-5, Z);

					Object[uid][object_pos][4] -= 5.0;
				}
			}
			else if(p == KEY_RIGHT)
			{
   				if(Keys & KEY_WALK)
 			    {
 			        GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z-0.1);

					Object[uid][object_pos][5] -= 0.1;
				}
				else if(Keys & KEY_SPRINT)
				{
				    GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z-10);

					Object[uid][object_pos][5] -= 10.0;
				}
				else
				{
					GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z-5);

					Object[uid][object_pos][5] -= 5.0;
				}
			}
			else if(p == KEY_LEFT)
			{
   				if(Keys & KEY_WALK)
 			    {
 			        GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z+0.1);

					Object[uid][object_pos][5] += 0.1;
				}
				else if(Keys & KEY_SPRINT)
				{
				    GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z+10);

					Object[uid][object_pos][5] += 10.0;
				}
				else
				{
					GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z+5);

					Object[uid][object_pos][5] += 5.0;
				}
			}
		}
	}
   	return 1;
}
