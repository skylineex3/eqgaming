stock LoadVehicles()
{
 	new i = 0, DB_Query[1000], data[1000];

    format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_vehicles`");
    mysql_query(DB_Query);

	mysql_store_result();

	while(mysql_fetch_row_format(data, "|"))
	{
		i++;

 		sscanf(data, "p<|>ddfffffddddddddffdd", Vehicle[i][veh_uid], Vehicle[i][veh_model], Vehicle[i][veh_health], Vehicle[i][veh_pos][0], Vehicle[i][veh_pos][1], Vehicle[i][veh_pos][2], Vehicle[i][veh_pos][3],
   			Vehicle[i][veh_color][0], Vehicle[i][veh_color][1], Vehicle[i][veh_tires], Vehicle[i][veh_doors], Vehicle[i][veh_panels], Vehicle[i][veh_lights], Vehicle[i][veh_world], Vehicle[i][veh_interior], Vehicle[i][veh_fuel],
      			Vehicle[i][veh_mileage], Vehicle[i][veh_owner], Vehicle[i][veh_paintjob]);

		Vehicle[i][veh_spawned] = false;
		Vehicle[i][veh_locked] = true;
	}

	mysql_free_result();

	printf("[load][vehicles] Za³adowano %d pojazdów.", i);
	return 1;
}

