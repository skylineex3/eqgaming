stock LoadDoors()
{
    new DB_Query[128], data[1000], i = 0;

    format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_doors`");
	mysql_query(DB_Query);

	mysql_store_result();

	while(mysql_fetch_row_format(data, "|"))
 	{
		i++;

		sscanf(data, "p<|>ds[24]ddffffddffffdddd", Doors[i][UID], Doors[i][Name], Doors[i][Type], Doors[i][Model], Doors[i][EnterX], Doors[i][EnterY], Doors[i][EnterZ], Doors[i][EnterA],
			Doors[i][EnterVW], Doors[i][EnterInterior], Doors[i][ExitX], Doors[i][ExitY], Doors[i][ExitZ], Doors[i][ExitA], Doors[i][ExitVW], Doors[i][ExitInterior], Doors[i][Owner], Doors[i][Locked]);

		Doors[i][samp_id] = CreateDynamicPickup(Doors[i][Model], 1, Doors[i][EnterX], Doors[i][EnterY], Doors[i][EnterZ], Doors[i][EnterVW]);
	}

	mysql_free_result();

	printf("[load][doors] Za³adowano %d drzwi.", i);
	return 1;
}

