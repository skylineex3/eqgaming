stock LoadObjects()
{
 	new i, DB_Query[1000], data[1000], loaded = 0;

 	format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_objects`");
  	mysql_query(DB_Query);

	mysql_store_result();

  	while(mysql_fetch_row_format(data, "|"))
   	{
        sscanf(data, "p<|>d", i);

    	sscanf(data, "p<|>ddffffffdd", Object[i][object_uid], Object[i][object_model], Object[i][object_pos][0], Object[i][object_pos][1], Object[i][object_pos][2], Object[i][object_pos][3], Object[i][object_pos][4], Object[i][object_pos][5],
     		Object[i][object_world], Object[i][object_interior]);

       	Object[i][object_sampid] = CreateDynamicObject(Object[i][object_model], Object[i][object_pos][0], Object[i][object_pos][1], Object[i][object_pos][2], Object[i][object_pos][3], Object[i][object_pos][4], Object[i][object_pos][5], Object[i][object_world], Object[i][object_interior], -1, STREAMER_OBJECT_SD, 100.0, -1, 0);

		loaded++;
	}

	mysql_free_result();

	printf("[load][object] Za³adowano %d obiektów.", loaded);
	return 1;
}
