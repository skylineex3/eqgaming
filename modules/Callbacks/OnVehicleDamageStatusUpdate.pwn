public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    new panels, doors, lights, tires, uid = GetVehicleUID(vehicleid);
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

    Vehicle[uid][veh_tires] = tires;
    Vehicle[uid][veh_doors] = doors;
    Vehicle[uid][veh_panels] = panels;
    Vehicle[uid][veh_lights] = lights;

    new DB_Query[256];
	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_vehicles` SET ``veh_tires` = %d, `veh_doors` = %d, `veh_panels` = %d, `veh_lights` = %d WHERE `veh_uid` = %d LIMIT 1",
	    Vehicle[uid][veh_tires], Vehicle[uid][veh_doors], Vehicle[uid][veh_panels], Vehicle[uid][veh_lights], Vehicle[uid][veh_uid]);
	mysql_query(DB_Query);
	return 1;
}
