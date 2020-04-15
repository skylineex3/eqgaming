stock SaveObject(uid)
{
	new DB_Query[1000];
	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_objects` SET `object_model` = %d, `object_pos_x` = %f, `object_pos_y` = %f, `object_pos_z` = %f, `object_rot_x` = %f, `object_rot_y` = %f, `object_rot_z` = %f, `object_world` = %d, `object_interior` = %d WHERE `object_uid` = %d LIMIT 1",
	    Object[uid][object_model], Object[uid][object_pos][0], Object[uid][object_pos][1], Object[uid][object_pos][2], Object[uid][object_pos][3], Object[uid][object_pos][4], Object[uid][object_pos][5], Object[uid][object_world], Object[uid][object_interior], Object[uid][object_uid]);
	mysql_query(DB_Query);
	return 1;
}
