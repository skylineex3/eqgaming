stock SendClientMessageEx(Float:range, playerid, message[], col1, col2, col3, col4, col5, bool:echo = false)
{
	new
		Float:pos[ 3 ],
		worldid = GetPlayerVirtualWorld(playerid),
		interiorid = GetPlayerInterior(playerid)
	;
	GetPlayerPos(playerid, pos[ 0 ], pos[ 1 ], pos[ 2 ]);

	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(GetPlayerVirtualWorld(i) != worldid) continue;
		if(GetPlayerInterior(i) != interiorid) continue;
		if(echo == true && i == playerid) continue;
   		if(PlayerData[i][char_bw] != 0)
	 	{
   			SendClientMessage(i, 0xCCCCCCFF, "** Twoja postac jest nieprzytomna, więc nie słyszysz głosu innych osób **");
	     	continue;
	 	}

		if(IsPlayerInRangeOfPoint(i, range/16, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, col1, message);
		else if(IsPlayerInRangeOfPoint(i, range/8, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, col2, message);
		else if(IsPlayerInRangeOfPoint(i, range/4, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, col3, message);
		else if(IsPlayerInRangeOfPoint(i, range/2, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, col4, message);
		else if(IsPlayerInRangeOfPoint(i, range, pos[ 0 ], pos[ 1 ], pos[ 2 ]))
			SendClientMessage(i, col5, message);
	}
	return 1;
}
