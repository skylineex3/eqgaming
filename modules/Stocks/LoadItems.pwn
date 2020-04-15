stock LoadItems()
{
	new i = 0, DB_Query[1000], data[1000];

    format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_items`");
	mysql_query(DB_Query);

	mysql_store_result();

	while(mysql_fetch_row_format(data, "|"))
 	{
 	    i++;

  		sscanf(data, "p<|>ds[64]s[256]ddddddddfffd", Item[i][UID], Item[i][Name], Item[i][Desc], Item[i][Owner], Item[i][Type], Item[i][Var][0], Item[i][Var][1], Item[i][Var][2], Item[i][Var][3], Item[i][Var][4], Item[i][Var][5],
    		Item[i][item_pos][0], Item[i][item_pos][1], Item[i][item_pos][2], Item[i][in_vehicle]);

      	Item[i][Active] = false;
	}

	mysql_free_result();

	printf("[load][item] Za³adowano %d przedmiotów.", i);
	return 1;
}
