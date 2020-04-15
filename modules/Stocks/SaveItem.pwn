stock SaveItem(playerid)
{
    for(new i=0; i<MAX_ITEMS; i++)
	{
	    if(Item[i][UID] == -1) continue;

	    if(Item[i][Owner] == PlayerData[playerid][char_uid])
	    {
     	   	if(Item[i][Type] == ITEM_WEAPON && Item[i][Active])
			{
  		      	new weapid, ammo;
   				GetPlayerWeaponData(playerid, GetWeaponSlot(Item[i][Var][0]), weapid, ammo);
  		      	Item[i][Var][1] = ammo;
			}

			if(Item[i][Active]) Item[i][Active] = false;

			new DB_Query[1000];
			format(DB_Query, sizeof(DB_Query), "UPDATE `rp_items` SET `item_name` = '%s', `item_desc` = '%s', `item_owner` = %d, `item_type` = %d, `item_var1` = %d, `item_var2` = %d, `item_var3` = %d, `item_var4` = %d, `item_var5` = %d, `item_var6` = %d, `item_pos_x` = %f, `item_pos_y` = %f, `item_pos_z` = %f, `item_in_vehicle` = %d WHERE `item_uid` = %d LIMIT 1",
				Item[i][Name], Item[i][Desc], Item[i][Owner], Item[i][Type], Item[i][Var][0], Item[i][Var][1], Item[i][Var][2], Item[i][Var][3], Item[i][Var][4], Item[i][Var][5], Item[i][item_pos][0], Item[i][item_pos][1], Item[i][item_pos][2], Item[i][in_vehicle], Item[i][UID]);
			mysql_query(DB_Query);
		}
	}
	return 1;
}
