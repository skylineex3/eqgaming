stock SaveVehicle(uid)
{
	new DB_Query[1000];
	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_vehicles` SET `veh_health` = %f, `veh_pos_x` = %f, `veh_pos_y` = %f, `veh_pos_z` = %f, `veh_pos_a` = %f, `veh_color1` = %d, `veh_color2` = %d, `veh_tires` = %d, `veh_doors` = %d, `veh_panels` = %d, `veh_lights` = %d, `veh_world` = %d, `veh_interior` = %d, `veh_fuel` = %f, `veh_mileage` = %f, `veh_owner` = %d, `veh_paintjob` = %d WHERE `veh_uid` = %d LIMIT 1",
	    Vehicle[uid][veh_health], Vehicle[uid][veh_pos][0], Vehicle[uid][veh_pos][1], Vehicle[uid][veh_pos][2], Vehicle[uid][veh_pos][3], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_tires], Vehicle[uid][veh_doors], Vehicle[uid][veh_panels], Vehicle[uid][veh_lights], Vehicle[uid][veh_world], Vehicle[uid][veh_interior], Vehicle[uid][veh_fuel], Vehicle[uid][veh_mileage], Vehicle[uid][veh_owner], Vehicle[uid][veh_paintjob], Vehicle[uid][veh_uid]);
	mysql_query(DB_Query);
	return 1;
}
