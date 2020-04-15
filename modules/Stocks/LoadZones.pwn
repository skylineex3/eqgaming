stock LoadZones()
{
	new i = 0, DB_Query[64], data[1000];
 	format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_zones`");
	mysql_query(DB_Query);

	mysql_store_result();

 	while(mysql_fetch_row_format(data, "|"))
  	{
		i++;

   		sscanf(data, "p<|>dds[32]ffffdddd", Zone[i][z_uid], Zone[i][z_name], Zone[i][z_min][0], Zone[i][z_min][1], Zone[i][z_max][0], Zone[i][z_max][1], Zone[i][z_owner], Zone[i][z_house_cost], Zone[i][z_buis_cost], Zone[i][z_size]);

		Zone[i][z_sampid] = GangZoneCreate(Zone[i][z_min][0], Zone[i][z_min][1], Zone[i][z_max][0], Zone[i][z_max][1]);
	}

	mysql_free_result();

	printf("[load][zones] Za³adowano %d stref.", i);
	return 1;
}
