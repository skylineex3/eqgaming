stock UnloadDoors()
{
	for(new i=1; i<MAX_DOORS; i++)
	{
	    new DB_Query[1024];
	    format(DB_Query, sizeof(DB_Query), "UPDATE `rp_doors` SET door_name = '%s', door_type = %d, door_model = %d, door_enterx = %f, door_entery = %f, door_enterz = %f, door_entera = %f,\
	        door_entervw = %d, door_enterinterior = %d, door_exitx = %f, door_exity = %f, door_exitz = %f, door_exita = %f, door_exitvw = %d, door_exitinterior = %d, door_owner = %d, door_locked = %d WHERE door_uid = %d LIMIT 1",
	            Doors[i][Name], Doors[i][Type], Doors[i][Model], Doors[i][EnterX], Doors[i][EnterY], Doors[i][EnterZ], Doors[i][EnterA], Doors[i][EnterVW], Doors[i][EnterInterior], Doors[i][ExitX], Doors[i][ExitY], Doors[i][ExitZ], Doors[i][ExitA],
	                Doors[i][ExitVW], Doors[i][ExitInterior], Doors[i][Owner], Doors[i][Locked], Doors[i][UID]);
		mysql_query(DB_Query);

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
     	Doors[i][Locked] = -1;
     	format(Doors[i][Name], 24, " ");
	}
	return 1;
}
